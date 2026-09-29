// rig_common.scad — shared dimensions and modules for the PCIe test-rig power box.
//
// A fused, switched, metered 12 V feed for a bench PCIe GPU test rig, in a
// 4x4 Clickfinity-footed box. Wiring lives in github.com/IamMrCupp/pcie-gpu-test-rig
// (WIRING.md, wiring/pcie_rig_power.kicad_sch); this file is the geometry.
//
// TWO PRINTED PARTS + two small rails:
//
//   rig_base      footed floor plate with a raised tongue round its edge and
//                 four screw bosses. The electronics floor — the fuse holder
//                 and WAGO sit on it. Prints feet-down, like any bin.
//   rig_cup       top deck + four walls, open bottom, skirted to wrap the
//                 base's tongue. EVERY electrical part lives here (meter +
//                 switch + probe post on the deck, XT60 + banana input on the
//                 rear wall, XT60 + banana output on the right), so the wiring
//                 never crosses a joint and the top is fixed. Prints deck-down:
//                 the panel cutouts land on the bed.
//   rig_dock_rail two small rails that CA into pockets on the deck; their
//                 pegs hold the x16 riser board by its four mining holes.
//                 Separate because a peg can't grow off a face that's on the bed.
//
// The leads live in a parts drawer, not in the box — the drawer bay that
// earlier revisions carried underneath (frame + shelf + drawer, ~450 cm3 and
// 70 mm of height) was dropped 2026-09-28 for exactly that reason.
//
// WHY THE BOTTOM OPENS, NOT THE TOP. Service = four side screws out, cup lifts
// off with all its wiring intact, base stays latched to the grid. Nothing
// that carries current is on a part you remove to get at something else.
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
FLOOR_T = 3.0;      // base plate above the feet

/* [Electronics bay] */
// The meter hangs 24.45 below the deck; the rest is room for its screw
// terminals, the WAGO, the fuse holder and 14 AWG bends.
CUP_IN_H = 40;      // base floor top to deck underside

/* [Joint — cup to base] */
// The base carries a raised tongue round its edge; the cup's bottom edge is a
// skirt that wraps it, outer faces flush. Four M3 x 10 screws go in
// HORIZONTALLY from outside — through the skirt, through the tongue,
// self-tapping into a boss on the tongue's inner face — so the box stays
// latched to the grid for service. No heat-set inserts: the repo's insert bore
// is a recorded slip fit with the knurl never measured, and a 2.6 pilot in
// PETG holds an M3 fine for screws that come out twice a year.
REBATE    = 1.5;    // skirt thickness = tongue thickness
JOINT_CLR = 0.2;    // per side, skirt inner to tongue outer
TONGUE_H  = 9;
SKIRT_H   = TONGUE_H;
BOSS_Y    = 55;     // +/- from centre, along the side walls
BOSS_IN   = 4.5;    // boss depth inward from the tongue
BOSS_W    = 8;
SCREW_Z   = TONGUE_H/2;           // above the floor top — mid tongue
SCREW_CLR = 3.4;    // through the skirt
SCREW_TAP = 2.6;    // pilot through tongue + boss (6 mm of thread)
TONGUE_OUT_W = W - 2*(REBATE + JOINT_CLR);   // tongue outline
TONGUE_OUT_D = D - 2*(REBATE + JOINT_CLR);
TONGUE_R     = BIN_R - REBATE - JOINT_CLR;
TONGUE_IN_W  = TONGUE_OUT_W - 2*REBATE;
TONGUE_IN_D  = TONGUE_OUT_D - 2*REBATE;
TONGUE_IN_R  = TONGUE_R - REBATE;
SKIRT_IN_W   = W - 2*REBATE;                 // skirt inner outline
SKIRT_IN_D   = D - 2*REBATE;
SKIRT_IN_R   = BIN_R - REBATE;
CUP_H        = CUP_IN_H + WALL;              // 43; the cup's z=0 is the base floor top
Z_FLOOR      = BIN_BASE_H + FLOOR_T;         // base floor top, above the plate's socket floor

