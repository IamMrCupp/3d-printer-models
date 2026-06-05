# Drybox splitter stand

A two-part stand that raises a [PolyDryer Splitter Mod](https://www.thingiverse.com/thing:7028485) assembly — the dryer + splitter mod with two PolyDryer boxes on top — **~4.5″ off the desk**, with an open-front **Gridfinity storage cubby** underneath.

It's two parts because the **dryer sits in the middle** of the assembly, so the top has to be a solid platform — which can't share a single bottom-up print with a hollow storage cubby (the top would be one big unsupported bridge). Splitting it makes both parts print support-free.

| Part | File | Size | Prints |
|---|---|---|---|
| **Base** | `drybox_splitter_stand_base.scad` | 260 × 260 × 104 mm | as-is — Gridfinity floor on the bed, walls up, open top |
| **Top** | `drybox_splitter_stand_top.scad` | 260 × 260 × 22 mm | flat — solid face on the bed, lip up |

- Common geometry/parameters live in `drybox_splitter_stand_common.scad` (shared library).
- **Lift:** 114 mm (4.5″) — change `base_wall_h` to retarget.
- **Storage:** integrated 6×6 Gridfinity baseplate (36 cells), open front for bin access.
- **Top:** solid platform with a retaining lip (display notch front, cable notch back) the assembly nests into.

## Assembly

Drop the top plate onto the base and drive **4 self-tapping M3 screws** through the countersunk corner holes into the post pilots. (The flat plate-on-posts contact also bonds well with plastic/filament glue if you'd rather make it permanent for the heavy load.)

## Gridfinity

The cubby floor is a spec-correct Gridfinity baseplate (42 mm pitch, 41.5 mm bins, 0.7/1.8/2.15 = 4.65 mm socket, 4 mm fillet). Standard bins from any generator drop straight in.

## Source

```sh
openscad -o drybox_splitter_stand_base.stl --export-format binstl drybox_splitter_stand_base.scad
openscad -o drybox_splitter_stand_top.stl  --export-format binstl drybox_splitter_stand_top.scad
```

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | Base: as modeled. Top: flat, lip up. No supports either part. |
| Material | PETG or PLA (PETG if it sits near a warm dryer) |
| Layer height | 0.2 mm |
| Walls / perimeters | 4 (carries a heavy, top-heavy load) |
| Top / bottom layers | 5 |
| Infill | 15–20 % |
| Supports | None |

You'll typically print **two** sets (one per spool-pair on a 4-feeder U1).
