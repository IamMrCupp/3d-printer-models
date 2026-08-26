// owon_bin_cords_label — dark text inlay for owon_bin_cords. Part 2 of 2.
//
// Shares an origin with the body part, so load both into the slicer without
// moving either and assign a contrasting toolhead. The inlay fills the body's
// pocket flush — nothing stands proud to catch or peel, and it survives the IPA
// wipe that takes a printed sticker off.
//
// Optional. Skip it and the body prints with an engraved label that still
// reads, just without the contrast.

include <owon_bins_common.scad>

$fn = 48;

// Flush with the outer face: the inlay occupies the pocket exactly, no overrun.
_inlay_y = CORD_FRONT_Y + LABEL_T;

translate([0, _inlay_y, WARN_Z1]) label_inlay_v(WARN_L1, size = WARN_SIZE);
translate([0, _inlay_y, WARN_Z2]) label_inlay_v(WARN_L2, size = WARN_SIZE);
