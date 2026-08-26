# Heat gun holder

![Heat gun holder](preview.png)

**Gridfinity** 2×2 plate that the heat gun's magnetic bracket screws down onto, putting the gun
on the grid instead of loose on the bench.

## It bolts from below

The bracket takes screws only from its underside, so they come **up through the plate** into the
bracket's own threads — not down into the plastic.

That inverts the whole plate. v1.0.x had four blind 2.22 mm pilots 10 mm deep in a 12 mm deck:

| | v1.0.x | now |
|---|---|---|
| Holes | blind, 2.22 pilot | **through, 3.24 clearance** |
| Screw head | on top of the bracket | **recessed 4 mm into the foot** |
| Deck | 12 mm | **5 mm** |
| Plate height | 16.75 mm | **9.75 mm** |

A pilot would bind the shank, and a head left proud on the underside holds the plate off the grid
so the latch never seats.

## The deck is sized by screw reach

This is the part that's easy to get wrong. A screw entering from below has to cross the whole
plate before it reaches the bracket:

| Deck | Plate | Screw crosses | Needs a screw of |
|---|---|---|---|
| 12 mm (old) | 16.75 | 12.75 | **17 mm+** |
| 8 mm | 12.75 | 8.75 | 13 mm+ |
| 6 mm | 10.75 | 6.75 | 11 mm+ |
| **5 mm** | **9.75** | **5.75** | **10 mm+** |
| 4 mm | 8.75 | 4.75 | 9 mm+ |

At the old 12 mm deck the screw would need to be 17 mm long just to get 4 mm of bite. 5 mm is the
default because a 10 mm screw then gives 4.25 mm of engagement.

**Measure your screws and pick the row.** Override without editing:

```sh
openscad -o p.stl --export-format binstl -D DECK=6 plate_heat_gun.scad
```

## What's measured and what isn't

**Measured:** the hole pattern (36 × 21 centre to centre, a true rectangle) and the screw's
2.84 mm thread OD.

> ⚠️ **Not measured: the screw heads.** `HEAD_D = 8.0` and `HEAD_H = 4.0` are set **generously on
> purpose.** An oversized recess loses a little material; an undersized one holds the plate off
> the grid and the latch never seats. Wrong in the safe direction.

> ⚠️ **Not measured: screw length** — and it matters more now than it did. Too short and it never
> reaches the bracket; too long and it bottoms out inside the bracket before the plate pulls
> tight, which feels like a loose bracket rather than a wrong screw.

## Why 2×2 and not 2×1

The hole pattern is only 36 × 21, which a 2×1 would take. But Clickfinity holds about 12.2 N per
cell — a 2×1 is ~24 N (2.5 kgf), a 2×2 is ~49 N (5 kgf). Pulling a heat gun off a magnetic
bracket beats 2.5 kgf easily, and then the plate lifts with the gun.

## Recommended print settings

| | |
|---|---|
| Material | PETG — screws into PLA creep and loosen |
| Layer height | 0.2 mm |
| Walls | 4 perimeters — the bosses take the thread |
| Infill | 30 % around the screw bosses |
| Supports | **None** |
