// bin_t48_tools — 3 extractor tools + the ribbon-cable adapter for the T48.
//
// 3x2 rather than 2x3: same six cells, laid the other way so the long extractor
// tools lie along the 3-cell axis (~123 mm of interior) instead of across.
//
// Undivided on purpose — four rigid objects that don't bury each other, unlike
// the DSLogic's loose clips.
//
// PRINT: as emitted, foot down. No supports. x1.
include <instrument_holders_common.scad>

bin(3, 2, H_T48_TOOLS);
