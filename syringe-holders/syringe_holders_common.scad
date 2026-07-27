// syringe_holders_common — shared syringe/flux holder geometry.
// All working syringes are 10 cc (⌀~10.8) except the 30 cc flux (⌀25.5).
include <../lib/vessel.scad>
D_LARGE = 25.5;   // 30 cc flux
D_SMALL = 10.8;   // 10 cc flux / paste / UV-mask
CAPTURE = 40;     // bore depth; syringes stand proud above
// Flux: 2 large (back row) + 4 small (front 2×2), generous webs in a 2×2.
FLUX_BORES = [
    [-20,  20, D_LARGE], [20,  20, D_LARGE],
    [-20,  -6, D_SMALL], [20,  -6, D_SMALL],
    [-20, -26, D_SMALL], [20, -26, D_SMALL],
];
