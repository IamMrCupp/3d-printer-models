// owon_tray_frame.scad — one-piece clamp frame for the OWON SPM8104 tray.
//
// Part 1 of 2 (the stock Clickfinity plate drops into it). **Print ONE.**
//
// WHY ONE PIECE — this is physics, not styling. A screw clamp needs two jaws
// joined by a rigid frame: you tighten a screw, the case is driven against the
// OPPOSITE jaw, and the reaction closes around the frame. The earlier two-loose-
// rails version could not work — each screw was threaded into the same jaw it
// pushed against, so it just shoved that jaw off the case (a jack screw with no
// anvil). The frame IS the anvil.
//
// FORCE PATH (verified): side screw tip -> pushes case wall inward -> case bears
// on the far jaw's screw tips -> that reaction runs through the front/back END-
// BARS (in tension) back to the near jaw. Closed loop -> the case is clamped
// BETWEEN the two jaws. The bars are load-bearing structure, not trim.
//
// PRINT: flat, skirts DOWN as modelled, no supports except optionally a brief
// one under the two screw bosses (short overhang). PETG or PLA — not a spring.
// Rubber/felt dot on each screw tip so it won't mar the case.

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

// One side jaw (+X side): extruded hook + two heat-set screw bosses. The screw
// threads through the insert and its tip presses the case; the reaction is taken
// by the frame (via the end-bars), NOT by this jaw alone.
module _jaw() {
    difference() {
        union() {
            translate([0, RAIL_LEN/2, 0]) rotate([90,0,0])
                linear_extrude(RAIL_LEN) polygon(_jaw_profile());
            for (y = [-SCREW_Y, SCREW_Y])
                translate([SKIRT_OUT - 1, y, SCREW_Z]) rotate([0,90,0])
                    cylinder(h = BOSS_EXT + 1, d = BOSS_OD);
        }
        for (y = [-SCREW_Y, SCREW_Y])
            translate([SKIRT_IN - 1, y, SCREW_Z]) rotate([0,90,0])
                cylinder(h = SKIRT_T + BOSS_EXT + 2, d = HS_D);
    }
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
