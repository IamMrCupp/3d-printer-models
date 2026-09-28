# PCIe test rig — power box

![PCIe test rig power box](preview.png)

A **fused, switched, metered 12 V feed** for a bench PCIe GPU test rig, in a 4×4 Clickfinity-footed box with a cord drawer underneath. Run a card off external 12 V plus the slot, watch it boot, probe the rails. The riser docks on top; its cables live in the drawer. Nothing about it is mounted permanently — the riser lifts off, the drawer pulls out, four screws open the box.

Wiring is its own document: **[WIRING.md](WIRING.md)**, with the KiCad schematic in [`wiring/`](wiring/).

## Parts

| Part | File | Size | Print |
|---|---|---|---|
| **Frame** | `rig_frame.scad` | 167.5 × 167.5 × 79.75 mm | ×1 — feet down, no supports. 217 cm³ |
| **Cup** | `rig_cup.scad` | 167.5 × 167.5 × 55 mm | ×1 — emitted deck-down, no supports. 158 cm³ |
| **Shelf** | `rig_shelf.scad` | 164 × 163 × 3 (+6 upstand) | ×1 — flat, upstand up. 83 cm³ |
| **Drawer** | `rig_drawer.scad` | 151.5 × 164 × 67 mm | ×1 — open top up. 151 cm³ |
| **Dock rail** | `rig_dock_rail.scad` | 10 × 47 × 6.4 mm | ×2 — pegs up. 0.7 cm³ each |
| **Deck coupon** | `coupons/deck_coupon.scad` | 140 × 100 × 3 mm | **print first** — every panel hole with a fit ladder. 25 cm³ |
| **Rail ladder** | `coupons/dock_rail_ladder.scad` | 52 × 47 × 6.4 mm | **print first** — four rails at four peg sizes. 3 cm³ |

About 610 cm³ for the box, all PETG.

## How it stacks

Bottom to top: **frame → shelf → cup**, with the drawer in the frame and the rails on the cup.

- **Frame.** Footed floor plus left, right and rear walls. The drawer bay. Latching feet in the four corners only — sixteen would need ~195 N to lift — with ribs bearing on the plate's grid walls between them, the same pattern as the filler tiles.
- **Shelf.** A flat plate on the frame's rim. Drawer-bay ceiling, electronics floor. It's a separate part because a horizontal plate spanning the box is a 160 mm bridge in any print orientation unless it's the face on the bed. The handoff design had it modelled in; it would never have printed.
- **Cup.** Deck plus four walls, open bottom. **Every electrical part is on this one piece** — meter, switch and probe post on the deck, input posts and fuse on the rear wall, pigtail exit on the right — so the wiring never crosses a joint. Prints upside down, deck on the bed, so the cutouts come out in the first layers.
- **Joint.** The frame's rim is rebated to a 1.5 mm tongue; the cup's bottom 12 mm is a skirt that wraps it, flush outside. Four **M3 × 10** screws go in horizontally from outside, through the skirt and tongue, self-tapping into bosses behind. The box stays latched to the grid for service: screws out, cup and shelf lift off together, drawer out. No heat-set inserts.
- **Drawer.** Two compartments — the spare 6+2 cables and the 12VHPWR lead on the left, the riser's x1 card and USB lead in a 36 mm bay on the right. 65 mm inside, because that's how tall the loose pile measured. Narrower than the bay by the depth of the screw bosses it slides past.
- **Riser dock.** The x16 board has its slot flush along one edge, capacitors crowding the other and the 6-pin and USB filling an end, so there's no edge to clip. It has four mounting holes on a 99 × 37 pitch instead. Two rails, two pegs each, CA'd into flush pockets on the deck; the board lies on its own foam pad with the pegs through it. Separate parts because a peg can't grow off the face that's on the bed.

## Layout

| Face | Carries |
|---|---|
| **Top deck** | PZEM-031 meter, 20 mm rocker, probe GND post, riser dock |
| **Rear** | 12 V IN + / − binding posts, 5×20 fuse holder |
| **Right** | pigtail exit — both 6+2 tails through one ⌀19 hole, zip tie inside |
| **Front** | the drawer |

Every position is a named constant in `rig_common.scad`, and the cup asserts that nothing walks into a wall or onto the meter's bezel if you move one.

## Measured, not assumed

Every component number came off calipers on the real part (survey 2026-09-27):

| Part | Measured | Hole in the model |
|---|---|---|
| Ampper rocker | body 20.87, clips relaxed 22.88, 23.3 below deck | `SW_HOLE` 21.0 |
| PZEM-031 meter | housing 84.29 × 44.50, 24.45 deep; bezel 89 × 49 | cutout +0.30/side |
| 4 mm binding post | thread 7.45, 19 long | `POST_HOLE` 7.7 |
| 5×20 fuse holder | thread 11.6, 26 long | `FUSE_HOLE` 11.9 |
| pigtail, both tails | 18.25 across | `TAILS_HOLE` 19.0 |
| riser x16 board | 126.55 × 43.20, holes ⌀3.98 on 99 × 37, 4.0 thick with its foam | `PEG_D` 3.8 |
| riser x1 card | 33 × 29 | drawer bay 36 |
| cord pile, loose, 4×4 footprint | 65 tall | drawer 65 inside |

The four hole sizes are nominal. **The coupon decides them.**

## Print order

1. **`coupons/deck_coupon.scad`** — 3 mm plate with the meter cutout and a three-step ladder for the rocker, fuse holder and binding post, plus the pigtail hole. Push each part in, note which step fits, set `SW_HOLE` / `FUSE_HOLE` / `POST_HOLE` to match.
2. **`coupons/dock_rail_ladder.scad`** — four rails at 3.6 / 3.7 / 3.8 / 3.9. Push the riser onto each; set `PEG_D` to the one that holds without a fight. Snap off the two you'll use — they're the real rails.
3. Then the box: frame, shelf, cup, drawer.

## Verified

- All seven parts render **single-body, watertight**, at the sizes in the table
- **`check_assembly.py`** places every part and every component where it lives and renders 18 pairwise intersections: parts against parts, meter / switch / posts / fuse / pigtail / riser against the cup, a 2.5 mm rod down every screw axis through both the clearance and the pilot. All empty. (Its first run caught a 1.5 mm lip of the cup's front wall hanging across the drawer opening — 768 mm³ that the per-part checks were happy with.)
- Clean on **OpenSCAD 2021.01**, what CI runs

## Recommended print settings

| Setting | Value |
|---|---|
| Material | PETG |
| Layer height | 0.2 mm |
| Walls | 3 |
| Infill | 15% gyroid |
| Supports | **None** |

The cup is emitted deck-down. The frame is feet-down. Don't flip either.

## License

CC BY-NC 4.0, like the rest of the models here. The wiring schematic and check script are MIT.
