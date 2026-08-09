# Oscilloscope riser — OWON ADS1014D

> **Status: skeleton.** The geometry is real and CI-validated, but it is sized
> against **placeholder measurements**. Print `riser_foot_gauge.scad` and nothing
> else until the constants tagged `[MEASURE]` in `riser_common.scad` have been
> replaced with readings off the actual scope. No preview, catalog row, or
> release until then.

A pair of blocks that lift an [OWON ADS1014D](https://www.owon.com.hk/) off the
bench and give its footprint back as storage. The scope only needs to be *seen* —
it's the instrument you stare at and rarely touch — so it's the one thing on the
bench that can afford to go up and back. Everything it was sitting on becomes
open grid underneath.

Each block stands on **Gridfinity feet**, so it latches into a Clickfinity desk
plate rather than skating on wood. The span between the two blocks stays open
grid — that's where bins go, and it's what the block height is sized around.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Left block** | `riser_block_left.scad` | 83.5 × 167.5 × 99 mm | ×1 — top face on the bed, feet up, no supports |
| **Right block** | `riser_block_right.scad` | 83.5 × 167.5 × 99 mm | ×1 — same orientation |
| **Foot gauge** | `riser_foot_gauge.scad` | 168 × 34 × 4.1 mm | **print this first** |

Sizes above are the placeholder render — they'll move once the scope is measured.
Shared dimensions live in `riser_common.scad`.

The two blocks are mirror images, not copies. They're only identical if the
scope's feet happen to land on grid centres (`POCKET_DX == 0`).

## Why two blocks and not one riser

The ADS1014D is roughly 340 mm wide against the U1's 270 mm bed. A single
bridging riser would need tiling and joining. Two blocks — one under each side,
with the scope bridging them — means nothing spans the full width, nothing has to
be joined, and no part comes near the bed limit. It's also how the scope's own
feet already carry it.

## Why a solid top

`stack_base()` in `lib/gridfinity.scad` is the closest shared module — Gridfinity
feet below, open-front cavity, baseplate cap above — and this uses its idiom with
one change: the top is **solid**, not a baseplate cap. The cap is a socket grid,
and the scope's rubber feet would land across socket openings and rock. A cap
earns its keep when a Gridfinity bin stacks on it; a scope isn't a bin.

Instead the top plate carries a shallow **locating pocket** under each foot. The
pocket only stops the scope creeping — it isn't a clamp. Deep pockets on
compliant rubber feet make the scope awkward to lift off and add nothing.

## Height is set by what goes underneath

`BLOCK_H` is derived, not hand-set:

```
BLOCK_H = MAX_BIN_H + HAND_CLEAR + TOP_T
```

Clickfinity's latch **grips** — a bin comes out by pulling straight up against
four arms per cell. So the clearance has to cover the bin, plus the release
travel, plus room to get a hand in. Sizing to the bin height alone builds a shelf
whose bins you can't extract. `HAND_CLEAR` defaults to 40 mm; below about 30 it
gets unpleasant one-handed.

## The gauge

`riser_foot_gauge.scad` is six blind pockets, 10–20 mm, notch-tallied, at the
riser's real pocket depth. Print it, try the scope's foot in each, and keep the
smallest one it seats into without being forced.

It exists because calipers measure the wrong thing. The number the top plate
depends on is the **finished pocket** a foot drops into — which folds the foot's
diameter, its rubber compliance, and this printer's hole shrinkage into one
reading. Calipers give you one of the three. The pockets are blind rather than
through-holes for the same reason: the OWON tip gauge used through-holes and a
tip "falling through" read as loose when the real blind bores held it fine.

## Source

Parametric OpenSCAD. Render with:

```bash
openscad -o riser_block_left.stl --export-format binstl riser_block_left.scad
```

`riser_common.scad` carries geometry asserts that catch what a mesh check can't —
pockets falling off the top plate, a pocket punching through it, blocks closer
together than a grid cell. Those fail at render time rather than producing a part
whose pockets miss the feet.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 4 |
| Infill | 20% — these carry an instrument, not decoration |
| Supports | none |
| Orientation | as emitted — top face on the bed, feet up |

The blocks print upside down on purpose. The top face is the precision surface —
it carries the load and the foot pockets — and it comes out flattest against
glass. It also puts the cavity opening upward during the print, so there's no
ceiling to bridge.

## Still open

- Every `[MEASURE]` constant — scope body, foot spans, foot diameter
- Whether the feet are round. A long rubber strip foot wants a slot, not a bore,
  and that's a different top plate.
- Whether the derived block depth wastes material against real feet. If it does,
  the fix is a grid-sized block with the top plate overhanging on gusseted end
  shelves — the trick `owon_tray_frame` uses. Deliberately not built against
  placeholder numbers, since an overhang puts the scope's load on a cantilever.
