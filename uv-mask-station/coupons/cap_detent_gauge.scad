// cap_detent_gauge — PRINT THIS BEFORE THE CAP AND THE RACK.
//
// Two short rings that reproduce the cap/block detent at full size: same
// 83.5 mm span, same wall thicknesses, same 0.25 mm per-side gap, same detent
// height above the mouth. Push one onto the other and judge the click.
//
// WHAT IT IS TESTING: not the diameter — the CATCH DEPTH.
//   catch = DET_PROUD - CAP_CLR/2  (0.60 - 0.25 = 0.35 mm at the defaults)
// and the bump rubs the block by that same amount for the whole 36 mm of
// insertion on the real part. Too deep and the cap is a fight to fit and
// scrapes; too shallow and it lifts off when you brush it. Neither has been
// verified on this printer, and the failure mode is the expensive kind — a cap
// that quietly falls off lets 365 nm at the mask and you find out weeks later.
//
// WHY FULL SPAN: the click comes from the cap wall flexing. A short test piece
// is stiffer than the real 83.5 mm wall, so it would read tighter than the part
// and send you to a value that ends up too weak. The span is the point.
//
// HOW TO USE
//   1. Print both. Any material — but if your cap will be PETG, print this in
//      PETG; the spring differs.
//   2. Push the ring onto the stub. You want a definite click, held against a
//      shake, released by a deliberate pull.
//   3. Too tight / scrapes  -> lower DET_PROUD.  Falls off -> raise it.
//      Re-render with:  openscad -D DET_PROUD=0.8 -o gauge.stl ...
//   4. Tell me the value that works and I will set it in uv_mask_common.scad.
//
// ~26 g against 384 cm³ of block and cap in opaque filament.
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp

include <../uv_mask_common.scad>

H       = 12;    // [8:1:20] ring height — must exceed DET_UP with room to spare
STUB_W  = 3.0;   // [2:0.5:5] block-stub wall. The real block is solid; this only
                 //   has to be rigid enough not to flex, which at 83.5 mm it is.
GAP     = 8;     // [4:1:20] space between the two pieces on the bed

assert(H > DET_UP + 3, "Ring is too short to contain the detent plus a lead-in.");

// Block stub: outer face where the real block's is, dimples at DET_UP.
translate([-(BLOCK_W + GAP + CAP_CAV/1 + 2*CAP_WALL)/2 + BLOCK_W/2, 0, 0])
difference() {
    linear_extrude(H) offset(BIN_R) offset(-BIN_R) square([BLOCK_W, BLOCK_W], center = true);
    translate([0, 0, -0.1])
        linear_extrude(H + 0.2) square([BLOCK_W - 2*STUB_W, BLOCK_W - 2*STUB_W], center = true);
    uvm_detents(BLOCK_W, DET_UP);
}

// Cap ring: cavity where the real cap's is, bumps at the same height.
translate([(BLOCK_W + GAP + CAP_CAV + 2*CAP_WALL)/2 - (CAP_CAV/2 + CAP_WALL), 0, 0])
union() {
    difference() {
        linear_extrude(H) square([CAP_CAV + 2*CAP_WALL, CAP_CAV + 2*CAP_WALL], center = true);
        translate([0, 0, -0.1]) linear_extrude(H + 0.2) square([CAP_CAV, CAP_CAV], center = true);
    }
    intersection() {
        uvm_detents(CAP_CAV, DET_UP);
        linear_extrude(H) square([CAP_CAV, CAP_CAV], center = true);
    }
}
