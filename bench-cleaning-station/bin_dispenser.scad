// bin_dispenser — 2×2 cup for one 200 ml push-down IPA pump.
//
// The bottle is SQUARE. This used collar_cup(), which only bores cylinders, so
// a 53.50 mm square base was cut as a 53.50 mm round hole — the bottle's corners
// foul the bore by ~11 mm a side and it never seats. The measurement was right
// and the shape was wrong.
//
// POCKET_R is deliberately small: the pocket only accepts the bottle if its own
// corners are no rounder than the bottle's. 2 mm suits any bottle with a corner
// radius of 2 mm or more, which is effectively all of them.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

POCKET_R = 2.0;   // [0.5:0.5:6] pocket corner radius — keep <= the bottle's
CLR      = 1.0;   // across flats, matching lib/vessel.scad's convention

h = BIN_BASE_H + 1.4 + CAPTURE;
s = D_DISPENSER + CLR;

difference() {
    bin_blank(2, 2, h);
    translate([0, 0, BIN_BASE_H + 1.4])
        linear_extrude(CAPTURE + 0.1)
            offset(POCKET_R) offset(-POCKET_R) square([s, s], center = true);
}
