// bin_deoxit_droppers — 5×1 block: three DeoxIT concentrate droppers (D100 /
// F100 / G100) plus six slots for the brushes and swabs that come with them.
//
// THE BOTTLES ARE NOT ROUND. 39 × 20 is a flattened cross-section, and this part
// originally bored round 21 mm holes from it — the same mistake bin_dispenser
// made with the square alcohol pump. A measurement is a shape as well as a
// number; check which before choosing the cutter.
//
// Rounded rectangles rather than true ovals: an oval pocket only suits an oval
// bottle, a rounded rect accepts either. It locates the bottle, it need not
// trace it.
//
// The six applicator slots keep each product's brush and swab with its own
// bottle — D, F and G are different chemicals and a shared applicator carries
// one into the next.
//
// ⚠️ THE SLOTS ARE STILL OVERSIZED, AND DEPTH ALONE DOES NOT FIX THAT.
//
// The applicators fell over at CAP_DROPPER = 15, so it is now 26 and the block is
// half again as tall. That helps, but be clear about how much: a slot is
// 11.9 × 20 mm and nothing has ever put calipers on a brush handle. Assuming a
// 4 mm handle, the lean it can still take is
//
//       depth 15 → 27.8° across the slot, 46.8° along it
//       depth 26 → 16.9° across the slot, 31.6° along it
//
// Better, not fixed. The slots are sized from LEFTOVER SPACE, not from the thing
// going in them — they are whatever was between the bottle pockets. THE NUMBER
// THIS PART NEEDS is the handle diameter of a brush and of a swab, and how many
// of each ship with a bottle. With those the slot becomes handle + clearance and
// the lean goes to nothing; without them, more depth is the only lever and it is
// a weak one.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 5;
POCKET_L = D_DROPPER_L + DROPPER_CLR;   // 40
POCKET_W = D_DROPPER_W + DROPPER_CLR;   // 21
POCKET_R = 6.0;    // [2:0.5:9] pocket corner radius
GAP      = 1.5;    // [1.2:0.1:4] web between bottle pockets
SPLIT    = 3.0;    // [2:0.5:8] wall between the bottle bay and the slots
N_SLOT   = 6;      // [3:1:10] applicator slots
DIV      = 1.2;    // [1:0.2:3]
SLOT_D   = 20;     // [10:1:39] slot depth into the block (Y)
SLOT_R   = 1.5;    // [0:0.5:4]

WALL = 1.2; FLOOR = 1.4;
W = NX*GF - 0.5; D = 1*GF - 0.5;
IW = W - 2*WALL;  ID = D - 2*WALL;
H  = BIN_BASE_H + FLOOR + CAP_DROPPER;

// Layout is THREE GROUPS, each a bottle with its own two applicators beside it —
// not a bottle bay and a separate slot bay. Grouping means each product's brush
// and swab sit with its bottle, and the whole row lands in front of the matching
// spray can in the block behind. D, F and G are different chemicals; a shared
// applicator carries one into the next.
PG    = 2.0;   // [1.2:0.1:5] gap between a bottle pocket and its first slot
GG    = 3.0;   // [2:0.5:8] gap between groups

// group = pocket + gap + slot + divider + slot
SLOT_W = (IW - 2*GG - 3*(POCKET_L + PG + DIV)) / 6;
GROUP_W = POCKET_L + PG + 2*SLOT_W + DIV;

assert(SLOT_W >= 5, str("Applicator slots collapse to ", SLOT_W, " mm."));
assert(SLOT_D <= ID, "Slot is deeper than the block.");
echo(str("group ", GROUP_W, " mm = pocket ", POCKET_L, " + 2 slots of ", SLOT_W));

X0 = -IW/2;

difference() {
    bin_blank(NX, 1, H);
    for (g = [0 : 2]) {
        gx = X0 + g*(GROUP_W + GG);
        // the bottle
        translate([gx + POCKET_L/2, 0, BIN_BASE_H + FLOOR])
            linear_extrude(CAP_DROPPER + 0.1)
                offset(POCKET_R) offset(-POCKET_R)
                    square([POCKET_L, POCKET_W], center = true);
        // its two applicators
        for (i = [0, 1])
            translate([gx + POCKET_L + PG + SLOT_W/2 + i*(SLOT_W + DIV), 0,
                       BIN_BASE_H + FLOOR])
                linear_extrude(CAP_DROPPER + 0.1)
                    offset(SLOT_R) offset(-SLOT_R)
                        square([SLOT_W, SLOT_D], center = true);
    }
}
