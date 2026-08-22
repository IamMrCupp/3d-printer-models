// bin_bga_rack — 3×3 bin: the AMAOE reballing jig lying flat, plus four slots
// for the stencil bags standing on end.
//
// The jig is 85.17 × 85.18 × 15 and LIES FLAT — at 20 mm deep it just drops in.
// The stencils (largest 50 × 50) STAND ON END in narrow slots and deliberately
// stand proud of the rim: a slot's job is to hold them upright and sorted, not
// to swallow them. Burying a 50 mm stencil would need a 56 mm bin for no gain.
//
// WHY 3×3. The jig is 85.18 across, which does not fit a 3×2's 81.1 mm interior.
// 3×3 gives 123.1 square — the jig compartment takes 87.2 and the remaining
// ~31 mm carries the stencil slots.
//
// FOUR slots because there are four bags, sorted by ball size. One bag per slot
// keeps that sorting rather than pooling them.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/gridfinity.scad>

/* [Contents] */
JIG_W     = 85.18;  // AMAOE jig across, measured (85.17 × 85.18, square enough)
JIG_CLR   = 2.0;    // [1:0.5:4] a rigid block dropping in, not a fit
N_STENCIL = 4;      // [2:1:6] one slot per bag

/* [Bin] */
NX = 3; NY = 3;
DEPTH  = 20;        // [10:1:60] usable depth — set by the 15 mm jig lying flat
WALL   = 1.2;
DIV    = 1.2;       // [1:0.2:3] divider thickness
FLOOR  = 1.4;

// AFTER FLOOR. OpenSCAD evaluates in file order, so a forward reference here
// silently yields undef — and the part still renders and still passes the mesh
// check, just at the wrong height.
RACK_H = BIN_BASE_H + FLOOR + DEPTH;

W  = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;   ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

JIG_BAY = JIG_W + JIG_CLR;
STENCIL_SLOT = (ID - JIG_BAY - N_STENCIL*DIV) / N_STENCIL;

assert(STENCIL_SLOT >= 4,
       str("Stencil slots collapse to ", STENCIL_SLOT, " mm — fewer slots, or 4×3."));
assert(JIG_BAY <= ID, "Jig bay is wider than the bin interior.");
echo(str("jig bay ", JIG_BAY, " x ", IW, " mm; ", N_STENCIL,
         " stencil slots of ", STENCIL_SLOT, " mm"));

// Dividers are ADDED to the shell, never cut from it — subtracting them slots
// the outer walls open instead of partitioning the inside, and that renders as a
// perfectly watertight mesh with the right bounding box.
union() {
    bin(NX, NY, RACK_H, wall = WALL, floor = FLOOR);
    for (i = [0 : N_STENCIL - 1])
        translate([-IW/2, -ID/2 + JIG_BAY + i*(STENCIL_SLOT + DIV), Z0])
            cube([IW, DIV, RACK_H - Z0]);
}
