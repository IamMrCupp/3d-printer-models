# Bench instrument risers

> **Status: in progress.** Geometry is real and CI-validated, and the pedestals
> are printable as they stand. Two things are still unconfirmed — see
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
| **Foot gauge** | `riser_foot_gauge.scad` | 168 × 34 × 4.1 mm | only if you want locating pockets |

Both pedestals are the same module at different heights. Shared dimensions live
in `riser_common.scad`.

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

## Flat tops, on purpose

A locating pocket has to be cut where that instrument's foot lands, which makes
the part bespoke — and the value here is that every pedestal is interchangeable.
The pedestal is latched to the plate and can't move; the instrument sits on it on
its own rubber feet, which grip PETG fine.

`riser_foot_gauge.scad` is there if something does creep in use — six blind
pockets, 10–20 mm, notch-tallied. It exists because calipers measure the wrong
thing: the number that matters is the **finished pocket** a foot drops into,
folding the foot's diameter, its rubber compliance, and this printer's hole
shrinkage into one reading. The pockets are blind rather than through-holes for
the same reason the OWON tip gauge should have been — a tip "falling through" a
through-hole reads as loose when the real blind bore holds it fine.

Set `POCKET_D` above 0 to use it, and accept that those pedestals stop being
interchangeable.

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
the four pedestals together. The awkward moment is placing the station on four
tall posts single-handed.

If the station's feet are far enough apart to take 126 mm pedestals:

```bash
openscad -o hotair.stl --export-format binstl -D GX=3 -D GY=3 riser_pedestal_hotair.scad
```

That drops the ratio to a comfortable 1.21:1.

## Source

Parametric OpenSCAD, on `lib/gridfinity.scad`. The asserts in `riser_common.scad`
catch what a mesh check can't — a pocket deeper than the material above the feet,
a pocket wider than the pedestal, a height that doesn't clear the Gridfinity
foot, anything past the 270 mm bed.

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

- **Does the scope really need only two pedestals?** Two under a four-footed
  scope only works if each pedestal catches *both* feet on its side — that needs
  a front-to-back foot span of roughly 84 mm minus the foot diameter. If the span
  is wider, this wants four pedestals or two 2×3 rails instead.
- **Hot air station foot spacing** — decides whether the 6″ pedestals can go 3×3
  and shed the aspect-ratio warning.
- Whether the station's underside vents. Four corner pedestals *improve*
  under-chassis airflow, so this is likely a bonus rather than a problem, but
  worth a look before committing.
