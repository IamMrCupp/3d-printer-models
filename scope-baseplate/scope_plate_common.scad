// scope_plate_common — Gridfinity plate for the microscope boom stand's weighted
// base. Sits flat on the base, wraps the boom pole, 5x3 grid on top.
//
// THIS IS A REBUILD. The previous version was a 3x3 with a three-sided skirt,
// open at the BACK for the pole. Both premises were wrong:
//   - the pole does NOT rise at the back edge, it rises from a boss ~a fifth of
//     the way in from one END. A plate that opens toward the back misses it.
//   - 131.84 x 130.54 was not the base. 130.54 was the true short axis, but the
//     long axis is 200.03 — the old reading covered only PART of the base.
// The old part is unusable; nothing here is carried over except the Gridfinity
// pitch itself.
//
// MEASURED 2026-08-28 (tape + calipers, user):
//   base       200.03 (7 7/8") x 130.18 (5 1/8")
//   boss       39.78 mm diameter, pole rises from it
//   boss pos   158.75 (6 1/4") from the RIGHT end  ->  41.28 from the left end
//
// ASSUMED, NOT MEASURED:
//   boss is CENTRED across the 130.18 width. The tape read 92.08 (3 5/8") from
//   one long edge, which is 27 mm off-centre and does NOT reconcile with the
//   eyeball "it looks centred". User's call, 2026-08-28: go with centred.
//   If it turns out to be off-centre the pole slot moves and TWO more cells die
//   (13 -> 11). Set BOSS_Y to the real offset and everything else follows.
include <../lib/gridfinity.scad>

// 200.03 x 130.18 IS THE PLATEAU — the raised top surface the plate sits on,
// not the outline of whatever the base steps down to below it. The old
// 131.84 x 130.54 was the same plateau with a short length reading; 130.54 and
// 130.18 are the same edge measured twice.
BASE_L = 200.03;   // 7 7/8"  long axis
BASE_W = 130.18;   // 5 1/8"  short axis
BOSS_D = 39.78;    // boss the pole rises from
BOSS_FROM_RIGHT = 158.75;   // 6 1/4"

STEP_H = 17.76;    // plateau height above the layer below -> how deep a skirt can grab
CORNER = 14;       // plateau corner radius. GAUGED, not calipered, with
                   // coupons/scope_corner_gauge.scad: gauges 5 (14) and 6 (16)
                   // both seated, so the real radius is ~15. Use 14 — the error
                   // is asymmetric. A larger CORNER rounds the skirt opening
                   // MORE, making it smaller at the corners, so it binds:
                   //     14 -> clears a real R of 14, 15 or 16
                   //     15 -> binds at 14
                   //     16 -> binds at 14 or 15
SKIRT_DEPTH = 12;  // < STEP_H with margin
SKIRT_WALL  = 2.5;
// Slip clearance, skirt to plateau. NOT 0.4 — that is the number that failed on
// the OWON tray frame over a similar span. PETG shrinks ~0.5 mm across 130 mm,
// so an internal dimension prints undersize and binds.
FIT = 1.2;

// ---- grid ----
// 5 along the length, 3 across the width.
//
// FIVE, NOT FOUR, AND IT OVERHANGS ON PURPOSE. 5*42 = 210 against a 200.03 base,
// so the plate hangs ~5 mm past each end. That is worth doing:
//     4 rows, slid so a row centre lands on the boss  -> 12 cells - 1 = 11
//     5 rows, overhanging                             -> 15 cells - 2 = 13
// Four rows can be positioned so the boss falls inside a single cell (the 32 mm
// of slack is enough to move a row centre onto 41.28). Five rows cannot — every
// offset in the valid -9.97..0 range straddles a boundary, so the boss costs two
// cells instead of one. You still come out two cells ahead, and the 32 mm of
// dead border stops existing.
//
// The overhang is plate, not bin: every socket stays a full 42 mm, so bins seat
// normally. What cantilevers is ~5 mm of 5.85 mm baseplate per end.
GRID_NX = 5;   // along BASE_L
GRID_NY = 3;   // across BASE_W

