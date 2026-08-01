// gridfinity.scad — shared Gridfinity baseplate + bin library (per spec).
//
// 42 mm pitch, 41.5 mm bins, baseplate socket 0.7/1.8/2.15 = 4.65 mm, 4 mm
// fillet; bin foot 0.8/1.8/2.15 = 4.75 mm, 3.75 mm corner radius. Verified the
// bin foot seats in the baseplate socket with ~0.25–0.5 mm clearance.
//
//   baseplate(nx, ny)                      — tiled receiving baseplate
//   bin_blank(nx, ny, h)                   — solid bin body (feet + block, no cavity)
//   bin(nx, ny, h, wall, floor)            — open Gridfinity bin
//   divided_bin(nx, ny, h, cols, rows, …)  — bin with internal compartments
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
