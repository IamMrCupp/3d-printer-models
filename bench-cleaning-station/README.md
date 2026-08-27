# Bench cleaning station

![Bench cleaning station](preview.png)

**Gridfinity** cups and bins for the IPA / contact-cleaner corner of an electronics repair bench — aerosols, wash bottle, dispenser pump, and melamine sponges.

Every dimension here was taken off the actual item with calipers. Nothing is a nominal from a product page, which matters: a collar cup is entirely a millimetre problem.

## Design notes

**Cups locate, they don't clamp.** Bores carry a per-diameter clearance (`CLR`, 1.0 mm), not an interference fit. A collar that grips harder than the bin weighs comes out of the baseplate with the bottle the first time you grab it one-handed.

**The bench this was built for sits under a fume-extractor intake**, so bins stay as low as the job allows — capture velocity is decided in the first six inches, and a wall of tall bins in front of the hood costs it.

**Capture depth is 50 mm** across all cups. That's a judgement call, not a derived third-of-height: the vessels' heights weren't measured. It's one constant (`CAPTURE`) if the first print feels wrong.

> ⚠️ **The aerosols are flammable and this bench has a 400 °C iron on it.** These cups are for *working* cans. Bulk stock belongs away from the hood and away from the iron.

## Swabs and sponges — separate units

They were briefly a two-tier tower (swab base with a baseplate top, sponge bin socketed on).
Separate bins turned out to be wanted, and stacking cost the swab bin its **open top** — which is
how you reload it. So: two independent bins.

`bin_swabs` is modelled on [thing:7165275](https://www.thingiverse.com/thing:7165275) (Haaneroth,
CC BY-NC-SA) — a **tall closed hopper whose front wall doubles as a dam, with a low scooped trough
in front of it.** Tip a box of buds in the top, they roll down a continuous curved floor, pass
under the dam, and present in the trough where you pinch one out.

**The silhouette is the design:**

