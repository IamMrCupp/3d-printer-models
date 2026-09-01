// bin_adhesive_foam — 3×2 bin for the adhesive and foam consumables from the
// phone-repair kit: one roll, cradled, plus a bay for the loose strips.
//
// THE ROLL SETS THE WHOLE LAYOUT, AND IT ONLY FITS ONE WAY. At ⌀92 it cannot lie
// flat in a 3×2: the interior is 123.1 × 81.1, so 92 clears the long axis and
// misses the short one by 11 mm. It has to sit like a wheel — axis across the
// short side, diameter along the long side. Everything else follows from that.
//
// WHY A CRADLE AND NOT A FLAT FLOOR. Foam is soft. Stood on a flat floor a roll
// carries its whole weight on one line and takes a flat spot. A trough cut to the
// roll's own diameter spreads that over the full arc, which is what "support the
// rolls" has to mean for foam.
//
// WHY NOT A SPINDLE. A spindle is the better holder for a roll, but a spindle is
// sized from the CORE, and the core has never been measured. A trough needs only
// the outside diameter, which is known. See `survey/TO-MEASURE.md` — if the core
// ever gets measured this can become a spindle without moving anything else.
//
// ⚠️ THE STRIP BAY IS DELIBERATELY UNSIZED. The strips have never been measured,
// and a slot cut to a guess is worse than no slot: too narrow and they will not
// go in, and no mesh check catches that. The bay is simply the interior that the
// roll does not use — 27.1 × 81.1, full depth. Same reasoning as the engraver
// accessory bin's open bay for the collet wrench.
//
// HEIGHT PUTS THE RIM AT THE ROLL'S EQUATOR. Contained any deeper and the roll is
// hard to pinch out; any shallower and the trough stops holding it sideways. At
// the equator the cradle does its most work and the top half stands proud to
// grab, which is how bin_stencil_bucket is set up for the same reason.
//
// PRINT: as emitted, feet down. No supports — the trough's surface faces UP and
// inward, so nothing in it overhangs.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Contents] */
// ✅ "about the same diameter as the kapton tape rolls" (user, 2026-09-01), and
// the Kapton reel is on record at ≈92 (survey/MEASUREMENTS.md). Not calipered —
// but a cradle is forgiving in a way a spindle or a slot is not: 2 mm of
// clearance either way changes nothing about whether the roll sits in it.
ROLL_D   = 92.0;   // [40:1:120]
ROLL_CLR = 2.0;    // [0:0.5:6] trough is this much over the roll

/* [Bin] */
NX = 3; NY = 2;
WALL  = 1.2;
FLOOR = 2.0;       // thicker than the usual 1.4 because the trough sinks into it
SINK  = 0.6;       // how far the trough dips below the interior floor
DIV   = 2.0;       // [1.2:0.1:4] wall between the trough and the strip bay

W  = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;   ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

TROUGH_D = ROLL_D + ROLL_CLR;
// THE TROUGH SINKS 0.6 INTO THE FLOOR ON PURPOSE. Sitting it exactly on Z0 makes
// the cylinder TANGENT to the floor plane — they touch along one line instead of
// crossing — and that returns non-manifold edges plus a zero-length sliver. A cut
// has to pass THROUGH a surface, not graze it. FLOOR is 2.0 so 1.4 of floor is
// still left under the trough, the usual thickness.
TROUGH_Z = Z0 + TROUGH_D/2 - SINK;   // trough axis
BIN_H    = TROUGH_Z;                 // rim lands on the roll's equator
// THE TROUGH IS INSET 1 mm FROM THE LEFT WALL, NOT HARD AGAINST IT. Flush, the
// cylinder is TANGENT to that wall — they touch along a line rather than
// crossing — and that returned 3 non-manifold edges at x -61.55, all of them on
// that seam. Same rule as the floor: a cut must cross a surface, not graze it.
// The 1 mm costs nothing; it just leaves a sliver of flat wall beside the roll.
TROUGH_INSET = 1.0;
TROUGH_X = -IW/2 + TROUGH_INSET + TROUGH_D/2;
BAY_X0   = TROUGH_X + TROUGH_D/2 + DIV;
BAY_W    = IW/2 - BAY_X0;

assert(TROUGH_D <= IW, "Roll is wider than the interior — needs a 4-wide bin.");
assert(BAY_W >= 12, "No usable strip bay left. Widen the bin or shrink the roll.");
echo(str("bin ", W, " x ", D, " x ", BIN_H, "; trough ⌀", TROUGH_D,
         " for a ⌀", ROLL_D, " roll; strip bay ", BAY_W, " x ", ID));

// Everything cut inside the bin is clipped to the ROUNDED interior. A plain
// rectangular cut spans the full interior and runs straight through bin_blank's
// corner radii, which opens all four corners — that shipped twice on this repo
// and both parts were watertight, manifold and CI-green the whole time.
module _interior(h) {
    translate([0, 0, Z0 - SINK - 0.1]) linear_extrude(h + SINK + 0.3)
        offset(BIN_R - WALL) offset(-(BIN_R - WALL))
            square([IW, ID], center = true);
}

difference() {
    bin_blank(NX, NY, BIN_H);
    intersection() {
        union() {
            // the roll's cradle — axis across the short side
            translate([TROUGH_X, ID/2 + 0.1, TROUGH_Z])
                rotate([90, 0, 0])
                    cylinder(d = TROUGH_D, h = ID + 0.2, $fn = 160);
            // strip bay — the interior the roll does not use, full depth
            translate([BAY_X0, -ID/2, Z0])
                cube([BAY_W, ID, BIN_H - Z0 + 0.1]);
        }
        _interior(BIN_H - Z0);
    }
}
