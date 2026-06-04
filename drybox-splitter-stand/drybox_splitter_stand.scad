// drybox_splitter_stand.scad — stand that raises the PolyDryer splitter
// assembly (two PolyDryer boxes on the splitter/dryer base) ~4.5" off the desk,
// with an open-front storage cubby and an integrated Gridfinity baseplate floor.
//
// Footprint is driven by the Gridfinity grid (6x6 = 252 mm) + walls; the top
// cradle holds the two-box footprint (~240 x 235 mm, each box 235 x 120). The
// front is kept clear so the dryer display + buttons stay accessible.
//
//   openscad -o drybox_splitter_stand.stl --export-format binstl drybox_splitter_stand.scad

/* [Gridfinity grid] */
gx = 6;          // cells across (X)
gy = 6;          // cells deep  (Y)

/* [Stand] */
raise      = 114;  // assembly-bottom height above desk (≈ 4.5"); 101.6 = 4", 127 = 5"
top_t      = 6;    // top platform thickness
lip_h      = 12;   // locating lip around the assembly
lip_w      = 4;    // lip thickness
wall_t     = 4;    // side / back wall thickness
front_sill = 12;   // low front lip so stored items don't slide out
header_h   = 16;   // front top beam supporting the platform's front edge
disp_w     = 110;  // front display / button notch width (centered)
cable_w    = 30;   // back lip notch for the dryer's power lead

$fn = 48;

// ---------- Gridfinity baseplate (per spec) ----------
// 42 mm pitch, 41.5 mm bins, socket profile 0.7 + 1.8 + 2.15 = 4.65 mm, 4 mm fillet.
GF        = 42;            // grid pitch (mm)
GF_FILLET = 4;            // outer corner radius
GF_C_TOP  = 2.15;         // top chamfer (45°)
GF_C_MID  = 1.8;          // vertical section
GF_C_BOT  = 0.7;          // bottom chamfer (45°)
GF_LIP    = GF_C_TOP + GF_C_MID + GF_C_BOT;  // 4.65
GF_FLOOR  = 1.2;          // solid floor beneath the sockets
GF_H      = GF_LIP + GF_FLOOR;

module gf_cell_2d(inset = 0) {  // rounded square, full cell minus `inset`
    offset(r = -inset) offset(r = GF_FILLET) offset(r = -GF_FILLET)
        square(GF, center = true);
}

module gf_socket() {  // z-shaped recess, top at z = GF_H, narrowing downward
    eps = 0.01;
    hull() {  // top chamfer
        translate([0, 0, GF_H - eps]) linear_extrude(eps) gf_cell_2d(0);
        translate([0, 0, GF_H - GF_C_TOP]) linear_extrude(eps) gf_cell_2d(GF_C_TOP);
    }
    translate([0, 0, GF_H - GF_C_TOP - GF_C_MID])  // vertical
        linear_extrude(GF_C_MID) gf_cell_2d(GF_C_TOP);
    hull() {  // bottom chamfer
        translate([0, 0, GF_H - GF_C_TOP - GF_C_MID - eps])
            linear_extrude(eps) gf_cell_2d(GF_C_TOP);
        translate([0, 0, GF_H - GF_LIP]) linear_extrude(eps) gf_cell_2d(GF_C_TOP + GF_C_BOT);
    }
}

module gridfinity_baseplate(nx, ny) {
    w = nx * GF; d = ny * GF;
    difference() {
        translate([0, 0, GF_H / 2]) linear_extrude(GF_H, center = true)
            offset(r = GF_FILLET) offset(r = -GF_FILLET) square([w, d], center = true);
        for (ix = [0 : nx - 1], iy = [0 : ny - 1])
            translate([(ix - (nx - 1) / 2) * GF, (iy - (ny - 1) / 2) * GF, 0]) gf_socket();
    }
}

// ---------- Stand ----------
bp_w = gx * GF; bp_d = gy * GF;          // 252 x 252
outer_w = bp_w + 2 * wall_t;             // 260
outer_d = bp_d + 2 * wall_t;
wall_h  = raise - top_t;                 // wall height to the platform underside

module stand() {
    win_z = GF_H + 14;
    win_h = wall_h - GF_H - 34;
    difference() {
        union() {
            translate([outer_w / 2, outer_d / 2, 0]) gridfinity_baseplate(gx, gy); // floor
            cube([wall_t, outer_d, wall_h]);                                        // left wall
            translate([outer_w - wall_t, 0, 0]) cube([wall_t, outer_d, wall_h]);    // right wall
            translate([0, outer_d - wall_t, 0]) cube([outer_w, wall_t, wall_h]);    // back wall
            cube([outer_w, wall_t, front_sill]);                                    // front sill
            translate([0, 0, wall_h - header_h]) cube([outer_w, wall_t, header_h]); // front header
            translate([0, 0, wall_h]) cube([outer_w, outer_d, top_t]);              // platform
            translate([0, 0, wall_h + top_t]) difference() {                        // locating lip
                difference() {
                    cube([outer_w, outer_d, lip_h]);
                    translate([lip_w, lip_w, -1])
                        cube([outer_w - 2 * lip_w, outer_d - 2 * lip_w, lip_h + 2]);
                }
                // front display notch
                translate([(outer_w - disp_w) / 2, -1, -1]) cube([disp_w, lip_w + 2, lip_h + 2]);
                // back cable notch
                translate([(outer_w - cable_w) / 2, outer_d - lip_w - 1, -1]) cube([cable_w, lip_w + 2, lip_h + 2]);
            }
        }
        // windows (visibility + weight); front stays open
        translate([-1, 50, win_z]) cube([wall_t + 2, outer_d - 100, win_h]);                  // left
        translate([outer_w - wall_t - 1, 50, win_z]) cube([wall_t + 2, outer_d - 100, win_h]); // right
        translate([50, outer_d - wall_t - 1, win_z]) cube([outer_w - 100, wall_t + 2, win_h]); // back
    }
}

stand();
