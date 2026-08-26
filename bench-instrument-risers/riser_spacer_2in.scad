// riser_spacer_2in — 2" spacer that clicks UNDER a pedestal.
//
// The hot air pedestals dropped from 8" to 6" so all four fit an overnight
// print. If 6" turns out short, four of these restore the original 8" without
// reprinting the pedestals.
//
// CLICKFINITY ON TOP, not a standard Gridfinity socket plate. This bench is
// Clickfinity: the latch grabs an unmodified Gridfinity foot, so the pedestal
// LATCHES into the spacer the same way it latches into the desk. A plain socket
// plate would only locate it, and a tall pedestal that merely sits in a shallow
// socket is exactly the rocking this whole model exists to stop.
//
// Net rise = body + PLATE_H - BIN_BASE_H. The Clickfinity plate is SHALLOW
// (4.00 vs 5.85), so the body is taller than it would be on a standard cap.
//
// ⚠️ PRINT IN PETG / ABS / ASA — **NOT PLA.** The latch tongues sit under
// constant spring tension and PLA creeps out of grip within weeks. Same rule as
// every Clickfinity plate on this bench.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/gridfinity.scad>
use <../lib/clickfinity.scad>

RISE  = 50.8;    // [25.4:0.1:101.6] net height added — 2"
CF_PLATE_H = 4.00;   // lib/clickfinity.scad PLATE_H — shallow by design
WALL  = 1.26;    // [1.2:0.2:4] matches the pedestals' three-line shell
FLOOR = 1.40;
VENT  = 10.0;    // [0:1:20] vent through the floor. NOT optional: a sealed
                 //   cavity traps air and renders as a SECOND CONNECTED
                 //   COMPONENT — watertight, right bbox, still wrong.

BODY = RISE - (CF_PLATE_H - BIN_BASE_H);

assert(BODY > BIN_BASE_H + FLOOR + 5, "Spacer body too short to be worth hollowing.");
echo(str("spacer body ", BODY, " mm, part ", BODY + CF_PLATE_H, " mm tall, net rise ", RISE));

difference() {
    union() {
        bin_blank(2, 2, BODY);
        translate([0, 0, BODY]) clickfinity_baseplate(2, 2);
    }
    // Hollow it out — walls only, capped by the plate above.
    //
    // The extrude stops EXACTLY at BODY, where the Clickfinity plate begins. It
    // used to run to BODY + 0.01, and that epsilon is what failed CI with
    // "8 non-manifold edges": the cut shaved a 0.01 sliver off the underside of
    // the plate, leaving near-coincident faces that OpenSCAD 2021.01 (what CI
    // runs) resolves into edges shared by more than two triangles. Locally, on
    // 2026.06, it rendered clean — which is why it sat unmerged.
    //
    // In Z, butt solids at the exact plane. Do not overlap by epsilon.
    translate([0, 0, BIN_BASE_H + FLOOR])
        linear_extrude(BODY - BIN_BASE_H - FLOOR)
            offset(BIN_R - WALL) offset(-(BIN_R - WALL))
                square([2*GF - 0.5 - 2*WALL, 2*GF - 0.5 - 2*WALL], center = true);
    // vents
    if (VENT > 0)
        for (ix = [-1, 1], iy = [-1, 1])
            translate([ix*GF/2, iy*GF/2, -1])
                cylinder(d = VENT, h = BIN_BASE_H + FLOOR + 2, $fn = 48);
}
