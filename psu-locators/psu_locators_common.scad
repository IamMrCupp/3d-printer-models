// psu_locators_common — open corner locators that give each bench supply a fixed
// home on the Clickfinity grid without blocking airflow. A shallow Gridfinity-
// footed floor plate (clicks into the bench baseplate) with LOW corner nubs that
// capture the PSU footprint. No side/front/rear walls — both supplies vent from
// the sides (ENGINDOT: FULL-height both sides; OWON: low side slots + rear fan),
// so anything enclosing would choke them. Nubs only appear on an axis where
// there's clearance between the PSU edge and the plate edge.
//
// Dimensions reused from the existing top-tray models (NOT re-measured):
//   OWON SPM8104   84.30 W × 226 D   (owon_tray_common: lid 84.30, ~226 long)
//   ENGINDOT       80    W × 193 D   (shortkiller_common: measured 80 × 193)
include <../lib/gridfinity.scad>

NUB_T   = 1.2;   // corner-nub wall thickness (thin — only room on a narrow gap)
NUB_LEN = 22;    // how far the nub runs along each captured edge
NUB_H   = 12;    // nub height — low, well clear of any vents
CLR     = 0.5;   // slip clearance so the PSU drops between the nubs
FLOOR   = 3;     // floor plate thickness above the Gridfinity foot

// One corner's nubs, inner corner at origin, opening toward −x,−y. `xw`/`yw`
// switch each wall on only when the plate has room for it on that axis.
module _corner(xw, yw) {
    if (xw) translate([0, -NUB_LEN, 0]) cube([NUB_T, NUB_LEN, NUB_H]);   // side wall
    if (yw) translate([-NUB_LEN, 0, 0]) cube([NUB_LEN, NUB_T, NUB_H]);   // end wall
}

// Footed floor plate + up to 4 corner nubs sized to a pw × pd PSU footprint.
module psu_locator(nx, ny, pw, pd) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    hx = (pw + CLR)/2; hy = (pd + CLR)/2;
    xw = (W/2 - hx) >= NUB_T;   // room for a side (x-blocking) wall?
    yw = (D/2 - hy) >= NUB_T;   // room for an end (y-blocking) wall?
    z0 = BIN_BASE_H + FLOOR;
    union() {
        bin_blank(nx, ny, z0);   // shallow Gridfinity-footed floor
        for (mx = [0,1]) for (my = [0,1])
            translate([(mx?-1:1)*hx, (my?-1:1)*hy, z0])
                mirror([mx,0,0]) mirror([0,my,0]) _corner(xw, yw);
    }
}
