// sticker_insert.scad — parametric sticker-holder insert
//
// A rectangular tray with a centered grid of square pockets that hold square
// stickers. Use this module from the variant files
// (insert_2x2_stickers_3x3.scad, insert_3x3_stickers_2x2.scad).
//
// NOTE: Reconstructed from the original STL meshes (original CAD was not
// preserved). The grid spacing was recovered by measuring the meshes; the
// pocket shape is square to match the square stickers. Authored Z-up.

INCH = 25.4;

// ---- Default shell dimensions (mm) ----
OUTER_W = 183;   // X — footprint width
OUTER_D = 180;   // Y — footprint depth
HEIGHT  = 30;    // Z — overall height
FLOOR_T = 2.9;   // solid base beneath the pockets

// ---- Pocket fit ----
POCKET_CLEARANCE = 0.5;  // added to the nominal sticker size so it drops in
POCKET_CORNER_R  = 3;    // rounded corner radius of each pocket

// Smoothness of the rounded corners.
$fn = 96;

// sticker_insert(cols, rows, spacing_x, spacing_y, sticker)
//   cols, rows   — pocket grid counts in X and Y
//   spacing_x/y  — center-to-center pocket spacing (grid is auto-centered)
//   sticker      — nominal square sticker size (mm); pocket = sticker + clearance
module sticker_insert(cols, rows, spacing_x, spacing_y, sticker,
                      outer_w = OUTER_W, outer_d = OUTER_D,
                      height = HEIGHT, floor_t = FLOOR_T,
                      clearance = POCKET_CLEARANCE, corner_r = POCKET_CORNER_R) {
    pocket = sticker + clearance;
    pocket_depth = height - floor_t;
    difference() {
        cube([outer_w, outer_d, height]);
        for (i = [0 : cols - 1], j = [0 : rows - 1]) {
            cx = outer_w / 2 + (i - (cols - 1) / 2) * spacing_x;
            cy = outer_d / 2 + (j - (rows - 1) / 2) * spacing_y;
            // rounded-square pocket, centered, opening through the top
            translate([cx, cy, floor_t])
                linear_extrude(height = pocket_depth + 1)
                    offset(r = corner_r)
                        square(pocket - 2 * corner_r, center = true);
        }
    }
}
