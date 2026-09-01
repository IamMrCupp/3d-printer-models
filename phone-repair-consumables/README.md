# Phone-repair consumables

![Phone-repair consumables](preview.png)

A **3×2 bin** for the adhesive and foam consumables out of the phone-repair kit: one roll, cradled, plus a bay for the loose strips.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Adhesive + foam bin** | `bin_adhesive_foam.scad` | 125.5 × 83.5 × 53.2 mm | ×1 — feet down, no supports |

## The roll only fits one way

At ⌀92 the roll **cannot lie flat** in a 3×2. The interior is 123.1 × 81.1, so 92 clears the long axis and misses the short one by 11 mm. It sits like a wheel — axis across the short side, diameter along the long side — and everything else in the bin follows from that.

| | |
|---|---|
| Roll | ⌀92, cradled in a ⌀94 trough |
| Strip bay | 26.1 × 81.1, full depth |
| Rim | lands on the roll's equator |

## Why a cradle and not a flat floor

Foam is soft. Stood on a flat floor a roll carries its whole weight on one line and takes a flat spot. A trough cut to the roll's own diameter spreads that over the full arc, which is what *support the rolls* has to mean for foam.

**Why not a spindle.** A spindle is the better holder for a roll, but a spindle is sized from the **core**, and the core has never been measured. A trough needs only the outside diameter, which is known. If the core ever gets measured this can become a spindle without moving anything else.

## What's measured and what isn't

✅ **⌀92** — *"about the same diameter as the kapton tape rolls"* (2026-09-01), and the Kapton reel is on record at ≈92. Not calipered, but a cradle is forgiving in a way a spindle or a slot is not: 2 mm either way changes nothing about whether the roll sits in it.

⚠️ **The strip bay is deliberately unsized.** The strips have never been measured, and a slot cut to a guess is worse than no slot — too narrow and they won't go in, and no mesh check catches that. The bay is simply the interior the roll doesn't use. Same call as the engraver accessory bin's open bay for the collet wrench.

Roll **width** never needed measuring: the trough spans the full interior, so anything up to 79 mm wide seats. Verified by sweeping 20 / 40 / 60 / 70 / 79 against the rendered mesh — all clear.

## Two tangencies this had to dodge

Both returned non-manifold edges on OpenSCAD 2021.01 and rendered clean locally:

- **Trough on the floor.** Sitting the cylinder exactly on the interior floor makes it *tangent* — they touch along a line instead of crossing. It sinks 0.6 mm into a 2.0 mm floor instead, leaving the usual 1.4 mm underneath.
- **Trough against the left wall.** Flush, the cylinder is tangent to that wall; 3 bad edges landed on that seam at x −61.55. It's inset 1 mm.

A cut has to pass **through** a surface, not graze it.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% grid |
| Supports | **None** — the trough's surface faces up and inward, so nothing in it overhangs |
