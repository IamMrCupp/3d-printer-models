// rotary_station_common.scad — HARDELL mini rotary tool + its accessories.
//
// The tool stands VERTICAL in a 1×1 cup rather than lying in a 4×1 trough. A cup
// captures the bottom ~45 mm and lets the remaining ~86 mm stick up, the way a
// pen sits in a pen cup — 4× less bench for the same tool.
//
// It's corded (barrel jack), so the cup carries a side channel open to the rim.
// Without one the lead drapes over the edge and levers the tool sideways.
// Store it COLLET-DOWN: a pointed burr at hand height on a bench you reach
// across is a snag you only notice once.

include <../lib/vessel.scad>
include <../lib/syringe.scad>

// ---- measured ----
TOOL_D   = 19.66;    // body diameter
TOOL_L   = 131.36;   // overall length (for reference; the cup captures a third)
BIT_SHANK = 2.381;   // 3/32" collet — 0.09375 × 25.4

TOOL_CAPTURE = 45;   // ≈ a third of TOOL_L
CORD_W       = 6;    // side channel for the barrel-jack lead

// ---- bit-hole clearance ----
// lib/vessel.scad's CLR = 1.0 mm is tuned for 50–80 mm vessels, where it's ~2%
// of the diameter. On a 2.381 mm shank the SAME 1.0 mm is 42% — the bits would
// rattle. Absolute clearance does not scale down; small bores need their own
// number.
//
// ✅ CALIBRATED 2026-08-25 by `coupons/bit_fit_gauge.scad`. The gauge's five
// holes ran 2.5 / 2.6 / 2.7 / 2.8 / 2.9 and the bits go into the **2.7**. So the
// finished bore this printer needs is 2.70, and BIT_CLR is derived from it
// rather than set by feel — the gauge reading is the measurement, the clearance
// is arithmetic.
//
// 2.6 does NOT take them, so the true figure sits between 2.6 and 2.7 and 2.70
// is the smallest that works. The old 0.25 guess would have cut 2.631 — under
// the smallest hole that fits, i.e. 70 holes that all needed reaming.
//
// This is why the coupon exists. Small vertical holes come off an FDM printer
// undersize (inner-perimeter over-extrusion) by an amount specific to the
// printer, nozzle and filament, so the useful number is the FINISHED HOLE and
// calipers on a bit only give you half of it.
//
// Re-run the gauge if the nozzle, filament or layer height changes.
BIT_BORE = 2.70;                    // gauge result — the hole that takes a shank
BIT_CLR  = BIT_BORE - BIT_SHANK;    // = 0.319

// ✅ COUNTED 2026-08-25: **35 bits** actually take this grinder's 3/32" shank.
// The old 14 × 5 = 70 was an upper bound taken from the 69-piece accessory set,
// on the assumption every piece was shank-mounted. It isn't — cut-off discs and
// drums come on mandrels, and the micro drill bits have their own shanks.
//
// 7 × 5 = 35 at the SAME 6.0 × 8.4 pitch, so the block halves from a 2×1 to a
// 1×1 and gives a cell back. Nothing about the holes changes.
BIT_COLS = 7; BIT_ROWS = 5;
BIT_CAPTURE = 18;   // bits are light; 18 mm keeps the block low under the hood
