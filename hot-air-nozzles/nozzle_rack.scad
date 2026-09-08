// nozzle_rack — 6×1, nine posts, hot air nozzles tip-up.
//
// PRINT: as emitted, feet down. No supports — the posts are plain cylinders on a
// flat base and carry themselves.
include <nozzle_rack_common.scad>
$fn = 96;
union() {
    bin_blank(NX, NY, BASE_H);
    for (i = [0 : COUNT-1])
        translate([(i - (COUNT-1)/2) * PITCH, 0, BASE_H - POST_SINK]) {
            cylinder(d = POST_D, h = POST_H + POST_SINK - POST_CHAM);
            translate([0, 0, POST_H + POST_SINK - POST_CHAM])
                cylinder(d1 = POST_D, d2 = POST_D - 2*POST_CHAM, h = POST_CHAM);
        }
}
