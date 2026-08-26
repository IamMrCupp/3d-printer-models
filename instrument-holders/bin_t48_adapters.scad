// bin_t48_adapters — pocket for the T48 adapter set, 73 x 103 x 30, measured
// AS A UNIT in its foam block.
//
// No dividers, no card file. Phase 2 §B.6 assumed these adapters needed
// lib/cardfile.scad with a per-card pitch; they don't, because the foam already
// indexes and protects them and it lifts out as one piece. That leaves the BGA
// stencils as cardfile's only prospective consumer.
//
// No cord notch — nothing here is plugged into anything.
//
// PRINT: as emitted, foot down. No supports. x1.
include <instrument_holders_common.scad>

bin(2, 3, H_ADAPTERS);
