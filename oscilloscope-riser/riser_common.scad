// riser_common.scad — shared dimensions for the OWON ADS1014D bench riser.
//
// >>> SKELETON. Every constant tagged [MEASURE] or [GAUGE] is a PLACEHOLDER. <<<
//
// The geometry below is real and renders, but it is sized against guessed
// numbers. Nothing here should be printed as a final part until the tagged
// constants are replaced with readings off the actual scope. The asserts at the
// bottom exist to make a bad combination fail loudly at render time rather than
// quietly producing a block whose pockets miss the feet.
//
// WHAT THIS MODEL IS
//   Two blocks, one under each side of the scope. The scope bridges them — no
//   part spans its full width, so nothing has to be tiled or joined and nothing
//   comes near the U1's 270 mm limit. Each block:
//     - stands on Gridfinity feet, so it LATCHES into a Clickfinity desk plate
//     - is hollow with an open front, so the cavity is usable storage
//     - has a SOLID flat top carrying a locating pocket per scope foot
//
// Why a solid top and not stack_base()'s baseplate cap: the cap is a socket
// grid, and the scope's rubber feet would land across socket openings and rock.
// The cap earns its keep when a Gridfinity BIN stacks on top; a scope is not a
// bin. Everything else about stack_base()'s idiom (feet down, open-front cavity)
// is kept.
//
// The point of the riser is that the span BETWEEN the two blocks stays open desk
// grid — that is where bins go, and it is what BIN_CLEAR_H below is sizing for.
//
// PRINT ORIENTATION: upside down, top face on the bed. The top face is the
// precision surface (it carries the foot pockets and takes the load), and it
// comes out flattest against glass. It also means the cavity opens upward during
// the print, so there is no ceiling to bridge and no supports anywhere. The
// wrappers emit this orientation by default — see PRINT_READY.

include <../lib/gridfinity.scad>

// Bins standardised on 48 across this repo after the OpenSCAD 2026.06.12
// tessellation gotcha (scattered height/$fn combinations emit non-manifold
// edges). Do not raise this without re-rendering and checking the validator.
$fn = 48;

/* [Scope — MEASURE ALL OF THESE] */
// OWON ADS1014D, 100 MHz / 1 GSa/s. Read off the unit with calipers or a rule,
// NOT off the datasheet: the SPM8104's published 82 mm width was wrong by 2.3 mm
// and cost a reprint. Body only — ignore the knobs and BNCs that stick out front.
SCOPE_W = 340.0;   // [MEASURE] overall body width
SCOPE_D = 155.0;   // [MEASURE] overall body depth, front bezel to rear panel

// Foot positions are what the geometry is actually built on. Measure CENTRE to
// CENTRE, not edge to edge, and measure both — a scope's feet are rarely
// symmetric about the case.
FOOT_SPAN_X = 300.0;  // [MEASURE] left foot centre -> right foot centre
FOOT_SPAN_Y = 110.0;  // [MEASURE] front foot centre -> rear foot centre

// FOOT_D comes from riser_foot_gauge.scad, NOT from calipers on the foot. The
// number that matters is the finished pocket a foot drops into, which folds the
// foot's own diameter and this printer's hole shrinkage into one reading. That
// is the lesson the OWON barrel-tip bore cost half a session to learn.
FOOT_D   = 14.0;   // [GAUGE] finished pocket diameter that locates a foot
FOOT_CLR = 0.00;   // extra clearance on top of the gauge reading. Should stay 0
                   //   — the gauge reading is already a finished-hole number, so
                   //   adding to it double-counts the clearance.

/* [Under-riser clearance] */
// This is the whole reason the riser is tall. BIN_CLEAR_H is the headroom under
// the top plate, measured from the same datum a bin sits on (the desk plate's
// socket floor), so it compares directly against a bin's total height.
//
// Clickfinity's latch GRIPS — a bin is pulled straight up against four arms per
// cell. So the clearance has to cover the bin plus the release travel plus room
// to get a hand in. Sizing this to the bin height alone builds a shelf whose
// bins you cannot extract.
MAX_BIN_H  = 55.0;  // [DECIDE] tallest bin you want to park under here.
                    //   55 matches the OWON cord well — the tallest bin so far.
HAND_CLEAR = 40.0;  // [DECIDE] air above that bin for fingers + release travel.
                    //   Below ~30 this gets unpleasant one-handed.
TOP_T      = 4.0;   // top plate thickness. Carries the scope; also the material
                    //   the foot pockets are sunk into, so TOP_T > POCKET_H.

BLOCK_H = MAX_BIN_H + HAND_CLEAR + TOP_T;   // derived — do not hand-set

/* [Foot pockets] */
POCKET_H = 2.50;   // [DECIDE] how deep a foot sits in. Deliberately shallow: the
                   //   pocket only has to LOCATE the scope so it cannot creep.
                   //   Deep pockets on compliant rubber feet make the scope
                   //   awkward to lift off and add nothing.

/* [Block shell] */
WALL    = 2.40;  // side wall thickness
FLOOR_T = 1.60;  // cavity floor above the feet

/* [Output] */
PRINT_READY = true;  // emit flipped, top face on the bed (see header)

