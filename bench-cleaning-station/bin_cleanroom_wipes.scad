// bin_cleanroom_wipes — 2×1 open bin for a bag of cleanroom wipes.
//
// AN OPEN BIN WITH NO WIPE DIMENSION IN IT. The wipes are 90 × 90 per the spec
// sheet, and that number is a red herring for this part: it describes a wipe
// opened out flat, not the shape it lives in. They are cloth-like and come in a
// plastic bag, so the bag conforms to whatever pocket it is given.
//
// Laid flat, a 90 mm wipe needs a 3×3 — it does not fit a 2×1, a 2×2 or even a
// 3×2. That arithmetic is correct and completely beside the point. Designing a
// rigid pocket around it would have produced a bin three times the size of what
// is actually needed.
//
// So the only number here is depth, and that is a capacity choice. Change H if
// the bag wants more or less room; nothing else depends on it.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>
include <../lib/gridfinity.scad>

NX = 2; NY = 1;
H  = 45;    // [20:1:70] ~39 mm of usable depth — a bag stands in it and you
            //   pull wipes off the top

WALL = 1.2; FLOOR = 1.4;

echo(str("interior ", NX*GF - 0.5 - 2*WALL, " x ", NY*GF - 0.5 - 2*WALL,
         " mm, usable depth ", H - BIN_BASE_H - FLOOR, " mm"));

bin(NX, NY, H, wall = WALL, floor = FLOOR);
