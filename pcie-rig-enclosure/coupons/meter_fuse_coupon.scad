// meter_fuse_coupon.scad — second coupon, after the deck coupon's results.
//
// The deck coupon's meter cutout (84.29 + 0.30/side on the long axis) bound so
// hard a retainer clip nearly broke. The short axis was fine. So: three thin
// frames, short side unchanged, long side stepped:
//
//     85.29 / 85.79 / 86.29   (0.50 / 0.75 / 1.00 per side)
//
// and the 5x20 panel fuse holder, back on the rear wall, gets its ladder:
//
//     11.8 / 12.0 / 12.2      (thread 11.6)
//
// plus the rocker and binding post at the sizes the deck coupon picked
// (21.3 and 7.6), so one print confirms every final panel hole together.
//
// TEXT IS ON THE BED SIDE, mirrored, so it reads right when you turn the piece
// over — the same way the deck's GND label prints on the cup (deck-down). Each
// frame and hole carries its size at 3 mm, and the strip carries a row of the
// real panel words at the real 5 mm / 0.6 deep, to judge legibility where it
// actually happens: in the first layers, against the bed. Push the meter into each frame: pick
// the tightest one it goes into without forcing a clip AND whose clips still
// catch the 3 mm edge. Set METER_CLR_L and FUSE_HOLE in rig_common.scad.
// The rocker and post should simply fit; if either doesn't, say so before the cup prints.
// Four separate pieces on the bed, ~20 cm3 together.

include <../rig_common.scad>

T      = WALL;                 // same 3 mm the deck is
BORDER = 6;
LADDER_L = [0.50, 0.75, 1.00]; // per side, long axis
FUSE_LADDER = [11.8, 12.0, 12.2];
FUSE_TXT    = ["11.8", "12.0", "12.2"];   // str(12.0) prints "12"
TXT = 3;

// Engraved into the BOTTOM face (z = 0 .. depth), mirrored in X so it reads
// correctly once the piece is flipped over.
module bed_label(txt, size) { mirror([1, 0, 0]) mirror([0, 0, 1]) label_pocket(txt, size, LABEL_DEPTH); }

cut_w  = METER_D + 2*METER_CLR_S;          // short axis, as fitted
module frame(clr) {
    cut_l = METER_W + 2*clr;
    difference() {
        translate([-(cut_l/2 + BORDER), -(cut_w/2 + BORDER), 0]) cube([cut_l + 2*BORDER, cut_w + 2*BORDER, T]);
        translate([0, 0, -1]) linear_extrude(T + 2) square([cut_l, cut_w], center = true);
        translate([0, -(cut_w/2 + BORDER/2), 0]) bed_label(str(round(cut_l*100)/100), TXT);
    }
}

PITCH_Y = cut_w + 2*BORDER + 6;
for (i = [0 : 2]) translate([0, (i - 1)*PITCH_Y, 0]) frame(LADDER_L[i]);

// hole strip: rocker and post at their chosen sizes, then the fuse ladder,
// then a row of the box's real panel words at full size
translate([0, -2*PITCH_Y - 2, 0]) difference() {
    translate([-(METER_W/2 + LADDER_L[2] + BORDER), -24, 0])
        cube([METER_W + 2*LADDER_L[2] + 2*BORDER, 48, T]);
    translate([-35, 12, -1]) cylinder(d = SW_HOLE, h = T + 2);
    translate([-35, -4, 0]) bed_label(str(SW_HOLE), TXT);
    translate([-15, 12, -1]) cylinder(d = POST_HOLE, h = T + 2);
    translate([-15, -4, 0]) bed_label(str(POST_HOLE), TXT);
    for (i = [0 : 2]) {
        translate([5 + i*17, 12, -1]) cylinder(d = FUSE_LADDER[i], h = T + 2);
        translate([5 + i*17, -4, 0]) bed_label(FUSE_TXT[i], TXT);
    }
    // panel words, as the box uses them. Negative x reads left once flipped.
    translate([0, -16, 0]) bed_label("12V IN  GND  FUSE  OUT  + -", LABEL_SIZE);
}

echo(str("meter_fuse_coupon: meter long axis ", METER_W + 2*LADDER_L[0], " / ", METER_W + 2*LADDER_L[1], " / ", METER_W + 2*LADDER_L[2], " x ", cut_w, "; fuse ", FUSE_LADDER));