| | height |
|---|---|
| Back wall | 58 mm — hopper, holds the pile |
| Dam (the hopper's front wall) | 58 mm, standing 9 mm clear of the floor |
| Front wall | **26 mm** — reach over it |

A previous version was a box of **uniform** height with a dish inside. Every wall stood at 42 mm,
so the trough sat at the bottom of a 36 mm well — you reached down a shaft to find a bud instead
of picking one off a shelf. It held buds; it didn't dispense them.

**Front and back are both real walls.** An attempt before that cut the front to a 12 mm lip and
buds rolled onto the desk. 26 mm over a trough floor at 7.97 gives **18 mm of containment** — a
dished shelf you reach into, not an opening things escape from.

**The floor is one continuous radius**, not a ramp meeting a trough, so there's no corner anywhere
along the path a bud rolls and it runs downhill the whole way instead of climbing out from under
the dam.

It's **3 × 2, not 2 × 2**: buds run to 3.2″ (81.28 mm) and a 2×2 interior is 81.10 mm. Missing by
0.18 mm means the bud sits diagonal, and a diagonal bud is the one that bridges the dam gap.

**Cut the sponges.** A full 100.1 mm block doesn't fit a 2×2 — quarter them to 50 × 30 × 20.
Melamine is consumed by abrasion, so a whole block is far more than any bench task needs, and the
smaller piece reaches between connectors. Bulk stock stays in the bag under the desk. The bin's
height still clears a **full block on edge**, so one uncut reserve can ride along.

## The dropper caddy got taller, and that is only half a fix

`bin_deoxit_droppers` went from 21 mm to **32 mm** overall (capture depth 15 → 26) because the
brushes and swabs fell over in their slots.

Depth is what resists an applicator tipping, so more of it genuinely helps — but be clear how
much. A slot is 11.9 × 20 mm and **no brush or swab has ever been on calipers.** Assuming a 4 mm
handle:

| Capture depth | Lean across the slot | Lean along it |
|---|---|---|
| 15 mm | 27.8° | 46.8° |
| **26 mm** | **16.9°** | **31.6°** |

Better, not fixed. The slots are sized from *leftover space between the bottle pockets*, not
from the thing that goes in them. **The number this part needs is the handle diameter of a brush
and of a swab, and how many of each ship with a bottle.** With those the slot becomes handle plus
clearance and the lean goes to nothing. Without them, depth is the only lever and it's a weak one.

## The Kimwipes tray runs 1.0 mm walls, and that is the design

The box is **119.60 × 122.86**. A 3×3 is 125.5 across, so at the usual 1.2 mm wall the interior is
123.10 and the long side clears by **0.24 mm** — not a fit, a coincidence. At 1.0 mm the interior
is 123.50 and the slack is **0.64 mm**, which a cardboard box actually goes into.

If it binds, go to a 3×4 — `-D NY=4` gives 165.10 of interior and 42 mm of slack. Do not thin the
walls further.

**Capture is 25 mm and the box's height is irrelevant.** It dispenses from the top, so the tray
only stops it sliding and tipping; anything taller just stands further proud. That's the one
dimension this part is deliberately independent of, which is why it could be built without ever
measuring the box's height.

> The same box also sits on `scope-baseplate/scope_wipe_plate.scad`, which was built as a platform
> for it. That's a **baseplate** — no walls — which is why it fits comfortably there and only just
> fits here. Don't copy that part's clearances across.

## Parts

| File | What | Size |
|---|---|---|
| `bin_aerosols.scad` | 5 × 2 three-can block — DeoxIT D5 + F5 + G5, one shared bore | 210 × 84 × 56 mm |
| `bin_freeze_spray.scad` | 2 × 2 cup — freeze spray, ⌀69 mm can | 84 × 84 × 56 mm |
| `bin_deoxit_droppers.scad` | 5 × 1 block — 3 × 39 × 20 mm dropper bottle + 2 applicators each | 210 × 42 × 32 mm |
| `bin_swabs.scad` | 3 × 2 dispenser — hopper + dam + scooped trough | 126 × 84 × 58 mm |
| `bin_kimwipes.scad` | 3 × 3 tray — Kimtech Kimwipes pop-up cube | 126 × 126 × 31 mm |
| `bin_flood_bottle.scad` | 2 × 2 cup — Labvida 500 ml IPA wash bottle | 84 × 84 × 56 mm |
| `bin_dispenser.scad` | 2 × 2 cup — 200 ml push-down IPA pump | 84 × 84 × 56 mm |
| `bin_sponges.scad` | 3 × 2 bin — melamine sponges on edge (~4) | 126 × 84 × 68 mm |

### Why the aerosol block is 5 × 2 and not 4 × 2

Three cans measure 162 mm of bore, which looks like it fits inside 168 mm. It doesn't — bores also need webs *between* them and a wall *outside* them. At 4 × 2 the first two overlap by 0.10 mm and the outer one breaks through the side wall by 0.50 mm.

That version still renders as a perfectly watertight, 2-manifold mesh. Mesh validation tells you a part is *closed*, not that it's *correct*, which is why `lib/vessel.scad` now asserts on bore spacing and rejects it at render time.

At 5 × 2 it's still a win over three separate 2 × 2 cups: 210 mm instead of 252 mm.

### Why the sponge bin is 3 × 2

A melamine sponge is 100 × 60 × 20 mm (3.94 × 2.35 × 0.79 in). A 2 × 2 bin's interior is 81 mm, so a full sponge doesn't fit — 3 × 2 is the floor. They stand **on edge**, about four across: same capacity as flat-stacking but in a 68 mm bin instead of a 107 mm one, and any sponge pinches out instead of peeling off a pile. Sponges get trimmed down in use, so offcuts share the bin.

## Not included yet

One item from this bench corner is still unbuilt for want of measurements:

- **DeoxIT D100L-25C** — ships as a boxed clamshell kit, not a bare bottle, and the clamshell was never measured

*(Swabs and Kimwipes were on this list and are now built — `bin_swabs.scad` and `bin_kimwipes.scad`. The Kimwipes entry claimed only one dimension was known; the box is 119.60 × 122.86, measured 2026-07-27, and that reading had been sitting in `MEASUREMENTS.md` the whole time.)*

There's no baseplate here either. Bins are independent of the total footprint, so the baseplate waits until the available bench width is known.

Built on the shared [`lib/vessel.scad`](../lib/vessel.scad) collar-cup and [`lib/gridfinity.scad`](../lib/gridfinity.scad) bin modules. Bins are spec-correct Gridfinity, so any standard bin drops into the same baseplate.

## Source

```sh
openscad -o bin_aerosols.stl --export-format binstl bin_aerosols.scad
```

Or render and validate everything at once with `tools/render.sh`.

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG (PETG if IPA contact is likely) |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** — all bores are vertical and print without them |

The flood-bottle cup is the tightest part in the set: a 76.5 mm bore in an 83.5 mm block leaves a 3.5 mm wall. If a print comes out snug on the bottle, widen `CLR` rather than shrinking the bore.
