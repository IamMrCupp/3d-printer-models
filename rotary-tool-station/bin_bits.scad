// bin_bits — 2×1 block, 14 × 5 grid of 3/32" shank holes.
// Set BIT_CLR from a bit_fit_gauge print before committing to 70 holes.
include <rotary_station_common.scad>
syringe_rack(2, 1, BIT_COLS, BIT_ROWS, BIT_SHANK, BIT_CAPTURE, clr = BIT_CLR);
