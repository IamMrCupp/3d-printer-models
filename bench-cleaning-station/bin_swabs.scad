// bin_swabs — 3×2 cotton-bud bin. Four walls, open top, dished floor, low dam.
//
// HOW YOU USE IT. Tip a box of buds in the open top. They lie flat, across the
// bin. The floor is a shallow CIRCULAR DISH, so they settle forward instead of
// piling where they landed. A low DAM two thirds of the way back splits the bin:
// the pile stays behind it, and only the front row is loose in the TROUGH. You
// reach in over the dam and pinch one out. Buds feed forward through the GAP
// under the dam as the trough empties.
//
// FRONT AND BACK ARE FULL WALLS. The version before this lowered the front to a
// 12 mm lip so buds presented themselves at the opening — a dispenser, not a
// bin. Anything that can roll out of an opening eventually does. The dam still
// does the useful half of that job; the wall stays.
//
// Failures this replaces:
//   v1 2×2 stack base   — baseplate cap on top, cannot be reloaded.
//   v2 2×2 open front   — entire front wall missing; buds roll onto the desk.
//   v3 1×1 upright cup  — buds on end; they splay and you fish for one.
//   v4 2×2 ramp + dam   — right idea, wrong shapes: a straight ramp meeting a
//                         flat floor makes a corner buds jam in.
//   v5 3×2 dispenser    — lowered front lip. Same hole as v2, smaller.
//
// WHY 3×2. Buds are up to 3.2" = 81.28 mm and a 2×2's interior is 81.10 — it
// misses by 0.18 mm. A bud that won't lie square sits diagonal, and a diagonal
// bud is what bridges over the dam gap. 123.1 mm also covers the pointed
// precision swabs coming later.
//
// WHY H IS 42 AND NOT 58. With a full front wall the trough is reached from
// above, so wall height is a reach depth, not free capacity. 42 mm puts the
// trough floor ~35 mm down — normal bin reach. The hopper still holds several
// hundred buds; they are 3 mm across.
//
// PRINT: as emitted, feet down. The dam's underside is a GAP-tall bridge over
// the dish; at this span it prints unsupported.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 3; NY = 2;
H          = 42;    // [30:1:70] overall height — also the reach into the trough
TROUGH_D   = 32;    // [22:1:45] trough depth (Y). Two fingers need ~30
DAM_H      = 24;    // [12:1:40] dam top, above the dish under it. Reach over it
SCOOP_R    = 140;   // [80:5:300] dish radius. Larger = flatter, less rise at the
                    //   back. Below ~100 the hopper floor gets steep.
DAM_T      = 2.0;   // [1.2:0.2:4] dam thickness
GAP        = 9;     // [5:0.5:16] feed opening under the dam — about one bud
WALL       = 1.2;
FLOOR      = 1.4;
BUD_L      = 81.28; // 3.2" — the number the footprint is chosen against

W = NX*GF - 0.5; D = NY*GF - 0.5;
IW = W - 2*WALL; ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

Y_FRONT = -ID/2;
Y_DAM   = Y_FRONT + TROUGH_D;
Y_BACK  = ID/2;
Y_LOW   = Y_FRONT + TROUGH_D/2;     // dish low point — inside the trough

function scoop_z(y) = SCOOP_R - sqrt(SCOOP_R*SCOOP_R - pow(y - Y_LOW, 2));

assert(IW > BUD_L + 2, str("A ", BUD_L, " mm bud will not lie square in ", IW, " mm."));
assert(DAM_H > GAP + 4, "Dam is shorter than its own feed gap — nothing holds the pile.");
assert(Z0 + scoop_z(Y_DAM) + DAM_H < H - 8, "Dam reaches the rim; you cannot get a hand past it.");
assert(scoop_z(Y_BACK) < H - Z0 - 10, "Dish rises too far at the back — raise SCOOP_R.");
echo(str("interior ", IW, " x ", ID, "; dish rises ", scoop_z(Y_BACK),
         " mm at the back; trough floor ", Z0 + scoop_z(Y_LOW),
         " mm, i.e. ", H - Z0 - scoop_z(Y_LOW), " mm below the rim"));

// The dish cylinder is 280 mm across a 125 mm part, so it runs straight through
// the outer walls. It MUST be clipped to the interior — an earlier version was
// not, and the cylinder shaved the front wall down to 0.7 mm, which is v2's
// "buds roll onto the desk" failure with extra steps.
module _interior_prism() {
    translate([0, 0, Z0]) linear_extrude(H)
        offset(BIN_R - WALL) offset(-(BIN_R - WALL))
            square([IW, ID], center = true);
}

union() {
    difference() {
        bin_blank(NX, NY, H);
        intersection() {
            union() {
                translate([-IW, Y_LOW, Z0 + SCOOP_R])
                    rotate([0, 90, 0]) cylinder(r = SCOOP_R, h = 2*IW, $fn = 256);
                translate([-IW/2, Y_FRONT, Z0 + SCOOP_R]) cube([IW, ID, H]);
            }
            _interior_prism();
        }
    }
    // dam: a low retaining ridge standing off the dish, GAP beneath it to feed
    translate([-IW/2, Y_DAM, Z0 + scoop_z(Y_DAM) + GAP])
        cube([IW, DAM_T, DAM_H - GAP]);
}
