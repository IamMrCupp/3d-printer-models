// bin_bits_engraver — 1×1 block, 7 × 5 grid, 35 holes for the engraver's bits.
//
// THE BORE IS THE MEASUREMENT. The holes are cut to 2.70 because that is the
// hole the bits go into on a printed gauge — not to a nominal shank plus a
// clearance somebody guessed. `clr = 0` here is deliberate and is not "no
// clearance": the clearance is already inside the 2.70, because a finished hole
// reading folds the shank and this printer's hole shrinkage together.
//
// That is also why this part could be built while the engraver's collet size is
// still unmeasured — a drilled block only ever needed the finished hole.
//
// 35 holes for 35 bits, counted. 7 × 5 at a 6.0 × 8.4 pitch fits a 1×1 with
// 3.3 mm of material between bores.
//
// Re-run `../rotary-tool-station/coupons/bit_fit_gauge.scad` and update
// BIT_BORE if the nozzle, filament or layer height changes — the number is a
// property of the printer as much as the tool.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <engraver_common.scad>
include <../lib/gridfinity.scad>
use <../lib/syringe.scad>

assert(BIT_COLS * BIT_ROWS >= BIT_COUNT,
       str(BIT_COLS, " x ", BIT_ROWS, " = ", BIT_COLS*BIT_ROWS,
           " holes for ", BIT_COUNT, " bits."));
echo(str(BIT_COLS*BIT_ROWS, " holes of ", BIT_BORE, " for ", BIT_COUNT, " bits"));

syringe_rack(1, 1, BIT_COLS, BIT_ROWS, BIT_BORE, BIT_CAPTURE, clr = 0);
