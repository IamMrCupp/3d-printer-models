# Soldering station mounts

![Soldering station mounts](preview.png)

**Gridfinity** plates that anchor the existing soldering iron / desoldering gun stand to the
grid, so it stops wandering across the bench.

## The printed part takes no heat

The stand's own cradle holds the iron. This only stops the stand moving, so ordinary filament is
fine — that's the scope this whole family of mounts was defined with.

## Rails and lips, not a pocket

The base is 70 mm across the front, 65 across the rear, 175 long — **and the sponge-tray end is a
large-radius D**, which those three numbers can't describe. A close-fitting pocket would need
that radius, and a wrong guess means the stand won't drop in at all.

Locating on the **straight sides** sidesteps it. The taper does the work: the stand wedges
between two converging rails.

**A lip does not need the radius either.** It's a backstop, not a socket — a straight bar across
the rear meets the D at its apex and stops it there, and it doesn't care what the curve does on
either side of that point. So the plate gets its front and back without anyone tracing anything,
and the stand is boxed in on all four sides. Drop it straight down in; lift it straight out.

That's the general lesson worth keeping — when an outline is partly unknown, locate on the
features you *have* measured rather than guessing the ones you haven't.

## End clearance is deliberately loose

The sides get 1 mm per side. The ends get **3**, because the 175 is approximate and the D apex
may sit past it. That leaves ~6 mm of fore-aft float, which is fine: **the lips are not what
locates the stand — the converging rails are.** It wedges between them and stops. The lips catch
it if it's knocked, and stop a hard shove walking it off the deck.

The rails run the full span and go **parallel for the last 3 mm at each end** rather than
extrapolating the taper past the stand. Extrapolating would pinch the rear gap below 67 and bind
the very thing the taper exists to seat.

## Parts

| File | What | Size |
|---|---|---|
| `plate_iron_stand.scad` | 2×5 plate, tapered side rails + end lips | 83.5 × 209.5 × 14.15 mm |

Rail gap runs 72 mm at the front to 67 at the rear — 1 mm clearance per side, deliberately tight
so the taper wedges rather than rattles. The end lips sit 181 mm apart and stand to the same
7 mm as the rails.

## Source

```sh
openscad -o plate_iron_stand.stl --export-format binstl plate_iron_stand.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** |
