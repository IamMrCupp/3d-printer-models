// spool_lower — spigot, lower flange, and the full hub.
//
// PRINT SPIGOT-DOWN, as emitted. The only overhang is the lower flange's
// underside, and it sits 3.80 mm above the bed — a short ring of support under a
// flat annulus, not a tower. The hub above it is ⌀24 against a ⌀56 flange, so it
// steps inward and needs nothing.
include <spool_common.scad>
$fn = 96;
union() {
    _lower_profile();
    // The boss lands on the hub's top face over ⌀10 of a ⌀24 annulus — a
    // PARTIAL-area join, so it overlaps volumetrically. Exact-plane butting is
    // for FULL-face joins only.
    translate([0, 0, SPLIT_Z - JOINT_SINK]) _joint_boss(JOINT_L + JOINT_SINK);
}
