// uv_mask_common — deep-bore, capped rack for UV-curable mask syringes.
// The mask cures under 365 nm, so ambient light skins it. Syringes sit TIP-DOWN
// in deep opaque bores (tip + most of the barrel shielded); an opaque CAP covers
// the stubs that stick up. Print BOTH in opaque filament (not clear/natural).
include <../lib/syringe.scad>
UVM_D      = 18.8;   // 10 ml syringe barrel — see syringe-holders/syringe_holders_common.scad
UVM_COLS   = 3; UVM_ROWS = 3;   // 9 slots (holds 7: 2 green + 5 others)
UVM_DEPTH  = 65;     // bore depth — swallows the tip + most of a ~100 mm syringe
UVM_NX = 2; UVM_NY = 2;   // 2x1 cannot hold 8 bores at 18.8 — it fits three

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
    clr = 0.5; wall = 2.5; top = 2; h = 42;
    difference() {
        translate([-(W+2*wall)/2, -(D+2*wall)/2, 0]) cube([W+2*wall, D+2*wall, h+top]);
        // Cavity opens UPWARD: starts above the solid top, runs out through z-max.
        translate([-(W+clr)/2, -(D+clr)/2, top]) cube([W+clr, D+clr, h+0.1]);
    }
}
