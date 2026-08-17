# djfivem-drugs

Config-driven FiveM drug economy: **harvest → process → `/trap` sell**.

Built for **QBX (`qbx_core`) + ox_lib + ox_target + ox_inventory**.

## Features

- Add new drugs from config only (no code changes)
- Harvest props at ingredient stations (3rd eye)
- Store supply grabs + ice machines
- Processing benches for every drug
- `/trap` street selling with chance-based haggling
- Usable drug effects (armor / stamina — no screen FX on combat stims)

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
3. Restart / ensure the resource

## Default drugs

| Drug | Ingredients | Sell/unit |
|------|-------------|-----------|
| **Pink Energy** | crystals, solvent, chug jars, caffeine | $550–$900 |
| **Weed** | weed buds + baggies | $80–$160 |
| **Cocaine** | coca leaves + acetone + baggies | $250–$420 |
| **Lean** | codeine + ice + cups + sprite + hard candies | $140–$260 |
| **Honda Pills** | capsules + formula + extract | $500–$850 |
| **Stab Juice** | stab powder + stab candy + concentrated juice | $500–$850 |
| **Black Lotus** | lotus powder + black liquid extract | $500–$850 |

## Combat stim effects

**Pink Energy, Honda Pills, Black Lotus** share the same clean buff:
- **+25% armor**
- **45 seconds infinite stamina**
- **No screen effects / timecycle / shake**

Finished drugs need:
```lua
server = { export = 'djfivem-drugs.useDrugServer' }
```

## Ingredient props

See `install/LOCATIONS.md` — powders use sacks, liquids use barrels, weed/coca use plants, pills/candy use matching props.

## Adding a new drug

1. Add ox_inventory items  
2. Add harvest spots in `config/config.lua`  
3. Add a `Config.Drugs` block with `process`, `sell`, and `effects`
