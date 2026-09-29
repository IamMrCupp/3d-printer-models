// deck_coupon.scad — PRINT THIS BEFORE THE BOX.
//
// A 3 mm plate, same thickness as the deck and walls, carrying every panel
// hole the box needs, with a fit ladder for each round one:
//
//   meter housing cutout      84.29 x 44.50 + 0.30/side   — clips must catch
//   rocker                    20.9 / 21.1 / 21.3          — body 20.87, snap-in
//   binding post              7.6 / 7.8 / 8.0             — thread 7.45
//   engraved label            "12V IN" at 5 mm / 0.6 deep — legible?
//   XT60E                     (added once the connectors are measured)
//
// Push each part into its ladder, note which hole fits, set SW_HOLE /
// POST_HOLE in rig_common.scad to match, then print the box.
//
// RESULT 2026-09-28: rocker 21.3, posts 7.6 (all passed), meter cutout too
// tight on the long axis -> coupons/meter_fuse_coupon.scad. Kept as printed.
// About 34 cm3 — a fraction of the 600 g it protects.

include <../rig_common.scad>

PLATE_W = 140; PLATE_D = 100; T = WALL;

SW_LADDER   = [20.9, 21.1, 21.3];
POST_LADDER = [7.6, 7.8, 8.0];

difference() {
    translate([-PLATE_W/2, -PLATE_D/2, 0]) cube([PLATE_W, PLATE_D, T]);
    // meter housing
    translate([-15, 22, -1]) linear_extrude(T + 2)
        square([METER_W + 2*0.30, METER_D + 2*0.30], center = true);   // as printed 2026-09-28: long axis too tight
    // rocker ladder
    for (i = [0 : 2]) translate([-48 + i*27, -16, -1]) cylinder(d = SW_LADDER[i], h = T + 2);
    // binding post ladder
    for (i = [0 : 2]) translate([-50 + i*14, -36, -1]) cylinder(d = POST_LADDER[i], h = T + 2);
    // label legibility, same size and depth as the walls
    translate([25, -36, T]) label_pocket("12V IN", LABEL_SIZE, LABEL_DEPTH);
    translate([50, -16, T]) label_pocket("+", LABEL_SIZE, LABEL_DEPTH);
    if (XT60_MEASURED) translate([45, -16, 0]) rotate([0, 0, 0]) translate([0, 0, T/2]) {
        cube([XT60_CUT_W, XT60_CUT_H, T*3], center = true);
        for (sx = [-1, 1]) translate([sx*XT60_EAR_PITCH/2, 0, 0]) cylinder(d = XT60_EAR_D, h = T*3, center = true);
    }
}

echo(str("deck_coupon: ", PLATE_W, " x ", PLATE_D, " x ", T, " mm"));
