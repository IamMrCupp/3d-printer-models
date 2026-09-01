// bin_adhesive_foam — 2×1 split down its length into two flat-bottomed
// compartments: the adhesive/foam roll in one, the loose strips in the other.
//
// TWO COMPARTMENTS, NO SHAPING. Earlier cuts tried to cradle the roll in a saddle
// matched to its radius. It is not needed: the roll is ⌀92 against a 79.1 mm
// compartment, so it never reaches the floor — it stands in the slot and rests
// across the end rims. What holds it upright is the SLOT WIDTH pinching its
// faces, and a flat floor does that as well as a curved one.
//
// ⚠️ THE ROLL BRIDGES, IT DOES NOT SIT IN. 92 is wider than the 79.1 mm interior
// length, so the roll spans the compartment resting on the two end walls and
// stands proud. That is the same arrangement as a tape dispenser and it is the
// only one a 2×1 allows — ⌀92 cannot be contained by this footprint in any
// orientation. If you want it fully enclosed it needs a 3×3.
//
// WHAT THE THREE EARLIER CUTS GOT WRONG, since the reasoning is worth keeping:
//   3×2   the trough spanned the bin's FULL DEPTH, handing 81 mm of it to a roll
//         about 9 mm thick. That is what made the part enormous.
//   2×1a  then ⌀92 was assumed to need CONTAINING, judged impossible, and the
//         trough shrunk to ⌀50 — which fits no roll at all.
//   2×1b  a full-depth saddle cradled it against rolling but left a thin disc
//         free to lean, and it did.
// All three came from treating a roll as something to swallow rather than to
// stand up.
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
// roll is the same DIAMETER. Recorded because it is what rules out containing
// the roll; nothing in the geometry below is cut from it.
ROLL_D = 92.0;

/* [Bin] */
NX = 2; NY = 1;
H     = 25.0;    // [12:0.5:60] deep enough for the strips; the roll bridges
WALL  = 1.2;
FLOOR = 1.4;
DIV   = 1.2;     // [1.2:0.1:3] wall between the two compartments

W = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;  ID = D - 2*WALL;
BAY = (ID - DIV)/2;

assert(H > BIN_BASE_H + FLOOR + 6, "Too shallow to hold anything.");
echo(str("bin ", W, " x ", D, " x ", H, "; two bays ", IW, " x ", BAY,
         ", floor to rim ", H - BIN_BASE_H - FLOOR,
         "; the ⌀", ROLL_D, " roll bridges the ", IW, " length"));

divided_bin(NX, NY, H, cols = 1, rows = 2, wall = WALL, floor = FLOOR, div = DIV);
