// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp
//
// gridfinity.scad — shared Gridfinity baseplate + bin library (per spec).
//
// 42 mm pitch, 41.5 mm bins, baseplate socket 0.7/1.8/2.15 = 4.65 mm, 4 mm
// fillet; bin foot 0.8/1.8/2.15 = 4.75 mm, 3.75 mm corner radius. Verified the
// bin foot seats in the baseplate socket with ~0.25–0.5 mm clearance.
//
//   baseplate(nx, ny)                      — tiled receiving baseplate
//   bin_blank(nx, ny, h)                   — solid bin body (feet + block, no cavity)
//   filler_tile(nx, ny)                    — flat lid over empty grid (corner feet + ribs)
//   bin(nx, ny, h, wall, floor)            — open Gridfinity bin
//   divided_bin(nx, ny, h, cols, rows, …)  — bin with internal compartments
//   open_front_bin(nx, ny, h, …)           — bin with the front wall swept away
//   lid(nx, ny, …)                         — friction lid for a bin of the same footprint
//   stack_base(nx, ny, h, …)               — baseplate-topped base; a bin socket-stacks on it

GF = 42; GF_FILLET = 4;
_C_TOP = 2.15; _C_MID = 1.8; _C_BOT = 0.7;
_BP_LIP = _C_TOP + _C_MID + _C_BOT; _BP_FLOOR = 1.2; BP_H = _BP_LIP + _BP_FLOOR;  // 5.85
BIN_SZ = 41.5; BIN_R = 3.75; BIN_BASE_H = 4.75;

// ---- baseplate ----
module _bp_cell(i = 0) { offset(r = -i) offset(r = GF_FILLET) offset(r = -GF_FILLET) square(GF, center = true); }
module _bp_socket() {
    e = 0.01;
    hull() { translate([0,0,BP_H-e]) linear_extrude(e) _bp_cell(0); translate([0,0,BP_H-_C_TOP]) linear_extrude(e) _bp_cell(_C_TOP); }
    translate([0,0,BP_H-_C_TOP-_C_MID]) linear_extrude(_C_MID) _bp_cell(_C_TOP);
    hull() { translate([0,0,BP_H-_C_TOP-_C_MID-e]) linear_extrude(e) _bp_cell(_C_TOP); translate([0,0,BP_H-_BP_LIP]) linear_extrude(e) _bp_cell(_C_TOP+_C_BOT); }
}
module baseplate(nx, ny) {
    w = nx*GF; d = ny*GF;
    difference() {
        translate([0,0,BP_H/2]) linear_extrude(BP_H, center=true) offset(GF_FILLET) offset(-GF_FILLET) square([w,d], center=true);
        for (ix=[0:nx-1], iy=[0:ny-1]) translate([(ix-(nx-1)/2)*GF, (iy-(ny-1)/2)*GF, 0]) _bp_socket();
    }
}

// ---- filler tile ----
// A flat lid over empty grid, so a run of unused cells becomes a working
// surface — mouse, drink, parts tray, wrist rest.
//
// TWO THINGS DRIVE THIS DESIGN, both measured rather than assumed:
//
// 1. FEET GO IN THE CORNERS ONLY, never every cell. Each Clickfinity cell holds
//    with ~12.2 N (4 arms x 3.04 N). A foot in every cell of a 6x6 needs
//    ~438 N — 45 kgf — to lift: not a tile, a permanent fixture, and you break
//    something removing it. Four corner feet cap the release force at ~49 N
//    (5 kgf) at ANY tile size, which is firm enough not to wander and light
//    enough to lift by hand.
// 2. RIBS CARRY THE MIDDLE. With only corner feet, a large tile would sag, so
//    the underside drops ribs onto the plate's grid walls (they bear, they do
//    not latch). Rib depth is BIN_BASE_H - plate_top, which is exactly the
//    height a bin stands proud of that plate.
//
// PLATE_TOP is the plate's top surface above its socket floor, and it differs
// by plate:
//     Clickfinity shallow (PLATE_H 4.00, FLOOR 1.20) -> 2.80   <- the desk
//     standard full-depth  (BP_H 5.85, _BP_FLOOR 1.20) -> 4.65
// Get it wrong and the ribs either float (tile flexes) or hold the feet out of
// the sockets (tile rocks and will not latch).
//
// PRINT UPSIDE DOWN — top face on the bed. Every foot surface then tapers
// inward going up, so the whole part is self-supporting with no overhangs, and
// the working surface comes off the build plate glass-flat instead of as top
// solid infill.
FILLER_TOP_T     = 1.60;   // [1.20:0.20:3.00] top skin. 1.60 = 4 x 0.4 lines, pure perimeter
FILLER_RIB_T     = 1.60;   // [1.20:0.20:3.00] rib + perimeter wall thickness
FILLER_CHAMF     = 1.00;   // [0:0.25:2.00] chamfer on the outer top edge — kills the trip lip
FILLER_PLATE_TOP = 2.80;   // [2.00:0.05:5.00] plate top above socket floor. 2.80 Clickfinity, 4.65 standard

