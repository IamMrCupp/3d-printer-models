// scope_plate_common — click-on Gridfinity plate for the microscope boom's
// weighted-base raised platform. Sits on the platform, skirt hugs front + both
// sides (open at the back toward the pole), 3×3 grid on top — mainly a home for
// the Kimwipe box that already lives there.
//
// MEASURED 2026-07-27 (some low-confidence, flagged):
//   platform  131.84 (W) × 130.54 (D)   raised-platform outline, front→pole
//   step      ~11 mm ⚠ (dark display)   platform height above the rim → skirt grab
//   kimwipe   119.60 × 122.86           box footprint (fits the 3×3)
include <../lib/gridfinity.scad>

PLAT_W = 131.84;   // platform width  (X)
PLAT_D = 130.54;   // platform depth  (Y, front edge → pole)
STEP_H = 11;       // ⚠ estimate — skirt depth must stay under this
CORNER = 12;       // ⚠ estimate — platform corner radius

GRID_NX = 3; GRID_NY = 3;
SKIRT_DEPTH = 7;   // < STEP_H
SKIRT_WALL  = 2.5;
FIT         = 0.4; // slip clearance skirt-to-platform (interference-ish)
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
