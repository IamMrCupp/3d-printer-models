// engindot_plate — the Clickfinity baseplate that sits on the ENGINDOT lid.
//
// A stock magnet-free Clickfinity plate. Same idea as owon_tray_plate.scad, but
// with NO frame: the ENGINDOT vents the full height of both sides, so a
// hugging skirt would sit over the intake. This plate rests free on the lid on
// a thin silicone liner, which stops it skating and touches no vent.
//
// GX x GY comes from shortkiller_common.scad. It's a coarse fit — a plate too
// big for the lid overhangs visibly the moment you set it down.
//
// PRINT: flat, latches UP, PETG. **NOT PLA** — the latch tongues sit under
// spring tension and PLA creeps. See lib/clickfinity.scad for tuning knobs.
include <../lib/clickfinity.scad>
include <shortkiller_common.scad>

clickfinity_baseplate(GX, GY, arms = true);
