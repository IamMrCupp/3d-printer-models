// bin_tip_tinner — 1×1 bin for the tip tinner tin.
//
// The tin measures 42.5 across the LID and 38.38 across the BODY. The lid is the
// number that misleads: 42.5 is wider than a 1×1's entire 41.5 mm footprint, so
// sized off it this looked like a 2×2 part. The body is what goes inside.
//
// Stored lid-on, the body drops in and the lid's rim rests on the bin's rim, so
// the tin sits slightly proud and lifts out by the lid. That also means the
// bin only has to be deep enough for the body, not the whole 17 mm tin.
//
// Wall is 1.0 rather than the usual 1.2: at 1.2 the interior is 39.1 against a
// 38.38 tin, which is 0.36 mm a side — tight enough that a slightly thick-walled
// print would refuse it. 1.0 gives 39.5 and a comfortable drop-in.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/gridfinity.scad>

D_TIP_TINNER_LID  = 42.50;   // measured 2026-08-20 — does NOT set the bin size
D_TIP_TINNER_BODY = 38.38;   // measured — this is the one that matters
H_TIP_TINNER      = 17.00;   // lid on

WALL  = 1.0;
DEPTH = 12;   // [8:1:18] body sits in, lid rides on the rim

assert(41.5 - 2*WALL > D_TIP_TINNER_BODY,
       "Tin body is wider than the 1x1 interior — thin the wall or go 2x2.");

bin(1, 1, BIN_BASE_H + 1.4 + DEPTH, wall = WALL);
