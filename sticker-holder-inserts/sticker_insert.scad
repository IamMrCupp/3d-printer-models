// sticker_insert.scad — parametric sticker-holder insert
//
// A rectangular tray with a centered grid of circular pockets that hold
// sticker rolls / discs. Use this module from the variant files
// (insert_2x2_stickers_3x3.scad, insert_3x3_stickers_2x2.scad).
//
// NOTE: This is a reconstruction. The original CAD source for the inserts
// was not preserved, so these parameters were recovered by measuring the
// original STL meshes (see the project research notes). Reproduces the same
// design, reoriented Z-up (the originals were modeled with height on Y).

// ---- Default shell dimensions (mm) ----
OUTER_W   = 183;   // X — footprint width
OUTER_D   = 180;   // Y — footprint depth
HEIGHT    = 30;    // Z — overall height
FLOOR_T   = 2.9;   // solid base beneath the pockets
POCKET_DIA = 16.5; // pocket diameter

// Smoothness of the pocket cylinders.
$fn = 96;

// sticker_insert(cols, rows, spacing_x, spacing_y, ...)
//   cols, rows   — pocket grid counts in X and Y
//   spacing_x/y  — center-to-center pocket spacing (grid is auto-centered)
module sticker_insert(cols, rows, spacing_x, spacing_y,
                      outer_w = OUTER_W, outer_d = OUTER_D,
                      height = HEIGHT, floor_t = FLOOR_T,
                      pocket_dia = POCKET_DIA) {
    pocket_depth = height - floor_t;
    difference() {
        cube([outer_w, outer_d, height]);
        for (i = [0 : cols - 1], j = [0 : rows - 1]) {
            cx = outer_w / 2 + (i - (cols - 1) / 2) * spacing_x;
            cy = outer_d / 2 + (j - (rows - 1) / 2) * spacing_y;
            // start at the floor, overshoot the top so the pocket opens cleanly
            translate([cx, cy, floor_t])
                cylinder(h = pocket_depth + 1, d = pocket_dia);
        }
    }
}
