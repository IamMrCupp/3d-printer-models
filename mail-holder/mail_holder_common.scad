// mail_holder_common — a flat tray for oversized mail, sitting on the shelf below
// the mail slot, with OVERSIZED MAIL on its floor so the carrier stops stuffing
// big envelopes through the slot.
//
// SIZE (user, 2026-10-25/26): 265 × 200 footprint, 38 tall (1.5 in). 265 is the
// long side the user chose; the short side is what leaves room on the 270 bed for
// the prime tower a two-colour print needs. Mail lies flat;
// a 9 × 12 envelope (229 × 305) overhangs the long side a little, as in any tray.
//
// THE LABEL IS ON THE FLOOR, read from above, as a FLUSH TWO-COLOUR INLAY
// (lib/label.scad): a 0.8 mm pocket in the floor's top face, filled by
// mail_holder_inlay in the second colour. On the floor the colour change is only
// the floor's top layers — the cheap kind of two-colour print. Load both STLs at
// the same origin in the slicer and give each a colour; print the body alone for
// a one-colour engraved label.
//
// DRAIN HOLES in the corners: it sits below an outside slot, so rain can get in.
//
// PRINT: floor down, as emitted. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp

include <../lib/label.scad>

W = 265;        // long side
D = 200;        // short side — was 215 in v1.0.0, which left no room on the
                //   270 bed for the prime tower a two-colour print needs (user,
                //   2026-10-26: auto-arrange pushed the tray off the plate). 200
                //   leaves a 70 mm strip: ~30 tower + 5 brim each side + spacing.
PRIME_STRIP = 70;   // what the bed must still have beside the tray
H = 38;         // tall: 1.5 in (user, 2026-10-25)
WALL  = 2.4;
FLOOR = 2.4;    // carries the 0.8 mm label pocket
R     = 6;      // vertical corner radius
DRAIN_D = 6;
DRAIN_IN = 18;  // drain holes this far in from each corner, clear of the label

LINES     = ["OVERSIZED", "MAIL"];
TXT_SIZE  = 26;
LINE_GAP  = 14;  // between the two lines

assert(W <= 270 && D <= 270, "Footprint over the U1's 270 × 270 bed.");
assert(270 - D >= PRIME_STRIP, "No room left beside the tray for a two-colour prime tower.");
assert(FLOOR > LABEL_T + 1.2, "Floor too thin under the label pocket.");

$fn = 48;

module _outline_2d() { offset(r = R) offset(delta = -R) square([W, D], center = true); }

module _labels(inlay) {
    for (i = [0:len(LINES)-1])
        translate([0, (len(LINES)-1)/2 * (TXT_SIZE + LINE_GAP) - i * (TXT_SIZE + LINE_GAP), FLOOR])
            if (inlay) label_inlay(LINES[i], TXT_SIZE); else label_pocket(LINES[i], TXT_SIZE);
}

module mail_holder() {
    difference() {
        linear_extrude(H) _outline_2d();
        translate([0, 0, FLOOR]) linear_extrude(H) offset(delta = -WALL) _outline_2d();
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*(W/2 - DRAIN_IN), sy*(D/2 - DRAIN_IN), -1]) cylinder(d = DRAIN_D, h = FLOOR + 2);
        _labels(false);
    }
}

module mail_holder_inlay() { _labels(true); }
