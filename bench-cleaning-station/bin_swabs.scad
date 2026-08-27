// bin_swabs — 3×2 cotton-bud dispenser: tall hopper behind, low trough in front.
//
// MODELLED ON thing:7165275 (Haaneroth, CC BY-NC-SA), which is the shape that
// actually works. That design is a TALL CLOSED BOX whose front wall doubles as a
// dam, with a LOW SCOOPED TROUGH projecting in front of it. Buds tip into the
// box, roll down a continuous curved floor, pass under the dam, and present in
// the trough where you pinch one out.
//
// WHAT THIS REPLACES, AND WHY IT WAS WRONG. The previous version was a box of
// UNIFORM height with a dish inside it. Every wall stood at 42 mm, so the trough
// was at the bottom of a 36 mm well — you reached down a shaft to find a bud
// instead of picking one off a shelf. It held buds; it did not dispense them,
// and it looked nothing like the reference it was supposedly modelled on.
//
// THE SILHOUETTE IS THE DESIGN. Tall at the back, low at the front:
//
//     back wall      58 mm      hopper — holds the pile
//     dam            58 mm      the hopper's front wall, GAP mm clear at its base
//     front wall     26 mm      low enough to reach over, tall enough to contain
//
// FRONT AND BACK ARE BOTH REAL WALLS. An earlier attempt cut the front to a
// 12 mm lip and buds rolled onto the desk. 26 mm against a trough floor at 7.97
// gives **18 mm of containment** — the trough is a dished shelf you reach into,
// not an opening things escape from.
//
// THE FLOOR IS ONE CONTINUOUS RADIUS, not a ramp meeting a trough. A single
// SCOOP_R means there is no corner anywhere along the path a bud rolls, and it
// runs downhill the whole way rather than having to climb out from under the dam.
//
// PRINT: as emitted, feet down. The dam's underside is a GAP-tall bridge over
// the floor; at this span it prints unsupported.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 3; NY = 2;
H         = 58;    // [40:1:90] hopper height — the back wall and the dam
FRONT_H   = 26;    // [16:1:40] front wall. Low enough to reach over, high enough
                   //   to contain: see the 18 mm figure in the header.
TROUGH_D  = 30;    // [20:1:45] front-to-back depth of the trough, dam to front
SCOOP_R   = 90;    // [50:5:200] floor radius. Smaller digs a deeper trough and
                   //   raises the floor at the back; below ~70 the hopper's rear
                   //   floor climbs into the usable volume.
LOW_IN    = 18;    // [8:1:30] where the floor bottoms out, back from the front
DAM_T     = 2.0;   // [1.2:0.2:4] dam thickness
GAP       = 9;     // [5:0.5:16] feed opening under the dam — about one bud
WALL      = 1.2;
FLOOR     = 1.4;
BUD_L     = 81.28; // 3.2" — the footprint is chosen against this

W = NX*GF - 0.5; D = NY*GF - 0.5;
IW = W - 2*WALL; ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

Y_FRONT = -ID/2;
Y_DAM   = Y_FRONT + TROUGH_D;
Y_BACK  = ID/2;
Y_LOW   = Y_FRONT + LOW_IN;

function floor_z(y) = SCOOP_R - sqrt(SCOOP_R*SCOOP_R - pow(y - Y_LOW, 2));

assert(IW > BUD_L + 2, str("A ", BUD_L, " mm bud will not lie square in ", IW, " mm."));
assert(FRONT_H > Z0 + floor_z(Y_FRONT) + 12,
       "Front wall is too low over the trough floor — buds will roll out.");
assert(Z0 + floor_z(Y_BACK) < H - 15, "Floor climbs too far at the back — raise SCOOP_R.");
echo(str("front wall ", FRONT_H, " over a trough floor at ", Z0 + floor_z(Y_FRONT),
         " = ", FRONT_H - Z0 - floor_z(Y_FRONT), " mm of containment; hopper ",
         H - Z0 - floor_z(Y_BACK), " mm usable at the back"));

// EVERY CUT IS CLIPPED TO THIS. bin_blank's interior is a ROUNDED rectangle, and
// a plain cube spanning the full interior runs straight through the corner radii
// and opens all four corners. Two bins shipped and were printed that way before
// anyone looked; tools/validate_stl.py now fails it.
module _interior(h) {
    translate([0, 0, Z0]) linear_extrude(h)
        offset(BIN_R - WALL) offset(-(BIN_R - WALL))
            square([IW, ID], center = true);
}

difference() {
    union() {
        difference() {
            bin_blank(NX, NY, H);
            intersection() {
                union() {
                    // the curved floor, swept across the full width
                    translate([-IW, Y_LOW, Z0 + SCOOP_R])
                        rotate([0, 90, 0]) cylinder(r = SCOOP_R, h = 2*IW, $fn = 256);
                    // everything above it
                    translate([-IW/2, Y_FRONT, Z0 + SCOOP_R]) cube([IW, ID, H]);
                }
                _interior(H);
            }
        }
        // the dam — the hopper's front wall, standing GAP clear of the floor
        translate([-IW/2, Y_DAM, Z0 + floor_z(Y_DAM) + GAP])
            cube([IW, DAM_T, H - Z0 - floor_z(Y_DAM) - GAP]);
    }
    // drop the FRONT wall to FRONT_H — everything ahead of the dam
    translate([-W, Y_FRONT - WALL - 1, FRONT_H])
        cube([2*W, TROUGH_D + WALL + 1, H]);
}
