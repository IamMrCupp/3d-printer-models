// vessel.scad — parametric collar cups for bottles, cans, and pen-form tools.
//
// A collar cup is a solid Gridfinity block with cylindrical bores sunk into it.
// It LOCATES a vessel; it does not clamp one. That distinction is the whole
// design: a collar that grips harder than the bin weighs comes out of the
// baseplate with the bottle when you grab it one-handed. Clearance, not
// interference — CLR is per-diameter, not per-side.
//
// Capture depth is roughly a third of the vessel's height. Enough to resist a
// knock (this bench sits under a 180 W fume-extractor intake), not so much that
// you're fishing the bottle out.
//
//   collar_cup(nx, ny, vessel_d, capture_h, …)   — one centred bore
//   collar_cup_multi(nx, ny, bores, capture_h, …) — bores = [[x, y, d], …]
//
// Cord slot: pen-form tools that stand in a cup are usually corded (the HARDELL
// rotary tool takes a barrel jack). Without a slot the lead drapes over the rim
// and levers the tool sideways. `cord_w > 0` cuts a channel from the bore out
// through the wall, open to the top.

include <gridfinity.scad>

CLR      = 1.0;   // bore = vessel_d + CLR. Loose on purpose — see above.
MIN_WALL = 1.2;   // minimum material between two bores, and bore to outer face

// ---- geometry guards ----
// Overlapping bores and bores that break out through the side wall both still
// render as perfectly watertight, 2-manifold meshes — CI cannot tell you the
// part is wrong, only that it is closed. These asserts encode the intent that
// the mesh check can't. Cheap, and they fire at render time rather than on the
// printer.
function _pair_gaps(bores, clr) = [
    for (i = [0 : len(bores)-1], j = [0 : len(bores)-1]) if (i < j)
        norm([bores[i][0]-bores[j][0], bores[i][1]-bores[j][1]])
        - (bores[i][2]+clr)/2 - (bores[j][2]+clr)/2
];
function _edge_gaps(bores, clr, W, D) = [
    for (b = bores) min(W/2 - abs(b[0]) - (b[2]+clr)/2,
                        D/2 - abs(b[1]) - (b[2]+clr)/2)
];

// Multi-bore block. Bores are [x, y, diameter] in mm, relative to the block centre.
module collar_cup_multi(nx, ny, bores, capture_h, floor = 1.4, clr = CLR,
                        cord_w = 0, cord_at = 0, min_wall = MIN_WALL) {
    h = BIN_BASE_H + floor + capture_h;
    e = 0.1;
    W = nx*GF - 0.5; D = ny*GF - 0.5;
    _pg = _pair_gaps(bores, clr);
    _eg = _edge_gaps(bores, clr, W, D);
    assert(len(_pg) == 0 || min(_pg) >= min_wall,
           "collar_cup: bores are too close — they would merge into one pocket");
    assert(min(_eg) >= min_wall,
           "collar_cup: a bore breaches the outer wall — block needs more units");
    difference() {
        bin_blank(nx, ny, h);
        for (b = bores)
            translate([b[0], b[1], BIN_BASE_H + floor])
                cylinder(d = b[2] + clr, h = capture_h + e, $fn = 96);
        // Cord channel: from the first bore outward through the +X wall, open to
        // the rim so the lead drops in from above rather than threading.
        if (cord_w > 0)
            translate([bores[0][0], bores[0][1] - cord_w/2, BIN_BASE_H + floor + cord_at])
                cube([nx*GF, cord_w, h]);
    }
}

// Single centred bore — the common case.
module collar_cup(nx, ny, vessel_d, capture_h, floor = 1.4, clr = CLR,
                  cord_w = 0, cord_at = 0, min_wall = MIN_WALL) {
    collar_cup_multi(nx, ny, [[0, 0, vessel_d]], capture_h, floor, clr,
                     cord_w, cord_at, min_wall);
}

// Evenly spaced row of same-depth bores along X — for a rank of aerosol cans.
// Returns geometry, not a list; pass the diameters and it lays them out on the
// block's centre line.
module collar_cup_row(nx, ny, diameters, capture_h, floor = 1.4, clr = CLR,
                      min_wall = MIN_WALL) {
    n = len(diameters);
    pitch = nx * GF / n;
    collar_cup_multi(nx, ny,
        [for (i = [0 : n-1]) [(i - (n-1)/2) * pitch, 0, diameters[i]]],
        capture_h, floor, clr, 0, 0, min_wall);
}
