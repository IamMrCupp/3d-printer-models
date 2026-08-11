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

## Hollow, because solid was unprintable

These were modelled solid at first, on the theory that infill percentage is the
right place to decide how much material a part uses. That doesn't survive a 6″
pedestal. A solid 2×2 × 152 mm block is **1043 cm³**, and sliced four-up it came
out at **36 hours and 995 g** — with **85% of that time in sparse infill alone**.
Walls were 3h40m of the job; infill was over thirty hours.

So the interior is removed in the model instead. What's left:

- the **Gridfinity feet, fully solid** — every latch surface untouched
- a 3 mm perimeter shell
- **ribs on the cell boundaries**, which do double duty: they carry load up the
  middle, they put material back exactly where the cavity would otherwise thin
  the internal foot walls, and they cut the cap's bridge span down to one cell,
  which is what makes a solid top printable over a hollow
- a 6 mm solid cap under the pad
- a **vent hole per cell** through the floor, so nothing is a sealed void

That's **242 cm³** — 77% less material, same outside geometry.

The cavity is structural, not usable storage. Storage goes in the open grid
*between* the pedestals, which is the point of raising anything.

## Cell budget — why the 6″ pedestals stay 2×2

At 152.4 mm on an 84 mm square footprint the hot air pedestals are **1.81:1**
tall against wide, past the `MAX_ASPECT` guideline of 1.6. Rendering echoes a
note rather than failing, and the obvious fix — widen to 3×3 — **doesn't work**:

| Footprint | Cells each | ×4 | On a 6×6 plate (36 cells) |
|---|---|---|---|
| 2×2 | 4 | 16 | 20 cells free |
| 3×3 | 9 | **36** | **zero free — fills the plate edge to edge** |

Four 3×3 pedestals tile an entire 6×6 baseplate, which removes every cell the
riser exists to create. **Plate capacity binds before foot spacing does.**

The aspect ratio is fine anyway, because the guideline checks a pedestal in
isolation and that isn't the situation. All four latch into **one shared plate**,
so their bases are tied together rigidly — no single post can tip, and they can't
splay relative to each other. Once the station is on, its chassis ties the tops
too. Structurally there was never a question: see the load numbers below.

## Load

A hot air station is 3–6 kg, so ~1.5 kg per pedestal. The hollow 2×2 section:

| Check | Capacity |
|---|---|
| Load-bearing cross-section | 1349 mm² (shell + ribs) |
| Crushing | 67 kN ≈ 6,875 kg |
| Crushing, derated 80% for print voids | 1,375 kg |
| Euler buckling of the column | 888 kN ≈ 90,500 kg |
| Cap dishing under a foot mid-cell | 0.62 MPa vs 50 MPa yield |

Three reasons the shell is enough. The load is **pure compression along the print
Z axis** — FDM's strong direction, since layer adhesion only matters in tension
and peel. A **closed box section** is enormously stiff in bending, and hollowing
removes material from the middle where it contributes almost nothing to `I`.
And the **ribs sit under the cap's bridge span**, so a foot anywhere on the pad is
at most ~18 mm from supported material.

## Source

Parametric OpenSCAD, on `lib/gridfinity.scad`. The asserts in `riser_common.scad`
catch what a mesh check can't — a lip taller than the material above the feet, a
rim wider than the corner radius it's offset from, a height that doesn't clear
the Gridfinity foot, anything past the 270 mm bed.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm — 0.3 mm on the 6″ is fine, there's no fine detail above the foot |
| Walls | 3–4 |
| Infill | **5–10%** |
| Infill pattern | Lines or Grid |
| Supports | none |
| Orientation | as emitted, feet down |

**Don't raise the infill.** The 3 mm shell is thicker than the perimeters can
fit, so the slicer fills it solid regardless — infill percentage only reaches the
cap. Turning it up re-creates the 36-hour problem the hollow was cut to solve.

## Still open

- **Scope foot length, front to back.** The scope has two feet, one per side, so
  each pedestal carries one foot and all the front-to-back stability comes from
  that foot's own length. If a foot overhangs its pedestal you've *shortened* the
  effective base by raising it. Over ~80 mm, use the 2×3 (`-D GY=3`, pad
  78.5 × 120.5); under ~55 mm the 2×2 is fine.
- **Hot air station foot spacing** — the pedestals have to land under its feet,
  and where they land decides whether the 20 free cells end up reachable at the
  plate edges or stranded under the middle of the station.
- Whether the station's underside vents. Four corner pedestals *improve*
  under-chassis airflow, so this is likely a bonus rather than a problem, but
  worth a look before committing.
