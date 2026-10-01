// joint_coupon.scad — one corner of the base and the matching corner of the
// cup, so the skirt-over-tongue fit and the self-tapping screw get tried on
// 13 g of plastic instead of two 130 cm3 parts.
//
// The deck coupon covers the panel holes; nothing covers the joint. This does:
//
//   - JOINT_CLR (0.2/side): does the skirt drop over the tongue by hand, and
//     stay put without slop?
//   - SCREW_TAP (2.6): does an M3 x 10 bite through tongue + boss without
//     splitting the boss, and pull the skirt tight?
//   - the corner foot: does it latch a Clickfinity cell? (Proven elsewhere in
//     the repo, but it costs nothing to see it here.)
//
// Two separate pieces, side by side on the bed (deliberately two bodies — the
// slicer sees two objects). Drop the cup corner over the base corner, run the
// screw in. Then set JOINT_CLR / SCREW_TAP in rig_common.scad if either needs
// it, and print the box.

use <../rig_base.scad>
use <../rig_cup.scad>
include <../rig_common.scad>

SAMPLE = 40;                                  // corner sample, square
CX = W/2 - SAMPLE/2;  CY = -(D/2 - SAMPLE/2); // centre of the front-right corner sample
Z_BASE_TOP = Z_FLOOR + TONGUE_H;   // 18.3 now the floor sits on the flared feet

module corner_box(h) { translate([CX - SAMPLE/2, CY - SAMPLE/2, -1]) cube([SAMPLE, SAMPLE, h + 1]); }   // top face exactly at h

module base_corner() { intersection() { rig_base(); corner_box(Z_BASE_TOP); } }
module cup_corner()  { intersection() { rig_cup();  corner_box(SKIRT_H + 6); } }   // skirt + 6 mm of full wall

// Side by side, both on the bed. The cup corner is FLIPPED, skirt up, because
// that is how the real cup prints (deck-down): the skirt is the last layers,
// with no elephant's foot on its inner face. A skirt-down coupon would test a
// tighter fit than the part will have.
GAP = 8;
CUP_SAMPLE_H = SKIRT_H + 6;
translate([-(SAMPLE/2 + GAP/2), 0, 0]) translate([-CX, -CY, 0]) base_corner();
translate([ (SAMPLE/2 + GAP/2), 0, CUP_SAMPLE_H]) rotate([180, 0, 0]) translate([-CX, -CY, 0]) cup_corner();

echo(str("joint_coupon: two ", SAMPLE, " mm corners; base top z=", Z_BASE_TOP, ", cup sample ", SKIRT_H + 6, " tall"));
