# OWON SPM8104 top tray

![OWON SPM8104 top tray](preview.png)

A **magnet-free Clickfinity** tray that drops onto the top of an [OWON SPM8104](https://www.owon.com.hk/) power-supply/DMM, so the mains cord and a spread of barrel adapters live on top of the unit in swappable bins instead of loose on the bench. Ten cells, ~4 mm tall, **no hardware** — it drops on and lifts off.

The SPM8104's top vents nowhere (rear fan only), so a tray over the lid is thermally free. A measured surprise: the datasheet says 82 mm wide, but the real lid is **84.30 mm** — exactly a 2-cell Clickfinity plate (84.00 mm), so it sits flush.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Frame** | `owon_tray_frame.scad` | 90 × 228 × 25.5 mm | ×1 — flat, walls down, no supports |
| **Plate** | `owon_tray_plate.scad` | 84 × 210 × 4 mm | ×1 — flat, latches up, **PETG** |

Shared dimensions live in `owon_tray_common.scad`.

## How it mounts — no hardware

The frame **drops over the top** of the unit and is held passively:

- **Side walls** hug the case sides (20 mm deep, clearing the low side vents) → can't slide off sideways.
- **Shallow front/back lips** (5 mm) hook the top edges, clearing the front display and rear fan → can't slide off lengthwise.
- **Gravity** does the rest — it's a tray of adapters; nothing lifts it.

No clamp, no screws, no inserts. (Earlier revisions had a screw clamp — pointless for this load, and it didn't even work: a screw threaded into a wall can't clamp that same wall.)

## Why two parts

The plate must print **latches-up** so the Clickfinity spring tongues come out solid; the frame walls print **down**. There's no single orientation where both are right, so they print separately. Since the plate is permanent (you swap *bins*, not the plate), just **bond it into the frame** at assembly.

## Assembly

1. Drop the plate into the frame — it rests on the frame's inner ledge.
2. Run a bead of CA or plastic cement around the seam. One solid unit.

## Bins

Two bins fill all ten cells exactly — 2×3 + 2×2 = 126 + 84 = 210 mm.

| Part | File | Size | Print |
|---|---|---|---|
| **Fit gauge** | `owon_tip_fit_gauge.scad` | 152 × 30 × 12 mm | ×1 — only for a different adapter kit |
| **Tip block** | `owon_bin_tips.scad` | 84 × 126 × 16 mm | ×1 — flat, foot down |
| **Cord well** | `owon_bin_cords.scad` | 84 × 84 × 55 mm | ×1 — flat, foot down |
| **Cord well label** | `owon_bin_cords_label.scad` | inlay | ×1 — optional, dark toolhead |

Shared numbers live in `owon_bins_common.scad`.

> The tip block’s 40 bores are **13.0 mm**, measured off `owon_tip_fit_gauge.scad`. The kit holds two populations (a ~12 mm class and a ~13 mm class); one bore at the larger reading takes both, so any tip goes in any hole. The smaller tips sit with ~0.5 mm of slop — about 5° of lean in a 10 mm bore.

The gauge is eight through-holes, 8–15 mm, each engraved with its size. Print it before the block if you are building this for a different adapter kit — it reports the *finished hole* a tip drops into, folding the tip OD and your printer’s hole shrinkage into one number.

**The low bin goes at the front.** The tip block is 16 mm and the cord well is 55 — reversed, you'd reach over a 55 mm wall to pick a 12 mm tip. It also gives the warning label a home: the cord well's front wall stands ~39 mm proud of the tip block, so it reads across the top of it.

Tips stand **tip-up** — female end down in the bore, male barrel up where you can grab it — in 40 bores (5 × 8), captured 10 mm so they stand proud enough to pluck one-handed. Any overflow past 40 rides in the cord well.

The row pitch (`TIP_PITCH_Y = 15.5`) is deliberate, not incidental. At a 13 mm bore the two guards in `lib/` pull in opposite directions — `syringe_rack` wants pitch ≥ 15.40, `collar_cup_multi` wants ≤ 15.73 — and the even auto-pitch lands at 15.75, missing the outer-wall floor by 0.02 mm. Widen the bore and that window shuts; drop to 7 rows rather than shaving `min_wall`.

The cord well's divider is not decoration. Every tip in the kit is female, so the harvested master barrel lead is a single point of failure — it gets the rear compartment rather than going missing in the bulk. Set `CORD_ROWS = 1` for one undivided 84 × 84 well if the mains lead won't coil into 84 × 40.

## Clickfinity

The tray uses the magnet-free [Clickfinity latch generator](https://github.com/IamMrCupp/clickfinity-openscad) (vendored as `lib/clickfinity.scad`). It holds any standard 42 mm Gridfinity bin with spring tongues instead of magnets — **print bins in PETG, not PLA.**

## Source

```sh
openscad -o owon_tray_frame.stl --export-format binstl owon_tray_frame.scad
openscad -o owon_tray_plate.stl --export-format binstl owon_tray_plate.scad
```

## Recommended print settings

| Setting | Value |
|---|---|
| Material | **Plate: PETG** (Clickfinity latches creep in PLA). Frame: PETG or PLA. |
| Orientation | Plate flat, latches up. Frame flat, walls down. No supports either part. |
| Layer height | 0.2 mm |
| Walls | Plate: Arachne, ≥ 2 loops (thin tongues). Frame: 3+. |
| Cooling | Plate: modest — the tongues need layer bonding; don't blast overhang/bridge fan. |
| Infill | 15 % |
| Supports | None |

## Fit

Built for the measured unit (84.30 mm wide, ~225 mm deep top, side vents low on the case) and confirmed on it with print gauges. If your unit differs, the top three knobs in `owon_tray_common.scad` cover it: `CASE_W` (width), `MOUNT_L` (front-to-back length), `SKIRT_D` (side-wall depth vs. your vents).
