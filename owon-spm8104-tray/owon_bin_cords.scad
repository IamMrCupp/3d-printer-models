// owon_bin_cords — 2×2 divided well for the mains lead, alligator leads, and
// the master barrel plug. Part 1 of 2 (light body); the dark text inlay is
// owon_bin_cords_label.scad.
//
// Sits at the BACK of the tray. It is the tall bin (55 mm), so putting it
// behind the 16 mm tip block keeps the block reachable and gives this bin's
// front wall ~39 mm of clear face standing above it — which is where the
// warning label goes, readable from a normal bench stance.
//
// The divider is not decoration. The rear compartment is the master barrel
// cord's, and every tip in the kit is female: lose that one lead and the whole
// 41-piece set connects to nothing. Bulk storage is how that goes missing.
//
// PRINT: flat, foot-down, no supports.
//
// Two-colour: load this and owon_bin_cords_label.scad at the same origin and
// assign a light / dark toolhead. Single-colour is a valid fallback — print
// this part alone and the label is simply engraved instead of filled.

include <owon_bins_common.scad>

$fn = 48;

// Pocket sits LABEL_T into the front wall, overrunning the outer face slightly
// so difference() doesn't leave a coincident cut plane.
_pocket_y = CORD_FRONT_Y + LABEL_T - 0.05;

difference() {
    divided_bin(2, 2, CORD_H, cols = 1, rows = CORD_ROWS, wall = CORD_WALL);
    translate([0, _pocket_y, WARN_Z1]) label_pocket_v(WARN_L1, size = WARN_SIZE);
    translate([0, _pocket_y, WARN_Z2]) label_pocket_v(WARN_L2, size = WARN_SIZE);
}
