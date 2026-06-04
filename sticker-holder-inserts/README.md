# Sticker-holder inserts

Rectangular tray inserts with a centered grid of square pockets that hold square stickers. Two layouts share one outer shell — pick the one that matches your sticker size.

| Model | Sticker | Grid | Pockets | Pocket (inner) |
|---|---|---|---|---|
| `insert_2x2_stickers_3x3` | 2″ (50.8 mm) | 3 × 3 | 9 | 51.3 mm sq, 3 mm rounded corners |
| `insert_3x3_stickers_2x2` | 3″ (76.2 mm) | 2 × 2 | 4 | 76.7 mm sq, 3 mm rounded corners |

- **Outer footprint:** 183 × 180 mm
- **Height:** 30 mm (floor 2.9 mm, pocket depth ≈ 27 mm)
- **Pocket fit:** sticker size + 0.5 mm clearance so squares drop in cleanly

## Downloading

Printable STLs (plus a preview image) are attached to each **[GitHub Release](https://github.com/IamMrCupp/3d-printer-models/releases)** — look for a tag like `sticker-holder-inserts/vX.Y.Z`. The repo itself holds the OpenSCAD source; STLs are rendered from it, not committed.

## Source

The models are generated from OpenSCAD — `*.scad` is the source of truth:

```sh
openscad -o insert_2x2_stickers_3x3.stl --export-format binstl insert_2x2_stickers_3x3.scad
openscad -o insert_3x3_stickers_2x2.stl --export-format binstl insert_3x3_stickers_2x2.scad
```

[`sticker_insert.scad`](sticker_insert.scad) is a shared, parametric module — change `cols`, `rows`, `spacing_x/y`, or `sticker` (nominal square size) to make new layouts. Pocket = `sticker + POCKET_CLEARANCE`, with `POCKET_CORNER_R` rounded corners.

> **Note:** reconstructed from the original meshes (original CAD wasn't preserved). The grid spacing matches the originals; pockets are square (the early meshes had circular holes) and the models are authored Z-up.

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | Flat on the bed, pockets up. No supports needed. |
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls / perimeters | 3 |
| Top / bottom layers | 4 |
| Infill | 15 % |
| Supports | None |

Footprint is 183 × 180 mm — fits a 220 × 220 bed comfortably; will not fit 180 × 180 without rotation.
