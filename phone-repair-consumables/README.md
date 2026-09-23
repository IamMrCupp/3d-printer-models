# Phone-repair consumables

![Phone-repair consumables](preview.png)

A **3×1 bin, 58 tall, split down its length into two flat-bottomed bays** — the adhesive/foam roll in one, the loose strips in the other. Same footprint and height as the cleanroom-wipes bin, so the two sit as a pair.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Adhesive + foam bin** | `bin_adhesive_foam.scad` | 125.5 × 41.5 × 58 mm | ×1 — feet down, no supports |

Two bays of **123.1 × 18.95**, 51.85 mm floor to rim. 55.6 cm³ of plastic as modelled, about 71 g in PETG.

## The roll sits in now

The 2×1 (v1.0.0) had the ⌀92 roll **bridging** an 81.1 mm bay — resting across the two end rims, never touching the floor — and on the bench it did not stand up well. A thin disc balanced on two rim edges rocks.

A 3×1 bay is **123.1 mm** long, so the whole roll drops to the floor with 15 mm of run either side. **What holds it upright is still the slot width pinching its faces** — 18.95 mm — not the floor shape, which is why there is still no cradle. At 58 tall the rim sits about **40 mm below the roll's top**: that is the grab.

## Nothing here is cut from a guessed number

The divider sits at the midline — half the bin each. The roll's **thickness** and the strips' size never enter the geometry, so neither had to be measured.

The one recorded dimension, `ROLL_D = 92`, is measured (Kapton reel outer ⌀, 2026-08-20, core 78.5). No feature is cut from it; an assert only proves the bay is long enough for the roll to reach the floor.

## Three earlier cuts, and what each got wrong

Kept because the reasoning is the useful part:

| | What it did | Why it was wrong |
|---|---|---|
| **3×2** | trough spanning the bin's full depth | handed 81 mm of depth to a roll ~9 mm thick — that's what made it enormous |
| **2×1 (a)** | trough shrunk to ⌀50 | assumed ⌀92 needed *containing*, judged it impossible, and cut something that fits no roll at all |
| **2×1 (b)** | full-depth saddle at the roll's own radius | cradled it against rolling but left a thin disc free to lean, and it did |
| **2×1 (c)**, v1.0.0 | flat bays, the roll bridging the end rims | stood up, but rocked on two rim edges — "doesn't really support the roll well" |

All three came from treating a roll as something to swallow rather than something to stand up.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% grid |
| Supports | **None** |
