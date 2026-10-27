# Oversized mail tray

![Oversized mail tray](preview.png)

A **flat tray for oversized mail** that sits on the shelf below the mail slot, with **OVERSIZED MAIL** across its floor in a second colour. The carrier sees where the big envelopes go, and stops stuffing them through the slot.

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Tray** | `mail_holder.scad` | 265 × 200 × 38 mm (1.5 in) | ×1 — floor down, no supports |
| **Letters** | `mail_holder_inlay.scad` | fills the 0.8 mm label pocket in the floor | with the tray, second colour |

**Two colours:** load the tray, then add the letters to it **as a part of the same object**, not as a second object, or auto-arrange separates them. Give the tray one filament and the letters another. The letters fill a 0.8 mm pocket in the floor's top face, flush, so the colour change is only the top few layers of the floor. Print the tray alone for a one-colour engraved label.

## Sizes

The 265 mm length is the user's. The short side is 200 so the U1's 270 × 270 bed still has a 70 mm strip beside the tray for the **prime tower a two-colour print needs**. At 215 (v1.0.0), auto-arrange pushed the tray off the plate. Mail lies flat. A 9 × 12 inch envelope, 229 × 305 mm, overhangs the long side a little, as in any tray.

- **Walls:** 2.4 mm. **Floor:** 2.4 mm, which leaves 1.6 under the label.
- **Drain holes:** four, 6 mm, in the corners clear of the lettering, since an outside mail slot lets rain in.

## Checked

- One watertight body.
- Passes the slicing check: every layer has support under it.
- The letters fill their pocket exactly and sit flush with the floor.

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG — it sits outside |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% |
| Supports | None |
