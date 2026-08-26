// tray_remotes — 4×2 tray, two rows of three, one sized slot per remote,
// each standing on end.
//
// HOW YOU USE IT:
//   Each remote stands upright in its own slot, cut to that remote's width and
//   thickness. You grab the one you want by the top and lift it straight out.
//   Nothing has to be moved to reach anything else, and a remote can only go back
//   in its own slot. Every remote stands 40 mm or more proud of the tray, so the
//   back row is grabbed over the front row, not dug out from behind it.
//
// WHY SLOTS AND NOT ONE BIN: six remotes in a common well fall over each other
// and you dig. The narrowest here is 8 mm thick and the widest 35 — in a shared
// well the thin ones just lie down.
//
// WHY TWO ROWS, AND WHY THE 6×1 IS GONE. There are TWO Roku remotes, not one.
// Six remotes are 268 mm of width; with clearance and 3 mm dividers that is
// 289 mm of slot. A 6×1 has 249.1 mm of interior — short by 40. The width that
// would hold them is a 7×1 at 293.5 mm outer, which is past the 270 bed. So the
// row folds in half: 4×2, three slots front, three back.
//
// That also buys back the dividers. The 6×1 ran DIV = 2 because at 3 it needed
// 249.0 against 249.1 available, which is not a fit, it is a coincidence. The
// 4×2's widest row needs 152 of 165.1, so the dividers go to the usual 3 mm and
// stop being the thing holding the design together.
//
// ROWS ARE SPLIT BY THICKNESS, not by which remote you use most. Each row is
// only as deep as its own thickest member, so putting the 35 mm LG and the 8 mm
// fume extractor in the same row costs nothing, while spreading the thick ones
// across both rows would make both rows 36 mm deep and blow the Y budget.
//
// SLOTS ARE FRONT-ALIGNED WITHIN A ROW. The faces present at one line, so each
// row reads as a row. Back-aligning would stagger the fronts and bury the thin
// ones.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

CLR    = 1.0;   // [0.5:0.1:2] per dimension, on both width and thickness

// ⚠️ BUTTON_BULGE IS AN ALLOWANCE, NOT A MEASUREMENT.
//
// The Insignia jammed on its own buttons the moment it entered the slot. 20 mm
// is the thickness of the BODY; the feature that actually has to pass through
// the slot is the button crown, which stands proud of it and was never measured.
// This is the tip-tinner bug again — the 42.5 mm lid was measured where the
// 38.38 mm body was the thing that had to fit.
//
// 3.0 is a guess at a rubber-button crown, giving 4.0 mm of total thickness
// clearance where the body alone would get 1.0. If it still catches, the fix is
// NOT to raise this further by feel: put calipers across the remote AT THE
// BUTTONS and make that the thickness in the table.
BUTTON_BULGE = 3.0;   // [0:0.5:6]

// [name, width, thickness, extra thickness allowance]
// Widths and thicknesses measured 2026-08-20. Lengths run 90 to ~180 mm.
ROWS = [
    // back row — depth set by the 35 mm LG
    [["LG 4K TV",    45, 35, 0],
     ["Insignia TV", 50, 20, BUTTON_BULGE],
     ["Fume ext",    48,  8, 0]],
    // front row — depth set by the Rokus
    [["Roku",        42, 21, 0],
     ["Roku",        42, 21, 0],
     ["Scope cam",   41, 10, 0]],
];

NX = 4; NY = 2;
CAPTURE = 50;   // [30:1:80] slot depth, and a compromise between two ends of the
                //   range. The shortest remote is 90, so 50 holds over half of it
                //   and still leaves 40 to grab; go deeper and the short ones get
                //   hard to pinch out. The longest is ~180 and stands 130 proud —
                //   fine, because the slot grips its full width and thickness like
                //   a book in a shelf. A round bore could not do that.
DIV    = 3.0;   // [1.6:0.2:5] wall between slots in a row
ROWDIV = 3.0;   // [1.6:0.2:5] wall between the two rows
WALL   = 1.2;
FLOOR  = 1.4;

W = NX*GF - 0.5; D = NY*GF - 0.5;
IW = W - 2*WALL; ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;
H  = Z0 + CAPTURE;

function sum_upto(v, i) = i <= 0 ? 0 : v[i-1] + sum_upto(v, i-1);
function lmax(v, i)     = i >= len(v) ? 0 : max(v[i], lmax(v, i+1));

// slot footprint: X is the remote's width, Y its thickness plus any allowance
function slot_w(r) = r[1] + CLR;
function slot_d(r) = r[2] + CLR + r[3];

ROW_PITCH = [for (row = ROWS) [for (r = row) slot_w(r) + DIV]];
ROW_NEED  = [for (row = ROWS)
                sum_upto([for (r = row) slot_w(r)], len(row)) + DIV*(len(row) - 1)];
ROW_DEPTH = [for (row = ROWS) lmax([for (r = row) slot_d(r)], 0)];

Y_NEED   = sum_upto(ROW_DEPTH, len(ROWS)) + ROWDIV*(len(ROWS) - 1);
Y_MARGIN = (ID - Y_NEED) / 2;

for (i = [0 : len(ROWS) - 1])
    assert((IW - ROW_NEED[i])/2 >= 2,
           str("Row ", i, " needs ", ROW_NEED[i], " of ", IW,
               " — widen the tray or thin DIV."));
assert(Y_MARGIN >= 2, str("Rows need ", Y_NEED, " of ", ID,
                          " — only ", Y_MARGIN, " mm front and back."));
echo(str("rows need ", ROW_NEED, " of ", IW, " wide; ", Y_NEED, " of ", ID,
         " deep (", Y_MARGIN, " mm margin front and back)"));

difference() {
    bin_blank(NX, NY, H);
    for (ri = [0 : len(ROWS) - 1]) {
        row  = ROWS[ri];
        // front edge of this row, measured from the front of the interior
        y0   = -ID/2 + Y_MARGIN + sum_upto(ROW_DEPTH, ri) + ri*ROWDIV;
        marg = (IW - ROW_NEED[ri]) / 2;
        for (i = [0 : len(row) - 1])
            translate([-IW/2 + marg + sum_upto(ROW_PITCH[ri], i), y0, Z0])
                cube([slot_w(row[i]), slot_d(row[i]), CAPTURE + 0.1]);
    }
}
