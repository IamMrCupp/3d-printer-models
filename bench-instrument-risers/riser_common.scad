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
// WHY IT IS MODELLED SOLID
//   No cavity, no walls, no open front — the slicer's infill decides how much
//   material this uses, which is the right place for that decision. A hollow
//   shell would need an opening to be useful, and an opening on a load-bearing
//   pedestal puts a weak axis under an instrument. Storage goes in the open grid
//   BETWEEN the pedestals, which is the point of raising anything.
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
        bin_blank(gx, gy, h);

        if (lip_h > 0)
            translate([0, 0, h - lip_h]) linear_extrude(lip_h + 0.01)
                offset(BIN_R - lip_w) offset(-(BIN_R - lip_w))
                    square([pad_w, pad_d], center = true);
    }
}
