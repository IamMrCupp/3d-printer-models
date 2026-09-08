// respool_crank — drops over the spool's journal and turns it.
//
// Winding 15 m of braid is 126–149 turns. Pinching a ⌀56 flange means
// re-gripping every half turn; this makes it steady winding.
//
// THE SOCKET IS A D, NOT A CIRCLE. The journal carries two flats 12.00 apart
// across a ⌀14.60 body — the flats take the torque so the crank does not rely on
// friction, which printed-on-printed never survives.
//
// PRINT: as emitted, socket mouth DOWN on the bed. The socket's ceiling is a
// ⌀14.60 circle 5.2 mm up — a short bridge that needs no support. The grip
// stands up off the arm and carries itself.
include <respool_common.scad>
$fn = 96;

module _socket() {
    intersection() {
        cylinder(d = CRANK_JOURNAL + 2*CRANK_CLR, h = CRANK_DEPTH + EPS);
        translate([-(CRANK_FLAT_AF + 2*CRANK_CLR)/2, -CRANK_JOURNAL, -EPS])
            cube([CRANK_FLAT_AF + 2*CRANK_CLR, 2*CRANK_JOURNAL, CRANK_DEPTH + 3*EPS]);
    }
}

difference() {
    union() {
        hull() {
            cylinder(d = CRANK_JOURNAL + 8, h = CRANK_T);
            translate([CRANK_ARM, 0, 0]) cylinder(d = CRANK_GRIP_D + 6, h = CRANK_T);
        }
        translate([CRANK_ARM, 0, CRANK_T - EPS])
            cylinder(d = CRANK_GRIP_D, h = CRANK_GRIP_H + EPS);
    }
    translate([0, 0, -EPS]) _socket();
}
