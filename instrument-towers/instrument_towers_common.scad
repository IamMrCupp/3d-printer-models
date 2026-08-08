// instrument_towers_common — two-tier socket-stacked towers: instrument in the
// TOP bin (grab-and-go), its bits (cords/adapters) in the open-front stack_base
// below. Lift the top off (or reach the front) to get at the base. Each tower is
// independent and foots on the bench baseplate via its own base.
include <../lib/gridfinity.scad>

// ---- DSLogic Plus tower (2×2) ----
DSLOGIC_W = 74.01;   // measured width — fits a 2×2 (81 interior)
DSLOGIC_D = 70;      // ⚠ estimate (glared read) — confirm
DSLOGIC_TOP_H = 20;  // ⚠ PLACEHOLDER — analyzer height sets the top-bin depth
CORD_BASE_H   = 42;  // ⚠ PLACEHOLDER — base depth for the flying-lead harness + clips
