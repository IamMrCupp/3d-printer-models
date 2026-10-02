// rig_bin_key.scad — locates the storage bin on the deck. Print 2.
//
// A flat key, CA'd into one of the deck's two empty rail pockets (10.4 x 47.4 x
// 1.2) so it stands 0.8 mm proud; the storage bin's underside recesses drop
// over the pair. Print flat, no supports, ~1 g each.

include <rig_common.scad>

module rig_bin_key() { translate([-KEY_W/2, -KEY_L/2, 0]) cube([KEY_W, KEY_L, KEY_H]); }

rig_bin_key();
echo(str("rig_bin_key: ", KEY_W, " x ", KEY_L, " x ", KEY_H, " mm — 1.2 in the pocket, ", KEY_PROUD, " proud"));
