# Microscope base platform baseplate

![Microscope base platform baseplate](preview.png)

A **5×3 Gridfinity baseplate** that wraps the raised plateau on a microscope boom stand's weighted base, clears the boom pole, and turns that dead footprint into **13 usable cells**. Mainly a home for the Kimwipe box that already lives there, plus everything that used to get set down beside it.

> **Not the oscilloscope.** That one is [`bench-instrument-risers/`](../bench-instrument-risers/). This is the *microscope* boom base.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Baseplate** | `scope_wipe_plate.scad` | 210 × 136.38 × 17.85 mm | ×1 — **grid down**, no supports |
| **Wrap coupon** | `coupons/scope_wrap_coupon.scad` | 21 × 136.38 × 17.85 mm | **print first** — ~9 g |
| **Corner gauge** | `coupons/scope_corner_gauge.scad` | 192 × 94 × 3 mm | only if your stand differs |

Dimensions live in `scope_plate_common.scad`.

## This is a rebuild

The previous version was a 3×3 with a skirt open at the back for the pole. Both premises were wrong, and the printed part was unusable:

- **The pole doesn't rise at the back edge.** It rises from a boss about a fifth of the way in from one end. A plate that opens toward the back never reaches it.
- **131.84 wasn't the plateau's length.** It was a short reading of the same plateau — 200.03 is the real number. The width was right both times; 130.54 and 130.18 are the same edge measured twice.

Nothing carried over but the Gridfinity pitch and the gauged corner radius.

## How it mounts

No hardware. The skirt drops 12 mm down the plateau's 17.76 mm step and hugs it on **both long sides and the far end**. **Slide it on lengthwise from the near end**, pole passing up through the slot, until the far wall bears against the plateau's far edge — that's the stop, and it lands within 0.6 mm of designed.

The near end is open on purpose. Anything hanging down across it would hit the plateau's edge and stop the plate 12 mm short. It's also what lets you fit the plate without pulling the microscope head off the pole.

The near end is the one **41.28 mm** from the boss centre, not the 158.75 mm end.

## Why five rows, hanging over the ends

5 × 42 = 210 against a 200.03 mm plateau, so the plate hangs about 5 mm past each end. That's deliberate:

| Layout | Cells | Lost to the pole | Usable |
|---|---|---|---|
| 4 rows, slid to align the boss | 12 | 1 | 11 |
| **5 rows, overhanging** | **15** | **2** | **13** |

Four rows leaves 32 mm of slack, enough to slide a row *centre* onto the boss so it only eats one cell. Five rows can't — every offset in the valid range straddles a boundary, so the pole costs two. You still come out two cells ahead, and the 32 mm of dead border stops existing.

**The overhang is plate, not bin.** Every socket stays a full 42 mm, so bins seat normally. What cantilevers is ~5 mm of plate per end, and the skirt hangs *inboard* of the tips, under the cells — so the wrap costs nothing.

## Print the coupon first

`coupons/scope_wrap_coupon.scad` is a 22 mm band sliced off the far end of the real plate — both side walls at true spacing, the far end wall, both corners. **~9 g against the plate's ~50 g.**

It's an `intersection()` against the actual model, not a re-derivation, so it can't drift from the part it stands in for.

| What it does | What it means |
|---|---|
| Drops on, sits flat, no rock | `FIT` and `CORNER` are right — print the plate |
| Binds on the flats | `FIT` too small |
| Flats seat, corners hang up | `CORNER` too big |
| Rocks, or the wall bottoms out before the plate is flat | The step is shallower than 17.76 |
| Rattles | `FIT` too large |

One wall tells you nothing about the width — 0.6 mm a side over 130 mm is exactly what PETG shrink eats, and you need both walls at true spacing to see it. Print it in the same material as the plate for that reason.

It doesn't test the pole slot or the boss position. Those live at the other end.

## Fit

