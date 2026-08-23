// bin_deoxit_droppers — 3×1 block for the three DeoxIT concentrate droppers
// (D100 / F100 / G100), bare bottles out of their kit boxes.
//
// THE BOTTLES ARE NOT ROUND. 39 × 20 is a flattened cross-section, and this part
// originally bored round 21 mm holes from it — the same mistake bin_dispenser
// made with the square alcohol pump. A measurement is a shape as well as a
// number; check which before choosing the cutter.
//
// 3×1 rather than 2×1: three 40 mm pockets side by side need 123 mm of interior
// and a 2×1 has 81.1. Long axis across the block, so they sit in a row facing
// you. A 2×2 would also work with them stacked front-to-back, but costs a cell
// more and buries the back one.
//
// Corner radius is deliberately generous but not a full oval: an oval pocket
// only suits an oval bottle, whereas a rounded rectangle accepts either. It
// locates the bottle; it does not need to trace it.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

POCKET_L = D_DROPPER_L + DROPPER_CLR;
POCKET_W = D_DROPPER_W + DROPPER_CLR;
POCKET_R = 6.0;   // [2:0.5:9] pocket corner radius

H = BIN_BASE_H + 1.4 + CAP_DROPPER;
PITCH = (3*GF - 0.5 - 2*1.2) / 3;

assert(3*POCKET_L + 2*1.2 <= 3*GF - 0.5 - 2*1.2,
       "Three pockets do not fit the interior — widen the block.");

difference() {
    bin_blank(3, 1, H);
    for (i = [-1, 0, 1])
        translate([i*PITCH, 0, BIN_BASE_H + 1.4])
            linear_extrude(CAP_DROPPER + 0.1)
                offset(POCKET_R) offset(-POCKET_R)
                    square([POCKET_L, POCKET_W], center = true);
}