OVERHANG = (GRID_NX*GF - BASE_L) / 2;   // 4.99 per end
assert(OVERHANG > 0 && OVERHANG < GF/2, "grid/base mismatch — re-check BASE_L");
assert(GRID_NY*GF < BASE_W, "grid wider than the base — the sides would hang");

// ---- pole opening ----
// Boss centre in model coordinates (the grid is centred on the origin).
BOSS_X = -BASE_L/2 + (BASE_L - BOSS_FROM_RIGHT);   // -58.74
BOSS_Y = 0;                                        // ASSUMED centred — see header

// SLOT_W is 44, not BOSS_D + a fit clearance, and the reason is manifoldness on
// OpenSCAD 2021.01, not fit.
//
// Every "natural" width here lands within a millimetre of a socket boundary: the
// cell pitch is 42 and the boss is 39.78, so a 41-ish hole sits ~0.5 mm inside
// the socket opening, and at the plate's TOP FACE adjacent socket openings meet
// exactly at +-21. A cut plane tangent to that line is the same class of bug that
// put 96 non-manifold edges in the thermal mount's counterbore. 44 clears the
// whole of the middle column and passes 1 mm INTO the neighbouring sockets'
// outer taper — comfortably off every boundary, at the cost of a 1 mm nick in
// one wall of the two cells either side. Gridfinity retention is perimeter-wide;
// a 1 mm nick in one edge is cosmetic.
SLOT_W = 44;

// The slot runs off the near end so the plate SLIDES IN sideways. A closed hole
// would mean lifting the plate down over the pole — i.e. pulling the microscope
// head off first. The boss is 41.28 from the left end and 158.75 from the right,
// so the near end is the left.
//
// This costs nothing. The slot runs through the middle column of rows 1 and 2,
// which are the two cells the boss already destroyed.
SLOT_END = -GRID_NX*GF/2 + 2*GF + 2;   // -19: 2 mm past the row-2 / row-3 line at -21
EPS = 0.1;

assert(BOSS_X - BOSS_D/2 > -GRID_NX*GF/2, "boss falls off the near end");
assert(BOSS_X + BOSS_D/2 < SLOT_END,      "slot too short — boss is not fully freed");
assert(abs(BOSS_Y) + BOSS_D/2 < SLOT_W/2, "boss wider than the slot");

SKIRT_IN_L  = BASE_L + FIT;   SKIRT_IN_W  = BASE_W + FIT;
SKIRT_OUT_L = SKIRT_IN_L + 2*SKIRT_WALL;
SKIRT_OUT_W = SKIRT_IN_W + 2*SKIRT_WALL;

// THE WRAP IS CLOSED ON ALL FOUR SIDES. The near-end wall carries a channel
// exactly as wide as the pole slot above it, and nothing more.
//
// v2.0.1 left that whole end open, on the reasoning that the plate slides on
// lengthwise so anything hanging down across that end would hit the plateau.
// True — but it also means nothing stops the plate sliding straight back OFF,
// and the pole does not help, because the slot is open the same way. The
// printed plate slid off with a push.
//
// The fix is to change how it goes on. Instead of sliding on at plateau level:
//     1. hold the plate ABOVE the plateau and slide it sideways until the pole
//        is in the slot — the pole passes through this channel on the way
//     2. lower it straight down; all four walls drop over the plateau's edges
//
// Now sliding off is blocked by the two wall segments either side of the
// channel: they are ~43.7 mm each, and the plateau is 130.18 wide, so it cannot
// pass a 44 mm gap. The pole can. That is the whole trick, and it needs no
// measurement we do not already have — in particular it does NOT need the pole
// diameter or the boss height, which a keyhole throat would have.
SKIRT_GAP = SLOT_W;   // channel in the near-end wall — pole passes, plateau cannot

