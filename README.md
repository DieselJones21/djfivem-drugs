# djfivem-drugs

Config-driven FiveM drug economy: **harvest → process → `/trap` sell**.

Built for **QBX (`qbx_core`) + ox_lib + ox_target + ox_inventory**.

## Features

- Add new drugs from config only (no code changes)
- Harvest **bench props** at ingredient stations (3rd eye the prop)
- Weed / coca **plant fields** using GTA props
- Store supply grabs (baggies, cups, sprite, acetone) — no custom props
- Ice **machine props** for lean
- Processing **bench/table props** for every drug
- `/trap` street selling: NPC runs up, 3rd-eye, random qty + price

## Dependencies

```cfg
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qbx_core
ensure djfivem-drugs
```

## Install

1. Drop into `resources/[local]/djfivem-drugs`
2. Merge items from `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Optional: add images under `ox_inventory/web/images/`
4. Restart / ensure the resource

## Default drugs

| Drug | Harvest / supplies | Process prop | Sell/unit |
|------|--------------------|--------------|-----------|
| **Pink Energy** | 4 bench stations (crystals, solvent barrel, jar crates, caffeine barrel) | meth table | $550–$900 |
| **Weed** | `prop_weed_01` field + store baggies | weed table | $80–$160 |
| **Cocaine** | coca plants + acetone/baggies from stores | coke table | $250–$420 |
| **Lean** | codeine bench + ice coolers + cups/sprite stores | tool bench | $140–$260 |

## Props by location

| Spot | Prop |
|------|------|
| Pink crystals | `prop_tool_bench02` |
| Pink solvent | `prop_barrel_exp_01a` |
| Chug jars | `prop_box_wood02a` |
| Caffeine | `prop_barrel_02b` |
| Codeine | `prop_tool_bench02_ld` |
| Ice machines | `prop_bar_cooler_03` |
| Pink Energy process | `bkr_prop_meth_table01a` |
| Weed process | `bkr_prop_weed_table_01a` |
| Cocaine process | `bkr_prop_coke_table01a` |
| Lean process | `prop_tool_bench02` |
| Weed / coca fields | plant props (no bench) |
| Convenience stores | world zones only |

Coords cheat sheet: `install/LOCATIONS.md`

## How to play

1. 3rd eye harvest benches / plants / stores / ice machines
2. 3rd eye the drug’s process bench
3. `/trap` → buyer runs up → 3rd eye → sell

## Adding a new drug

1. Add ox_inventory items  
2. Add a `type = 'bench'` harvest (with `prop.model`) and/or store entries  
3. Add a `Config.Drugs` block with `process.prop`  

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
        duration = 15000,
        prop = { model = `bkr_prop_meth_table01a`, heading = 0.0 },
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

## Layout

```
client/     harvest benches, process benches, /trap sell
server/     validation, ox_inventory, qbx money
config/     config.lua + drugs.lua
shared/     utils + qbx/ox bridge
install/    ox items + locations
```
