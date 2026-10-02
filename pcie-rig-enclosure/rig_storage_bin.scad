// rig_storage_bin.scad — a three-bay bin glued to the cup's deck for the riser kit.
//
// Replaces the riser dock. The dock's pegs sat on the calipered 99 x 37 hole
// pitch, which was never coupon-tested for pitch, and it was wrong in both
// directions on the printed cup (2026-10-01). Not reprinting the cup, so the
// kit stores in a bin on top instead:
//
//   rear bay    the x16 board on its long edge (slot 17 + clearance, 126.55 long),
//               standing 43.20 — sticks up ~13 above the 30 mm walls to grab
//   front-left  the x1 card, lying flat in a 33 x 31 bay
//   front-right the USB 3.0 lead, coiled in whatever is left
//
// Glued flat on the deck, its back edge flush with the deck's back edge, and
// located by two separate keys (rig_bin_key.scad) that sit in the deck's empty
// rail pockets and stand 0.8 proud; the bin's underside has matching recesses.
// The keys are separate on purpose: moulded on, they would make the bin print
// standing on two pads with its whole floor bridging between them — the exact
// failure that scrapped two bases. The recesses bridge 10.6 mm, which is fine.
//
// Print as emitted: floor down, no supports. PETG.

include <rig_common.scad>

module scoop(x, y_wall) { translate([x, y_wall, BH]) rotate([90, 0, 0]) cylinder(r = 10, h = BW*4, center = true); }

module rig_storage_bin() {
    difference() {
        translate([-OW/2, -OD/2, 0]) cube([OW, OD, BH]);
        // rear bay: x16 board on its long edge
        translate([-LEN/2, OD/2 - BW - ROW1, BF]) cube([LEN, ROW1, BH]);
        // front-left: x1 card, flat
        translate([-LEN/2, -OD/2 + BW, BF]) cube([X1_BAY, ROW2, BH]);
        // front-right: USB lead
        translate([-LEN/2 + X1_BAY + BW, -OD/2 + BW, BF]) cube([LEN - X1_BAY - BW, ROW2, BH]);
        // finger scoops in the front wall of both front bays
        scoop(-LEN/2 + X1_BAY/2, -OD/2 + BW/2);
        scoop(-LEN/2 + X1_BAY + BW + (LEN - X1_BAY - BW)/2, -OD/2 + BW/2);
        // key recesses in the underside, over the deck's rail pockets
        for (x = POCKET_XS) translate([x - BIN_X, POCKET_Y - BIN_Y, -1])
            linear_extrude(RECESS_D + 1) square([KEY_W + 2*KEY_CLR, KEY_L + 2*KEY_CLR], center = true);
    }
}

rig_storage_bin();

assert(ROW2 >= X1_D + 2*BCLR, "front row too shallow for the x1 card");
assert(BF - RECESS_D >= 1.2, "floor too thin over the key recesses");
assert(BIN_X - OW/2 >= -(W/2 - BIN_R), "bin's back-left corner hangs past the deck's rounded corner");
assert(BIN_X + OW/2 <= W/2 - BIN_R, "bin's back-right corner hangs past the deck's rounded corner");
assert(BIN_Y - OD/2 >= BEZEL_BACK + FRONT_CLEAR - 0.01, "bin sits on the meter bezel");
assert(BIN_X + OW/2 < SW_X - 23/2 || BIN_Y - OD/2 > SW_Y + 23/2, "bin sits on the rocker bezel");
echo(str("rig_storage_bin: ", OW, " x ", OD, " x ", BH, " mm; x16 slot ", ROW1, ", x1 bay ", X1_BAY, " x ", ROW2, ", USB bay ", LEN - X1_BAY - BW, " x ", ROW2, "; deck position x=", BIN_X, " y=", BIN_Y));
