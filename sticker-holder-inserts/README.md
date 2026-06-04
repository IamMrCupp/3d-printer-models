# Sticker-holder inserts

Rectangular tray inserts with a centered grid of circular pockets that hold rolls/discs of stickers. Two layouts share one outer shell — pick the one that matches your sticker size and how many you want to sort.

| File | Grid | Pockets | Pocket ⌀ |
|---|---|---|---|
| [`insert_2x2_stickers_3x3.stl`](insert_2x2_stickers_3x3.stl) | 3 × 3 | 9 | 16.5 mm |
| [`insert_3x3_stickers_2x2.stl`](insert_3x3_stickers_2x2.stl) | 2 × 2 | 4 | 16.5 mm |

- **Outer footprint:** 183 × 180 mm
- **Height:** 30 mm (floor 2.9 mm, pocket depth ≈ 27 mm)

## Source

The models are generated from OpenSCAD — `*.scad` is the source of truth, the `.stl` is a build artifact:

```sh
openscad -o insert_2x2_stickers_3x3.stl --export-format binstl insert_2x2_stickers_3x3.scad
openscad -o insert_3x3_stickers_2x2.stl --export-format binstl insert_3x3_stickers_2x2.scad
```

[`sticker_insert.scad`](sticker_insert.scad) is a shared, parametric module — change `cols`, `rows`, `spacing_x/y`, or `POCKET_DIA` to make new layouts.

> **Note:** these are a *reconstruction*. The original CAD source wasn't preserved, so the parameters were recovered by measuring the original meshes. The geometry matches the originals; the models are now authored Z-up (correct print orientation — the originals were modeled with height on the Y axis).

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | As modeled — flat on the bed, pockets up. No supports needed. |
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls / perimeters | 3 |
| Top / bottom layers | 4 |
| Infill | 15 % |
| Supports | None |

Footprint is 183 × 180 mm — check it fits your bed (it does not fit a 180 × 180 bed without rotation; a 220 × 220 bed is comfortable).
