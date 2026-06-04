# Drybox splitter stand

A stand that raises a [PolyDryer Splitter Mod](https://www.thingiverse.com/thing:7028485) assembly — two PolyDryer boxes on the splitter/dryer base — **~4.5″ off the desk**, with an open-front **storage cubby** underneath whose floor is an **integrated 6×6 Gridfinity baseplate**.

| | |
|---|---|
| **Overall size** | 260 × 260 × 126 mm (fits the Snapmaker U1 270³ bed in one piece) |
| **Lift** | 114 mm (4.5″) — set `raise` to 101.6 for 4″ or 127 for 5″ |
| **Storage** | 6×6 Gridfinity grid (36 cells), open front, side/back windows |
| **Cradle** | Top platform holds the two-box footprint; front lip notched 110 mm for the dryer display; back lip notched for the power lead |

## Gridfinity

The cubby floor is a spec-correct Gridfinity baseplate (42 mm pitch, 41.5 mm bins, 0.7/1.8/2.15 = 4.65 mm socket profile, 4 mm corner fillet). Standard Gridfinity bins from any generator drop straight in.

## Source

Generated from OpenSCAD — `drybox_splitter_stand.scad` is the source of truth:

```sh
openscad -o drybox_splitter_stand.stl --export-format binstl drybox_splitter_stand.scad
```

Key parameters (top of the file): `gx`/`gy` (grid), `raise` (lift height), `disp_w` (display notch), `cable_w` (back notch). The Gridfinity baseplate is a self-contained module in the same file.

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | As modeled — baseplate down, open front facing you. No supports needed (windows/notches bridge fine). |
| Material | PETG or PLA (PETG if it sits near a warm dryer) |
| Layer height | 0.2 mm |
| Walls / perimeters | 4 (it carries a heavy, top-heavy load) |
| Top / bottom layers | 5 |
| Infill | 15–20 % |
| Supports | None |

Big single-piece print — budget several hours of filament. You'll typically want **two** (one per spool-pair on a 4-feeder U1).