// Corner cells only, de-duplicated so 1xN and 1x1 don't stack feet on themselves.
function _filler_corners(nx, ny) =
    [ for (ix = (nx > 1 ? [0, nx-1] : [0]), iy = (ny > 1 ? [0, ny-1] : [0])) [ix, iy] ];

module filler_tile(nx, ny, plate_top = FILLER_PLATE_TOP, top_t = FILLER_TOP_T,
                   rib = FILLER_RIB_T, chamf = FILLER_CHAMF) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    e = 0.01;
    assert(plate_top < BIN_BASE_H, "FILLER_PLATE_TOP must be below the foot top (4.75)");
    union() {
        // latching feet — corners only
        for (c = _filler_corners(nx, ny))
            translate([(c[0]-(nx-1)/2)*GF, (c[1]-(ny-1)/2)*GF, 0]) _bin_foot();

        // Top skin, with a chamfered outer edge.
        //
        // The skin ends EXACTLY where the chamfer hull starts — no `+e` overlap.
        // Poking e past that plane duplicates the chamfer's outer wall for e of
        // height and CGAL splits it at a computed vertex ~1e-4 off the arc, which
        // reads as a sliver. Same trap _bin_foot() documents above; it cost a
        // render here before the comment was taken at its word.
        translate([0,0,BIN_BASE_H]) linear_extrude(top_t - chamf)
            offset(BIN_R) offset(-BIN_R) square([W,D], center=true);
        if (chamf > 0)
            hull() {
                translate([0,0,BIN_BASE_H + top_t - chamf]) linear_extrude(e)
                    offset(BIN_R) offset(-BIN_R) square([W,D], center=true);
                translate([0,0,BIN_BASE_H + top_t - e]) linear_extrude(e)
                    offset(BIN_R) offset(-BIN_R) square([W-2*chamf, D-2*chamf], center=true);
            }

        // perimeter wall + ribs on the cell lines, bearing on the plate's grid walls
        translate([0,0,plate_top]) linear_extrude(BIN_BASE_H - plate_top) {
            difference() {
                offset(BIN_R) offset(-BIN_R) square([W,D], center=true);
                offset(BIN_R) offset(-BIN_R) square([W-2*rib, D-2*rib], center=true);
            }
            for (ix = [1:max(nx-1,0)]) if (nx > 1)
                translate([(ix-nx/2)*GF, 0]) square([rib, D], center=true);
            for (iy = [1:max(ny-1,0)]) if (ny > 1)
                translate([0, (iy-ny/2)*GF]) square([W, rib], center=true);
        }
    }
}