// ---------------------------------------------------------------------------
// Derived — nothing below is hand-set
// ---------------------------------------------------------------------------

POCKET_D = FOOT_D + FOOT_CLR;
EDGE_MIN = 2.00;             // minimum solid top plate outside a pocket

// The blocks are grid-quantised; the scope's feet are not. So the block SEPARATION
// snaps to whole cells and each pocket is then offset within its own block to
// land on the real foot. This is the same reconciliation owon-spm8104-tray does
// between a grid-sized frame and a case that is not a multiple of 42.
BLOCK_SEP = round(FOOT_SPAN_X / GF) * GF;      // block centre -> block centre
POCKET_DX = (FOOT_SPAN_X - BLOCK_SEP) / 2;     // pocket offset within a block,
                                               //   outboard positive

// Depth is derived so BOTH pockets land on solid top plate with EDGE_MIN to
// spare. Deriving it (rather than hand-picking GY) is what stops a repeat of the
// OWON frame bug, where an outer dimension was set by eye and the span that
// actually had to fit came out 8 mm short.
GY = max(2, ceil((FOOT_SPAN_Y + POCKET_D + 2 * EDGE_MIN) / GF));
GX = max(2, ceil((2 * abs(POCKET_DX) + POCKET_D + 2 * EDGE_MIN) / GF));

BLOCK_W = GX * GF - 0.5;
BLOCK_D = GY * GF - 0.5;
CAV_Z0  = BIN_BASE_H + FLOOR_T;   // cavity floor, above the Gridfinity feet

// If GY comes out visibly deeper than the scope once real numbers land, the
// optimisation is a grid-sized block with the top plate OVERHANGING on gusseted
// end shelves — the trick owon_tray_frame uses. Deliberately NOT done here:
// an overhang puts the scope's load on a cantilever, and it is not worth
// designing against placeholder dimensions. Revisit only if the derived GY
// actually wastes material against measured feet.

// ---------------------------------------------------------------------------
// Asserts — these catch what the CI mesh check cannot
// ---------------------------------------------------------------------------

assert(POCKET_H < TOP_T,
       "POCKET_H must be less than TOP_T or the foot pocket punches through the top plate.");

assert(FOOT_SPAN_Y / 2 + POCKET_D / 2 + EDGE_MIN <= BLOCK_D / 2,
       "Foot pockets fall off the top plate front-to-back. GY should have grown to cover it — check FOOT_SPAN_Y and FOOT_D.");

assert(abs(POCKET_DX) + POCKET_D / 2 + EDGE_MIN <= BLOCK_W / 2,
       "Foot pocket falls off the top plate left-to-right. Raise GX or re-check FOOT_SPAN_X.");

assert(BLOCK_SEP - BLOCK_W >= GF,
       "The two blocks are closer than one grid cell apart — at this foot span they want to be a single part, not a pair.");

assert(BLOCK_H <= 270 && BLOCK_W <= 270 && BLOCK_D <= 270,
       "Block exceeds the U1's 270 mm build volume.");

assert(BLOCK_W - 2 * WALL > 0 && BLOCK_D - 2 * WALL > 0,
       "WALL is thicker than the block — nothing left for a cavity.");

// ---------------------------------------------------------------------------
// Geometry
// ---------------------------------------------------------------------------

// One riser block. side = "left" or "right" — they are mirror images whenever
// the feet do not land on grid centres (POCKET_DX != 0).
module riser_block(side = "left") {
    dx = (side == "right") ? POCKET_DX : -POCKET_DX;
    iw = BLOCK_W - 2 * WALL;
    id = BLOCK_D - 2 * WALL;
    cav_h = BLOCK_H - TOP_T - CAV_Z0;

    difference() {
        bin_blank(GX, GY, BLOCK_H);

        // hollow it out, stopping TOP_T below the top face
        translate([0, 0, CAV_Z0]) linear_extrude(cav_h + 0.01)
            offset(BIN_R - WALL) offset(-(BIN_R - WALL))
                square([iw, id], center = true);

        // Open the front (-Y) so the cavity is reachable in place.
        //
        // The cut has to reach the cavity's own front face at -id/2, which is
        // WALL inboard of the block's front face at -BLOCK_D/2. Reaching only
        // -BLOCK_D/2 leaves the front wall standing and the cavity sealed —
        // which renders as a perfectly manifold part with TWO connected
        // components (outer shell + trapped inner surface) and passes CI.
        // stack_base() in lib/gridfinity.scad has exactly that off-by-WALL.
        translate([-iw / 2, -BLOCK_D, CAV_Z0])
            cube([iw, BLOCK_D / 2 + WALL + 0.01, cav_h + 0.01]);

        // locating pocket under each scope foot on this side
        for (sy = [-1, 1])
            translate([dx, sy * FOOT_SPAN_Y / 2, BLOCK_H - POCKET_H])
                cylinder(h = POCKET_H + 0.01, d = POCKET_D);
    }
}

// Flipped for printing: top face on the bed, feet pointing up. No bridging, no
// supports, and the surface the scope sits on is the one against the plate.
module riser_block_emit(side = "left") {
    if (PRINT_READY) translate([0, 0, BLOCK_H]) rotate([180, 0, 0]) riser_block(side);
    else riser_block(side);
}
