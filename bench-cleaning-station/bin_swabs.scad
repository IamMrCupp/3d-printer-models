// bin_swabs — 2×2 bin for cotton buds and beauty swabs.
//
// Open at the FRONT so they roll out rather than being lifted over a rim, and
// open at the TOP so you can tip a fresh box straight in. It was briefly a
// stacking base under the sponge bin; separate units turned out to be wanted,
// and stacking cost the open top that makes reloading easy.
//
// Swabs lie across the bin — a 2×2's 81 mm interior takes a ~75 mm bud.
//
// PRINT: as emitted, feet down. No supports — the front opening is swept into
// the pocket profile, so there is no overhang to bridge.
include <cleaning_station_common.scad>

SWAB_H = 45;   // [25:1:80] bin height

open_front_bin(2, 2, SWAB_H);