/* [Deck layout] — x across, y front(-) to back(+), all centred on the box */
// Riser board along the rear half, meter + switch + probe post across the front.
RISER_X = -15;  RISER_Y = 50;          // board centre. 126.55 x 43.20, holes 99 x 37
METER_X = -25;  METER_Y = -38;         // housing 84.29 x 44.50, bezel 89 x 49
SW_X    =  45;  SW_Y    = -38;         // rocker
GND_X   =  66;  GND_Y   = -64;         // probe post — front-right corner, clear of the
                                       // RISER output's body coming through the right wall

/* [Component dimensions — MEASURED] */
METER_W = 84.29; METER_D = 44.50; METER_DEPTH = 24.45;   // housing behind the bezel
METER_CLR_S = 0.30;   // per side, SHORT axis — fitted on the deck coupon 2026-09-28
METER_CLR_L = 0.75;   // per side, LONG axis. FITTED 2026-09-29: 85.79 snaps in tight and
                      // comes out clean (meter_fuse_coupon). 0.30 bound so hard a clip nearly broke.
SW_BODY   = 20.87;  SW_CLIP = 22.88;  SW_DEPTH = 23.3;   // body / relaxed clips / below deck
POST_THREAD = 7.45; POST_LEN = 19;                       // 4 mm binding post
FUSE_THREAD = 11.6; FUSE_LEN = 26;                       // 5x20 panel fuse holder (owned)
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
SW_HOLE   = 21.3;   // body 20.87. FITTED: largest step of the deck coupon ladder, 2026-09-28
POST_HOLE = 7.6;    // thread 7.45. FITTED: all three steps passed; tightest wins, the nut clamps
FUSE_HOLE = 11.8;   // 5x20 panel holder, thread 11.6. FITTED 2026-09-29 (tight); 12.0 is the fallback
PEG_D     = 3.8;    // hole 3.98. Ladder 3.6 / 3.7 / 3.8 / 3.9 on coupons/dock_rail_ladder.scad

/* [Rear wall — 12 V input] — x across the wall, z above the cup's skirt bottom */
WALL_Z   = CUP_IN_H/2;             // dead centre of the electronics bay wall
XT60_IN_X = -45;                   // XT60E-M
J2_PLUS_X =  15;                   // banana IN +  (red)
J2_MINUS_X = J2_PLUS_X + 19.05;    // banana IN -  (black), standard pair pitch
F1_X      =  60;                   // 5x20 panel fuse holder — swap a fuse without opening the box

/* [Right wall — output] — y along the wall (front -, rear +) */
XT60_OUT_N   = 2;                  // [1:2] XT60E-F outputs, in parallel behind the switch
XT60_OUT_Y   = [-40, -10];         // RISER, CARD
J5_PLUS_Y    =  22;                // banana OUT +  (red)
J5_MINUS_Y   = J5_PLUS_Y + 19.05;  // banana OUT -  (black)

/* [Labels] — engraved with lib/label.scad, single colour */
LABEL_SIZE  = 5;
LABEL_DEPTH = 0.8;                 // lib default: 4 layers. 0.6 let a two-colour inlay's base show through
LABEL_LIFT  = 9;                   // label baseline above a hole's centre

/* [Riser dock rails] */
RAIL_W = 10; RAIL_L = 47; RAIL_T = 1.2;
RAIL_POCKET = RAIL_T;          // rail sits FLUSH with the deck: the board rests
                               // on its foam, not on the rails. 1.8 of deck left under it
PEG_H_ABOVE_DECK = RISER_T + 1.2;   // peg tip 1.2 above the PCB top

E = 0.01;

// ---------------------------------------------------------------------------
// helpers
// ---------------------------------------------------------------------------
module rrect(w, d, r = BIN_R) { offset(r) offset(-r) square([w, d], center = true); }

// A screw boss standing on the base floor against the tongue's inner face.
//   side = +1 right, -1 left. Printed floor-down it is a plain block: no overhang.
module tongue_boss(side, y) {
    x_face = side * (TONGUE_IN_W/2);              // tongue inner face
    x_in   = x_face - side * BOSS_IN;
    translate([min(x_face, x_in), y - BOSS_W/2, Z_FLOOR]) cube([BOSS_IN, BOSS_W, TONGUE_H]);
}
