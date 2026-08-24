// bin_swabs — 3×2 gravity dispenser for cotton buds.
//
// HOW YOU USE IT, stated first because the previous three versions were all
// geometrically valid and functionally useless:
//
//   Tip a box of buds into the open top of the tall HOPPER at the back. They lie
//   flat, across the bin. A scooped CHUTE runs from the hopper floor down under a
//   full-height DAM and into a dished TROUGH at the front. You pinch one out of
//   the trough; the next rolls down to replace it. The dam holds the pile back so
//   only the front row is ever loose.
//
// Failures this replaces:
//   v1 2×2 stack base  — baseplate cap on top, cannot be reloaded.
//   v2 2×2 open front  — entire front wall missing; buds roll onto the desk.
//   v3 1×1 upright cup — buds on end; they splay and you fish for one.
//   v4 2×2 straight ramp + flat dam — right mechanism, wrong shapes: a straight
//      ramp meeting a flat floor makes a corner buds jam in.
//
// WHY 3×2 AND NOT 2×2. Buds are up to 3.2" = 81.28 mm and a 2×2's interior is
// 81.10 — it misses by 0.18 mm. A bud that won't lie square sits diagonal, and a
// diagonal bud is what jams a dispenser. 123.1 mm of interior also covers the
// pointed precision swabs coming later.
//
// The floor is one CIRCULAR SCOOP, not a ramp plus a trough: a single radius
// means there is no corner anywhere along the path a bud rolls. Its low point
// sits in the trough, so buds run downhill the whole way rather than having to
// climb out from under the dam.
//
// PRINT: as emitted, feet down. The dam's underside is a GAP-tall bridge over
// the chute; at this span it prints unsupported.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 3; NY = 2;
H          = 58;    // [40:1:90] overall height — hopper capacity
TROUGH_D   = 26;    // [18:1:40] front trough depth (Y)
TROUGH_LIP = 12;    // [8:1:20] front wall height above the trough floor
SCOOP_R    = 140;   // [80:5:300] chute radius. Larger = gentler slope, less rise
                    //   at the back. Below ~100 the hopper floor gets steep.
DAM_T      = 2.0;   // [1.2:0.2:4] dam thickness
GAP        = 9;     // [5:0.5:16] opening under the dam — about one bud
WALL       = 1.2;
FLOOR      = 1.4;
BUD_L      = 81.28; // 3.2" — the number the footprint is chosen against

W = NX*GF - 0.5; D = NY*GF - 0.5;
IW = W - 2*WALL; ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

Y_FRONT = -ID/2;
Y_DAM   = Y_FRONT + TROUGH_D;
Y_BACK  = ID/2;
Y_LOW   = Y_FRONT + TROUGH_D/2;     // scoop low point — inside the trough

function scoop_z(y) = SCOOP_R - sqrt(SCOOP_R*SCOOP_R - pow(y - Y_LOW, 2));

assert(IW > BUD_L + 2, str("A ", BUD_L, " mm bud will not lie square in ", IW, " mm."));
assert(scoop_z(Y_BACK) < H - Z0 - 10, "Scoop rises too far at the back — raise SCOOP_R.");
echo(str("interior ", IW, " x ", ID, "; scoop rises ", scoop_z(Y_BACK),
         " mm at the back, ", scoop_z(Y_DAM), " mm at the dam"));

// The scoop cylinder is 140 mm across a 125 mm part, so it runs straight through
// the outer walls. It MUST be clipped to the interior — an earlier version was
// not, and the cylinder shaved the front wall down to 0.7 mm, which is v2's
// "buds roll onto the desk" failure with extra steps. Clip first, cut the lip
// second, in that order.
module _interior_prism() {
    translate([0, 0, Z0]) linear_extrude(H)
        offset(BIN_R - WALL) offset(-(BIN_R - WALL))
            square([IW, ID], center = true);
}

difference() {
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
        // dam: full height, standing on the scoop, GAP beneath it
        translate([-IW/2, Y_DAM, Z0 + scoop_z(Y_DAM) + GAP])
            cube([IW, DAM_T, H - Z0 - scoop_z(Y_DAM) - GAP]);
    }
    // NOW lower the front wall to the trough lip — after the cavity is clipped,
    // so this is the only thing that decides the lip height.
    translate([-W, -D/2 - 1, Z0 + TROUGH_LIP]) cube([2*W, WALL + 1.01, H]);
}
