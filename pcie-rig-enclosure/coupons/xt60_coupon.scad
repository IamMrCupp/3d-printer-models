// xt60_coupon.scad — the last panel cutouts, tried before the cup prints.
//
// A 3 mm plate, the wall's thickness, with the XT60E-M (rear, input) cutout on
// the left and the XT60E-F (right wall, outputs) on the right, both from the
// XT60M / XT60F calipers in rig_common.scad. Labels on the bed face, mirrored.
// Push each connector in and screw it to its ears; if both seat, print the cup.
//
// Each measured connector gets a row with two clearances (0.30 / 0.60 per side);
// the model uses XT60_CLR. Bolt the flange on through the ear holes too.

include <../rig_common.scad>

T = WALL;
CLRS = [0.30, 0.60];           // per side; the model's XT60_CLR is 0.40 — pick from these
module bed_text(txt) { mirror([1, 0, 0]) mirror([0, 0, 1]) label_pocket(txt, 4, LABEL_DEPTH); }
module xt60_hole(x, clr) {
    translate([0, 0, T/2]) cube([x[0] + 2*clr, x[1] + 2*clr, T*3], center = true);
    for (sx = [-1, 1]) translate([sx*x[2]/2, 0, -1]) cylinder(d = x[3], h = T + 2);
}

// one row per connector that is measured; two clearances side by side
module row(x, name) {
    for (i = [0 : 1]) translate([(i - 0.5)*44, 0, 0]) {
        xt60_hole(x, CLRS[i]);
        translate([0, -x[1]/2 - 5, 0]) bed_text(str(name, " +", CLRS[i]));
    }
}

difference() {
    translate([-45, -18, 0]) cube([90, 36 * (XT60M_MEASURED ? 2 : 1), T]);
    translate([0, 4, 0]) row(XT60F, "F");
    if (XT60M_MEASURED) translate([0, 40, 0]) row(XT60M, "M");
}
if (!XT60M_MEASURED) echo("NOTE: xt60_coupon carries the F cutouts only — the M body is not yet measured.");
