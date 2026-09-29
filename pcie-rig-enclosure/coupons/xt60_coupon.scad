// xt60_coupon.scad — the last panel cutouts, tried before the cup prints.
//
// A 3 mm plate, the wall's thickness, with the XT60E-M (rear, input) cutout on
// the left and the XT60E-F (right wall, outputs) on the right, both from the
// XT60M / XT60F calipers in rig_common.scad. Labels on the bed face, mirrored.
// Push each connector in and screw it to its ears; if both seat, print the cup.
//
// Until XT60_MEASURED is true this is a blank plate and says so.

include <../rig_common.scad>
use <../rig_cup.scad>

T = WALL;
module xt60_hole(x) {
    if (XT60_MEASURED) {
        translate([0, 0, T/2]) cube([x[0], x[1], T*3], center = true);
        for (sx = [-1, 1]) translate([sx*x[2]/2, 0, -1]) cylinder(d = x[3], h = T + 2);
    }
}
module bed_text(txt) { mirror([1, 0, 0]) mirror([0, 0, 1]) label_pocket(txt, 4, LABEL_DEPTH); }

difference() {
    translate([-40, -18, 0]) cube([80, 36, T]);
    translate([-20, 3, 0]) xt60_hole(XT60M);
    translate([ 20, 3, 0]) xt60_hole(XT60F);
    translate([-20, -12, 0]) bed_text("M IN");
    translate([ 20, -12, 0]) bed_text("F OUT");
}

if (!XT60_MEASURED) echo("WARNING: xt60_coupon is a blank plate — XT60_MEASURED is false.");
