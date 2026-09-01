// bin_nozzles_mf50 — 4×2 Gridfinity bin, eight octagonal nozzle pockets for the
// Wolfbox MF50.
//
// WHY THIS EXISTS: the MakerWorld model this replaces is labelled Gridfinity and
// is not. Measured off its mesh: 90.00 × 133.00 footprint — 2.155 × 3.179 cells,
// not a whole number of either — and NO FOOT AT ALL. Its footprint is a constant
// 90 × 133 from 0.8 mm up to the rim, where a real bin steps 79.20 → 83.50 in
// BOTH axes between 2.2 and 3.0 mm. It also carries 30 non-manifold edges. It
// would sit loose in a 2×3 area with nothing to latch.
//
// THE POCKET GEOMETRY IS KEPT, BECAUSE THAT PART WAS RIGHT. Rastered
// cross-sections of the original at two heights, six pockets on a 2×3 grid at a
// clean 43 mm pitch:
//
//     collar recess   36.8 across flats, 39.87 across corners, 9 mm deep
//     bore            30.40, 8 mm deep
//     floor           3 mm
//
// ⚠️ THE RECESS IS AN OCTAGON, NOT A HEX. Corner-to-flat ratio measures 1.089;
// a regular hexagon is 1.155 and a regular octagon 1.082. It reads as a hex in a
// render and is not one. The user confirms the nozzles themselves are octagonal.
//
// A REGULAR OCTAGON'S BOUNDING BOX IS ITS ACROSS-FLATS, NOT ITS ACROSS-CORNERS —
// the corners sit at ±22.5° and fall inside the box. Sizing the pitch off 39.87
// suggested 1.4 mm walls and nearly cost the layout; the real figure is 36.8,
// which leaves 4.5 mm in X and 3.75 mm in Y.
//
// EIGHT POCKETS, NOT SIX: the stock nozzles are covered by the other holder;
// this one is for the aftermarket set.
//
// PRINT: as emitted, feet down. No supports — every pocket wall is vertical and
// every floor faces up.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Nozzles — measured off the original mesh] */
OCTA_AF   = 36.8;   // [20:0.1:60] collar recess, ACROSS FLATS
OCTA_DEEP = 9.0;    // [3:0.5:20] recess depth
BORE_D    = 30.4;   // [10:0.1:50] barrel bore
BORE_DEEP = 8.0;    // [3:0.5:20] bore depth below the recess

/* [Bin] */
NX = 4; NY = 2;
COLS = 4; ROWS = 2;   // 8 pockets
WALL  = 1.2;
FLOOR = 3.0;          // the original's floor, kept

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
