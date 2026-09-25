// bin_nozzles_mf50 — 4×2 Gridfinity bin, eight octagonal nozzle pockets for the
// Wolfbox MF50.
//
// WHY THIS EXISTS: a real Gridfinity home for the aftermarket nozzle set — a
// whole number of cells, a proper foot, one pocket per nozzle.
//
// THE POCKETS ARE SIZED FROM THE NOZZLE. Calipered on an aftermarket MF50
// nozzle, 2026-09-25 (survey/MEASUREMENTS.md):
//
//     octagonal collar   36.6 across the flats
//     round body         30.2 just below the collar
//
// Each pocket is that plus NOZZLE_CLR: a recess the collar drops into and rests
// on, over a bore the body hangs in. The depths are this design's choice: deep
// enough to hold a nozzle upright, shallow enough to grab it.
//
// ⚠️ THE RECESS IS AN OCTAGON, NOT A HEX. For reference, the corner-to-flat
// ratio of a regular hexagon is 1.155 and a regular octagon 1.082. It reads as a hex at a
// glance and is not one — the nozzles themselves are octagonal.
//
// A REGULAR OCTAGON'S BOUNDING BOX IS ITS ACROSS-FLATS, NOT ITS ACROSS-CORNERS —
// the corners sit at ±22.5° and fall inside the box. Sizing the pitch off 39.87
// suggests 1.4 mm walls; the real figure is the across-flats, which leaves
// 4.5 mm in X and 3.75 mm in Y.
//
// EIGHT POCKETS: the aftermarket set. The stock nozzles live elsewhere.
//
// PRINT: as emitted, feet down. No supports — every pocket wall is vertical and
// every floor faces up.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Nozzle — calipered 2026-09-25] */
NOZZLE_AF   = 36.6;   // octagonal collar, across the flats
NOZZLE_BODY = 30.2;   // round body just below the collar
NOZZLE_CLR  = 0.2;    // [0:0.05:0.6] added to both, on the diameter — 0.1 a side

/* [Pockets] */
OCTA_AF   = NOZZLE_AF + NOZZLE_CLR;     // 36.8 collar recess, ACROSS FLATS
OCTA_DEEP = 9.0;    // [3:0.5:20] recess depth
BORE_D    = NOZZLE_BODY + NOZZLE_CLR;   // 30.4 body bore
BORE_DEEP = 8.0;    // [3:0.5:20] bore depth below the recess

/* [Bin] */
NX = 4; NY = 2;
COLS = 4; ROWS = 2;   // 8 pockets
WALL  = 1.2;
FLOOR = 3.0;          // solid under the bores — the nozzles are not light

W  = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;   ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;
H  = Z0 + BORE_DEEP + OCTA_DEEP;

PITCH_X = IW/COLS;
PITCH_Y = ID/ROWS;
// A regular octagon of across-flats AF has circumradius AF/(2·cos22.5°), and is
// rotated 22.5° to put the flats on the axes.
OCTA_R = OCTA_AF/(2*cos(22.5));

assert(PITCH_X > OCTA_AF + 2, "Pockets too close in X — walls under 2 mm.");
assert(PITCH_Y > OCTA_AF + 2, "Pockets too close in Y — walls under 2 mm.");
assert(BORE_D < OCTA_AF, "Bore wider than the recess — the collar would not seat.");
echo(str("bin ", W, " x ", D, " x ", H, "; ", COLS, "x", ROWS, " = ", COLS*ROWS,
         " pockets at ", PITCH_X, " x ", PITCH_Y, " pitch; walls ",
         PITCH_X - OCTA_AF, " / ", PITCH_Y - OCTA_AF));

// Cuts are clipped to the ROUNDED interior — a plain cut spanning the interior
// runs through bin_blank's corner radii and opens all four corners. That shipped
// twice on this repo, both times watertight and CI-green.
module _interior(h) {
    translate([0, 0, Z0 - 0.1]) linear_extrude(h + 0.3)
        offset(BIN_R - WALL) offset(-(BIN_R - WALL))
            square([IW, ID], center = true);
}

difference() {
    bin_blank(NX, NY, H);
    intersection() {
        union() {
            for (cx = [0 : COLS-1], cy = [0 : ROWS-1]) {
                x = (cx - (COLS-1)/2) * PITCH_X;
                y = (cy - (ROWS-1)/2) * PITCH_Y;
                // barrel bore, lower
                translate([x, y, Z0 - 0.1])
                    cylinder(d = BORE_D, h = BORE_DEEP + 0.1, $fn = 96);
                // octagonal collar recess, upper
                translate([x, y, Z0 + BORE_DEEP])
                    linear_extrude(OCTA_DEEP + 0.2)
                        rotate(22.5) circle(r = OCTA_R, $fn = 8);
            }
        }
        _interior(H - Z0);
    }
}
