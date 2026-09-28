// rig_common.scad — shared dimensions and modules for the PCIe test-rig power box.
//
// A fused, switched, metered 12 V feed for a bench PCIe GPU test rig, in a
// 4x4 Clickfinity-footed box with a cord drawer underneath. Wiring is in
// WIRING.md and wiring/pcie_rig_power.kicad_sch; this file is the geometry.
//
// FOUR PRINTED PARTS + a drawer, stacked bottom to top:
//
//   rig_frame     footed floor + left/right/rear walls, open front. The drawer
//                 bay. Prints floor-down — feet on the bed, like any bin.
//   rig_drawer    slides into the frame. Cords one side, the riser's x1 card
//                 and USB lead the other.
//   rig_shelf     flat plate on the frame rim: drawer-bay ceiling, electronics
//                 floor. Separate on purpose — see below.
//   rig_cup       top deck + four walls, open bottom. EVERY electrical part
//                 lives here (meter + switch + probe post on the deck, XT60 +
//                 banana input on the rear wall, XT60 + banana output on the
//                 right), so the wiring never crosses a joint and the top is
//                 fixed. Prints deck-down: the panel cutouts land on the bed.
//   rig_dock_rail two small rails that CA into pockets on the deck; their
//                 pegs hold the x16 riser board by its four mining holes.
//                 Separate because a peg can't grow off a face that's on the bed.
//
// WHY THE SHELF IS ITS OWN PART. The handoff design had the drawer-bay ceiling
// modelled into the body — a 150 x 130 mm flat ceiling, unsupported in either
// print orientation. Any horizontal plate spanning the box is a bridge unless
// it is the face on the bed. So it prints flat, alone, and gets sandwiched.
//
// WHY THE BOTTOM OPENS, NOT THE TOP. Service = four screws from below, drawer
// out, cup lifts off with all its wiring intact. Nothing that carries current
// is on a part you remove to get at something else.
//
// FEET ARE CORNER-ONLY. A Clickfinity cell grips ~12 N; sixteen of them would
// need ~195 N to lift. Four corner feet + ribs bearing on the plate walls, the
// same pattern as lib's filler_tile(). See that module's comment.
//
// EVERY COMPONENT DIMENSION BELOW WAS CALIPERED 2026-09-27 — survey/MEASUREMENTS.md.
// Hole sizes carry a fit ladder on coupons/deck_coupon.scad; print that first.

include <../lib/gridfinity.scad>
include <../lib/label.scad>

$fn = 48;

/* [Footprint] */
NX = 4;  // cells across
NY = 4;  // cells deep
W  = NX*GF - 0.5;   // 167.5
D  = NY*GF - 0.5;

/* [Plate] */
PLATE_TOP = 2.80;   // Clickfinity shallow plate. 4.65 for a standard baseplate.
RIB_T     = 1.60;   // underside ribs, bear on the plate's grid walls

/* [Walls] */
WALL    = 3.0;      // cup walls + deck. The rocker's clips catch ~1 mm/side
                    // behind it and the PZEM's spring clips take it; the coupon
                    // confirms both.
FLOOR_T = 3.0;      // frame floor above the feet
SHELF_T = 3.0;

/* [Bays] */
// Drawer bay: the loose cord pile measured 65 mm tall in a 4x4 stand-in. The
// drawer keeps that as INNER height; the bay adds the drawer floor, the screw
// heads under the frame bosses, and running clearance.
CORD_PILE_H  = 65;
DRAWER_FLOOR = 2.0;
DRAWER_WALL  = 2.0;
SCREW_HEAD_H = 3.0;                                   // M3 pan head under the boss
BAY_H        = CORD_PILE_H + DRAWER_FLOOR + SCREW_HEAD_H + 2;   // 72
// Electronics bay: the meter hangs 24.45 below the deck; the rest is room for
// its screw terminals and 12 AWG bends.
CUP_IN_H = 40;

/* [Joint — cup to frame] */
// A rebate joint. The frame's rim is cut down to a tongue (outer REBATE
// removed over the top TONGUE_H); the cup's bottom edge is a skirt that wraps
// it, outer faces flush. The shelf sits on the tongue top, inside the skirt.
// Four M3 x 10 screws go in HORIZONTALLY from outside — through the skirt,
// through the tongue, self-tapping into a boss on the tongue's inner face —
// so the box stays latched to the grid for service. No heat-set inserts: the
// repo's insert bore is a recorded slip fit with the knurl never measured, and
// a 2.6 pilot in PETG holds an M3 fine for screws that come out twice a year.
REBATE    = 1.5;    // taken off the OUTSIDE of the frame rim -> tongue 1.5 thick
JOINT_CLR = 0.2;    // per side, skirt inner to tongue outer
TONGUE_H  = 9;
SKIRT_H   = TONGUE_H + SHELF_T;   // 12 — skirt covers tongue + shelf edge
BOSS_Y    = 55;     // +/- from centre, along the side walls
BOSS_IN   = 4.5;    // boss depth into the bay, behind the tongue
BOSS_W    = 8;
BOSS_H    = 12;     // from the rim down
SCREW_Z   = TONGUE_H/2;           // above the tongue root — mid tongue
SCREW_CLR = 3.4;    // through the skirt
SCREW_TAP = 2.6;    // pilot through tongue + boss (6 mm of thread)
TONGUE_OUT_W = W - 2*(REBATE + JOINT_CLR);   // tongue outline
TONGUE_OUT_D = D - 2*(REBATE + JOINT_CLR);
TONGUE_R     = BIN_R - REBATE - JOINT_CLR;
SKIRT_IN_W   = W - 2*REBATE;                 // skirt inner outline
SKIRT_IN_D   = D - 2*REBATE;
SKIRT_IN_R   = BIN_R - REBATE;
CUP_H        = SKIRT_H + CUP_IN_H + WALL;   // 55; the cup's z=0 is the skirt's bottom edge

