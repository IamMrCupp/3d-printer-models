# Bench instrument risers

> **Status: in progress.** Geometry is real and CI-validated, and the pedestals
> are printable as they stand. One check outstanding — see
> [Still open](#still-open). No preview, catalog row, or release yet.

Pedestals that lift bench instruments off the desk and give their footprint back
as storage. Each one stands on **Gridfinity feet**, so it latches into a
Clickfinity desk plate instead of skating on wood. Put one under each instrument
foot and the space underneath becomes open grid.

Current bench:

| Instrument | Pedestals | Height |
|---|---|---|
| Hot air station | ×4 | 6″ (152.4 mm) |
| Oscilloscope ([OWON ADS1014D](https://www.owon.com.hk/)) | ×2 | 2″ (50.8 mm) |

The scope only needs to be *seen* — it's the instrument you stare at and rarely
touch — which makes it the one thing on the bench that can afford to give up
prime desk real estate and go up.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Hot air pedestal** | `riser_pedestal_hotair.scad` | 83.5 × 83.5 × 152.4 mm | ×4 — feet down, no supports |
| **Scope pedestal** | `riser_pedestal_scope.scad` | 83.5 × 83.5 × 50.8 mm | ×2 — feet down, no supports |

Both are the same module at different heights. Shared dimensions live in
`riser_common.scad`.

## The lip

The top is a shallow tray — a raised rim all the way round a recessed pad. It
captures whatever sits on it sideways **without knowing anything about that
instrument's feet**, so every pedestal stays interchangeable. A pocket or a slot
has to be cut where one specific foot lands, which makes the part bespoke and
throws that away.

Defaults are `LIP_W = 2.5` mm wide, `LIP_H = 2.0` mm tall — slight on purpose.
It only has to stop the instrument walking, and a taller rim risks fouling a
chassis that overhangs its own feet. `LIP_H = 0` gives a flat top.

**The one thing to check: the foot has to fit inside the pad.** A foot wider or
longer than the recess perches on the rim instead of sitting in the tray, which
is worse than no lip at all. The pad size is echoed at render time:

| Footprint | Pad |
|---|---|
| 2×2 | 78.5 × 78.5 mm |
| 2×3 | 78.5 × 120.5 mm |

## Height is what goes underneath

A pedestal's height **is** the clear height under the instrument, measured from
the same datum a bin sits on — the desk plate's socket floor — so it compares
directly against a bin's total height.

Clickfinity's latch **grips**: a bin comes out by pulling straight up against
four arms per cell. The clearance has to cover the bin, the release travel, and
room to get a hand in. Sizing to bin height alone builds a shelf whose bins you
can't extract. Rule of thumb — usable bin height is about `RISER_H − 40`:

- **6″ under the station** takes the tallest bin in the repo (the 55 mm OWON cord
  well) with room to spare
- **2″ under the scope** is shallow trays only, roughly 10 mm

Neither height is a hard constraint. Override without editing anything:

```bash
openscad -o r.stl --export-format binstl -D RISER_H=90 riser_pedestal_scope.scad
```

## Modelled solid

No cavity, no walls, no open front. The slicer's infill decides how much material
this uses, which is the right place for that decision — a hollow shell would need
an opening to be useful, and an opening on a load-bearing pedestal puts a weak
axis under an instrument. Storage goes in the open grid *between* the pedestals,
which is the point of raising anything.

## Aspect ratio on the 6″ pedestal

At 152.4 mm on an 84 mm square footprint, the hot air pedestals are **1.81:1**
tall against wide. That's past the `MAX_ASPECT` guideline of 1.6, and rendering
echoes a warning rather than failing — whether it can be widened depends on the
station's foot spacing, which the model doesn't know.

It's a handling concern, not a structural one. A Gridfinity foot in a socket
resists sideways load well, and once the station is on top its own chassis ties
the four pedestals together. The awkward moment is placing a heavy station on
four tall posts single-handed.

If the station's feet are far enough apart to take 126 mm pedestals:

```bash
openscad -o hotair.stl --export-format binstl -D GX=3 -D GY=3 riser_pedestal_hotair.scad
```

That drops the ratio to a comfortable 1.21:1.

## Source

Parametric OpenSCAD, on `lib/gridfinity.scad`. The asserts in `riser_common.scad`
catch what a mesh check can't — a lip taller than the material above the feet, a
rim wider than the corner radius it's offset from, a height that doesn't clear
the Gridfinity foot, anything past the 270 mm bed.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 4 |
| Infill | 20% — 40% under the hot air station if you want it dead solid |
| Supports | none |
| Orientation | as emitted, feet down |

## Still open

- **Scope foot length, front to back.** The scope has two feet, one per side, so
  each pedestal carries one foot and all the front-to-back stability comes from
  that foot's own length. If a foot overhangs its pedestal you've *shortened* the
  effective base by raising it. Over ~80 mm, use the 2×3 (`-D GY=3`, pad
  78.5 × 120.5); under ~55 mm the 2×2 is fine.
- **Hot air station foot spacing** — decides whether the 6″ pedestals can go 3×3
  and shed the aspect-ratio warning.
- Whether the station's underside vents. Four corner pedestals *improve*
  under-chassis airflow, so this is likely a bonus rather than a problem, but
  worth a look before committing.
