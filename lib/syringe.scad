// syringe.scad — bore-grid racks: a Gridfinity block drilled with a 2D array of
// vertical holes. Syringes, barrel tips, rotary burrs — same form, different
// numbers.
//
// This is a layout helper over collar_cup_multi(), not new geometry. The bores
// are VERTICAL: no overhangs to print, densest packing, shortest block. Tilting
// them toward the user reads better and plucks easier, but costs all three —
// revisit only if upright proves annoying in practice.
//
// Bore depth is a CAPTURE depth, not the item's length. A 125 mm syringe in a
// 35 mm bore stands like a pen in a cup; the block doesn't grow to swallow it.
//
//   bore_grid(cols, rows, d, px, py)          — position list, for composing
//   syringe_rack(nx, ny, cols, rows, d, …)    — the finished rack
//
// Auto-pitch: with pitch = nx*GF/cols and the grid centred, the margin from the
// outermost bore's centre to the block edge is exactly pitch/2 — so a single
// condition, pitch >= bore + 2*min_wall, guards BOTH inter-bore webs and the
// outer wall. That's what the assert below checks. It is not decoration: a
// plausible-looking spec (10 mm syringes, 6 across a 2-unit block) leaves a
// 0.84 mm outer wall, which you would otherwise find out about on the printer.

include <vessel.scad>

SYR_CLR      = 1.0;   // bore = syringe_d + SYR_CLR (per diameter, not per side)
SYR_MIN_WALL = 1.2;   // minimum web between bores, and bore to outer face

// Bore centres for a cols × rows grid, centred on the origin.
function bore_grid(cols, rows, d, px, py) =
    [for (c = [0 : cols-1], r = [0 : rows-1])
        [(c - (cols-1)/2) * px, (r - (rows-1)/2) * py, d]];

// Rack of identical bores. pitch_x / pitch_y default to an even spread across
// the block footprint; pass them explicitly to pack tighter and leave a margin.
module syringe_rack(nx, ny, cols, rows, syringe_d, capture_h = 35,
                    floor = 1.4, clr = SYR_CLR, min_wall = SYR_MIN_WALL,
                    pitch_x = 0, pitch_y = 0) {
    px   = pitch_x > 0 ? pitch_x : nx * GF / cols;
    py   = pitch_y > 0 ? pitch_y : ny * GF / rows;
    bore = syringe_d + clr;

    assert(px >= bore + 2 * min_wall,
           "syringe_rack: too many columns — bores would merge or breach the outer wall");
    assert(py >= bore + 2 * min_wall,
           "syringe_rack: too many rows — bores would merge or breach the outer wall");

    collar_cup_multi(nx, ny, bore_grid(cols, rows, syringe_d, px, py),
                     capture_h, floor, clr);
}
