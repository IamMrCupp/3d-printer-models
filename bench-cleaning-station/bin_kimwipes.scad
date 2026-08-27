// bin_kimwipes — 3×3 tray for the Kimtech Kimwipes pop-up cube.
//
// HOW YOU USE IT:
//   The box drops in and stands proud. It dispenses from the TOP, so the tray
//   only has to stop it sliding around and being knocked over — it does not need
//   to swallow the box, and swallowing it would bury the pop-up.
//
// WHY IT IS SHALLOW. Capture is 25 mm, which holds the base and leaves the whole
// dispensing face clear. The box's HEIGHT has never been measured and does not
// need to be: anything taller than 25 mm simply stands further proud. That is
// the one dimension this part is deliberately independent of.
//
// ⚠️ WALLS ARE 1.0, NOT THE USUAL 1.2, AND THAT IS THE WHOLE DESIGN PROBLEM.
//
// The box is 119.60 × 122.86 (measured 2026-07-27). A 3×3 is 125.5 across, so at
// the normal 1.2 wall the interior is 123.10 and the long side clears by
// **0.24 mm** — that is not a fit, it is a coincidence. Dropping to 1.0 gives
// 123.50 and 0.64 mm, which a cardboard box will actually go into.
//
// If it still binds, the answer is a 3×4 (165.10 interior, 42 mm of slack) and
// not thinner walls. -D NY=4 does it without editing anything.
//
// ⚠️ THIS BOX ALSO SITS ON `scope-baseplate/scope_wipe_plate.scad`, which was
// built as a platform for it. That is a BASEPLATE — no walls — which is why the
// box fits there and only just fits here. Do not "fix" this by copying that
// part's clearances.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

/* [Box] */
BOX_L = 119.60;   // measured 2026-07-27
BOX_W = 122.86;   // measured — the tight axis

/* [Tray] */
NX = 3; NY = 3;
DEPTH = 25;       // [12:1:60] capture. Box height is irrelevant — see header.
WALL  = 1.0;      // [0.8:0.1:2] see the note above before raising this
FLOOR = 1.4;

H  = BIN_BASE_H + FLOOR + DEPTH;
W  = NX*GF - 0.5; D = NY*GF - 0.5;
IW = W - 2*WALL;  ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

assert(IW >= BOX_L + 0.3, str("Box (", BOX_L, ") will not go in ", IW, " mm."));
assert(ID >= BOX_W + 0.3, str("Box (", BOX_W, ") will not go in ", ID,
                              " mm — go to a 3x4 with -D NY=4."));
echo(str("interior ", IW, " x ", ID, "; box ", BOX_L, " x ", BOX_W,
         " -> slack ", IW - BOX_L, " / ", ID - BOX_W, " mm"));

// The pocket is the FULL interior, clipped to the rounded corners. A plain cube
// spanning IW x ID would cut straight through bin_blank's corner radii and open
// all four corners — watertight, right bbox, and not a box. Two bins shipped
// that way. tools/validate_stl.py now fails it.
difference() {
    bin_blank(NX, NY, H);
    intersection() {
        translate([-IW/2, -ID/2, Z0]) cube([IW, ID, DEPTH + 0.1]);
        translate([0, 0, Z0]) linear_extrude(DEPTH + 0.2)
            offset(BIN_R - WALL) offset(-(BIN_R - WALL))
                square([IW, ID], center = true);
    }
}
