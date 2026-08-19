// filler_common — shared knobs for the Gridfinity filler tiles.
//
// A filler turns a run of empty grid into a working surface: mouse, drink,
// wrist rest, somewhere to put a board down. Geometry lives in
// `lib/gridfinity.scad` as `filler_tile()`; this file only carries the choices
// specific to these parts.
//
// Set the size from the command line, no file editing:
//     openscad -o f_3x2.stl --export-format binstl -D NX=3 -D NY=2 filler_flat.scad

include <../lib/gridfinity.scad>

/* [Size] */
NX = 2;  // [1:6]
NY = 2;  // [1:6]

/* [Plate] */
// The plate's top surface above its socket floor. This bench is gridded with
// Clickfinity, so 2.80 is the default. A standard full-depth Gridfinity
// baseplate is 4.65 — get it wrong and the ribs either float (the tile flexes)
// or hold the feet clear of the sockets (it rocks and won't latch).
PLATE_TOP = 2.80;  // [2.00:0.05:5.00]

/* [Recess — coaster / mousepad variants only] */
RECESS_D     = 2.00;  // [1.00:0.25:4.00] mm depth of the dish
RECESS_WALL  = 6.00;  // [3.00:0.50:12.00] mm rim left around it
RECESS_FLOOR = 1.20;  // [0.80:0.20:2.40] mm material left UNDER the dish

// The flat tile's skin is FILLER_TOP_T (1.60). A 2 mm dish sunk into 1.6 mm of
// skin cuts straight through into the hollow and you get a tile with a hole in
// it — caught by probing the dish floor, not by looking at the render, which
// shows a perfectly plausible dished tile either way. So the recessed variants
// run a THICKER top: dish depth plus a real floor beneath it.
RECESS_TOP_T = RECESS_D + RECESS_FLOOR;

/* [Quality] */
$fn = 48;  // [32:8:96]

// A recess sunk into the top face, leaving RECESS_WALL of rim.
// Kept clear of the outer chamfer so the rim never goes knife-thin.
module filler_recess(nx, ny, depth = RECESS_D, wall = RECESS_WALL, top_t = RECESS_TOP_T) {
    W = nx*GF - 0.5 - 2*wall;
    D = ny*GF - 0.5 - 2*wall;
    assert(W > 10 && D > 10, "recess too small for this tile — lower RECESS_WALL or use a bigger tile");
    assert(depth < top_t, "RECESS_D must be less than the top thickness or the dish holes through");
    top = BIN_BASE_H + top_t;
    translate([0, 0, top - depth + 0.01])
        linear_extrude(depth) offset(BIN_R) offset(-BIN_R) square([W, D], center = true);
}
