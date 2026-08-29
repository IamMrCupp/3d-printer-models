# Thermal cam mount

![Thermal cam mount](preview.png)

A **three-part** mount that holds a **Sipeed T256s thermal camera** on the LED-56S ring light's
control-box tab, aimed down at the board. A sandwich clamp grips the tab, and the cradle hangs
off it on a **lockable joint** — set the down-angle anywhere from 30° to 55°, then tighten.

The T256s is registered onto the scope's visible feed so a hot component's bloom labels that
component. That registration transform is computed once and has to **hold between sessions**, so
nothing may drift.

**Rigid and adjustable aren't opposites.** v1.0.1 was fixed-angle on the reasoning that anything
adjustable could creep — which made every aim error a reprint. Adjust-then-clamp gives both: an
M3 hand-tight in PETG holds on the order of 1.6 N·m of friction at this radius, against the
camera's ~0.006 N·m of gravity torque about the pivot. That's ~250× margin. The joint is not the
weak point.

## Parts

| File | What | Size |
|---|---|---|
| `mount_bottom.scad` | bottom plate + screw bosses | 70.05 × 28.0 × 31.7 mm |
| `mount_top.scad` | top plate + arm + joint pad | 71.33 × 51.7 × 33.4 mm |
| `mount_cradle.scad` | the cradle + its joint pad | 54.6 × 24.0 × 33.0 mm |

Two M3 screws into heat-set inserts draw the plates together, and two more join the cradle to the
arm — four M3s and four inserts in total. Shared dimensions live in `thermal_cam_mount_common.scad`.

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

## Why v1.0.1 didn't hold the camera

The cradle gripped the camera **entirely below its centre of mass.**

The camera sits on the lip, so it spans z 4.50 → 39.50 and its centre of mass is at z 22.00. At `SIDE_H = 16` every retaining feature — side walls, back wall, and the front corner tabs that ride on top of the walls — topped out at z 19.00. Measured off the mesh:

| | v1.0.1 | now |
|---|---|---|
| Material in front of the camera (what retains it) | z 0 → **19.00** | z 0 → **33.00** |
| Material beside it | z 0 → 19.00 | z 0 → 33.00 |
| Camera | z 4.50 → 39.50, **CoM at 22.00** | unchanged |

The cradle is tilted 60°, which puts a gravity component of 0.87 along the local −Y — straight out the open front. With every grip below the centre of mass, the camera pivots over the top of the walls and levers itself out. It was never going to hold.

**The camera's dimensions were never the problem.** The pocket is 42.6 × 14.6 and a 42 × 14 body drops straight in. The fix is `SIDE_H` 16 → 30, which puts the front corner tabs at z 30 → 33 and takes the side-wall grip from 14.5 mm of the 35 mm body to 25.5 mm.

`BACK_H` was split out and left at 19 on purpose. The back wall is the only solid face against the 1.69" screen, and raising it with the sides would bury the screen this open cradle exists to keep visible — and it isn't the face doing the work, because gravity pushes the camera forward, not back.

**Nothing could have caught this.** The mesh was valid, the bounding box was right, and `verify_aim.py` checks the lens *angle*, which was correct the whole time. There was no check that retention reached above the centre of mass. There is now — see below.

## Still to confirm on the first print

- **`FIT = 0.3`** — the gap between each plate and the tab face. Too loose and the calibration
  drifts, which is the one thing this mount exists to prevent.
- **Front-corner screw clearance** — that the screws really do pass outboard of the wheel.
- **That the tab's top face is rigid ABS** before trusting the grip.
- **That the sandwich clamp itself grips the tab.** The v1.0.1 failure was the cradle; whether the clamp half holds is a separate question and hasn't been reported either way.

## Checking retention

Aim is not the only thing a valid mesh can get wrong. Retention has to reach above the camera's centre of mass, or the body levers out however good the aim is:

```sh
python3 check_retention.py
```

```
camera        z   4.50 ..  39.50    centre of mass z  22.00
retention     z   0.00 ..  33.00

retention reaches +11.00 mm relative to the centre of mass
PASS  28.5 mm of the camera's 35.0 mm height is gripped (81%)
```

It probes the real `_cradle()` with OpenSCAD booleans rather than re-deriving the geometry, so it can't drift from the model. Put `SIDE_H` back to 16 and it fails with `-3.00 mm` — it catches the exact bug that shipped.

**Run this and `verify_aim.py` before any print.** Between them they cover the two things a valid mesh can still get wrong: where the lens points, and whether the camera stays in.

## Setting the angle

The cradle pivots on one M3 and locks with a second through an arc slot in the arm's pad. Loosen
both, swing the cradle, tighten both.

**The range is 30°–55° from vertical, and the floor is geometry, not taste.** Below 30° the top
plate's own front-top corner clips the bottom of the camera's 42° vertical FOV:

| Angle | FOV clearance over the plate corner |
|---|---|
| 28° | **−3.45 mm** — blocked |
| 29° | **−0.79 mm** — blocked |
| 30° | +1.30 mm |
| 35° | +7.48 mm |
| 55° | +15.50 mm |

That falls off fast, so the slot's end bores are **inset** to make the reachable range exactly
30°–55°. Hulling bores centred on the endpoints instead would let the screw sit 2.6° past each
end and set 28°. Probed at 29.0 / 29.4 / 29.6 — all correctly blocked.

You don't need shallower. At 165 mm the thermal sees a 175 × 127 mm patch of board, so the
objective's spot stays well in frame across the whole range.

## Recommended print settings

| | |
|---|---|
| Material | PETG or ABS — not PLA, it creeps under clamp load |
| Layer height | 0.2 mm |
| Walls | 4 perimeters |
| Infill | 40 % — this is a clamp |
| Supports | **None, on any part.** See below |

### Supports — none

Measured off the exported meshes in each part's own print orientation:

| Part | Unsupported overhang steeper than 45° | |
|---|---|---|
| `mount_bottom` | **0.0%** | none |
| `mount_top` | **1.8%** | none |
| `mount_cradle` | **2.7%** | none |

**Splitting the cradle out is what killed the support problem.** In v1.0.1 it was fused to the top
plate at 60°, putting two ~470 mm² flat-down faces in mid-air — `mount_top` measured 14.3%. As its
own part each piece prints in its own orientation.

`mount_cradle` prints **upright, as exported**. That only became the right answer once `PAD_R` came
down from 16 to 12 — at 16 the joint disc was itself the overhang, and lying it on its side was
better (7.5% against 16.2%). At 12 upright wins outright: 2.7% against 7.4% on its side.

This README said "Supports: none" for both parts until 2026-08-27 when it wasn't true, and a print
was started on that basis and killed. It is true now, and the numbers above are measured.

**Set supports per-object.** If both parts share a plate, a global support setting grows them
under `mount_bottom` for nothing.
