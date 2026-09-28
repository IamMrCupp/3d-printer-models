// deck_coupon.scad — PRINT THIS BEFORE THE BOX.
//
// A 3 mm plate, same thickness as the deck and walls, carrying every panel
// hole the box needs, with a fit ladder for each round one:
//
//   meter housing cutout      84.29 x 44.50 + 0.30/side   — clips must catch
//   rocker                    20.9 / 21.1 / 21.3          — body 20.87, snap-in
//   fuse holder               11.8 / 12.0 / 12.2          — thread 11.6
//   binding post              7.6 / 7.8 / 8.0             — thread 7.45
//   pigtail exit              19.0                        — both tails, 18.25
//
// Push each part into its ladder, note which hole fits, set SW_HOLE /
// FUSE_HOLE / POST_HOLE in rig_common.scad to match, then print the box.
// About 34 cm3 — a fraction of the 600 g it protects.

include <../rig_common.scad>

PLATE_W = 140; PLATE_D = 100; T = WALL;

SW_LADDER   = [20.9, 21.1, 21.3];
FUSE_LADDER = [11.8, 12.0, 12.2];
POST_LADDER = [7.6, 7.8, 8.0];

difference() {
    translate([-PLATE_W/2, -PLATE_D/2, 0]) cube([PLATE_W, PLATE_D, T]);
    // meter housing
    translate([-15, 22, -1]) linear_extrude(T + 2)
        square([METER_W + 2*METER_CLR, METER_D + 2*METER_CLR], center = true);
    // rocker ladder
    for (i = [0 : 2]) translate([-48 + i*27, -16, -1]) cylinder(d = SW_LADDER[i], h = T + 2);
    // fuse holder ladder
    for (i = [0 : 2]) translate([29 + i*16, -16, -1]) cylinder(d = FUSE_LADDER[i], h = T + 2);
    // binding post ladder
    for (i = [0 : 2]) translate([-50 + i*14, -36, -1]) cylinder(d = POST_LADDER[i], h = T + 2);
    // pigtail exit
    translate([10, -36, -1]) cylinder(d = TAILS_HOLE, h = T + 2);
}

echo(str("deck_coupon: ", PLATE_W, " x ", PLATE_D, " x ", T, " mm"));