// ---- bin ----
// The foot's cross-section at inset i: a rounded square of side BIN_SZ - 2i,
// nominal corner radius BIN_R - i.
//
// Known deviation, left in deliberately. offset(r = -i) insets the outline
// after it has been tessellated, so it eats into the facet chords rather than
// the true curve and the corner radius lands under nominal by roughly the arc's
// sagitta — at inset 2.15 the radius measures 1.5896 at $fn = 32 and 1.5974 at
// $fn = 64 against a nominal 1.60. The flats are exact; only the corners move,
// by at most 0.014 mm, and the error shrinks as $fn rises.
//
// Building the profile as a hull of four circles at radius BIN_R - i hits
// nominal exactly at every $fn and would retire both the deviation and its
// $fn-dependence. Not done here: it shifts the printed foot on parts already
// fit-tested against a 0.25 mm clearance band, and it does nothing for the
// sliver bug below — measured, not assumed. See lib/selftest_fn.scad.
module _bin_cell(i = 0) { offset(r = -i) offset(r = BIN_R) offset(r = -BIN_R) square(BIN_SZ, center = true); }
// Each hull's end slab sits *inside* the span it defines — `0.8-e` and
// `BIN_BASE_H-e`, never `0.8` and `BIN_BASE_H`. Don't "tidy" the `-e` away.
//
// A slab that pokes e past the plane where the next solid starts duplicates
// that solid's outer wall for e of height, and CGAL then has to split the wall
// at z = plane + e. The split vertex is computed rather than copied, so it
// lands ~1e-4 mm off the arc vertex it should coincide with, leaving sliver
// triangles that read as non-manifold edges once tools/validate_stl.py rounds
// coordinates to 4 decimals. The slivers were always there; which ($fn, nx)
// pairs happened to collapse a sliver into a duplicate edge was luck, which is
// why raising $fn never helped. See lib/selftest_fn.scad for the failure map.
module _bin_foot() {
    e = 0.01;
    hull() { linear_extrude(e) _bin_cell(2.95); translate([0,0,0.8-e]) linear_extrude(e) _bin_cell(2.15); }  // bottom chamfer
    translate([0,0,0.8]) linear_extrude(1.8) _bin_cell(2.15);                                                 // vertical
    hull() { translate([0,0,2.6]) linear_extrude(e) _bin_cell(2.15); translate([0,0,BIN_BASE_H-e]) linear_extrude(e) _bin_cell(0); } // top chamfer
}
// Solid bin body: Gridfinity feet + the block above them, with no cavity cut.
// Cup-style bins (lib/vessel.scad) subtract their own bores from this instead of
// re-deriving the foot + shell union.
module bin_blank(nx, ny, h) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    union() {
        for (ix=[0:nx-1], iy=[0:ny-1]) translate([(ix-(nx-1)/2)*GF, (iy-(ny-1)/2)*GF, 0]) _bin_foot();
        translate([0,0,BIN_BASE_H]) linear_extrude(h-BIN_BASE_H) offset(BIN_R) offset(-BIN_R) square([W,D], center=true);
    }
}

module _bin_shell(nx, ny, h, wall, floor) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    difference() {
        bin_blank(nx, ny, h);
        translate([0,0,BIN_BASE_H+floor]) linear_extrude(h) offset(BIN_R-wall) offset(-(BIN_R-wall)) square([W-2*wall, D-2*wall], center=true);
    }
}
module bin(nx, ny, h, wall = 1.2, floor = 1.4) { _bin_shell(nx, ny, h, wall, floor); }

// ---- stacking base ----

// The lower compartment's 2D profile: a rounded rect, swept `front` mm toward
// −Y when the front is open (front = 0 leaves the plain closed pocket).
module _stack_pocket(iw, id, r, front) {
    hull() {
        offset(r) offset(-r) square([iw, id], center = true);
        translate([0, -front]) offset(r) offset(-r) square([iw, id], center = true);
    }
}

