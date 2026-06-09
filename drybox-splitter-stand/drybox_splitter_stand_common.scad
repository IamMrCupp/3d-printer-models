// drybox_splitter_stand_common.scad — shared library for the two-part stand.
//
// Raises the PolyDryer splitter assembly (dryer + splitter mod + two boxes)
// ~4.5" off the desk with Gridfinity storage underneath. Two parts because the
// dryer sits in the middle of the assembly, so the top must be a solid platform
// — which can't share a single bottom-up print with a hollow storage cubby.
//
//   stand_base()  — Gridfinity storage cubby (open top + front). Prints as-is.
//   stand_top()   — solid platform + lip. Prints flat (solid face down, lip up).
//
// Variants `drybox_splitter_stand_base.scad` / `_top.scad` `include` this file.

include <../lib/gridfinity.scad>   // baseplate(nx, ny) + Gridfinity constants

/* [Grid] */
gx = 6; gy = 6;

/* [Dimensions] */
wall_t      = 4;
base_wall_h = 104;   // storage walls; + plate_t = assembly-bottom height (≈ 4.5")
plate_t     = 10;    // solid top platform thickness
post        = 14;    // corner post (square) — takes the screws
sill_h      = 12;    // low front sill to retain bins
lip_h       = 12;    // retaining lip around the assembly on the top plate
lip_w       = 4;     // lip thickness
disp_w      = 110;   // front display notch in the lip
cable_w     = 30;    // back cable notch
pilot_d     = 2.8;   // self-tapping pilot in the posts (M3)
screw_d     = 3.6;   // clearance hole in the plate
screw_head  = 7;     // countersink diameter

$fn = 48;

// Gridfinity baseplate comes from lib/gridfinity.scad (baseplate, GF, GF_FILLET).

// ---- Shared geometry ----
bp_w = gx * GF; bp_d = gy * GF;
outer_w = bp_w + 2 * wall_t;     // 260
outer_d = bp_d + 2 * wall_t;
posts = [[post/2, post/2], [outer_w - post/2, post/2],
         [post/2, outer_d - post/2], [outer_w - post/2, outer_d - post/2]];

module stand_base() {
    difference() {
        union() {
            translate([outer_w/2, outer_d/2, 0]) baseplate(gx, gy);               // floor (lib/gridfinity)
            cube([wall_t, outer_d, base_wall_h]);                                 // left wall
            translate([outer_w - wall_t, 0, 0]) cube([wall_t, outer_d, base_wall_h]); // right wall
            translate([0, outer_d - wall_t, 0]) cube([outer_w, wall_t, base_wall_h]); // back wall
            cube([outer_w, wall_t, sill_h]);                                      // front sill
            for (p = posts) translate([p[0] - post/2, p[1] - post/2, 0]) cube([post, post, base_wall_h]); // posts
        }
        for (p = posts) translate([p[0], p[1], base_wall_h - 16]) cylinder(h = 18, d = pilot_d); // pilots
    }
}

module stand_top() {
    difference() {
        union() {
            cube([outer_w, outer_d, plate_t]);                                    // platform
            difference() {                                                        // retaining lip
                cube([outer_w, outer_d, plate_t + lip_h]);
                translate([lip_w, lip_w, plate_t]) cube([outer_w - 2*lip_w, outer_d - 2*lip_w, lip_h + 1]);
            }
        }
        for (p = posts) translate([p[0], p[1], -1]) {
            cylinder(h = plate_t + 2, d = screw_d);                               // clearance
            translate([0, 0, plate_t - 3]) cylinder(h = 4, d1 = screw_d, d2 = screw_head); // countersink
        }
        translate([(outer_w - disp_w)/2, -1, plate_t - 1]) cube([disp_w, lip_w + 2, lip_h + 2]);          // display notch
        translate([(outer_w - cable_w)/2, outer_d - lip_w - 1, -1]) cube([cable_w, lip_w + 2, plate_t + lip_h + 2]); // cable notch
    }
}
