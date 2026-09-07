// bin_iron_tips — 1×1, sixteen bores for soldering iron tips standing on end.
//
// Calipered 2026-09-07: tips are ⌀6.22 and 41.6 mm long, and there are 14–15 of
// them. Sixteen bores covers either count with spares.
//
// A 1×1 IS THE RIGHT SIZE, NOT A COMPROMISE. At a 9.62 mm pitch a single cell
// takes 4×4 = 16. A 2×1 would take 32 — twice the grid for tips that do not
// exist. The tips are small; the bin should be too.
//
// BORE DEPTH IS THE ONLY REAL DECISION. Too shallow and a 41.6 mm tip topples;
// too deep and there is nothing left to pinch. At BORE_DEEP the tip stands
// proud by the amount echoed below — aim for a good 15 mm of grip.
//
// PRINT: as emitted, feet down. No supports — the bores are open-topped holes,
// not overhangs.
include <../lib/gridfinity.scad>

NX = 1; NY = 1;
H          = 32;      // [20:1:50]
FLOOR      = 2.0;
WALL       = 1.2;

TIP_D      = 6.22;    // calipered shank ⌀
TIP_L      = 41.6;    // calipered length
TIP_CLR    = 0.40;    // tips must drop in and lift out one-handed
BORE_D     = TIP_D + TIP_CLR;
GAP        = 3.0;     // material between bores
PITCH      = BORE_D + GAP;

IW    = NX*GF - 0.5 - 2*WALL;
COUNT = floor((IW + GAP) / PITCH);
BORE_DEEP = H - BIN_BASE_H - FLOOR;
PROUD     = TIP_L - BORE_DEEP;

EPS = 0.01;

assert(BORE_DEEP > TIP_L/2, "Bore is shallower than half a tip — they will topple.");
assert(PROUD > 10, str("Only ", PROUD, " mm of tip proud — not enough to pinch."));
echo(str(COUNT, "x", COUNT, " = ", COUNT*COUNT, " bores at ", PITCH, " mm pitch; ",
         BORE_DEEP, " mm deep, tip stands ", PROUD, " mm proud"));

difference() {
    bin_blank(NX, NY, H);
    for (ix = [0 : COUNT-1], iy = [0 : COUNT-1])
        translate([(ix - (COUNT-1)/2) * PITCH,
                   (iy - (COUNT-1)/2) * PITCH,
                   H - BORE_DEEP])
            // Through the top face, never stopping on it.
            cylinder(d = BORE_D, h = BORE_DEEP + EPS, $fn = 48);
}
