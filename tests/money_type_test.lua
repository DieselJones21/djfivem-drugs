--[[
    Standalone payout routing tests (no FiveM runtime).

    lua tests/money_type_test.lua
]]

local failed = 0

local function assertEq(got, expected, msg)
    if got ~= expected then
        failed = failed + 1
        io.stderr:write(('FAIL %s: expected %s, got %s\n'):format(
            msg, tostring(expected), tostring(got)
        ))
    end
end

local function assertTrue(cond, msg)
    assertEq(not not cond, true, msg)
end

Config = {
    Debug = false,
    MoneyType = 'cash',
    DirtyMoneyType = 'black_money',
    FrameworkMoneyTypes = {
        cash = true,
        bank = true,
        crypto = true,
    },
    Drugs = {
        weed = { sell = { enabled = true, moneyType = 'cash' } },
        cocaine = { sell = { enabled = true, moneyType = 'black_money' } },
        pink_energy = { sell = { enabled = true, moneyType = 'black_money' } },
        lean = { sell = { enabled = true, moneyType = 'black_money' } },
        honda_pills = { sell = { enabled = true, moneyType = 'black_money' } },
        stab_juice = { sell = { enabled = true, moneyType = 'black_money' } },
        black_lotus = { sell = { enabled = true, moneyType = 'black_money' } },
    },
}

dofile('shared/utils.lua')

assertEq(Utils.IsFrameworkMoney('cash'), true, 'cash is QBX account')
assertEq(Utils.IsFrameworkMoney('bank'), true, 'bank is QBX account')
assertEq(Utils.IsFrameworkMoney('crypto'), true, 'crypto is QBX account')
assertEq(Utils.IsFrameworkMoney('black_money'), false, 'black_money is inventory item')
assertEq(Utils.IsFrameworkMoney('markedbills'), false, 'markedbills is inventory item')
assertEq(Utils.IsFrameworkMoney(nil), false, 'nil is not framework money')
assertEq(Utils.IsFrameworkMoney(''), false, 'empty string is not framework money')

Config.FrameworkMoneyTypes = nil
assertEq(Utils.IsFrameworkMoney('cash'), true, 'default cash')
assertEq(Utils.IsFrameworkMoney('black_money'), false, 'default black_money')

Config.FrameworkMoneyTypes = { cash = true, black_money = true }
assertEq(Utils.IsFrameworkMoney('black_money'), true, 'opt-in black_money account')
assertEq(Utils.IsFrameworkMoney('bank'), false, 'bank omitted from custom map')

Config.FrameworkMoneyTypes = { cash = true, bank = true, crypto = true }

-- FiveM stubs so server/main.lua can load
function TriggerClientEvent() end
function AddEventHandler() end
function CreateThread() end

Bridge = {
    calls = {},
    canCarry = true,
    addItemOk = true,
    addMoneyOk = true,
}

function Bridge.AddMoney(_, moneyType, amount)
    Bridge.calls[#Bridge.calls + 1] = { op = 'AddMoney', moneyType = moneyType, amount = amount }
    return Bridge.addMoneyOk
end

function Bridge.AddItem(_, item, amount)
    Bridge.calls[#Bridge.calls + 1] = { op = 'AddItem', item = item, amount = amount }
    return Bridge.addItemOk
end

function Bridge.CanCarry()
    return Bridge.canCarry
end

function Bridge.ItemCount() return 0 end
function Bridge.RemoveItem() return true end
function Bridge.RemoveMoney() return true end
function Bridge.GetMoney() return 0 end
function Bridge.GetPlayers() return {} end

dofile('server/main.lua')

local function resetBridge()
    Bridge.calls = {}
    Bridge.canCarry = true
    Bridge.addItemOk = true
    Bridge.addMoneyOk = true
end

resetBridge()
assertTrue(Server.AddMoney(1, 160, 'cash'), 'cash payout succeeds')
assertEq(#Bridge.calls, 1, 'cash makes one bridge call')
assertEq(Bridge.calls[1].op, 'AddMoney', 'weed cash uses qbx_core:AddMoney')
assertEq(Bridge.calls[1].moneyType, 'cash', 'cash account name')

-- Regression: last PR called AddMoney('black_money') which QBX rejects
resetBridge()
Bridge.addMoneyOk = false
assertTrue(Server.AddMoney(1, 850, 'black_money'), 'black_money payout succeeds without QBX account')
assertEq(Bridge.calls[1].op, 'AddItem', 'hard drugs use ox_inventory:AddItem')
assertEq(Bridge.calls[1].item, 'black_money', 'adds black_money item')
assertEq(Bridge.calls[1].amount, 850, 'adds sale total as item count')
for i = 1, #Bridge.calls do
    assertEq(Bridge.calls[i].op ~= 'AddMoney', true, 'black_money never calls qbx AddMoney')
end

resetBridge()
Bridge.canCarry = false
assertEq(Server.AddMoney(1, 500, 'black_money'), false, 'full inventory fails dirty payout')
assertEq(Server.CanAddPayout(1, 'black_money', 500), false, 'CanAddPayout false when cannot carry')
assertEq(Server.CanAddPayout(1, 'cash', 500), true, 'cash payout does not need inventory space')

resetBridge()
Bridge.addItemOk = false
assertEq(Server.AddMoney(1, 500, 'black_money'), false, 'missing black_money item fails payout')

for id, drug in pairs(Config.Drugs) do
    resetBridge()
    -- Stock QBX rejects black_money; hard-drug sales must still pay
    Bridge.addMoneyOk = (drug.sell.moneyType == 'cash')
    local ok = Server.AddMoney(1, 100, drug.sell.moneyType)
    assertTrue(ok, id .. ' sale payout succeeds')
    local expectedOp = (id == 'weed') and 'AddMoney' or 'AddItem'
    assertEq(Bridge.calls[1].op, expectedOp, id .. ' uses ' .. expectedOp)
end

if failed > 0 then
    os.exit(1)
end

print('money_type_test: ok')
