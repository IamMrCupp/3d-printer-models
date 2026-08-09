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

module scope_wipe_plate() {
    union() {
        // 3×3 grid, centred
        baseplate(GRID_NX, GRID_NY);
        // border frame: a ring OUTSIDE the grid out to the platform outline
        // (overlaps the grid edge by ~1 mm so the union fuses; must NOT cover the
        // grid or it fills the sockets).
        difference() {
            linear_extrude(BP_H) _rrect(PLAT_W, PLAT_D, CORNER);
            translate([0,0,-EPS]) linear_extrude(BP_H + 2*EPS)
                _rrect(GRID_NX*GF - 2, GRID_NY*GF - 2, GF_FILLET);
        }
        // click skirt: U around front + both sides, open at +Y (pole side)
        difference() {
            translate([0,0,-SKIRT_DEPTH]) linear_extrude(SKIRT_DEPTH + EPS)
                _rrect(PLAT_W + FIT + 2*SKIRT_WALL, PLAT_D + FIT + 2*SKIRT_WALL, CORNER);
            translate([0,0,-SKIRT_DEPTH - EPS]) linear_extrude(SKIRT_DEPTH + 3*EPS)
                _rrect(PLAT_W + FIT, PLAT_D + FIT, CORNER);
            // open the back wall (pole side)
            translate([-PLAT_W, PLAT_D/2 - SKIRT_WALL, -SKIRT_DEPTH - 1])
                cube([2*PLAT_W, 4*SKIRT_WALL, SKIRT_DEPTH + 2]);
        }
    }
}
