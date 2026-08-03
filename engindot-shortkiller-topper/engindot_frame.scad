// engindot_frame.scad — one-piece drop-over frame for the ENGINDOT top. PRINT ONE.
//
// Part 1 of 2. The stock Clickfinity plate (engindot_plate.scad) drops into the
// inner ledge and is bonded there; bins click into the plate. Same two-part
// split as owon-spm8104-tray, for the same reason — the plate must print
// latches-UP, the frame walls-DOWN, and no single orientation suits both.
//
// NO CLAMP, NO HARDWARE. Retention is passive:
//   * front/back LIPS hook the top edges  -> cannot slide fore-aft
//   * short side SKIRTS hug the case      -> cannot slide sideways
//   * gravity                             -> holds it down
//
// The skirts are deliberately SHORT here. The ENGINDOT vents the full height of
// both sides, so a 20 mm skirt like the OWON's would sit over the intake. The
// lips carry the retention; the skirts only locate. SKIRT_D is the knob.
//
// Unlike the OWON, the plate (84 mm) is much narrower than the case (102 mm),
// so the ledge is a real shelf spanning ~9 mm each side rather than a 2 mm lip.
// LEDGE_T is thickened to suit.
//
// PRINT: as rendered — walls UP, so the frame outline sits on the bed and the
// only overhang is the inner ledge, which bridges. No supports.
include <shortkiller_common.scad>

_TOP = LEDGE_T + PLATE_T_;

// One side jaw's cross-section (x, z), inner edge outward:
//
//   * a LEDGE_IN-wide lip that catches the plate edge
//   * a solid border, full height, from the plate edge out to the case wall
//   * the short skirt down the case side
//
// The border is SOLID rather than a shelf, and that is a printability decision,
// not a styling one. The plate (84) is much narrower than the lid (102), so the
// gap between them is ~9 mm per side. Carried at ledge height that would be a
// 9 mm one-sided cantilever running the full 217 mm — printed walls-up it hangs
// in air and needs support for its whole length. Full height, it is a wall
// sitting on the bed, and the ONLY overhang left is the LEDGE_IN lip, which
// bridges exactly like the OWON's does.
//
// It is also far stiffer, which this frame wants — it spans 217 mm on 2.5 mm
// skirts.
function _jaw_profile() = [
    [PLATE_W_/2 - LEDGE_IN,  0],
    [PLATE_W_/2 - LEDGE_IN,  LEDGE_T],
    [PLATE_W_/2,             LEDGE_T],
    [PLATE_W_/2,             _TOP],
    [SKIRT_OUT,              _TOP],
    [SKIRT_OUT,             -SKIRT_D],
    [SKIRT_IN,              -SKIRT_D],
    [SKIRT_IN,               0],
];

module _jaw() {
    translate([0, MOUNT_L/2, 0]) rotate([90, 0, 0])
        linear_extrude(MOUNT_L) polygon(_jaw_profile());
}

// Front/back end-bar: spans the full width, fuses into BOTH jaws to close the
// frame, and carries the lip that hooks the front/back top edge. Overlapped
// into the jaws so it merges without coincident planes.
module _end_bar(s) {
    y0 = s > 0 ? MOUNT_L/2 - END_BAR_T : -MOUNT_L/2;
    translate([-SKIRT_OUT - EPS, y0, -END_LIP_D])
        cube([2*SKIRT_OUT + 2*EPS, END_BAR_T, END_LIP_D + _TOP]);
}

module frame() {
    _jaw();
    mirror([1, 0, 0]) _jaw();
    _end_bar(1);
    _end_bar(-1);
}

// Rendered WALLS-UP for printing. Flip walls-down to use it on the supply.
rotate([180, 0, 0]) frame();
