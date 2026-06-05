# VJ rig stand

![VJ rig stand](preview.png)

A desk stand for a VJ rig: holds an **iPad** (TouchOSC controller) in an angled cradle behind the keyboard, an **Apple Magic Trackpad** in a tray that partly frames the keyboard's right side, and a **3× Lightning cable holder** along the back.

It's a **single flat-based piece** — 440 × 153 × 124 mm, **wider than the 270 mm bed**, so split it in your slicer where convenient and rejoin with your preferred joiners (glue, dowels, etc.).

- **iPad 8** (250.6 × 174.1 mm): rests in a **16 mm bottom channel** (fits the Apple magnetic flip case with the cover folded behind) and leans on the 65° panel. Tune `chan_w` / `ipad_ang` to taste.
- **Magic Trackpad** (160 × 115 mm): drops into the tray recess; front finger-relief to lift it out.
- **Cables:** three Lightning slots in the back bar (`cable_n` / `cable_pitch`).

## Source

```sh
openscad -o vj_rig_stand.stl --export-format binstl vj_rig_stand.scad
```

All dimensions are parameters at the top of `vj_rig_stand.scad` (cradle width/angle, channel, trackpad pocket, cable count/pitch, how far the tray is slid forward).

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | As modeled, base down. No supports. |
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls / perimeters | 3–4 |
| Infill | 15 % |
| Supports | None |
| Bed | Wider than 270 mm — split in slicer (or print on a larger bed). |
