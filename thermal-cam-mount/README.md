# Thermal cam mount

![Thermal cam mount](preview.png)

A two-part sandwich clamp that holds a **Sipeed T256s thermal camera** on the LED-56S ring
light's control-box tab, aimed down at the board.

The T256s is registered onto the scope's visible feed so a hot component's bloom labels that
component. That registration transform is computed once and has to **hold between sessions** — so
the mount is rigid, non-drifting, and fixed-angle. Anything that can rotate or creep invalidates
the calibration.

## Parts

| File | What | Size |
|---|---|---|
| `mount_bottom.scad` | bottom plate + cam cradle | 70.05 × 28.0 × 31.7 mm |
| `mount_top.scad` | top plate, counterbored | 70.05 × 57.9 × 32.3 mm |

Two M3 screws into heat-set inserts draw the plates together. Shared dimensions live in
`thermal_cam_mount_common.scad`.

## Why a sandwich and not a bracket

The tab is a **boss on top of the ring**, which rules out five of its six faces:

| Face | Why it's unusable |
|---|---|
| Rear | merges into the ring |
| Front | brightness wheel |
| Both sides | switch and jack |
| Bottom | centre screw |
| **Top** | **clear — the only one** |

So the plates grip the top and bottom faces over the front 28 mm of the tab's 32.51, and the two
screws pass **outboard** of the tab at the front corners — clear of the mid-side controls, either
side of the front wheel. No rear wall, no side walls.

The long top-and-bottom grip is the moment arm that resists the camera's weight tilting the whole
thing nose-down. The bottom plate carries a pocket for the tab's centre screw.

Tab measured 2026-07-23: **49.65 W × 32.51 front-to-back × 26.42 thick**.

## The cradle rides above the plate, not below

The tab is coplanar with the ring light's disc, so **everything below it is the working volume**
between the objective and the board. The camera must never enter it.

An earlier version hung the cradle below the bottom plate, rotated `-(90 - CAM_ANGLE)`. That put
the camera in the working volume *and* aimed the lens 60° up into the objective — two failures at
once. Fixed 2026-08-08: the cradle sits above the top plate, just outboard of the tab's front
face, sighting down past the plate's front-top corner.

`verify_aim.py` exists so that can't regress silently. It checks the lens vector and the corner
clearance:

```sh
python3 verify_aim.py
```

```
lens vector  dY=-0.500 dZ=-0.866  -> 30.0 deg from vertical, INWARD, DOWN
  ray  9.0 deg  clearance  +1.30  ok
lowest cradle point z=18.36  (top plate underside z=13.36)  -> out of the working volume
PASS
```

**Run it before any print.** A mount that aims the lens at the objective still renders, still
slices, and still passes a mesh check.

## Still to confirm on the first print

- **`FIT = 0.3`** — the gap between each plate and the tab face. Too loose and the calibration
  drifts, which is the one thing this mount exists to prevent.
- **Front-corner screw clearance** — that the screws really do pass outboard of the wheel.
- **That the tab's top face is rigid ABS** before trusting the grip.

## Recommended print settings

| | |
|---|---|
| Material | PETG or ABS — not PLA, it creeps under clamp load |
| Layer height | 0.2 mm |
| Walls | 4 perimeters |
| Infill | 40 % — this is a clamp |
| Supports | **`mount_top`: YES. `mount_bottom`: none.** See below |

### Supports — mount_top only

Measured off the exported mesh, not eyeballed:

| Part | Surface that is unsupported overhang steeper than 45° |
|---|---|
| `mount_top` | **14.3%** |
| `mount_bottom` | **0.0%** |

`mount_top` carries two ~470 mm² faces that are **flat-down** — 0.1° off horizontal, hanging in
air — plus the cradle's 30° faces, because the cradle is tilted 60° from vertical by design. That
is not a marginal overhang; it is a ceiling.

This README said "Supports: none" for both parts until 2026-08-27, and a print was started on
that basis and killed. `mount_bottom` genuinely needs none — it is a plate with a pocket.

**Set supports per-object.** If both parts share a plate, a global support setting grows them
under `mount_bottom` for nothing.
