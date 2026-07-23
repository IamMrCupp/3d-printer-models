// cleaning_station_common.scad — shared parameters for the bench cleaning station.
//
// The IPA / contact-cleaner corner of the electronics repair bench. Everything
// here is measured off the actual items with calipers; nothing is a nominal from
// a product page. Diameters carry a per-diameter clearance (lib/vessel.scad CLR),
// not per-side.
//
// This corner sits under a fume-extractor intake, which drives two decisions:
//   * Cups CAPTURE the vessel rather than clamp it — a collar that grips harder
//     than the bin weighs lifts out of the baseplate with the bottle.
//   * Bins stay as low as the job allows. Capture velocity is decided in the
//     first six inches, and a wall of tall bins in front of the hood costs it.
//
// The aerosols are FLAMMABLE and this bench has a 400 °C iron on it. These cups
// are for working cans only; bulk stock belongs away from the hood entirely.

include <../lib/vessel.scad>

// ---- measured diameters (mm) ----
D_FREEZE_SPRAY = 56.00;   // MEICON freeze spray
D_DEOXIT_D5    = 54.20;   // DeoxIT D5 contact cleaner
D_DEOXIT_F5    = 51.75;   // DeoxIT F5 FaderLube
D_DISPENSER    = 53.50;   // 200 ml push-down alcohol pump, square base across flats
D_FLOOD_BOTTLE = 75.50;   // Labvida 500 ml LDPE wash bottle

// ---- melamine sponges (mm) — 3.94 × 2.35 × 0.79 in ----
SPONGE_L = 100.1; SPONGE_W = 59.7; SPONGE_T = 20.1;

// ---- capture depth ----
// Vessel HEIGHTS were not measured, so this is a judgement call rather than a
// derived third-of-height: 50 mm resists a knock without making the bottles a
// two-handed retrieval. One number to change if the first print feels wrong.
CAPTURE = 50;

// Sponge bin: sponges stand ON EDGE (60 mm tall), ~4 across the 81 mm interior.
// On edge beats flat-stacked — same count in a 68 mm bin instead of a 107 mm one,
// and any sponge can be pinched out rather than peeling off the top of a pile.
SPONGE_BIN_H = SPONGE_W + BIN_BASE_H + 1.4 + 2;   // ≈ 68
