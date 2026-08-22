// bin_tip_tinner — 2×2 cup for the tip tinner tin, lid on.
//
// 42.5 mm tin + 1.0 clearance = a 43.5 bore, and that will not fit a 1×1 (41.5)
// or a 2×1 — a 2×1's short interior is 41.5 as well. So a single tin costs a
// 2×2, with 20 mm of wall all round it.
//
// If the rosin tin turns out similar, a 3×2 holding BOTH is the better part:
// two 43.5 bores need 105 mm, which a 3×2's 125.5 takes comfortably. Measure the
// rosin before committing to this solo cup.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/vessel.scad>

D_TIP_TINNER = 42.50;   // measured 2026-08-20, lid on
H_TIP_TINNER = 17.00;   // measured, lid on
CAPTURE      = 10;      // [6:1:16] leaves ~7 mm proud to pinch

collar_cup(2, 2, D_TIP_TINNER, CAPTURE);
