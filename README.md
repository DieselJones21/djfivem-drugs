# djfivem-drugs

Config-driven FiveM drug economy: **harvest → process → `/trap` sell**.

Built for **QBCore + ox_lib + ox_target + ox_inventory**.

## Features

- Add new drugs from config only (no code changes)
- Harvest spots + prop fields (GTA weed plant props)
- Store / ice-machine supply grabs
- Processing benches with recipes
- `/trap` street selling: NPC runs up, 3rd-eye (ox_target), random qty + random price in your min/max range

## Dependencies

- `qb-core`
- `ox_lib`
- `ox_target`
- `ox_inventory`

## Install

1. Drop this resource into `resources/[local]/djfivem-drugs` (or your folder)
2. Merge items from `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Add images under `ox_inventory/web/images/` if you want icons (`pink_energy.png`, etc.)
4. Ensure start order in `server.cfg`:

```cfg
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qb-core
ensure djfivem-drugs
```

## Default drugs

| Drug | Ingredients | Sell range (per unit) |
|------|-------------|------------------------|
| **Pink Energy** (highest) | pink crystal shards, pink energy solvent, chug jars, caffeine powder | $550–$900 |
| **Weed** | weed buds (plant props) + baggies (stores) | $80–$160 |
| **Cocaine** | coca leaves + acetone + baggies | $250–$420 |
| **Lean** | codeine + ice (machine) + cups + sprite (stores) | $140–$260 |

Locations and recipes live in:

- `config/config.lua` — harvest spots, stores, ice machines, trap settings
- `config/drugs.lua` — drug recipes, benches, sell prices

## How to play

1. Harvest / grab each ingredient at its location (3rd eye)
2. Go to that drug’s processing bench and craft the finished item
3. Run `/trap`
4. An NPC runs up — 3rd eye them, accept the random offer, get paid

Stop trapping with `/trap` again.

## Adding a new drug

1. Add items to ox_inventory
2. Add harvest/store spots in `config/config.lua` if needed
3. Add a block in `config/drugs.lua`:

```lua
meth = {
    label = 'Meth Bag',
    item = 'meth_bag',
    ingredients = {
        { item = 'pseudo', amount = 2 },
        { item = 'baggies', amount = 1 },
    },
    process = {
        label = 'Cook Meth',
        coords = vec3(0.0, 0.0, 0.0),
        heading = 0.0,
        size = vec3(1.6, 1.6, 2.0),
        rotation = 0.0,
        duration = 15000,
        output = { item = 'meth_bag', amount = 1 },
    },
    sell = {
        enabled = true,
        minPrice = 300,
        maxPrice = 500,
        minQty = 1,
        maxQty = 5,
    },
},
```

Restart the resource. Buyers will automatically offer the new product if the player has it.

## Config tips

- Toggle harvest/process blips with `blip.enabled = true` on any spot
- Set store items to paid grabs with `paid = true, price = 50`
- Police gate: `Config.Police.enabled = true` + `minimum`
- Trap cooldown / buyer timing: `Config.Trap`

## Resource layout

```
client/     harvest, process, sell (/trap)
server/     validation, inventory, offers
config/     config.lua + drugs.lua
shared/     helpers
install/    ox_inventory item definitions
```
