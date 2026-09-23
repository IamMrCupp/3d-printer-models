// bin_adhesive_foam — 3×1 × 58, split down its length into two flat-bottomed
// bays: the adhesive/foam roll in one, the loose strips in the other. The same
// footprint and height as the cleanroom-wipes bin, so the two sit as a pair.
//
// THE ROLL SITS IN NOW. The 2×1 (v1.0.0) had the ⌀92 roll BRIDGING an 81.1 mm
// bay — resting across the two end rims, never touching the floor — and on the
// bench it did not stand up well: a thin disc balanced on two rim edges rocks.
// A 3×1 bay is 123.1 long, so the whole roll drops to the floor with 15 mm of
// run either side, and the 18.95 mm slot width is what keeps it upright, as
// before. 58 tall puts the rim ~40 mm below the roll's top, which is the grab.
//
// TWO COMPARTMENTS, NO SHAPING. A saddle at the roll's radius was tried in an
// earlier cut and left a thin disc free to lean; it is the slot width that
// holds it, and a flat floor does that as well as a curved one.
//
// WHAT THE EARLIER CUTS GOT WRONG, since the reasoning is worth keeping:
//   3×2   the trough spanned the bin's FULL DEPTH, handing 81 mm of it to a roll
//         about 9 mm thick. That is what made the part enormous.
//   2×1a  then ⌀92 was assumed to need CONTAINING, judged impossible, and the
//         trough shrunk to ⌀50 — which fits no roll at all.
//   2×1b  a full-depth saddle cradled it against rolling but left a thin disc
//         free to lean, and it did.
//   2×1c  (v1.0.0) flat bays, roll bridging the end rims — stood up, badly.
//
// The divider sits at the midline, so no unmeasured dimension is involved: half
// the bin each. Roll thickness and strip size never enter it.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Contents] */
// ✅ MEASURED — Kapton reel outer ⌀, 2026-08-20 (core 78.5, outer ≈92). The foam
// roll is the same DIAMETER. Nothing below is cut from it; the assert only
// proves the bay is long enough for the roll to reach the floor.
ROLL_D = 92.0;

/* [Bin] */
NX = 3; NY = 1;  // matches bin_cleanroom_wipes
H     = 58.0;    // [12:0.5:70] matches bin_cleanroom_wipes; roll top ~40 above the rim
WALL  = 1.2;
FLOOR = 1.4;
DIV   = 1.2;     // [1.2:0.1:3] wall between the two compartments

W = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;  ID = D - 2*WALL;
BAY = (ID - DIV)/2;

assert(H > BIN_BASE_H + FLOOR + 6, "Too shallow to hold anything.");
assert(IW > ROLL_D + 10, "Bay too short for the roll to sit on the floor with any run.");
echo(str("bin ", W, " x ", D, " x ", H, "; two bays ", IW, " x ", BAY,
         ", floor to rim ", H - BIN_BASE_H - FLOOR,
         "; the ⌀", ROLL_D, " roll sits on the floor with ", (IW - ROLL_D)/2, " mm of run each way, top ",
         BIN_BASE_H + FLOOR + ROLL_D - H, " above the rim"));

divided_bin(NX, NY, H, cols = 1, rows = 2, wall = WALL, floor = FLOOR, div = DIV);
