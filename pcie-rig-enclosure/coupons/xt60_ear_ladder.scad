// xt60_ear_ladder.scad — just the XT60E ear-hole pairs, at three hole sizes.
//
// The first XT60 coupon had the right body cutout (+0.30) and 2.7 mm ear holes
// that an M2.5 bolt would not pass through — a 2.7 vertical hole in PETG prints
// nearer 2.4 — and the pair looked slightly off pitch besides. The flange is
// clamped by nuts, so slop in these holes costs nothing. Three pairs per
// connector, 3.0 / 3.2 / 3.4, at the measured pitches: the first pair the
// bolts drop through both ears is the one. Set XT60_EAR_HOLE in rig_common.scad.
// ~6 g.

include <../rig_common.scad>

T = WALL;
LADDER = [3.0, 3.2, 3.4];
module bed_text(txt) { mirror([1, 0, 0]) mirror([0, 0, 1]) label_pocket(txt, 3.5, LABEL_DEPTH); }

difference() {
    translate([-45, -27, 0]) cube([90, 54, T]);
    for (i = [0 : 2]) {
        y = (1 - i) * 18;
        // male pitch on the left half, female on the right
        for (sx = [-1, 1]) translate([-22 + sx*XT60M[2]/2, y + 4, -1]) cylinder(d = LADDER[i], h = T + 2);
        for (sx = [-1, 1]) translate([ 22 + sx*XT60F[2]/2, y + 4, -1]) cylinder(d = LADDER[i], h = T + 2);
        translate([-22, y - 5, 0]) bed_text(str("M ", LADDER[i]));
        translate([ 22, y - 5, 0]) bed_text(str("F ", LADDER[i]));
    }
}
