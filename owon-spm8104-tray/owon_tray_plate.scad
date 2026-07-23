// owon_tray_plate.scad — the Clickfinity tray that sits on the OWON SPM8104 lid.
//
// Part 1 of 2. A stock 2x5 magnet-free Clickfinity baseplate (84 x 210 x 4 mm),
// flush on the measured 84.30 mm lid. No fasteners pierce it — the two clamp
// rails hook over its rim and pin it down, so this stays a plain Clickfinity
// plate you could swap for another size.
//
// PRINT: flat, plate-down, PETG. **NOT PLA** — the latch tongues sit under
// spring tension and PLA creeps. See lib/clickfinity.scad for tuning knobs.

include <../lib/clickfinity.scad>
include <owon_tray_common.scad>

$fn = 48;

clickfinity_baseplate(GX, GY, arms = true);
