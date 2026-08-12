// riser_pedestal_scope.scad — 2" pedestal, ×2 under the oscilloscope.
//
// At 50.8 mm this is a spacer, not a shelf — see the bin-height note in
// riser_common.scad. It buys the sightline and hands the footprint back to the
// grid; it does not buy storage underneath.
//
// PRINT: as emitted, feet down. No supports. ×2.

include <riser_common.scad>

RISER_H = SCOPE_RISE;

riser_pedestal(RISER_H);
