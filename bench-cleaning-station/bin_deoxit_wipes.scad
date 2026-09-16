// bin_deoxit_wipes — 2×1 open bin for the small wipes that ship with the DeoxIT
// bottles.
//
// AN OPEN BIN WITH NO WIPE DIMENSION IN IT, the same as its neighbours. The
// wipes have never been on calipers and do not need to be: a bin that only
// contains does not care how big its contents are, and a fitted pocket built on
// an unmeasured guess is how a part ends up unusable.
//
// The only number here is depth, and that is a capacity choice.
//
// 45, NOT 58. Its neighbours — bin_swabs, bin_micro_sponges, bin_cleanroom_wipes
// — all stand at 58 and deliberately line up. This one does not, because these
// are small sachets: in a 58 mm bin they sink to the bottom of a 52 mm well and
// you fish for them. Reaching in beats looking tidy. Change H to 58 if the row
// mattering more is the call.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 2; NY = 1;
H  = 45;    // [20:1:70] ~39 mm usable

WALL = 1.2; FLOOR = 1.4;

echo(str("interior ", NX*GF - 0.5 - 2*WALL, " x ", NY*GF - 0.5 - 2*WALL,
         " mm, usable depth ", H - BIN_BASE_H - FLOOR, " mm"));

bin(NX, NY, H, wall = WALL, floor = FLOOR);
