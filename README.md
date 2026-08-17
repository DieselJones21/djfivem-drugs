# djfivem-drugs

Config-driven FiveM drug economy: **harvest → process → `/trap` sell**.

Built for **QBX (`qbx_core`) + ox_lib + ox_target + ox_inventory**.

## Features

- Add new drugs from config only (no code changes)
- Harvest **bench props** at ingredient stations (3rd eye the prop)
- Store supply grabs (baggies, cups, sprite, acetone, hard candies) — no custom props
- Ice **machine props** for lean
- Processing **bench/table props** for every drug
- `/trap` street selling: NPC runs up, 3rd-eye, random qty + opening price
- Ask for higher prices with chance-based success (buyer may counter, refuse, or walk)
- **Usable drug effects** when consuming finished product (screen FX, speed, armor, stress, etc.)

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
| **Pink Energy** | 4 ingredient benches | meth table | $550–$900 |
| **Weed** | weed bud bench + store baggies | weed table | $80–$160 |
| **Cocaine** | coca leaf bench + acetone/baggies | coke table | $250–$420 |
| **Lean** | codeine + ice + cups/sprite/hard candies | tool bench | $140–$260 |
| **Honda Pills** | capsules + formula + extract | tool bench | $500–$850 |
| **Stab Juice** | stab powder + stab candy + concentrated juice | tool bench | $500–$850 |

## Drug effects

Finished drugs are usable from inventory.

1. **QBX auto-registers usables** for every finished drug (works even without ox item exports)
2. Optional ox_inventory `client.export` (see `install/ox_inventory_items.lua`)

On resource start, the console prints the exact export string for your folder name.

- Toggle globally: `Config.UseEffects = true`
- Per-drug: `Config.Drugs.<id>.effects`
- Stress relieve: `Config.StressEvent` (default `hud:server:RelieveStress`)

Flow: use item → progress → consume 1 → high → wears off.

If Use does nothing: merge ox items, restart `qbx_core`/`djfivem-drugs`, then use a finished product from inventory.

## Coords

See `install/LOCATIONS.md` (Honda + Stab Juice harvest spots are placeholders — edit freely).

## Adding a new drug

1. Add ox_inventory items  
2. Add `type = 'bench'` harvest spots  
3. Add a `Config.Drugs` block with `process`, `sell`, and optional `effects`  

## Layout

```
client/     harvest, process, /trap sell, effects
server/     validation, ox_inventory, qbx money, usables
config/     config.lua + drugs.lua
shared/     utils + qbx/ox bridge
install/    ox items + locations
```
