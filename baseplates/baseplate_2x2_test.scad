// baseplate_2x2_test — small Clickfinity test tile (JOIN on). PRINT TWO before
// committing to the big plates: (1) click a 1×1 bin in — does the latch hold?
// (2) slide the two tiles together on their shared edge — does the dovetail lock?
// Validates latch clearance + JOIN_CLEAR at ~20 min/tile instead of after 7.5h.
include <../lib/clickfinity.scad>
JOIN = true;
clickfinity_baseplate(2, 2, arms = true);
