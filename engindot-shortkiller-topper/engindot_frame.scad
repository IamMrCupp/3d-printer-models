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
    [POCKET_HW - LEDGE_IN,  0],
    [POCKET_HW - LEDGE_IN,  LEDGE_T],
    [POCKET_HW,             LEDGE_T],
    [POCKET_HW,             _TOP],
    [TOP_OUT,               _TOP],
    [TOP_OUT,               RAMP],
    [SKIRT_OUT,             0],
    [SKIRT_OUT,            -SKIRT_D],
    [SKIRT_IN,             -SKIRT_D],
    [SKIRT_IN,              0],
];
// No inner ramp any more: the ledge now reaches inboard of the skirt to bear on
// the lid, so the old ramp would sit inside the case volume. Its 2 mm inward
// cantilever bridges, exactly as the OWON's does.

module _jaw(len) {
    translate([0, len/2, 0]) rotate([90, 0, 0])
        linear_extrude(len) polygon(_jaw_profile());
}

// Front/back end-bar: spans the full width, fuses into BOTH jaws to close the
// frame, and carries the lip that hooks the front/back top edge. Overlapped
// into the jaws so it merges without coincident planes.
module _end_bar(s, len) {
    y0 = s > 0 ? len/2 - END_BAR_T : -len/2;
    // FULL HEIGHT to _TOP. This is a printability constraint, not a fit one:
    // walls-up, the frame stands on its skirt tops, and a bar stopping short of
    // that plane bridges ~85 mm across the opening and sags. The plate clears it
    // by fitting BETWEEN the bars — hence the MOUNT_L assert.
    translate([-TOP_OUT - EPS, y0, -END_LIP_D])
        cube([2*TOP_OUT + 2*EPS, END_BAR_T, END_LIP_D + LEDGE_T]);
}

// len defaults to the real MOUNT_L. A short len gives a genuine slice of this
// same geometry for fit-testing — see frame_test_section.scad.
// Shelf carrying the plate's overhang past the end of the frame, 45-degree
// gusset underneath. Walls-down that gusset is self-supporting; a square shelf
// would be an 8.5 mm overhang running the full width.
module _end_shelf(s, len) {
    y0 = s > 0 ? len/2 : -len/2;
    pts = s > 0
        ? [[y0, -END_LIP_D], [y0 + SHELF_OUT, -END_LIP_D + SHELF_OUT],
           [y0 + SHELF_OUT, LEDGE_T], [y0, LEDGE_T]]
        : [[y0, -END_LIP_D], [y0, LEDGE_T],
           [y0 - SHELF_OUT, LEDGE_T], [y0 - SHELF_OUT, -END_LIP_D + SHELF_OUT]];
    translate([-TOP_OUT - EPS, 0, 0])
        rotate([90, 0, 90]) linear_extrude(2*TOP_OUT + 2*EPS) polygon(pts);
}

module frame(len = MOUNT_L) {
    _jaw(len);
    mirror([1, 0, 0]) _jaw(len);
    _end_bar(1, len);
    _end_bar(-1, len);
    // Below ~2 mm the shelf is a sliver wedge that adds nothing and goes
    // non-manifold against the end bar. The plate barely overhangs at that point.
    if (END_SHELF && SHELF_OUT >= 2) {
        _end_shelf(1, len);
        _end_shelf(-1, len);
    }
}

// Rendered WALLS-DOWN — as used AND as printed. Skirt bottoms and end-lip
// bottoms share the bed; the only overhangs are the two 45-degree ramps and the
// 2 mm plate ledge. Do NOT flip this: walls-up leaves the end bars in mid-air.
frame();
