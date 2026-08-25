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
//
// ✅ ATTRIBUTION RESOLVED 2026-08-25. The HARDELL measures **28 mm at the base,
// tapering to ≈30** at its widest. The 19.66 / 131.36 that sat here for months
// were never this tool — they belong to the small engraver, and moved to
// `../engraver-station/engraver_common.scad` along with the cup bored to them.
//
// That cup was watertight, manifold, and exactly the size it claimed to be. It
// simply would not have taken the tool named on it. Nothing in the toolchain
// can catch a right-shaped part cut for the wrong object.
//
// ⚠️ IT IS A TAPER, NOT A CYLINDER. Bore to the WIDEST section that enters —
// 30, not 28 — or the tool jams partway down.
BIT_SHANK   = 2.381;  // 3/32" collet — 0.09375 × 25.4. Nominal only; the bore
                      //   comes from the gauge, not from this. See BIT_BORE.
TOOL_D_BASE = 28.0;   // narrow end of the base
TOOL_D      = 30.0;   // ⚠️ widest — this is what the bore is sized from
TOOL_L      = undef;  // ❌ NOT MEASURED. Only ever fed TOOL_CAPTURE, and capture
                      //   is a comfort choice, not a fit constraint — the bin
                      //   latches into the grid so nothing tips. Not a blocker.

TOOL_CAPTURE = 45;   // [20:1:80] judgement, NOT derived — TOOL_L is unknown.
                     //   45 holds plenty and leaves the tool easy to pinch out.
                     //   Override with -D TOOL_CAPTURE= once you've held one.
// ⚠️ CORD_W IS INHERITED AND UNVERIFIED FOR THIS TOOL. The 6 mm barrel-jack
// slot was measured on the engraver, back when the two tools were conflated.
// A slot too narrow stops the tool seating, so check the HARDELL's lead before
// printing — or widen it, since an oversized notch costs nothing.
CORD_W       = 6;

// ---- bit-hole clearance ----
// lib/vessel.scad's CLR = 1.0 mm is tuned for 50–80 mm vessels, where it's ~2%
// of the diameter. On a 2.381 mm shank the SAME 1.0 mm is 42% — the bits would
// rattle. Absolute clearance does not scale down; small bores need their own
// number.
//
// ✅ CALIBRATED 2026-08-25. `coupons/bit_fit_gauge.scad` was printed and the
// shanks go into the **2.7** hole; 2.6 does not take them. The HARDELL's bits
// and the small engraver's were confirmed the same size, so both tools share
// this bore — see `../engraver-station/engraver_common.scad`.
//
// BIT_BORE is the measurement and BIT_CLR is arithmetic, not the other way
// round. The gauge reads the FINISHED HOLE, which folds the shank diameter and
// this printer's hole shrinkage into one number — the only number a drilled
// block needs.
//
// The old BIT_CLR = 0.25 guess was TOO TIGHT: it cut 2.631, under the smallest
// hole that actually takes a shank. Every one of these holes would have needed
// reaming, which is precisely what the coupon exists to prevent.
//
// Re-run the coupon if the nozzle, filament or layer height changes.
BIT_BORE = 2.70;                    // gauge result — the finished hole
BIT_CLR  = BIT_BORE - BIT_SHANK;    // = 0.319


// An earlier edit to this file deleted BIT_SHANK by accident. `bin_tool` then
// rendered a perfectly valid STL from an undefined constant — OpenSCAD only
// WARNS — and it was the assert inside syringe_rack() that stopped the bit
// block. These asserts exist because a warning scrolls past and a broken part
// does not announce itself.
assert(is_num(BIT_SHANK) && BIT_SHANK > 0, "BIT_SHANK is undefined or non-positive.");
assert(is_num(BIT_BORE) && BIT_BORE > BIT_SHANK,
       "BIT_BORE must be a number larger than BIT_SHANK — it is the FINISHED hole.");
assert(is_num(TOOL_D) && TOOL_D >= TOOL_D_BASE,
       "TOOL_D must be a number, and the WIDEST section of the taper.");
// ✅ COUNTED 2026-08-25: the HARDELL came with about **15 shank bits**, a stack
// of cut-off wheels and ~20 sanding disks.
//
// The old 14 × 5 = 70 was an upper bound taken from a 69-piece set on the
// assumption every piece was shank-mounted. It isn't, and the block was
// oversized by more than 4×. The wheels and disks are mandrel-mounted and want
// a pocket, not a bore — the largest cut-off wheel is 25 mm across.
//
// 5 × 3 = 15 on a 1×1 at an 8.4 × 14 pitch. The engraver's block took exactly
// this correction, 70 → 35, for exactly this reason.
BIT_COLS = 5; BIT_ROWS = 3;
BIT_CAPTURE = 18;   // bits are light; 18 mm keeps the block low under the hood
