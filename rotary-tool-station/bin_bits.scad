// bin_bits — 1×1 block, 7 × 5 grid of 3/32" shank holes, one per bit.
//
// 35 holes for 35 bits, counted 2026-08-25. It was a 2×1 with 70 holes, sized
// off the 69-piece set on the assumption every piece was shank-mounted; most
// aren't. Same 6.0 × 8.4 pitch, half the block, a cell back.
//
// The bore is CALIBRATED, not guessed: `coupons/bit_fit_gauge.scad` was printed
// and the shanks go into its 2.7 hole, so BIT_BORE is 2.70 and BIT_CLR falls out
// of it. Re-run the coupon if the nozzle, filament or layer height changes.
include <rotary_station_common.scad>
syringe_rack(1, 1, BIT_COLS, BIT_ROWS, BIT_SHANK, BIT_CAPTURE, clr = BIT_CLR);
