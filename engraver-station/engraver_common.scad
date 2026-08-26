// engraver_common — shared numbers for the SMALL ENGRAVER rotary tool.
//
// THIS IS NOT THE HARDELL. `rotary-tool-station/` is HARDELL-only and none of
// its body numbers transfer — different tool, different diameter, different
// length, different bit count. The two were briefly conflated and the engraver's
// gauge result was very nearly written into the HARDELL's bit block, which would
// have recalibrated a part nobody had measured for.
//
// ---- KNOWN ----
//
// BIT_BORE is the one number that matters here, and it is a MEASUREMENT, not a
// derivation. `rotary-tool-station/coupons/bit_fit_gauge.scad` was printed
// 2026-08-25 — five holes, 2.5 / 2.6 / 2.7 / 2.8 / 2.9, each engraved — and the
// engraver's bits go into the **2.7**. The 2.6 does not take them.
//
// WHY THAT UNBLOCKS THE BIT BLOCK WITHOUT KNOWING THE COLLET SIZE. The gauge
// reads the FINISHED HOLE, which folds the shank diameter and this printer's
// hole shrinkage into a single number. That is the only number a drilled block
// needs. Calipers on a bit would give half of it and still leave the shrinkage
// unknown, which is exactly why the coupon exists. So the collet's nominal size
// stays unmeasured and stays irrelevant *to this part* — it is still needed
// before any tool cup gets built.
BIT_BORE  = 2.70;   // [2:0.05:5] ✅ gauge result 2026-08-25 — the finished hole
BIT_COUNT = 35;     // ✅ counted 2026-08-25
BIT_COLS  = 7;      // [3:1:14] 7 × 5 = 35 on a 1×1
BIT_ROWS  = 5;      // [2:1:8]
BIT_CAPTURE = 18;   // [8:1:40] bits are light; 18 keeps the block low

// ---- NOT KNOWN — the tool cup is blocked on these ----
//
//   body ⌀ at its widest    — sets the cup bore
//   overall length          — TOOL_CAPTURE is about a third of it
//   corded? lead ⌀          — the HARDELL's CORD_W = 6 is a barrel jack; no cord
//                             means no slot at all, and a different lead means a
//                             different slot
//
// Do NOT borrow the HARDELL's 19.66 / 131.36 to fill these in. That is the
// mistake this file exists to prevent.

// ---- body, re-attributed from rotary-tool-station 2026-08-25 ----
//
// These two were recorded as the HARDELL's for months. The HARDELL measures
// 28 mm at the base tapering to ≈30, so 19.66 cannot be it — and it matches the
// ~20 mm this tool reads across to within 0.34 mm. `bin_tool.scad` moved here
// with them, as `bin_tool_engraver.scad`.
TOOL_D   = 19.66;   // body diameter — ✅ re-attributed, corroborated by "20 across"
TOOL_L   = 131.36;  // ⚠️ overall length — re-attributed on the SAME reasoning
                    //   (recorded beside the 19.66 in one session), which is
                    //   inference rather than a reading. Put a tape on the
                    //   engraver end to end: ≈131 settles it.
TOOL_CAPTURE = 45;  // [20:1:80] ≈ a third of TOOL_L
CORD_W       = 0;   // no slot — it charges from the base, not a lead
