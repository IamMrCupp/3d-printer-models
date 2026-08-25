// bin_bits — 1×1 block, 5 × 3 grid, 15 holes for the HARDELL's shank bits.
//
// 15 holes for ~15 bits, counted 2026-08-25. It was a 2×1 with 70, sized off a
// 69-piece set on the assumption every piece was shank-mounted; most aren't.
// The wheels and sanding disks are mandrel-mounted and want a pocket instead.
//
// The bore is CALIBRATED: the gauge was printed and the shanks go into its 2.7
// hole, so BIT_BORE is 2.70 and BIT_CLR derives from it. The HARDELL and the
// small engraver take the same bits, so both tools share this number.
include <rotary_station_common.scad>
syringe_rack(1, 1, BIT_COLS, BIT_ROWS, BIT_SHANK, BIT_CAPTURE, clr = BIT_CLR);
