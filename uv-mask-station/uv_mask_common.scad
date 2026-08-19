// uv_mask_common — deep-bore, capped rack for UV-curable mask syringes.
// The mask cures under 365 nm, so ambient light skins it. Syringes sit TIP-DOWN
// in deep opaque bores (tip + most of the barrel shielded); an opaque CAP covers
// the stubs that stick up. Print BOTH in opaque filament (not clear/natural).
include <../lib/syringe.scad>
UVM_D      = 18.8;   // 10 ml syringe barrel — see syringe-holders/syringe_holders_common.scad
UVM_COLS   = 3; UVM_ROWS = 3;   // 9 slots (holds 7: 2 green + 5 others)
UVM_DEPTH  = 65;     // bore depth — swallows the tip + most of a ~100 mm syringe
UVM_NX = 2; UVM_NY = 2;   // 2x1 cannot hold 8 bores at 18.8 — it fits three

/* [Cap] */
// The cap was a plain box over a plain block: 0.25 mm per side, friction only,
// nothing holding it on. For a cap whose whole job is keeping UV off the mask,
// coming off unnoticed is the failure that matters — you find out weeks later
// when the syringes have skinned. So: four detents, one centred on each wall.
//
// Point contacts, not a continuous bead. A bead has to be right everywhere at
// once and is unforgiving to tune; four bumps can be sanded back if they bind.
CAP_WALL = 2.5;   // [2:0.5:4]
CAP_TOP  = 2.0;   // [1.5:0.5:4] solid roof
CAP_CLR  = 0.5;   // [0.3:0.1:1.2] total, so half of this per side
CAP_H    = 42;    // [30:1:60] cavity depth. Stub height = syringe length - UVM_DEPTH

DET_R     = 2.5;  // [1.5:0.5:4] bump sphere radius
DET_PROUD = 0.6;  // [0.3:0.1:1.2] how far it stands into the gap.
                  //   CATCH DEPTH = DET_PROUD - CAP_CLR/2, and the bump rubs the
                  //   block by that same amount all the way down. UNVERIFIED on
                  //   this printer — print coupons/cap_detent_gauge.scad first.
DET_UP    = 6.0;  // [3:0.5:12] bump centre, measured UP from the cap's mouth

// Block height, derived — do not hardcode 71.15.
UVM_BLOCK_H = UVM_DEPTH + BIN_BASE_H + 1.4;

CAP_CAV   = UVM_NX*GF - 0.5 + CAP_CLR;     // cavity across flats
BLOCK_W   = UVM_NX*GF - 0.5;

// Detent centres. The two must agree or the cap simply will not click, so both
// are derived from the same DET_UP rather than written down twice.
CAP_DET_Z   = CAP_TOP + CAP_H - DET_UP;          // in the cap's own emitted frame
BLOCK_DET_Z = UVM_BLOCK_H - CAP_H + DET_UP;      // in the block's frame

// Male bumps for the cap, female dimples for the block: same call, different
// offset, so they cannot drift apart.
module uvm_detents(across, z, r = DET_R, proud = DET_PROUD) {
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([across/2 + r - proud, 0, z]) sphere(r = r, $fn = 32);
}

// Cap that slides over the block top, covering the protruding syringe stubs.
//
// EMITTED TOP-DOWN, and that is the orientation to print it in: the solid 2 mm
// top lies on the bed, the walls rise from it, and the mouth faces up.
//
// Do NOT print it mouth-down. The cavity is 84 mm across, so closing the top
// last means bridging 84 mm of open air — it sags, and the sag is on the face
// that has to sit flat over the rack. An earlier version of this file emitted
// mouth-down and the README recommended it, reasoning that the sealing rim
// wants to be on the bed. The rim does print marginally crisper that way; an
// 84 mm bridge is not a trade worth making for it.
module uvm_cap() {
    W = UVM_NX*GF - 0.5; D = UVM_NY*GF - 0.5;
    clr = CAP_CLR; wall = CAP_WALL; top = CAP_TOP; h = CAP_H;
    union() {
        difference() {
            translate([-(W+2*wall)/2, -(D+2*wall)/2, 0]) cube([W+2*wall, D+2*wall, h+top]);
            // Cavity opens UPWARD: starts above the solid top, runs out through z-max.
            translate([-(W+clr)/2, -(D+clr)/2, top]) cube([W+clr, D+clr, h+0.1]);
        }
        // Bumps stand INTO the cavity. A sphere on a vertical wall is a shallow
        // overhang at this radius and prints without support.
        intersection() {
            uvm_detents(CAP_CAV, CAP_DET_Z);
            translate([-(W+clr)/2, -(D+clr)/2, top]) cube([W+clr, D+clr, h]);
        }
    }
}

// The block's matching dimples. Subtracted by bin_uv_mask.
module uvm_block_detents() { uvm_detents(BLOCK_W, BLOCK_DET_Z); }
