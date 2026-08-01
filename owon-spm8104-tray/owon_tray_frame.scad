// owon_tray_frame.scad — one-piece drop-over frame for the OWON SPM8104 tray.
//
// Part 1 of 2 (the stock Clickfinity plate drops into it). **Print ONE.**
//
// NO CLAMP, NO HARDWARE. For a coiled cord and some barrel adapters on a supply
// that never moves, retention is passive: the side walls hug the case sides so
// it can't slide off sideways, the shallow front/back lips catch the top edges
// so it can't slide off front/back, and gravity holds it down. It drops on and
// lifts off. (An earlier version added a screw clamp — pointless overkill for
// this load, and mechanically wrong besides.)
//
// PRINT: flat, skirts DOWN as modelled. No supports, no bridges.
// PETG or PLA — this part carries no load and isn't a spring.

include <owon_tray_common.scad>
$fn = 48;

_TOP = LIP_T + PLATE_H_;

// One side jaw's cross-section (x,z): lip under the plate edge, upstand that
// captures the plate, and the 20 mm skirt down the case side.
function _jaw_profile() = [
    [PLATE_W/2 - LIP_IN,  0],
    [PLATE_W/2 - LIP_IN,  LIP_T],
    [SKIRT_IN,            LIP_T],
    [SKIRT_IN,            _TOP],
    [SKIRT_OUT,           _TOP],
    [SKIRT_OUT,          -SKIRT_D],
    [SKIRT_IN,           -SKIRT_D],
    [SKIRT_IN,            0],
];

// One side wall (+X side): just the extruded hook — lip under the plate, upstand
// that captures the plate, and the skirt that hugs the case side. No bosses.
module _jaw() {
    translate([0, RAIL_LEN/2, 0]) rotate([90,0,0])
        linear_extrude(RAIL_LEN) polygon(_jaw_profile());
}

// Front/back end-bar: spans the full width and fuses into BOTH jaws, closing the
// frame (the reaction path). Also carries the shallow front/back lip: from the
// jaw top (_TOP) down over the front/back edge by END_LIP_D. Overlaps the jaws
// (+/-0.01) so it merges without coincident planes.
module _end_bar(s) {
    y0 = s > 0 ? RAIL_LEN/2 - END_BAR_T : -RAIL_LEN/2;
    translate([-SKIRT_OUT - 0.01, y0, -END_LIP_D])
        cube([2*SKIRT_OUT + 0.02, END_BAR_T, END_LIP_D + _TOP]);
}

// The complete one-piece frame.
module frame() {
    _jaw();
    mirror([1,0,0]) _jaw();
    _end_bar(1);
    _end_bar(-1);
}

frame();
