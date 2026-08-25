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
// 🛑 ATTRIBUTION DISPUTED 2026-08-25 — DO NOT BUILD A SECOND CUP ON THESE.
//
// TOOL_D / TOOL_L are labelled HARDELL and were recorded before the small
// engraver was bought, which argues they really are the HARDELL's. But the
// engraver now reads ~20 mm across and the HARDELL is reported to be BIGGER,
// and 19.66 vs 20 is a 0.34 mm gap — those cannot all hold.
//
// So one of two things is true and nobody knows which: either 19.66 is the
// ENGRAVER's diameter mis-labelled as the HARDELL's, or the HARDELL is not in
// fact bigger. `bin_tool` is bored to 19.66 and may therefore be cut for the
// wrong tool.
//
// Resolving it needs both tools on calipers in ONE pass, together, with a note
// saying which reading is which. Until then this number stays put — changing it
// on a guess would just move the error rather than fix it — and no cup gets
// built for the other tool.
//
// The bit bore below is NOT affected: bits are bits, and both tools were
// confirmed to take the same ones.
TOOL_D   = 19.66;    // ⚠️ body diameter — see the attribution note above
TOOL_L   = 131.36;   // ⚠️ overall length — same caveat
BIT_SHANK = 2.381;   // 3/32" collet — 0.09375 × 25.4

TOOL_CAPTURE = 45;   // ≈ a third of TOOL_L
CORD_W       = 6;    // side channel for the barrel-jack lead

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

// ⚠️ 70 IS STILL AN UPPER BOUND, NOT A COUNT. Confirmed 2026-08-25 that the
// HARDELL kit is mixed: extra bits, grinding wheels, cut-off wheels and sanders.
// The wheels come on mandrels and do not want a shank hole at all — the largest
// cut-off wheel is 25 mm across and needs somewhere flat, not a bore.
//
// So this grid is oversized by an unknown amount. Drop BIT_COLS/BIT_ROWS once
// the shank-mounted pieces are counted; the engraver's block was 70 → 35 on
// exactly that correction.
BIT_COLS = 14; BIT_ROWS = 5;
BIT_CAPTURE = 18;   // bits are light; 18 mm keeps the block low under the hood
