# ENGINDOT Shortkiller topper

![ENGINDOT Shortkiller topper](preview.png)

A **magnet-free Clickfinity** topper that drops onto the lid of an ENGINDOT bench
supply and holds a **Shortkiller** short-finder where you can actually use it —
displays facing you, buttons reachable, probe and alligator lead in a bucket
behind it instead of tangled across the bench.

Sibling to [`owon-spm8104-tray`](../owon-spm8104-tray/), and the same idea: a
drop-over frame, a Clickfinity plate bonded into it, and bins that click in. The
difference is what the bins carry — that tray holds a spread of barrel adapters,
this one holds one instrument and its leads.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Frame** | `engindot_frame.scad` | 107.6 × 217 × 14 mm | ×1 — flat, **walls up** as rendered, no supports |
| **Plate** | `engindot_plate.scad` | 84 × 210 × 4 mm | ×1 — flat, **latches up**, **PETG** |
| **Shortkiller bin** | `bin_shortkiller.scad` | 113 × 180 × 42 mm | ×1 — flat, foot down, no supports |
| **Probe + leads bucket** | `bin_probe_leads.scad` | 41.5 × 41.5 × 42 mm | ×1 — flat, foot down |

Shared dimensions live in `shortkiller_common.scad`.

## How it mounts — no hardware

The frame **drops over the top** of the supply and is held passively:

- **Front/back lips** (7 mm) hook the top edges → can't slide fore-aft. This is
  what actually holds it on.
- **Short side skirts** (6 mm) hug the case sides → can't slide sideways.
- **Gravity** does the rest.

The skirts are deliberately short. The ENGINDOT vents the **full height of both
sides**, so the OWON's 20 mm skirt would have sat over the intake. Since the lips
carry the retention and the skirts only locate, 6 mm is enough. `SKIRT_D` takes
it lower if you want.

The top is solid — rear fan only — so a tray over the lid is thermally free.

## The bin is wider and longer than its own foot

The Shortkiller is **98 × 171 mm**. Neither number fits the grid:

- **98 mm wide** needs a 3-cell bin (125.5), but a 3-cell plate is 126 mm on a
  102 mm lid — the plate would overhang the supply.
- **171 mm long** exceeds a 4-cell foot (167.5), leaving nothing for an end lip
  to stand on.

So the **foot stays 2 × 4 cells** and the **body flares out above it** — sideways
to clear the width, forward to make room for a front lip. Both flares are 45°
ramps that finish below the pocket floor, so they print without support and the
pocket never cuts through a wall that's still narrow. That's what forces the bin
to 6 height units rather than 5.

The forward extension is at the **front only** — a rear one would collide with
the probe bucket.

⚠️ Because the body overhangs its foot, **nothing can sit directly beside this
bin.** On this plate that's fine; on a shared baseplate, leave the neighbouring
cells clear.

## Grip is a spring, not a fit

The pocket is modelled **3 mm oversize** and the side walls are **flexures** —
each relieved on its outer face to leave a 2 mm skin carrying a bump that presses
on the case. Anything within about ±3 mm of the real width still grips, which is
what let this be designed from tape-measure photographs and confirmed with a
coupon rather than calipers.

Both ends carry a **9 mm lip**. The box is operated in place, so they stay low:
the rear clears the DC jack and rocker, the front clears the GX12 connector and
the V+/V− buttons.

## The probe bucket is 1×1 on purpose

The rear row of the plate is two cells. One is this bucket; **the other stays
empty** — the Shortkiller's DC cord isn't detachable and has to leave the back of
the tray somewhere. Don't fill it.

The probe stands **tip-down** in a blind tube so the sharp end is buried in
plastic and you grab the handle. The alligator lead drapes into the well around
the tube. Neither gets unplugged.

The wall facing the Shortkiller is cut down to 13 mm so the bucket doesn't shadow
the box's rear panel.

## Assembly

1. Drop the plate into the frame — it rests on the frame's inner ledge.
2. Run a bead of CA or plastic cement around the seam. One solid unit.
3. Click the bins in. Drop the Shortkiller into its bin from above.

## Clickfinity

Uses the magnet-free [Clickfinity latch generator](https://github.com/IamMrCupp/clickfinity-openscad)
(vendored as `lib/clickfinity.scad`). It holds any standard 42 mm Gridfinity bin
with spring tongues instead of magnets — **print bins in PETG, not PLA.**

## Source

```sh
openscad -o engindot_frame.stl  --export-format binstl engindot_frame.scad
openscad -o engindot_plate.stl  --export-format binstl engindot_plate.scad
openscad -o bin_shortkiller.stl --export-format binstl bin_shortkiller.scad
openscad -o bin_probe_leads.stl --export-format binstl bin_probe_leads.scad
```

⚠️ **Don't raise `$fn`.** `lib/gridfinity.scad`'s `_bin_cell` emits non-manifold
edges at some `$fn`/bin-width combinations, and it isn't monotonic — higher is
not safer. Measured: 1-wide bins fail at 32/48/64/128, 2-wide fail at 64/72/80/96,
3-wide fail at 48. This model pins **40**, clean for the widths it builds.

## Test coupons

Print-first parts, not bench parts. Each answers something a photo can't:

| File | Answers |
|---|---|
| `bin_shortkiller_testfit.scad` | Does the box fit the pocket, does the foot seat in a plate |
| `bin_shortkiller_griptest.scad` | Do the flexures grip at their **real span** — a third of the material, no Gridfinity base |
| `wrap_test_bands.scad` | Brackets the box height 45/50/55/60 |
| `shortkiller_fit_gauge.scad` | Staircase gauge, reads a case width without calipers |

## Recommended print settings

| Setting | Value |
|---|---|
| Material | **Plate: PETG** (Clickfinity latches creep in PLA). Bins: PETG. Frame: either. |
| Orientation | Plate flat, latches up. Frame flat, walls up. Bins flat, foot down. No supports anywhere. |
| Layer height | 0.2 mm |
| Walls | Plate: Arachne, ≥ 2 loops (thin tongues). Bins: 3+. |
| Cooling | Plate: modest — the tongues need layer bonding. |
| Infill | 15 % |
| Brim | Plate: outer-only, 5 mm, 0.15 mm gap. Everything else: none. |

## Fit

Built for the measured unit — lid 102 × 216 mm, Shortkiller 98 × 171 mm. If yours
differs, the knobs are `CASE_W`, `MOUNT_L` and `SKIRT_D` for the frame, and
`SK_W` / `SK_D` for the bin.

**`MOUNT_L` is the frame's fit dimension.** The end lips must land on the front
and rear top edges: too short and it won't drop on, too long and they hang in
space with nothing resisting fore-aft slide.
