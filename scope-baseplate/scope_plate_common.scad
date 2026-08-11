// scope_plate_common — click-on Gridfinity plate for the microscope boom's
// weighted-base raised platform. Sits on the platform, skirt hugs front + both
// sides (open at the back toward the pole), 3×3 grid on top — mainly a home for
// the Kimwipe box that already lives there.
//
// MEASURED 2026-07-27:
//   platform  131.84 (W) × 130.54 (D)   raised-platform outline, front→pole
//   step      17.76 mm                  platform height above the rim → skirt grab
//   corner    ~15 mm radius             gauged (see CORNER below)
//   kimwipe   119.60 × 122.86           box footprint (fits the 3×3)
include <../lib/gridfinity.scad>

PLAT_W = 131.84;   // platform width  (X)
PLAT_D = 130.54;   // platform depth  (Y, front edge → pole)
STEP_H = 17.76;    // measured — platform height above rim → skirt grab

// Gauged with scope_corner_gauge.stl (8 female corners, 6–20 mm in 2 mm steps):
// gauges 5 (14) and 6 (16) both seated, so the real radius is ~15.
// Use 14, NOT 15 — the error is ASYMMETRIC. A larger CORNER rounds the skirt
// opening more, making it smaller at the corners, so it binds. Boolean
// interference test (platform vs skirt opening):
//     CORNER=14 -> clears real R = 14, 15, 16
//     CORNER=15 -> BINDS if R = 14
//     CORNER=16 -> BINDS if R = 14 or 15
// Taking the smaller gauge that seated clears the whole measured range, so no
// finer gauge is needed. Worst case the corners sit ~0.8 mm proud — irrelevant
// on a skirt registering against 130 mm of flat.
CORNER = 14;

GRID_NX = 3; GRID_NY = 3;
SKIRT_DEPTH = 12;  // < STEP_H (17.76), deep grip with margin
SKIRT_WALL  = 2.5;

// Slip clearance, skirt-to-platform. NOT 0.4 — that is the same number over the
// same ~131 mm span that just failed on the OWON tray frame: PETG shrinks
// ~0.5 mm across 131 mm, so an internal dimension prints undersize and binds.
// 1.2 leaves ~0.35 mm/side of real clearance after shrink.
FIT = 1.2;
EPS = 0.1;

module _rrect(w, d, r) { offset(r) offset(-r) square([w, d], center = true); }

// Derived: the skirt wraps the platform with FIT of slop, so its faces sit
// OUTBOARD of the platform outline.
SKIRT_IN_W  = PLAT_W + FIT;                    // inner face — hugs the platform
SKIRT_IN_D  = PLAT_D + FIT;
SKIRT_OUT_W = SKIRT_IN_W + 2*SKIRT_WALL;       // outer face
SKIRT_OUT_D = SKIRT_IN_D + 2*SKIRT_WALL;

// The plate must reach the skirt's OUTER face, not the platform outline.
//
// Sizing the border to PLAT_W left its edge at PLAT_W/2 = 65.92 while the skirt's
// inner face sits at (PLAT_W+FIT)/2 = 66.52 — they never touched, and the model
// rendered as TWO disconnected bodies (manifold, CI-green, and useless: a loose
// ring plus a loose plate). The gap is FIT/2, so it was present at the original
// FIT = 0.4 too, just 0.2 mm wide instead of 0.6.
module scope_wipe_plate() {
    // ONE cut at the platform's back edge opens the skirt for the boom pole and
    // stops the plate growing into it. Done in 3D on the finished union, not as a
    // 2D intersection on the outline: trimming the rounded outline in 2D
    // retriangulates the border's underside and throws sub-micron sliver
    // triangles at the inner corners, which the mesh validator rejects.
    difference() {
        union() {
            // 3×3 grid, centred
            baseplate(GRID_NX, GRID_NY);
            // Border frame: a ring from the grid's outer edge out to the skirt's
            // outer face.
            //
            // Its inner boundary is the EXACT expression baseplate() uses for its
            // own outline — _rrect(nx*GF, ny*GF, GF_FILLET) — so the two curves are
            // bit-identical and CGAL merges them. The earlier version cut at
            // nx*GF - 2 to "overlap the grid by ~1 mm", which put two rounded rects
            // 1 mm apart with the SAME corner radius: near-parallel arcs whose facet
            // vertices land close enough to stitch sub-micron sliver triangles.
            // Identical beats nearly-identical. Cranking $fn hid it on one renderer
            // and not on CI's.
            difference() {
                linear_extrude(BP_H) _rrect(SKIRT_OUT_W, SKIRT_OUT_D, CORNER);
                translate([0,0,-EPS]) linear_extrude(BP_H + 2*EPS)
                    _rrect(GRID_NX*GF, GRID_NY*GF, GF_FILLET);
            }
            // click skirt, full plate height so it is volumetrically embedded in
            // the border above z=0 rather than merely touching it on one face.
            difference() {
                translate([0,0,-SKIRT_DEPTH]) linear_extrude(SKIRT_DEPTH + BP_H)
                    _rrect(SKIRT_OUT_W, SKIRT_OUT_D, CORNER);
                // Bore runs the FULL height — the skirt stays a ring all the way
                // up. Stopping this at z=0 leaves a solid slab over the plate that
                // swallows every socket (416 facets instead of ~2600: a manifold,
                // CI-passing brick).
                translate([0,0,-SKIRT_DEPTH - EPS])
                    linear_extrude(SKIRT_DEPTH + BP_H + 2*EPS)
                        _rrect(SKIRT_IN_W, SKIRT_IN_D, CORNER);
            }
        }
        // the pole cut
        translate([-SKIRT_OUT_W, PLAT_D/2, -SKIRT_DEPTH - 1])
            cube([2*SKIRT_OUT_W, SKIRT_OUT_D, SKIRT_DEPTH + BP_H + 2]);
    }
}
