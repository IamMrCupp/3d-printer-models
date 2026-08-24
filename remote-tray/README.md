# Remote tray

![Remote tray](preview.png)

**Gridfinity** 4×2 tray holding six remotes on end, two rows of three, each in a slot cut to
that remote.

## Why slots and not a bin

Six remotes in a shared well fall over each other and you dig for the one you want. The
thinnest here is 8 mm and the thickest 35 — in a common well the thin ones just lie down.

A slot per remote also means each one can only go back where it came from, and each row
presents at a single front line rather than staggering.

## Slots

Back row, depth set by the 35 mm LG:

| Remote | Width × thickness | Slot |
|---|---|---|
| LG 4K TV | 45 × 35 | 46 × 36 |
| Insignia TV | 50 × 20 | 51 × **24** |
| Fume extractor | 48 × 8 | 49 × 9 |

Front row, depth set by the Rokus:

| Remote | Width × thickness | Slot |
|---|---|---|
| Roku | 42 × 21 | 43 × 22 |
| Roku | 42 × 21 | 43 × 22 |
| Microscope cam | 41 × 10 | 42 × 11 |

Front-aligned within a row, 3 mm dividers. Add or reorder by editing the `ROWS` list — widths,
row depths and positions are all computed from it, and asserts fire if a row no longer fits.

## The Insignia slot is 4 mm deeper than the remote is thick

Every other slot gets 1 mm of clearance. The Insignia gets 4, because **it jammed on its own
buttons the moment it entered the slot**. 20 mm is the thickness of the *body*; the thing that
actually has to pass through the slot is the button crown standing proud of it, and nobody
measured that.

> ⚠️ `BUTTON_BULGE = 3.0` is an **allowance, not a measurement.** If it still catches, don't
> raise it by feel — put calipers across the remote *at the buttons* and make that number the
> thickness in the `ROWS` table.

This is the same failure as the tip tinner, where the 42.5 mm lid got measured and the 38.38 mm
body was the part that had to fit. Measure the feature that passes through the hole.

## Why 4×2 and not 6×1

**There are two Roku remotes.** That is what killed the single row, and it isn't a matter of
tightening clearances:

| | |
|---|---|
| Six remote widths, touching, no walls at all | **268 mm** |
| 6×1 interior | **249.1 mm** |
| Shortfall before a single divider | **19 mm** |

With real clearance and 3 mm dividers it needs 289. A 7×1 *would* hold it — 291.1 mm of interior
— but it's 293.5 mm outer and **exceeds the 270 mm bed**. Stacking the two Rokus back-to-back in
one slot doesn't rescue it either: 42 mm of combined thickness against 39.1 mm of depth.

So the row folds in half. A 4×2 costs eight cells, which is what a 6×1 plus a 2×1 would have
cost anyway, and it's one part instead of two.

**Rows split by thickness, not by which remote you use most.** Each row is only as deep as its
own thickest member, so the 35 mm LG and the 8 mm fume extractor share a row for free. Spreading
the thick ones across both rows would make *both* rows 36 mm deep and blow the depth budget.

**Dividers went back to 3 mm.** The 6×1 ran 2 mm because at 3 it needed 249.0 of 249.1 available
— not a fit, a coincidence. The widest row here needs 152 of 165.1, so the dividers stop being
the thing holding the design together.

## Capture depth

`CAPTURE = 50` is a compromise across a 90–180 mm range of remote lengths. The shortest is held
over halfway with 40 mm to grab; the longest stands ~130 mm proud but is gripped on all four
sides like a book in a shelf, which a round bore could not do.

## Source

```sh
openscad -o tray_remotes.stl --export-format binstl tray_remotes.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** |