assert(SKIRT_DEPTH < STEP_H, "skirt deeper than the step — it will bottom out");
assert(SKIRT_OUT_W > GRID_NY*GF, "skirt inboard of the grid — no border to hang it from");
assert(SKIRT_OUT_L < GRID_NX*GF, "skirt outboard of the grid ends — it would float");

module _rrect(w, d, r) { offset(r) offset(-r) square([w, d], center = true); }

module scope_wipe_plate() {
    difference() {
        union() {
            baseplate(GRID_NX, GRID_NY);
            // Side rails: the grid is 126 wide, the skirt hangs at 136.38, so the
            // plate needs material out to the skirt to hang it from. The inner
            // boundary is the EXACT expression baseplate() uses for its own
            // outline, so the two curves are bit-identical and CGAL merges them
            // instead of stitching slivers between near-parallel arcs.
            difference() {
                linear_extrude(BP_H) _rrect(SKIRT_OUT_L, SKIRT_OUT_W, CORNER);
                translate([0,0,-EPS]) linear_extrude(BP_H + 2*EPS)
                    _rrect(GRID_NX*GF, GRID_NY*GF, GF_FILLET);
            }
            // Skirt. Bored the FULL height so it stays a ring all the way up —
            // stopping the bore at z=0 leaves a slab over the plate that swallows
            // every socket into a manifold, CI-passing brick.
            // THE SKIRT STOPS AT z=0. It used to run up to BP_H so it would
            // volumetrically merge with the plate rather than only touch it —
            // and that put skirt INSIDE the grid.
            //
            // The ring is 206.23 long against a 210 grid, so its two end
            // sections sit at |x| 100.62..103.12, which is inside the last row
            // of cells. Extruded to BP_H they ran straight through those
            // sockets: 448 mm3 of solid bar in every row-5 cell, 220 mm3 in
            // row 1. Nothing seated. The near-end cut below only removed
            // material under z=0, so opening that end did not save it either.
            //
            // Butting at exactly z=0 is the right join anyway — an overlap here
            // is the riser_spacer_2in bug, and a face-to-face union at an exact
            // plane is what 2021.01 wants.
            difference() {
                translate([0,0,-SKIRT_DEPTH]) linear_extrude(SKIRT_DEPTH)
                    _rrect(SKIRT_OUT_L, SKIRT_OUT_W, CORNER);
                translate([0,0,-SKIRT_DEPTH - EPS])
                    linear_extrude(SKIRT_DEPTH + 2*EPS)
                        _rrect(SKIRT_IN_L, SKIRT_IN_W, CORNER);
            }
        }
        // Channel through the near-end wall for the pole. Below z=0 only — the
        // plate above it stays whole, and the cut's top face BUTTS z=0 exactly
        // rather than overlapping by an epsilon, which is what broke
        // riser_spacer_2in on 2021.01.
        //
        // Aligned with the pole slot above it (same width, same BOSS_Y), so the
        // pole drops through both as one continuous channel.
        // Same rounded profile as the slot above it, not a sharp-cornered cube.
        // A cube here leaves the channel's square corners meeting the slot's
        // r=3 corners at z=0 — the profile changes shape abruptly across that
        // plane, and isolating the near end produced a 9.03e-04 mm sliver on
        // 2021.01. One continuous profile through both is cleaner and cheaper
        // than special-casing it.
        translate([0, 0, -SKIRT_DEPTH - 1]) linear_extrude(SKIRT_DEPTH + 1)
            translate([(-SKIRT_IN_L/2 + 1 - GRID_NX*GF)/2, BOSS_Y])
                _rrect(GRID_NX*GF - SKIRT_IN_L/2 + 1, SKIRT_GAP, 3);
        // Pole slot: rounded rect, open at the near end. Started well outside the
        // plate (-GRID_NX*GF) so the cut PASSES THROUGH the end face rather than
        // stopping on it.
        translate([0, 0, -EPS]) linear_extrude(BP_H + 2*EPS)
            translate([(SLOT_END - GRID_NX*GF)/2, BOSS_Y])
                _rrect(SLOT_END + GRID_NX*GF, SLOT_W, 3);
    }
}
