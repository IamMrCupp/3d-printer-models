// bin_shortkiller — a Gridfinity bin that cradles the Shortkiller.
//
// FOOT is NX_CRADLE x NY_CRADLE cells of stock Gridfinity, so it clicks into
// the ENGINDOT plate — or any other Clickfinity / Gridfinity baseplate. BODY
// flares out above the foot in BOTH axes:
//
//   * ACROSS, to clear a box wider than the grid, so the plate can stay narrow
//     and hug the supply
//   * FORWARD, to make room for a lip at each end. The box is 171 mm and a
//     4-cell foot is 167.5, so without this there is nothing for a front lip to
//     stand on. The extension is entirely at the front — a rear one would run
//     into the probe bucket in the next cell.
//
// Both flares are 45-degree ramps finishing below the pocket floor. A step
// instead of a ramp needs support; a ramp running past the floor would have the
// pocket cut the side walls away where they are still narrow.
//
// Not a stock bin(): the box is operated in place, so both end lips are LOW —
// the rear clears the DC jack and rocker, the front clears the GX12 connector
// and the V+/V- buttons.
//
// Parameters let one module serve every coupon, so they cannot drift:
//   foot  = false  swap the Gridfinity base for a flat slab (grip coupon)
//   lips  = false  open front, no forward extension (original cross-section)
//
// PRINT: flat, foot down, no supports. PETG if it lives in a Clickfinity plate.
include <../lib/gridfinity.scad>
include <shortkiller_common.scad>

GRIP_BASE_T = 3.0;   // flat base thickness when foot = false
FUSE        = 0.05;  // overlap between the feet and the flare above them.
                     //   The feet top out at BIN_BASE_H and the flare used to
                     //   START there — coplanar faces, which the two OpenSCAD
                     //   builds this repo must satisfy resolve differently:
                     //   2021.01 (CI) and 2026.06 (dev) each produced a
                     //   non-manifold mesh for one rounding construction and a
                     //   clean one for the other, in OPPOSITE directions.
                     //   Overlapping them sidesteps the disagreement entirely.

// Rounded rect via the SAME offset idiom lib/gridfinity.scad uses. Verified on
// both engines this repo has to satisfy:
//
//   construction        OpenSCAD 2021.01 (CI)   OpenSCAD 2026.06 (dev)
//   hull of circles     NON-MANIFOLD            clean
//   offset(R) offset(-R) clean                  clean  (at $fn = 40)
//
// An earlier revision used a hull of four circles, on the theory that the offset
// round-trip was the fragile one. That was backwards: it is clean here and it is
// what 2021.01 chokes on. Matching lib/gridfinity.scad's own construction also
// means the union with bin_blank's block never mixes two roundings.
module _rrect(w, d) { offset(r = BIN_R) offset(r = -BIN_R) square([w, d], center = true); }

module grip_bump(side, len, top_z, yc) {
    // Ridge running fore-aft on the flexure's inner face. Horizontal axis so the
    // box cams the flexure outward as it drops in, instead of catching on it.
    translate([side * POCKET_W / 2, yc, top_z - BUMP_H / 2 - 2])
        scale([BUMP_REACH / (BUMP_H / 2), 1, 1])
            rotate([90, 0, 0])
                cylinder(r = BUMP_H / 2, h = len, center = true, $fn = 32);
}

module bin_shortkiller(ny = NY_CRADLE, foot = true, lips = true) {
    D       = ny * GF - 0.5;              // foot length
    ext     = lips ? FRONT_EXT : 0;       // forward overhang past the foot
    BD      = D + ext;                    // body length
    yc      = -ext / 2;                   // body centre, shifted forward
    y_front = -(D / 2 + ext);             // body front face
    y_rear  = D / 2;                      // body rear face

    base_h  = foot ? BIN_BASE_H + CHAMF : GRIP_BASE_T;
    floor_z = base_h + FLOOR_T;
    top_z   = floor_z + (BIN_H - FLOOR_Z);  // identical grip geometry either way

    // pocket runs between the two lip inner faces
    p_front = lips ? y_front + LIP_T : y_front - 10;
    p_rear  = y_rear - BACKSTOP_T;

    union() {
        difference() {
            union() {
                if (foot) {
                    // Feet only — deliberately NOT bin_blank(). bin_blank builds
                    // its block with offset(R) offset(-R) square(), while the
                    // flare below uses _rrect (hull of circles). Unioning two
                    // nominally identical rectangles built different ways leaves
                    // faces coincident to within tessellation error, and the mesh
                    // goes non-manifold on some OpenSCAD builds but not others —
                    // it passed locally and failed in CI. One construction only.
                    for (ix = [0 : NX_CRADLE-1], iy = [0 : ny-1])
                        translate([(ix - (NX_CRADLE-1)/2) * GF,
                                   (iy - (ny-1)/2) * GF, 0]) _bin_foot();

                    // 45-degree flare, grid footprint out to body footprint
                    hull() {
                        translate([0, 0, BIN_BASE_H - FUSE])
                            linear_extrude(EPS) _rrect(FOOT_W, D);
                        translate([0, yc, BIN_BASE_H + CHAMF])
                            linear_extrude(EPS) _rrect(BODY_W, BD);
                    }
                } else {
                    translate([0, yc, 0])
                        linear_extrude(GRIP_BASE_T) _rrect(BODY_W, BD);
                }

                // straight body above the base
                translate([0, yc, base_h])
                    linear_extrude(top_z - base_h) _rrect(BODY_W, BD);
            }

            // pocket
            translate([-POCKET_W / 2, p_front, floor_z])
                cube([POCKET_W, p_rear - p_front, top_z]);

            // rear lip trimmed to BACKSTOP_H. Overshoot INTO the pocket — a cut
            // ending flush with the pocket face leaves a coincident face and the
            // mesh goes non-manifold.
            translate([-BODY_W / 2 - 1, p_rear - 4, floor_z + BACKSTOP_H])
                cube([BODY_W + 2, BACKSTOP_T + 6, top_z]);

            // front lip trimmed to FRONT_LIP_H, same overshoot
            if (lips)
                translate([-BODY_W / 2 - 1, y_front - 1, floor_z + FRONT_LIP_H])
                    cube([BODY_W + 2, LIP_T + 5, top_z]);

            // flexure relief — thin each side wall from its OUTER face, inset
            // from both ends so the rounded outer corners stay solid
            for (s = [-1, 1])
                translate([s > 0 ? POCKET_W / 2 + FLEX_T : -BODY_W / 2 - 2,
                           y_front + RELIEF_INSET,
                           floor_z + FLEX_START])
                    cube([SIDE_WALL - FLEX_T + 2,
                          BD - 2 * RELIEF_INSET,
                          top_z]);
        }

        for (s = [-1, 1])
            grip_bump(s, BD - 2 * RELIEF_INSET - 10, top_z, yc);
    }
}

bin_shortkiller();
