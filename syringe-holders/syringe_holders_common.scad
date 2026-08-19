// syringe_holders_common — shared syringe/flux holder geometry.
//
// ONE small family, not several. The 10 ml syringe is 18.80 mm across the
// barrel; the 30 cc AMTECH flux is 25.5. There is no ~10 mm syringe on this
// bench — an earlier 10.8 here was a misread of the same 18.80 barrel, and it
// shipped a printed rack that took the syringes tip-deep only. Do not
// reintroduce a small-bore constant without a caliper reading behind it.
include <../lib/vessel.scad>
D_LARGE = 25.5;   // 30 cc AMTECH flux barrel
D_SMALL = 18.8;   // 10 ml syringe barrel — flux, paste, UV mask are all this

// Rows are spaced from the bore walls outward (3 mm of material between any two
// bores and to the block edge), not from a round-number pitch. At the real
// diameters a 20 mm row pitch leaves 0.2 mm of wall, which is why the old
// layout could not simply have its diameters swapped.
FLUX_BORES = [
    [-25.50,  25.50, D_LARGE], [25.50,  25.50, D_LARGE],
    [-28.85,  -0.65, D_SMALL], [28.85,  -0.65, D_SMALL],
    [-28.85, -23.45, D_SMALL], [28.85, -23.45, D_SMALL],
];
CAPTURE = 40;     // bore depth; syringes stand proud above
