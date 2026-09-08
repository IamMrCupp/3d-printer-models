// respool_stand — the source spool rides this while you wind onto the printed one.
//
// PRINT: as emitted, feet down. No supports — the post is a plain cylinder
// standing on a flat base and carries itself.
include <respool_common.scad>
$fn = 96;
union() {
    bin_blank(NX, NY, BASE_H);
    translate([0, 0, BASE_H - POST_SINK]) {
        cylinder(d = POST_D, h = POST_H + POST_SINK - POST_CHAM);
        translate([0, 0, POST_H + POST_SINK - POST_CHAM])
            cylinder(d1 = POST_D, d2 = POST_D - 2*POST_CHAM, h = POST_CHAM);
    }
}