| Dimension | Value | How |
|---|---|---|
| Plateau | 200.03 × 130.18 mm (7⅞ × 5⅛") | tape |
| Step height | 17.76 mm | calipers — sets the 12 mm skirt depth |
| Corner radius | ~15 mm | **gauged**, not calipered |
| Boss ⌀ | 39.78 mm | calipers |
| Boss from the far end | 158.75 mm (6¼") | tape |
| Boss across the width | **assumed centred** | ⚠️ see below |

**`CORNER` is 14, not the midpoint 15** — the error is asymmetric. A larger `CORNER` rounds the skirt opening more, making it *smaller* at the corners, so it binds:

| `CORNER` | real R=14 | R=15 | R=16 |
|---|---|---|---|
| **14** | clears | clears | clears |
| 15 | **binds** | clears | clears |
| 16 | **binds** | **binds** | clears |

`FIT` is **1.2 mm**, deliberately not 0.4 — that's the clearance that failed on the OWON tray frame over a similar span. PETG shrinks ~0.5 mm across 130 mm, so an internal dimension prints undersize and binds.

**The boss position across the width is an assumption.** The tape read 92.08 mm (3⅝") from one long edge, which is 27 mm off-centre on a 130.18 mm width and doesn't reconcile with the eyeball "it looks centred". Centred is the working assumption.

If it's off-centre, the slot moves and two more cells die — 13 drops to 11. The width has only 4.18 mm of slack, so unlike the length there's no sliding out of it. Set `BOSS_Y` and everything else follows. To settle it: caliper from the boss edge to each side of the 5⅛" face, and see whether the two numbers match.

## Why the pole slot is 44 mm wide

Not fit — manifoldness. The cell pitch is 42 and the boss is 39.78, so any "natural" slot width lands within a millimetre of a socket boundary, and at the plate's top face adjacent socket openings meet exactly at ±21. A cut plane tangent to that line is the same class of bug that put 96 non-manifold edges in the thermal mount's counterbore.

44 clears the whole middle column and passes 1 mm into the neighbouring sockets' outer taper — comfortably off every boundary. It costs a 1 mm nick in one wall of the two cells either side, which is cosmetic: Gridfinity retention is perimeter-wide.

## What v2.0.0 got wrong

**The skirt ran through the sockets of the end rows, and nothing seated.**

The skirt ring is 206.23 long against a 210 mm grid, so its two end sections sit at |x| 100.62–103.12 — inside the last row of cells. It was extruded from −12 all the way up to `BP_H` so it would merge with the plate volumetrically instead of only touching it, and that put a solid 2.5 mm bar straight through those sockets: **448 mm³ in every row-5 cell, 220 mm³ in row 1.** Opening the near end didn't save it, because that cut only removed material below z=0.

The skirt now stops at **z=0**, butting the plate's underside at an exact plane. It still merges — the side rails overlap it in Y above z=0, and the end sections sit directly under the grid.

**Every check in the repo passed the broken part:** watertight, 2-manifold, correct bounding box, one connected body, corner walls present, seats on the plateau, slides on through all 14 positions, clean on OpenSCAD 2021.01. The per-cell check that would have caught it was run *before* the skirt was added and never re-run after.

`tools/check_sockets.py` exists now so that can't recur:

```sh
python3 ../tools/check_sockets.py scope_plate_common.scad "scope_wipe_plate()" 5 3
```

Put the old skirt back and it reports `FAIL 5 socket(s) have material in them`. A socket is defined by what *isn't* there, so every check that looks for material being present is blind to this class of bug.

## Verified

Measured on the rendered mesh, not asserted:

- **13 cells** at ≥91% of an intact cell's material; the two dead ones are the middle column, rows 1–2
- **Single connected body** — 1 component, not a plate and a loose ring
- **Boss passes clean through** — zero intersection with a 39.78 cylinder at the boss position
- **Slides on** — a plateau solid swept the full insertion path, 14 positions, no contact until seated
- **Seats and stops** — clear at 0 mm, bears on the far wall at +1 mm
- **Every socket clear** — `tools/check_sockets.py`, the check that was missing from v2.0.0
- Clean on **OpenSCAD 2021.01** (what CI runs) as well as current builds

## Source

```sh
openscad -o scope_wipe_plate.stl --export-format binstl scope_wipe_plate.scad
```

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% grid |
| Supports | **None** |
| Orientation | **Grid face down**, skirt walls up |

Print it **upside down**. Grid up puts a 200 × 130 flat ceiling 12 mm in the air inside the skirt — the pathological support case. Flipped, the plate lies on the bed, the skirt walls print as plain vertical walls, and the socket chamfers are all self-supporting. No supports at all.

210 × 136.38 fits the 270 mm bed with room to spare.