// A bin whose TOP is a Gridfinity baseplate, so a standard bin socket-stacks on
// it (two-tier towers: instrument on top, cords/jig/adapters in the base). The
// base is open at the FRONT (−Y) by default so the lower item is reachable while
// the top tier stays socketed — same idea as drybox-splitter-stand's open cubby.
// The whole tower foots on the bench baseplate via this base's own foot.
//
//   h = interior height of the lower compartment (floor to the baseplate cap).
module stack_base(nx, ny, h, wall = 1.2, floor = 1.4, open_front = true) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    z0 = BIN_BASE_H + floor;
    iw = W - 2*wall; id = D - 2*wall;
    difference() {
        union() {
            bin_blank(nx, ny, h);                    // solid foot + block to h
            translate([0,0,h]) baseplate(nx, ny);    // baseplate cap (sockets up)
        }
        // Lower cavity, floor up to the cap underside. An open front is swept
        // into the same 2D profile rather than cut by a second solid, so the
        // pocket is one prism.
        //
        // The old code cut the front with its own cube, and got it wrong twice
        // over: the cube spanned −D to −D/2 + 0.01, which shaved 0.01 mm off
        // the outside and left the wall standing (11.7 mm³ removed where the
        // opening wants ~1590). Widening it to reach the cavity then put the
        // cube's side walls exactly on the cavity's, and coincident walls are
        // what leave slivers behind — see _bin_foot above. Sweeping the profile
        // sidesteps both: there's only ever one wall to be on.
        translate([0,0,z0]) linear_extrude(h - z0 + 0.01)
            _stack_pocket(iw, id, BIN_R - wall, open_front ? D : 0);
    }
}

// A plain bin with its FRONT (-Y) wall swept away, so contents roll or slide out
// rather than being lifted over a rim — and the top stays open for reloading.
//
// The opening is made by hulling the cavity profile with a copy of itself
// translated -D, NOT by cutting the front with a second solid. That matters:
// a second cutter puts its side walls exactly on the cavity's own walls, and
// coincident walls are what leave the sliver triangles documented on _bin_foot.
// Sweeping one profile means there is only ever one wall to be on.
//
// Promoted here from instrument-holders 2026-08-20 on its second consumer
// (bench-cleaning-station's swab bin), per the rule that a shared module earns
// its place at two.
module open_front_bin(nx, ny, h, wall = 1.2, floor = 1.4) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    iw = W - 2*wall; id = D - 2*wall; r = BIN_R - wall;
    difference() {
        bin_blank(nx, ny, h);
        translate([0, 0, BIN_BASE_H + floor]) linear_extrude(h)
            _stack_pocket(iw, id, r, D);
    }
}

module divided_bin(nx, ny, h, cols = 1, rows = 1, wall = 1.2, floor = 1.4, div = 1.2) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    union() {
        bin(nx, ny, h, wall, floor);
        // internal divider walls (from the floor up to the rim)
        iw = W - 2*wall; id = D - 2*wall; z0 = BIN_BASE_H + floor;
        for (c = [1 : cols-1]) translate([-iw/2 + c*iw/cols - div/2, -id/2, z0]) cube([div, id, h - z0]);
        for (r = [1 : rows-1]) translate([-iw/2, -id/2 + r*id/rows - div/2, z0]) cube([iw, div, h - z0]);
    }
}

// ---- lid ----
// Friction lid for a bin of the same footprint: a flat plate with a skirt that
// drops into the bin's cavity. Emitted PRINT-READY — plate on the bed, skirt
// standing up — so it needs no supports. Flip it in your head to picture it
// fitted: the plate then caps the rim and the lid adds `t` to the stack height.
//
// Why lids exist here: full-extension drawer slides let small parts hop between
// compartments on a hard close, and brass inserts aren't magnetic — you can't
// sweep them back. `wall` must match the bin's wall so the skirt lands in the
// cavity; `clearance` is per-side slop between skirt and cavity.
module lid(nx, ny, t = 1.6, skirt = 4, wall = 1.2, clearance = 0.35, lid_wall = 1.6) {
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    iw = W - 2*wall - 2*clearance; id = D - 2*wall - 2*clearance;   // skirt outer
    ir = BIN_R - wall;                                              // cavity corner radius
    union() {
        linear_extrude(t) offset(BIN_R) offset(-BIN_R) square([W, D], center=true);
        translate([0,0,t]) linear_extrude(skirt) difference() {
            offset(ir) offset(-ir) square([iw, id], center=true);
            offset(ir-lid_wall) offset(-(ir-lid_wall)) square([iw-2*lid_wall, id-2*lid_wall], center=true);
        }
    }
}
