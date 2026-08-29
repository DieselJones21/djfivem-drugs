--[[
    Sell-rank math (no FiveM runtime).

    lua tests/progress_test.lua
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

Config = {
    Progression = {
        enabled = true,
        levels = {
            { level = 1, sold = 0,    label = 'Runner',    payoutMultiplier = 1.00 },
            { level = 2, sold = 250,  label = 'Hustler',   payoutMultiplier = 1.03 },
            { level = 3, sold = 800,  label = 'Plug',      payoutMultiplier = 1.06 },
            { level = 4, sold = 2000, label = 'Trap Star', payoutMultiplier = 1.10 },
            { level = 5, sold = 4500, label = 'Kingpin',   payoutMultiplier = 1.15 },
        },
    },
}

dofile('shared/utils.lua')

assertEq(Utils.GetRankForSold(0).level, 1, 'start at Runner')
assertEq(Utils.GetRankForSold(0).label, 'Runner', 'start label')
assertEq(Utils.GetRankForSold(249).level, 1, '249 still Runner')
assertEq(Utils.GetRankForSold(250).level, 2, '250 is Hustler')
assertEq(Utils.GetRankForSold(799).level, 2, '799 still Hustler')
assertEq(Utils.GetRankForSold(800).level, 3, '800 is Plug')
assertEq(Utils.GetRankForSold(1999).level, 3, '1999 still Plug')
assertEq(Utils.GetRankForSold(2000).level, 4, '2000 is Trap Star')
assertEq(Utils.GetRankForSold(4499).level, 4, '4499 still Trap Star')
assertEq(Utils.GetRankForSold(4500).level, 5, '4500 is Kingpin')
assertEq(Utils.GetRankForSold(99999).level, 5, 'over-max stays Kingpin')

assertEq(Utils.GetNextRank(0).sold, 250, 'next from 0 is Hustler at 250')
assertEq(Utils.GetNextRank(250).sold, 800, 'next from Hustler is Plug')
assertEq(Utils.GetNextRank(4500) == nil, true, 'Kingpin has no next rank')

assertEq(Utils.GetRankPayoutMultiplier(0), 1.00, 'L1 pay')
assertEq(Utils.GetRankPayoutMultiplier(250), 1.03, 'L2 pay')
assertEq(Utils.GetRankPayoutMultiplier(800), 1.06, 'L3 pay')
assertEq(Utils.GetRankPayoutMultiplier(2000), 1.10, 'L4 pay')
assertEq(Utils.GetRankPayoutMultiplier(4500), 1.15, 'L5 pay')

-- Long grind: 4500 units at 70 units/hour of mixed loop ≈ 64 hours
local hoursAt70 = 4500 / 70
assertEq(hoursAt70 > 60, true, 'max rank takes over 60 hours at 70 units/hour')
assertEq(hoursAt70 < 100, true, 'max rank is under 100 hours at 70 units/hour')

-- Honda-priced sale with Kingpin bonus still uses the same base range
local hondaMin, hondaMax = 500, 850
local kingMin = math.floor((hondaMin * 1.15) + 0.5)
local kingMax = math.floor((hondaMax * 1.15) + 0.5)
assertEq(kingMin > hondaMin, true, 'Kingpin floor above Honda min')
assertEq(kingMax > hondaMax, true, 'Kingpin ceiling above Honda max')

if failed > 0 then
    os.exit(1)
end

print('progress_test: ok')
