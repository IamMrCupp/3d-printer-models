// riser_common.scad — shared dimensions for the bench instrument risers.
//
// ONE part, printed as many times as you need, at two heights. A pedestal that
// stands on Gridfinity feet, so it LATCHES into a Clickfinity desk plate instead
// of skating. Put one under each instrument foot and the instrument's own
// footprint becomes open grid underneath.
//
//   hot air station  4 pedestals @ 6"
//   oscilloscope     2 pedestals @ 2"
//
// WHY A LIP AND NOT A FOOT POCKET
//   The top is a shallow tray — a raised rim all the way round a recessed pad.
//   It captures whatever sits on it sideways without knowing anything about that
//   instrument's feet, so every pedestal stays interchangeable. A pocket or a
//   slot has to be cut where one specific foot lands, which makes the part
//   bespoke and throws that away.
//
//   The one thing to check: the foot must fit INSIDE the pad. A foot wider or
//   longer than the recess perches on the rim instead of sitting in the tray,
//   which is worse than no lip at all. The pad size is echoed at render time.
//
// WHY IT IS HOLLOW
//   It was modelled solid at first, on the theory that infill percentage is the
//   right place to decide how much material a part uses. That does not survive a
//   6" pedestal: a solid 2x2 x 152 mm block is 1043 cm3, and the slicer put
//   85% of a 36-hour four-part job into sparse infill alone — 739 g of it.
//   Walls were 3h40m of that job; infill was over thirty hours.
//
//   So the interior is removed in the model instead. What is left:
//     - the Gridfinity feet, FULLY solid — the latch surfaces are untouched
//     - a perimeter shell
//     - ribs on the cell boundaries, which double as the internal foot walls
//     - a solid cap under the pad
//     - a vent hole per cell through the floor, so no sealed voids
//
//   Storage goes in the open grid BETWEEN the pedestals, which is the point of
//   raising anything — the cavity inside is structural, not usable.
//
// PRINT ORIENTATION: as emitted — feet DOWN, flat top up. Nothing to bridge, no
// supports, and the top face comes out flat as the last thing printed.

include <../lib/gridfinity.scad>

// Standardised across this repo after the OpenSCAD 2026.06.12 tessellation
// gotcha (scattered height/$fn combinations emit non-manifold edges). Do not
// raise this without re-rendering and checking the validator.
$fn = 48;

/* [Footprint] */
GX = 2;   // [1:1:4] cells across
GY = 2;   // [1:1:4] cells deep

/* [Heights] */
// Nominal, from the bench layout — both are "about", not measured constraints,
// so tune them freely. The pedestal height IS the clear height under the
// instrument, measured from the same datum a bin sits on (the desk plate's
// socket floor), so it compares directly against a bin's total height.
//
// Clickfinity's latch GRIPS: a bin comes out by pulling straight up against four
// arms per cell. Budget the bin height PLUS release travel PLUS room to get a
// hand in — sizing to bin height alone builds a shelf whose bins you cannot
// extract. Rule of thumb: usable bin height is roughly RISER_H minus 40.
SCOPE_RISE  =  50.8;  // 2" — fits shallow trays underneath (~10 mm bins)
HOTAIR_RISE = 152.4;  // 6" — takes the tallest bins in the repo with room over

// Either height can be overridden without editing this file:
//   openscad -o r.stl --export-format binstl -D RISER_H=90 riser_pedestal_scope.scad

/* [Retaining lip] */
// A rim around the whole top edge, leaving a shallow recessed pad in the middle.
// Deliberately slight: it only has to stop the instrument walking, and a tall rim
// would foul a chassis that overhangs its own feet.
LIP_W = 2.50;   // [1:0.5:6] rim width, measured inward from the outer edge
LIP_H = 2.00;   // [0:0.5:6] rim height above the pad. 0 = flat top, no lip.

/* [Shell] */
HOLLOW  = true;   // false gives the old solid prism — expect ~9 h for a 6"
SHELL_T = 3.00;   // [2:0.5:6] perimeter wall thickness
RIB_T   = 2.40;   // [1.6:0.2:4] internal rib thickness. Ribs sit on the cell
                  //   boundaries, so they also restore the internal foot walls
                  //   the cavity would otherwise thin out.
CAP_T   = 6.00;   // [4:0.5:12] solid material under the pad. This is what the
                  //   instrument's weight lands on, and what bridges the cavity
                  //   during the print — do not go thin here.
VENT_D  = 10.00;  // [0:1:20] vent hole per cell through the floor. 0 seals the
                  //   cavity, which traps air and reads as a second connected
                  //   component. Leave it on.

