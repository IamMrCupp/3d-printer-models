# Heat gun holder

![Heat gun holder](preview.png)

**Gridfinity** 2×2 plate that the heat gun's magnetic bracket screws down onto, putting the gun
on the grid instead of loose on the bench.

## Why 2×2 and not 2×1

The hole pattern is only 36 × 21, which a 2×1 would take. The constraint is **latch force**, not
geometry — Clickfinity holds roughly 12.2 N per cell:

| | Cells | Hold |
|---|---|---|
| 2×1 | 2 | ~24 N (2.5 kgf) |
| **2×2** | 4 | **~49 N (5 kgf)** |

Pulling a heat gun off a magnetic bracket beats 2.5 kgf easily, and then the plate lifts with the
gun rather than the gun leaving the bracket.

## Screws

Measured at **2.84 mm** thread OD (that's 0.112″, a #4). The pilot is **2.22 mm** — 78 % of OD,
because a self-tapper cuts its own thread and a hole at full OD strips instead of biting.

The model stores `SCREW_OD` and derives the pilot from it, so re-sizing means changing the
measurement rather than hand-editing a hole.

Holes are **blind, 10 mm deep** in a 12 mm deck, so a screw can never break through into the
baseplate socket underneath.

## Parts

| File | What | Size |
|---|---|---|
| `plate_heat_gun.scad` | 2×2 plate, 4 bosses at ±18 / ±10.5 | 83.5 × 83.5 × 16.75 mm |

## Source

```sh
openscad -o plate_heat_gun.stl --export-format binstl plate_heat_gun.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PETG — screws into PLA creep and loosen |
| Layer height | 0.2 mm |
| Walls | 4 perimeters — the bosses take the thread |
| Infill | 30 % around the screw bosses |
| Supports | **None** |
