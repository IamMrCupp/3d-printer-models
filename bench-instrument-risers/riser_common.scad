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
// WHY THE TOP IS FLAT BY DEFAULT
//   A locating pocket has to be cut where that instrument's foot actually lands,
//   which makes the part bespoke — and the value here is that every pedestal is
//   interchangeable. The pedestal is latched to the plate and cannot move; the
//   instrument sits on it on its own rubber feet, which grip PETG fine. Set
//   POCKET_D above 0 only if something actually creeps in use, and accept that
//   those pedestals stop being interchangeable when you do.
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

/* [Foot pocket — OPTIONAL] */
POCKET_D = 0.00;   // finished pocket diameter. 0 = flat top (default).
                   //   If you do want pockets, get this from riser_foot_gauge —
                   //   NOT from calipers on the foot. The number that matters is
                   //   the finished hole a foot drops into, which folds the
                   //   foot's size, its rubber compliance, and this printer's
                   //   hole shrinkage into one reading.
POCKET_H = 2.50;   // [1:0.5:6] pocket depth. Shallow on purpose — it only has to
                   //   stop creep. Deep pockets on rubber feet make the
                   //   instrument awkward to lift off and add nothing.

/* [Stability] */
// Height-to-width ratio past which a pedestal is tippy while you are placing the
// instrument on it. The Gridfinity foot in a socket resists sideways load well,
// so this is about handling, not about the assembly falling over in use — once
// the instrument is on, its own chassis ties the pedestals together.
MAX_ASPECT = 1.60;  // [1:0.1:2.5]

// ---------------------------------------------------------------------------
// Geometry
// ---------------------------------------------------------------------------

module riser_pedestal(h, gx = GX, gy = GY, pocket_d = POCKET_D, pocket_h = POCKET_H) {
    narrow = min(gx, gy) * GF;

    assert(h > BIN_BASE_H + 2,
           "Riser height barely clears the Gridfinity foot — there is no pedestal left above it.");

    assert(h <= 270 && gx * GF <= 270 && gy * GF <= 270,
           "Pedestal exceeds the U1's 270 mm build volume.");

    assert(pocket_d == 0 || pocket_h < h - BIN_BASE_H,
           "Foot pocket is deeper than the solid material above the feet.");

    assert(pocket_d == 0 || pocket_d + 4 <= narrow - 0.5,
           "Foot pocket is wider than the pedestal it is cut into.");

    // Deliberately an echo and not an assert: a tall-and-narrow pedestal is a
    // handling nuisance, not a broken part, and the call on whether to widen it
    // depends on foot spacing this file does not know.
    if (h > MAX_ASPECT * narrow)
        echo(str("WARNING: pedestal is ", h / narrow,
                 ":1 tall vs wide (limit ", MAX_ASPECT,
                 "). Widen GX/GY if the instrument's foot spacing allows it."));

    difference() {
        bin_blank(gx, gy, h);

        if (pocket_d > 0)
            translate([0, 0, h - pocket_h])
                cylinder(h = pocket_h + 0.01, d = pocket_d);
    }
}