/* [Stability] */
// Height-to-width ratio past which a pedestal is tippy while you are placing the
// instrument on it. The Gridfinity foot in a socket resists sideways load well,
// so this is about handling, not about the assembly falling over in use — once
// the instrument is on, its own chassis ties the pedestals together.
MAX_ASPECT = 1.60;  // [1:0.1:2.5]

// ---------------------------------------------------------------------------
// Geometry
// ---------------------------------------------------------------------------

module riser_pedestal(h, gx = GX, gy = GY, lip_w = LIP_W, lip_h = LIP_H) {
    narrow = min(gx, gy) * GF;
    W = gx * GF - 0.5;
    D = gy * GF - 0.5;
    pad_w = W - 2 * lip_w;   // usable pad inside the rim
    pad_d = D - 2 * lip_w;

    assert(h > BIN_BASE_H + lip_h + 2,
           "Riser height barely clears the Gridfinity foot — there is no pedestal left above it.");

    assert(h <= 270 && gx * GF <= 270 && gy * GF <= 270,
           "Pedestal exceeds the U1's 270 mm build volume.");

    // The rim is rounded by offsetting the body outline inward, so it cannot be
    // wider than the corner radius it is being offset from.
    assert(lip_h == 0 || (lip_w > 0 && lip_w < BIN_R),
           str("LIP_W must be between 0 and the corner radius (", BIN_R, ")."));

    assert(lip_h < h - BIN_BASE_H,
           "Lip is taller than the solid material above the feet.");

    // Deliberately echoes rather than asserts: a tall-and-narrow pedestal is a
    // handling nuisance, not a broken part, and the call on whether to widen it
    // depends on foot spacing this file does not know.
    if (h > MAX_ASPECT * narrow)
        echo(str("WARNING: pedestal is ", h / narrow,
                 ":1 tall vs wide (limit ", MAX_ASPECT,
                 "). Widen GX/GY if the instrument's foot spacing allows it."));

    // The number to check a foot against — it has to sit INSIDE this.
    if (lip_h > 0)
        echo(str("PAD (usable area inside the lip): ", pad_w, " x ", pad_d, " mm"));

    difference() {
        union() {
            difference() {
                bin_blank(gx, gy, h);
                if (HOLLOW) _cavity(gx, gy, h);
            }
            if (HOLLOW) _ribs(gx, gy, h);
        }

        // Vent every cell so the cavity is never sealed. A sealed void traps air
        // and reads as a second connected component. The holes sit at cell
        // centres, well clear of the foot walls the latch grabs.
        if (HOLLOW && VENT_D > 0)
            for (ix = [0 : gx - 1], iy = [0 : gy - 1])
                translate([(ix - (gx - 1) / 2) * GF, (iy - (gy - 1) / 2) * GF, -1])
                    cylinder(h = BIN_BASE_H + 2, d = VENT_D);

        if (lip_h > 0)
            translate([0, 0, h - lip_h]) linear_extrude(lip_h + 0.01)
                offset(BIN_R - lip_w) offset(-(BIN_R - lip_w))
                    square([pad_w, pad_d], center = true);
    }
}

// Interior removed from the pedestal. Starts at the TOP of the Gridfinity feet,
// so the feet stay fully solid and every latch surface is untouched.
module _cavity(gx, gy, h) {
    W = gx * GF - 0.5;
    D = gy * GF - 0.5;
    translate([0, 0, BIN_BASE_H]) linear_extrude(h - CAP_T - BIN_BASE_H)
        offset(BIN_R - SHELL_T) offset(-(BIN_R - SHELL_T))
            square([W - 2 * SHELL_T, D - 2 * SHELL_T], center = true);
}

// Ribs on the internal cell boundaries. Two jobs: they carry load up the middle
// of the part, and they put material back exactly where the cavity would have
// thinned the internal foot walls. They also cut the cap's bridge span down to
// one cell, which is what makes the top printable over a hollow.
module _ribs(gx, gy, h) {
    D = gy * GF - 0.5;
    W = gx * GF - 0.5;
    intersection() {
        _cavity(gx, gy, h);
        union() {
            for (i = [1 : max(gx - 1, 0)])
                translate([-gx * GF / 2 + i * GF - RIB_T / 2, -D, 0])
                    cube([RIB_T, 2 * D, h]);
            for (j = [1 : max(gy - 1, 0)])
                translate([-W, -gy * GF / 2 + j * GF - RIB_T / 2, 0])
                    cube([2 * W, RIB_T, h]);
        }
    }
}
