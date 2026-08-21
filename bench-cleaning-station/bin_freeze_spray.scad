// bin_freeze_spray — 2×2 cup for the freeze spray can, on its own.
//
// Separate because it is a larger can than the DeoxIT trio: it will not enter a
// 57.00 bore, which is the one that fits a DeoxIT.
//
// ⚠️ DO NOT PRINT until FREEZE_MEASURED is true — D_FREEZE_SPRAY is known too small.
//
// PRINT: as emitted, feet down. No supports.
include <cleaning_station_common.scad>

if (!FREEZE_MEASURED)
    echo("WARNING: bin_freeze_spray bore comes from a diameter KNOWN to be too small. Do not print.");

collar_cup(2, 2, D_FREEZE_SPRAY, CAPTURE, clr = 2.0);
