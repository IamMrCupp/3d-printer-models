// bit_fit_gauge — PRINT THIS FIRST. A calibration coupon, not a bench part.
//
// Small vertical holes come off an FDM printer undersize, by an amount specific
// to your printer/nozzle/filament. This strip has five holes spanning that
// range, each engraved with its modelled diameter. Print it, try a shank in
// each, and set BIT_CLR in rotary_station_common.scad so BIT_SHANK + BIT_CLR
// equals the one that slides in cleanly.
//
// Cheaper than discovering the error 70 holes at a time.
include <rotary_station_common.scad>
use <../lib/label.scad>

SIZES = [2.5, 2.6, 2.7, 2.8, 2.9];
PITCH = 17; PLATE_W = 95; PLATE_D = 24; PLATE_H = 9;

difference() {
    translate([-PLATE_W/2, -PLATE_D/2, 0]) cube([PLATE_W, PLATE_D, PLATE_H]);
    for (i = [0 : len(SIZES)-1]) {
        x = (i - (len(SIZES)-1)/2) * PITCH;
        translate([x, 4.5, -0.1]) cylinder(d = SIZES[i], h = PLATE_H + 0.2, $fn = 48);
        translate([x, -6, PLATE_H])
            label_pocket(str(SIZES[i]), size = 4.5);
    }
}
