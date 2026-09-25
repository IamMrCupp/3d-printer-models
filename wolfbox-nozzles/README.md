# Wolfbox MF50 nozzle bin

![Wolfbox MF50 nozzle bin](preview.png)

A **4×2 Gridfinity bin with eight octagonal nozzle pockets** for the Wolfbox MF50.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Nozzle bin** | `bin_nozzles_mf50.scad` | 167.5 × 83.5 × 24.75 mm | ×1 — feet down, no supports |

206.6 cm³, about 92 g.

## Pockets sized from the nozzle

Calipered on an aftermarket MF50 nozzle:

| | nozzle | pocket (+0.2 clearance) |
|---|---|---|
| octagonal collar, across the flats | 36.6 | **36.8**, 9 mm deep |
| round body below the collar | 30.2 | **30.4**, 8 mm deep |
| floor under the bore | | 3 mm |

The collar drops into the recess and rests on its floor, and the body hangs in the bore. `NOZZLE_CLR` sets the clearance; raise it if your printer runs tight.

⚠️ **The recess is an octagon, not a hexagon.** The nozzles' collars are octagonal, and it's easy to mistake one for a hex at a glance.

**A regular octagon's bounding box is its across-flats, not its across-corners** — the corners sit at ±22.5° and fall *inside* the box. Sizing the pitch off the across-corners would suggest 1.4 mm walls between pockets; the real figure is the across-flats, which leaves plenty:

| | pitch | wall |
|---|---|---|
| X | 41.28 | **4.48 mm** |
| Y | 40.55 | **3.75 mm** |

## Verified

Rastered cross-sections of the finished bin:

- **8 pockets**, evenly spaced; octagon **36.40 × 36.40**, corner-⌀ **39.52**; bore **30.40** — matching the modelled pockets within raster resolution
- single connected body
- **no supports**: 9.4% overhang against a plain `bin_blank(4,2)`'s 12.8%, with an *identical* 306.7 mm² above 50°. The pockets add no steep overhang — all of it is the standard Gridfinity foot
- clean on **OpenSCAD 2021.01**, what CI runs

## Eight, not six

This one is for the aftermarket set; the stock nozzles live elsewhere.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% grid |
| Supports | **None** |
