// bin_tip_tinner — 1×1 bin for the tip tinner tin.
//
// The tin measures 42.5 across the LID and 38.38 across the BODY. The lid is the
// number that misleads: 42.5 is wider than a 1×1's entire 41.5 mm footprint, so
// sized off it this looked like a 2×2 part. The body is what goes inside.
//
// Stored lid-on. The 10.15 mm body drops in and lands on the floor; the lid sits
// proud where you can grab it. The bin never needs to be as deep as the whole
// 17 mm tin.
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
H_BODY            = 10.15;   // measured — base to where the lid starts

WALL  = 1.0;
// Deliberately just UNDER the 10.15 body height. Deeper and the lid's 42.5 rim
// catches on the bin rim first, leaving the tin hanging with air beneath it and
// free to rock. At 9 the body lands on the floor and the lid sits 1.15 mm proud.
// The lid also overhangs the bin's outer wall by 0.5 mm a side, so there is a
// fingernail's purchase on it regardless of depth.
DEPTH = 9;    // [6:0.5:14]

assert(41.5 - 2*WALL > D_TIP_TINNER_BODY,
       "Tin body is wider than the 1x1 interior — thin the wall or go 2x2.");

assert(DEPTH < H_BODY,
       "Depth exceeds the tin body — it would hang from the lid instead of sitting on the floor.");

bin(1, 1, BIN_BASE_H + 1.4 + DEPTH, wall = WALL);
