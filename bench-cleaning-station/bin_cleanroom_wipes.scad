// bin_cleanroom_wipes — 3×1 open bin for cleanroom wipes, standing on end.
//
// AN OPEN BIN WITH NO WIPE DIMENSION IN IT. The wipes are 90 × 90 per the spec
// sheet, and that number is a red herring for this part: it describes a wipe
// opened out flat, not the shape it lives in. They are cloth-like and come in a
// plastic bag, so the bag conforms to whatever pocket it is given.
//
// Laid flat, a 90 mm wipe needs a 3×3. Stood on end in a 3×1 it does not have to
// lie flat at all: the interior is 123.1 × 39.1, so the 90 mm dimension runs
// along the length with room to spare and the stack fills the depth.
//
// So the only number here is depth, and that is a capacity choice. Change H if
// the bag wants more or less room; nothing else depends on it.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 3; NY = 1;   // 3×1 so they can stand on end — 123.1 mm of length
H  = 56.25;    // [20:1:70] ~39 mm of usable depth — a bag stands in it and you
            //   pull wipes off the top. 45 -> 56.25 (25% taller) 2026-09-08.

WALL = 1.2; FLOOR = 1.4;

echo(str("interior ", NX*GF - 0.5 - 2*WALL, " x ", NY*GF - 0.5 - 2*WALL,
         " mm, usable depth ", H - BIN_BASE_H - FLOOR, " mm"));

bin(NX, NY, H, wall = WALL, floor = FLOOR);
