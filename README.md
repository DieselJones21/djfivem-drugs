# djfivem-drugs

Config-driven FiveM drug economy: **harvest → process → `/trap` sell**.

Built for **QBX (`qbx_core`) + ox_lib + ox_target + ox_inventory**.

## Features

- Add new drugs from config only (no code changes)
- Harvest props at ingredient stations (3rd eye)
- Processing benches for every drug
- `/trap` street selling with chance-based haggling
- Weed sells for **cash** (QBX account); all other drugs sell for **black_money** (ox_inventory item)
- Weed harvest field map blip (other drug spots stay unmarked)
- **Island Pills** — Cayo Perico exclusive, $1800–$2800 dirty (highest pay)
- **Rebel Rolls** — Paleto Bay ecstasy, speed + stamina, Honda-level pay
- Usable drug effects (armor / stamina / sprint — no screen FX on combat stims)
- **Sell ranks + leaderboard** (`/drugboard`) — 5 levels from Runner to Kingpin
- **Admin boost events** (`/drugboost`) — 2x/3x/4x sell and/or harvest for timed events

## Dependencies

```cfg
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qbx_core
ensure djfivem-drugs

# optional ACE for boost menu
add_ace group.admin djdrugs.boost allow
```

## Install

1. Drop into `resources/[local]/djfivem-drugs`
2. Merge items from `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
   - Include `black_money` unless your inventory already has it (hard-drug sales pay this item)
3. Copy every PNG from `install/images/` into `ox_inventory/web/images/`
   (filenames match item names, e.g. `island_pills.png`). `black_money` is not included — ox_inventory already ships it.
4. Restart / ensure the resource

Hard-drug `/trap` sales add the `black_money` **item**, not a QBX money account. Stock QBX only has `cash` / `bank` / `crypto` — paying `black_money` through `qbx_core:AddMoney` is what caused **Payment failed**. To use a custom QBX account instead, add that name to `Config.FrameworkMoneyTypes`.

## Boost events

Admins run **`/drugboost`** (ox_lib menu):

- Start **Sell boost** (2x / 3x / 4x) — street sale prices
- Start **Harvest boost** (2x / 3x / 4x) — ingredient yields from harvest benches
- Start **Both**
- Stop sell / harvest / all
- Durations: 30m / 1h / 2h / 4h (configurable)

Permission: ACE `djdrugs.boost` **or** QBX `admin`/`god` (see `Config.Boost`).

## Default drugs

| Drug | Ingredients | Sell/unit | Payout |
|------|-------------|-----------|--------|
| **Pink Energy** | crystals, solvent, chug jars, caffeine | $550–$900 | black_money |
| **Weed** | weed buds + baggies | $80–$160 | cash |
| **Cocaine** | coca leaves + acetone + baggies | $250–$420 | black_money |
| **Lean** | codeine + ice + cups + sprite + hard candies | $140–$260 | black_money |
| **Honda Pills** | capsules + formula + extract | $500–$850 | black_money |
| **Stab Juice** | stab powder + stab candy + concentrated juice | $500–$850 | black_money |
| **Black Lotus** | lotus powder + black liquid extract | $500–$850 | black_money |
| **Island Pills** | cayo leaf + coral powder + island resin + perico capsules | $1800–$2800 | black_money |
| **Rebel Rolls** | rebel crystals + neon dye + pill binder + dove stamps | $500–$850 | black_money |

All **Island Pills** harvest + process benches are on **Cayo Perico** (airstrip, docks, crop fields, east shore). The island must be streamed on your server (`bob74_ipl` or equivalent). Existing Los Santos spots are unchanged.

All **Rebel Rolls** harvest + process benches are in **Paleto Bay**.

## Combat stim effects

**Pink Energy, Honda Pills, Black Lotus** share the same clean buff:
- **+25% armor**
- **45 seconds infinite stamina**
- **No screen effects / timecycle / shake**

**Island Pills** is a stronger Cayo exclusive:
- **+40% armor**
- **60 seconds infinite stamina**
- **No screen effects**

**Rebel Rolls** (Paleto ecstasy):
- **1.35x sprint speed** (GTA caps at 1.49)
- **45 seconds infinite stamina**
- **No screen effects / armor**

## Sell ranks + leaderboard

`/trap` sales count toward a 5-rank grind (`Config.Progression`). Open **`/drugboard`** for your rank and the top 10 sellers.

| Rank | Units sold | Pay bonus |
|------|------------|-----------|
| 1 Runner | 0 | — |
| 2 Hustler | 250 | +3% |
| 3 Plug | 800 | +6% |
| 4 Trap Star | 2,000 | +10% |
| 5 Kingpin | 4,500 | +15% |

Kingpin is a long grind (on the order of 60–90 hours of mixed harvest → process → sell). Progress is stored in resource KVP (no database).

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