/* [Deck layout] — x across, y front(-) to back(+), all centred on the box */
// Riser board along the rear half, meter + switch + probe post across the front.
RISER_X = -15;  RISER_Y = 50;          // board centre. 126.55 x 43.20, holes 99 x 37
METER_X = -25;  METER_Y = -38;         // housing 84.29 x 44.50, bezel 89 x 49
SW_X    =  45;  SW_Y    = -38;         // rocker
GND_X   =  66;  GND_Y   = -64;         // probe post — front-right corner, clear of the
                                       // RISER output's body coming through the right wall

/* [Component dimensions — MEASURED] */
METER_W = 84.29; METER_D = 44.50; METER_DEPTH = 24.45;   // housing behind the bezel
METER_CLR = 0.30;                                        // per side; spring clips forgive slop
SW_BODY   = 20.87;  SW_CLIP = 22.88;  SW_DEPTH = 23.3;   // body / relaxed clips / below deck
POST_THREAD = 7.45; POST_LEN = 19;                       // 4 mm binding post
RISER_L = 126.55; RISER_W = 43.20; RISER_T = 4.0;        // PCB + factory foam pad
RISER_HOLE_PITCH_L = 99;  RISER_HOLE_PITCH_W = 37;  RISER_HOLE_D = 3.98;

/* [XT60 panel connectors — NOT YET MEASURED] */
// XT60E-M (rear, input) and XT60E-F (right, outputs) are ordered, not in hand.
// Their cutout, ear pitch and screw size go in when calipered. Until then the
// walls carry no XT60 cutout at all — a plausible number here is exactly how
// two printed parts got scrapped in August. Positions are reserved below.
XT60_MEASURED = false;
XT60_CUT_W = undef;  XT60_CUT_H = undef;  XT60_EAR_PITCH = undef;  XT60_EAR_D = undef;
XT60_BODY_IN = undef;                  // depth behind the panel, for check_assembly

/* [Holes — nominal; the coupon's ladder picks the final value] */
SW_HOLE   = 21.0;   // body 20.87. Ladder 20.9 / 21.1 / 21.3
POST_HOLE = 7.7;    // thread 7.45. Ladder 7.6 / 7.8 / 8.0
PEG_D     = 3.8;    // hole 3.98. Ladder 3.6 / 3.7 / 3.8 / 3.9 on coupons/dock_rail_ladder.scad

/* [Rear wall — 12 V input] — x across the wall, z above the cup's skirt bottom */
WALL_Z   = SKIRT_H + CUP_IN_H/2;   // dead centre of the electronics bay wall
XT60_IN_X = -45;                   // XT60E-M
J2_PLUS_X =  15;                   // banana IN +  (red)
J2_MINUS_X = J2_PLUS_X + 19.05;    // banana IN -  (black), standard pair pitch

/* [Right wall — output] — y along the wall (front -, rear +) */
XT60_OUT_N   = 2;                  // [1:2] XT60E-F outputs, in parallel behind the switch
XT60_OUT_Y   = [-40, -10];         // RISER, CARD
J5_PLUS_Y    =  22;                // banana OUT +  (red)
J5_MINUS_Y   = J5_PLUS_Y + 19.05;  // banana OUT -  (black)

/* [Labels] — engraved with lib/label.scad, single colour */
LABEL_SIZE  = 5;
LABEL_DEPTH = 0.6;
LABEL_LIFT  = 9;                   // label baseline above a hole's centre

/* [Riser dock rails] */
RAIL_W = 10; RAIL_L = 47; RAIL_T = 1.2;
RAIL_POCKET = RAIL_T;          // rail sits FLUSH with the deck: the board rests
                               // on its foam, not on the rails. 1.8 of deck left under it
PEG_H_ABOVE_DECK = RISER_T + 1.2;   // peg tip 1.2 above the PCB top

/* [Drawer] */
DRAWER_W = W - 2*WALL - 2*BOSS_IN - 1.0;   // 151.5 — clears the frame bosses
DRAWER_D = D - WALL - 0.5;                 // front face flush with the frame
DRAWER_H = CORD_PILE_H + DRAWER_FLOOR;     // 67
X1_CARD_L = 33; X1_CARD_W = 29;            // riser x1 adapter, measured
X1_BAY_W  = X1_CARD_L + 3;                 // its compartment, right-hand side
PULL_R    = 12;

E = 0.01;

// ---------------------------------------------------------------------------
// helpers
// ---------------------------------------------------------------------------
module rrect(w, d, r = BIN_R) { offset(r) offset(-r) square([w, d], center = true); }

// A screw boss on a side wall's inner face, hanging from the rim, with a
// 45-degree taper underneath so it doesn't overhang when printed floor-down.
//   side = +1 right wall, -1 left; z_top = the rim.
module wall_boss(side, y, z_top) {
    x_face = side * (W/2 - WALL);                 // wall inner face
    x_in   = x_face - side * BOSS_IN;
    hull() {
        translate([min(x_face, x_in), y - BOSS_W/2, z_top - BOSS_H]) cube([BOSS_IN, BOSS_W, BOSS_H]);
        translate([min(x_face, x_face + side*E), y - BOSS_W/2, z_top - BOSS_H - BOSS_IN]) cube([E, BOSS_W, E]);
    }
}
