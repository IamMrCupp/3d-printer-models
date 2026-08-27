// bin_accessories_engraver — 2×1 bin for the ENGRAVER's non-shank accessories:
// the square bit box, the wheels, and an open bay.
//
// WHY IT EXISTS. `bin_bits_engraver` is a drilled block and only takes
// shank-mounted pieces. The box and the wheels are not that — wheels are
// mandrel-mounted and want a pocket, not a bore.
//
// THREE ZONES, full depth in Y:
//
//   BOX    14 mm — the 13 × 13 box plus 1 mm. One box; it can slide fore-aft in
//                  the zone, which does not matter for a rigid cube.
//   DISCS  26 mm — cut-off wheels AND sanding disks together, stacked flat like
//                  coins. Both are flat circles of the same order, so splitting
//                  them into two pockets would just waste width.
//   BAY    37.1 mm × 39.1 — spare, for whatever else turns up.
//
// The collet wrench is the HARDELL's, not this tool's, and is not accounted for
// here.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Contents] */
BOX_SZ   = 13.0;   // [8:0.5:30] square bit box, measured — 1 off
BOX_CLR  = 1.0;    // [0.5:0.1:2]
DISC_D   = 25.0;   // [10:1:40] largest wheel, measured
DISC_CLR = 1.0;    // [0.5:0.1:2]

/* [Bin] */
NX = 2; NY = 1;
DEPTH = 15;        // [8:1:40] "25-ish wide and 15 tall should be more than
                   //   enough" — the wheels' own spec, so the stack sits near
                   //   the rim rather than 3 mm down where it is hard to pinch
WALL  = 1.2;
FLOOR = 1.4;
DIV   = 2.0;       // [1.2:0.2:4]

H  = BIN_BASE_H + FLOOR + DEPTH;
W  = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;   ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

BOX_W  = BOX_SZ + BOX_CLR;
DISC_W = DISC_D + DISC_CLR;
BAY_W  = IW - BOX_W - DISC_W - 2*DIV;

assert(BAY_W >= 20, str("Open bay collapses to ", BAY_W,
                        " mm — nothing useful fits beside the pockets."));
assert(DISC_W < ID, "Disc pocket is deeper than the bin interior.");
echo(str("box ", BOX_W, " | discs ", DISC_W, " | bay ", BAY_W, " x ", ID,
         " (diagonal ", sqrt(BAY_W*BAY_W + ID*ID), ")"));


// THE CUTS MUST BE CLIPPED TO THE ROUNDED INTERIOR.
//
// bin_blank's interior is a ROUNDED rectangle (radius BIN_R - WALL). A plain
// cube spanning the full IW x ID runs straight through those corner radii and
// opens all four corners — the bin comes off the printer with no connected
// corners at all.
//
// It renders. It is watertight, 2-manifold, the right bounding box, and every
// zone measures exactly right. tools/validate_stl.py PASSES it. The only thing
// wrong is that the box is not a box, and nothing in the toolchain can see that.
// This shipped and was printed before anyone noticed.
//
// Clip first, then cut. Same fix as bin_swabs.
module _interior() {
    translate([0, 0, Z0]) linear_extrude(DEPTH + 0.2)
        offset(BIN_R - WALL) offset(-(BIN_R - WALL))
            square([IW, ID], center = true);
}

difference() {
    bin_blank(NX, NY, H);
    intersection() {
        union() {
            // zone 1 — the bit box
            translate([-IW/2, -ID/2, Z0]) cube([BOX_W, ID, DEPTH + 0.1]);
            // zone 2 — wheels, stacked flat
            translate([-IW/2 + BOX_W + DIV, -ID/2, Z0]) cube([DISC_W, ID, DEPTH + 0.1]);
            // zone 3 — open bay, spare
            translate([-IW/2 + BOX_W + DISC_W + 2*DIV, -ID/2, Z0])
                cube([BAY_W, ID, DEPTH + 0.1]);
        }
        _interior();
    }
}
