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
// DeoxIT bore: taken from the PART, not from a can measurement.
//
// The 2026-08-20 print had three bores — 57.00 / 55.20 / 52.75. The 57.00 fits a
// DeoxIT; 55.20 barely does; 52.75 holds nothing. So 57.00 is a validated bore,
// which beats re-deriving it from a can diameter plus a clearance guess. D5, F5
// and G5 are the same can, so one bore serves all three.
BORE_DEOXIT = 57.00;   // ✅ proven by the printed part

// Freeze spray is a DIFFERENT, LARGER can — 13 mm wider than a DeoxIT, which is
// why it never fitted a shared block.
D_FREEZE_SPRAY = 69.00;   // ✅ measured 2026-08-20 (was 56.00, badly wrong)
FREEZE_CLR     = 2.0;     // [1:0.5:4] -> 71.00 bore
FREEZE_MEASURED = true;

D_DISPENSER    = 53.50;   // 200 ml push-down alcohol pump, square base across flats
D_FLOOD_BOTTLE = 75.50;   // Labvida 500 ml LDPE wash bottle

// ---- melamine sponges (mm) — 3.94 × 2.35 × 0.79 in ----
// Full block as sold. Bulk stock lives in the bag under the desk, ~100 of them;
// none of it competes for grid.
SPONGE_L = 100.1; SPONGE_W = 59.7; SPONGE_T = 20.1;

// WORKING size: a full block is far more sponge than any bench task needs, and
// melamine is consumed by abrasion — quartering one gets four uses out of what
// was one, and the smaller piece reaches between connectors where a 100 mm block
// cannot. Halve across, halve lengthwise.
CUT_L = SPONGE_L / 2;   // 50.05
CUT_W = SPONGE_W / 2;   // 29.85
CUT_T = SPONGE_T;       // 20.1 — unchanged, cuts are through the face

// ---- capture depth ----
// Vessel HEIGHTS were not measured, so this is a judgement call rather than a
// derived third-of-height: 50 mm resists a knock without making the bottles a
// two-handed retrieval. One number to change if the first print feels wrong.
CAPTURE = 50;

// Sponge bin: sponges stand ON EDGE (60 mm tall), ~4 across the 81 mm interior.
// On edge beats flat-stacked — same count in a 68 mm bin instead of a 107 mm one,
// and any sponge can be pinched out rather than peeling off the top of a pile.
// Height is set by a FULL block standing on edge, not a cut one — so one uncut
// block can still ride in the bin as reserve alongside the trimmed pieces.
// Cut pieces are 50 long, which is what lets the footprint drop to 2×2.
SPONGE_BIN_H = SPONGE_W + BIN_BASE_H + 1.4 + 2;   // ≈ 68
