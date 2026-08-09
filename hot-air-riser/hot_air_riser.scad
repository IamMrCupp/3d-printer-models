// hot_air_riser — simple Gridfinity-footed riser that lifts the hot-air station
// up behind the front-row gear. Foots into the Clickfinity bench baseplate; the
// station sits on the top deck inside a retaining lip so it can't slide off.
// Hollow body (print economy). Print in PETG — it holds a hot appliance.
//
// TWO NUMBERS to set: the grid footprint (GX × GY, ≥ the station footprint) and
// the height H (deck sits above the front items' height).
include <../lib/gridfinity.scad>

GX = 4;    // ⚠ set: grid cells wide  (× 42 mm). Cover the station footprint.
GY = 3;    // ⚠ set: grid cells deep
H  = 80;   // ⚠ set: riser height, foot → deck top (clear the front items)

WALL   = 2.4;   // body wall
DECK   = 3;     // top deck thickness
LIP_H  = 6;     // retaining lip height
LIP_W  = 3;     // retaining lip width

module hot_air_riser(nx, ny, h) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    union() {
        difference() {
            bin_blank(nx, ny, h);                                    // Gridfinity foot + block
            translate([0,0,BIN_BASE_H])                              // hollow from below, leave the deck
                linear_extrude(h - BIN_BASE_H - DECK)
                    offset(BIN_R-WALL) offset(-(BIN_R-WALL))
                        square([W-2*WALL, D-2*WALL], center=true);
        }
        translate([0,0,h]) linear_extrude(LIP_H)                     // top retaining lip
            difference() {
                offset(BIN_R) offset(-BIN_R) square([W, D], center=true);
                offset(BIN_R) offset(-BIN_R) square([W-2*LIP_W, D-2*LIP_W], center=true);
            }
    }
}

hot_air_riser(GX, GY, H);
