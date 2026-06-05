# VJ rig stand

![VJ rig stand](preview.png)

A desk stand for a VJ rig: holds an **iPad** (TouchOSC controller) in an angled cradle behind the keyboard, an **Apple Magic Trackpad** in a tray that partly frames the keyboard's right side, and a **3× Lightning cable holder** along the back.

Two parts (the combined unit is wider than the bed), bolted together at the joint:

| Part | File | Size | Holds |
|---|---|---|---|
| **Cradle** | `vj_rig_stand_cradle.scad` | 260 × 95 × 124 mm | iPad 8 (landscape, ~65°) + 3 cables |
| **Tray** | `vj_rig_stand_tray.scad` | 202 × 153 × 17 mm | Magic Trackpad + connecting arm |

- Common geometry/parameters: `vj_rig_stand_common.scad` (shared library).
- **iPad 8** (250.6 × 174.1 mm): rests in a **16 mm bottom channel** (fits the Apple magnetic flip case with the cover folded behind) and leans on the 65° panel. Tune `chan_w` / `ipad_ang` to taste.
- **Magic Trackpad** (160 × 115 mm): drops into the tray recess; front finger-relief to lift it out.
- **Cables:** three Lightning slots in the back bar (`cable_n` / `cable_pitch`).

## Assembly

The tray's arm laps over the cradle's right edge; drive **2 self-tapping M3 screws** down through the countersunk holes into the cradle (or glue the lap — flat contact bonds well). Keyboard sits in front, framed by the L.

## Source

```sh
openscad -o vj_rig_stand_cradle.stl --export-format binstl vj_rig_stand_cradle.scad
openscad -o vj_rig_stand_tray.stl   --export-format binstl vj_rig_stand_tray.scad
```

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | Both as modeled (cradle base down, tray base down). No supports. |
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls / perimeters | 3–4 |
| Infill | 15 % |
| Supports | None |
