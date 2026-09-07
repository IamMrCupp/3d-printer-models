// bin_micro_sponges — 2×1 open bin for mechanic's micro cleaning sponges.
//
// AN OPEN BIN, NOT A FITTED TRAY, AND THAT IS DELIBERATE. The sponges were
// described as "prob 20×20" — an estimate, not a reading. A fitted pocket built
// on an estimate is how a part ends up unusable; an open bin does not care. You
// tip them in and take one out.
//
// So no sponge dimension appears anywhere below. The only number that matters is
// how deep the bin is, and that is a choice about how many you want to hold, not
// a claim about the sponges.
//
// A 2×1's interior is 81.1 × 39.1 mm. At a nominal 20 mm that is four across and
// one deep per layer, so the height sets the stack.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 2; NY = 1;
H  = 58;    // [16:1:90] matches bin_swabs' HIGH side — its hopper wall and dam
            //   both stand at 58, so the two sit level on the plate rather than
            //   stepping. bin_swabs' front wall is 26 and is deliberately lower;
            //   this follows the tall side, not that one.

WALL = 1.2; FLOOR = 1.4;

echo(str("interior ", NX*GF - 0.5 - 2*WALL, " x ", NY*GF - 0.5 - 2*WALL,
         " mm, usable depth ", H - BIN_BASE_H - FLOOR, " mm"));

bin(NX, NY, H, wall = WALL, floor = FLOOR);
