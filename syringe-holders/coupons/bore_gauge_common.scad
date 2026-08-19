// bore_gauge_common — shared geometry for the syringe bore-fit coupons.
//
// WHY THIS EXISTS: `bin_flux` shipped with bores cut for a 10.8 mm barrel when
// the syringe is 18.80 mm. That was a bad number, and it cost a ~250 g print to
// discover. But even with the right barrel diameter the bore can still be wrong,
// for a second and independent reason: small vertical holes come off an FDM
// printer undersize by an amount specific to the printer, nozzle and filament.
// `lib/vessel.scad` assumes CLR = 1.0 and that figure has never been checked
// against a real syringe.
//
// So this coupon tests the CLEARANCE, not the barrel. Each collar is engraved
// with the clearance that produced it; the one that slides without slop is the
// number to put in CLR.
//
// PRINT IT FLAT, AS EMITTED. The bores must print vertically, the same way the
// bin's bores do — that is the whole point. Lay it on its side and the holes
// come out a different size and the reading transfers nothing.
//
// Rings, not a slab: a solid plate of 20 mm holes is minutes of perimeter and a
// lot of infill. The earlier attempt at this coupon was a three-hour print,
// which costs more than the part it is protecting. These are ~15 minutes.
//
// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Aaron Cupp

use <../../lib/label.scad>

/* [Geometry] */
// Nothing here is structural — it is a thing you push a syringe into once. Every
// dimension is the smallest that still reads, because a coupon that costs more
// than a fraction of the part it protects does not get printed.
//   wall 3.0 -> 1.6  (four 0.4 mm lines; pure perimeter, no infill)
//   height 6 -> 4    (still ample engagement to feel bind vs slop on a ~19 mm bore)
WALL   = 1.6;   // [1.2:0.4:4] collar wall, at the LARGEST bore
RING_H = 4.0;   // [3:0.5:12] collar height
BAR_H  = 2.4;   // [1.6:0.4:8] backbone thickness — six layers at 0.4 mm
BAR_D  = 8.0;   // [6:1:16] backbone depth, carries the engraved numbers
GAP    = 2.0;   // [1:0.5:6] between collars
TEXT   = 4.0;   // [3:0.5:7] engraved digit height

/* [Quality] */
$fn = 64;       // the bore IS the measurement

// str(1.0) renders as "1" in OpenSCAD, which reads as a different kind of number
// beside "0.7" and "1.3". Force one decimal place so the row is comparable.
function _1dp(v) = let (t = round(v*10)) str(floor(t/10), ".", t % 10);

// barrel     — nominal barrel ⌀ under test
// clearances — bore = barrel + clearance, one collar each
module bore_gauge(barrel, clearances) {
    bores  = [for (c = clearances) barrel + c];
    outer  = max(bores) + 2*WALL;          // uniform outside, so collars compare by eye
    pitch  = outer + GAP;
    len_x  = (len(bores) - 1) * pitch + outer;
    bar_y  = -(outer/2 + BAR_D - 1);        // 1 mm of overlap onto every collar

    assert(min(bores) + 2*WALL <= outer,
           "WALL is measured at the largest bore; smaller bores get thicker walls.");

    difference() {
        union() {
            for (i = [0 : len(bores)-1])
                translate([(i - (len(bores)-1)/2) * pitch, 0, 0])
                    cylinder(d = outer, h = RING_H);
            translate([-len_x/2, bar_y, 0]) cube([len_x, BAR_D, BAR_H]);
        }
        for (i = [0 : len(bores)-1]) {
            x = (i - (len(bores)-1)/2) * pitch;
            translate([x, 0, -0.1]) cylinder(d = bores[i], h = RING_H + 0.2);
            translate([x, bar_y + BAR_D/2 - 0.5, BAR_H])
                label_pocket(_1dp(clearances[i]), size = TEXT, depth = 0.6);
        }
    }
}
