// respool_winder — the spool stands in this while you crank it.
//
// A 2×2 plate with a ⌀10.00 socket. The spool's spigot drops in, the crank goes
// on its journal, and you wind. It is a separate plate from respool_stand
// because a ⌀69.13 source spool and a ⌀56 printed spool will not both fit on one
// 2×2 — and two small plates place more freely on a bench than one long one.
//
// PRINT: as emitted, feet down. No supports — the socket is an open hole.
include <respool_common.scad>
$fn = 96;
difference() {
    bin_blank(WIND_NX, WIND_NY, BASE_H);
    // Through the top face, never stopping on it.
    translate([0, 0, BASE_H - WIND_SOCK_H])
        cylinder(d = WIND_SOCK_D, h = WIND_SOCK_H + EPS);
}
