# BGA rack

![BGA rack](preview.png)

**Gridfinity** 3×3 for the BGA reballing kit — the AMAOE jig lying flat, and four stencil bags
standing on end beside it.

## Why this shape

**The jig lies flat.** It's 85.17 × 85.18 × 15 mm, so at 20 mm deep it simply drops in.

**The stencils stand on end and stick out, on purpose.** The largest is 50 × 50, and a slot's job
is to hold them upright and sorted, not to swallow them. Sizing the bin to bury a 50 mm stencil
would nearly triple its height and make them harder to pinch out, not easier.

**3×3 because of one millimetre.** The jig is 85.18 across; a 3×2's short interior is 81.1. It
doesn't fit, so the footprint goes to 3×3 — 123.1 square, of which the jig bay takes 87.2 and the
remaining ~31 mm carries the slots.

**Four slots for four bags**, which are sorted by ball size. One bag per slot keeps that sorting
instead of pooling them.

## Parts

| File | What | Size |
|---|---|---|
| `bin_bga_rack.scad` | 3×3, one 87.2 mm jig bay + 4 × 7.78 mm stencil slots | 125.5 × 125.5 × 26.2 mm |

`N_STENCIL` changes the slot count; the widths redistribute automatically and an assert fires if
they'd collapse below 4 mm.

## Source

```sh
openscad -o bin_bga_rack.stl --export-format binstl bin_bga_rack.scad
```


## The bagged packs go in a separate bucket

The rack's slots are **7.78 mm**. The largest *bagged* pack is **over 12.7** — less than two
thirds of what it needs, which is why the packs never went in. That was always the weak half of
this part: the slots were sized from a photo-estimated ≈56.6 mm, and the real bare stencil turns
out to be 50 × 50, so that estimate was reading the bag.

**The rack is not being redesigned.** It keeps the jig, and its slots take the flat, thin things:
iPhone-sized stencils, trace-repair sheets, paste scrapers, and the two 1″×1″ glass plates in
their bags. The bulky bagged packs go in `bin_stencil_bucket.scad`.

| File | What | Size |
|---|---|---|
| `bin_stencil_bucket.scad` | 2×2, four bays, bagged packs on edge | 83.5 × 83.5 × 38 mm |

Four bays of **18.8 mm**, one per ball size, so the sorting the four bags already carry survives
the move. The bay depth is simply the whole 81.1 mm interior — a bucket doesn't need to trace its
contents, and a bag around a 50 mm stencil clears that by a wide margin. Nothing in it is cut to
a number nobody measured.

At 38 mm tall a bag stands **~12 mm proud**, which is deliberate. Burying it would need a taller
bin for no gain and make the bags harder to get out — the same reasoning the rack's own slots
were built on.

**Growth is a second bucket, not a bigger one.** The collection keeps growing; a 2×2 latches
anywhere on the grid, so another print gives four more bays alongside. That beats guessing today
how big the collection gets. `N_BAY` is parametric if you'd rather subdivide further.

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** |
