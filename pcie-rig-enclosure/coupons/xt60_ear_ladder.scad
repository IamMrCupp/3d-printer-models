// xt60_ear_ladder.scad — the XT60E ear-hole pairs, stepping the PITCH in.
//
// The first XT60 coupon had the right body cutout (+0.30) but its 2.7 mm ear
// holes would not pass an M2.5 bolt (a 2.7 vertical hole in PETG prints nearer
// 2.4), and both pairs sat slightly too far APART — away from the connector's
// centre, the same on the male and the female. So the calipered pitches
// (22.60 / 27.25) read a little long. Holes here are all 3.2; the rows pull the
// pitch in by 0, 0.4 and 0.8 mm. The first row the bolts drop through both
// ears is the one. Set XT60M[2] / XT60F[2] in rig_common.scad to that pitch.
// ~6 g.

include <../rig_common.scad>

T = WALL;
PULL_IN = [0, 0.4, 0.8];
module bed_text(txt) { mirror([1, 0, 0]) mirror([0, 0, 1]) label_pocket(txt, 3.5, LABEL_DEPTH); }

difference() {
    translate([-45, -27, 0]) cube([90, 54, T]);
    for (i = [0 : 2]) {
        y = (1 - i) * 18;
        pm = XT60M[2] - PULL_IN[i];  pf = XT60F[2] - PULL_IN[i];
        // male pitch on the left half, female on the right
        for (sx = [-1, 1]) translate([-22 + sx*pm/2, y + 4, -1]) cylinder(d = XT60_EAR_HOLE, h = T + 2);
        for (sx = [-1, 1]) translate([ 22 + sx*pf/2, y + 4, -1]) cylinder(d = XT60_EAR_HOLE, h = T + 2);
        translate([-22, y - 5, 0]) bed_text(str("M ", pm));
        translate([ 22, y - 5, 0]) bed_text(str("F ", pf));
    }
}
