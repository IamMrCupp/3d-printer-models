// bin_stencil_bucket — 2×2 bin, four bays, for the BAGGED stencil packs standing
// on edge.
//
// HOW YOU USE IT:
//   Four bays, one per ball size, bags filed on edge like records. You flip to
//   the size you want and lift the bag out. The bags stand proud of the rim, so
//   there is always something to pinch.
//
// WHY THIS EXISTS SEPARATELY FROM bin_bga_rack. The rack's slots are 7.78 mm and
// the largest bagged pack is over 12.7 — less than two thirds of what it needs,
// which is why the packs never fitted. The rack is NOT being redesigned: it
// keeps the jig and takes the flat, thin things (iPhone-sized stencils, trace
// repair sheets, paste scrapers, the two 1"×1" glass plates in their bags). The
// bulky bagged packs come here.
//
// THE BAG SIZE IS NOT A TIGHT DIMENSION, AND THAT IS THE POINT. The largest bare
// stencil is 50 × 50, so its bag is somewhere above 50 and nowhere near the
// 81.1 mm a 2-wide interior gives. A bucket does not need to trace its contents
// — it needs to swallow them and keep them sorted. Nothing here is cut to a
// number nobody measured; the bay depth is simply the whole interior.
//
// HEIGHT IS A GRAB ALLOWANCE, NOT CAPACITY. At 38 mm a bag holding a 50 mm
// stencil stands at least ~15 mm proud. Burying it would need a taller bin for
// no gain and would make the bags harder to get out, which is the same reasoning
// the rack's slots were built on.
//
// GROWTH IS A SECOND BUCKET, NOT A BIGGER ONE. The collection is expected to
// keep growing. A 2×2 latches anywhere on the grid, so another print gives four
// more bays alongside — which beats guessing today how big the collection gets.
// N_BAY is parametric if you would rather subdivide further.
//
// PRINT: as emitted, feet down. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../lib/gridfinity.scad>

/* [Contents] */
STENCIL_W = 50.0;   // largest bare stencil, measured — the bag is bigger than this
N_BAY     = 4;      // [2:1:8] one bay per ball size; there are four bags

/* [Bin] */
NX = 2; NY = 2;
DEPTH  = 38 - BIN_BASE_H - 1.4;   // usable depth; see HEIGHT note above
WALL   = 1.2;
DIV    = 2.0;       // [1.2:0.2:4] divider between bays
FLOOR  = 1.4;

BUCKET_H = BIN_BASE_H + FLOOR + DEPTH;

W  = NX*GF - 0.5;  D = NY*GF - 0.5;
IW = W - 2*WALL;   ID = D - 2*WALL;
Z0 = BIN_BASE_H + FLOOR;

BAY = (IW - (N_BAY - 1)*DIV) / N_BAY;

assert(BAY >= 12.7 + 1.0,
       str("Bays are ", BAY, " mm — the largest pack is over 12.7 thick and will not go in."));
assert(ID > STENCIL_W + 4,
       str("A ", STENCIL_W, " mm stencil's bag will not lie in a ", ID, " mm bay."));
assert(BUCKET_H < STENCIL_W - 8,
       "Bin is too tall — the bags would sit flush or buried with nothing to grab.");
echo(str(N_BAY, " bays of ", BAY, " mm across ", IW, "; bay depth ", ID,
         "; rim at ", BUCKET_H, " so a ", STENCIL_W, " mm stencil stands ",
         STENCIL_W - BUCKET_H, "+ mm proud"));

difference() {
    bin_blank(NX, NY, BUCKET_H);
    for (i = [0 : N_BAY - 1])
        translate([-IW/2 + i*(BAY + DIV), -ID/2, Z0])
            cube([BAY, ID, DEPTH + 0.1]);
}
