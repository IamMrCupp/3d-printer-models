// POCKET GAUGE ONLY. This tests whether the camera fits the pocket. It tells
// you NOTHING about whether the mount survives being fitted.
//
// It prints flat: layers across the bend, plate free to bow, no arm. The mount
// prints on edge with its layers aligned to the split and the arm and gussets
// pinning the edges that would have to move. This coupon seated the camera
// perfectly at LIP_PROJ = 3.0 while the real mount broke into six pieces doing
// the same thing.
//
// A structurally honest version was tried — the real mount trimmed in X, in the
// mount's own orientation. Keeping the load path, the bed face and both side
// pads left 32.5 g against the mount's 36.1 g. A 10% saving is not a gauge, so
// it was dropped: for anything structural, print the mount.
//
// Use this for one question only: does the camera enter and sit in the pocket.
include <../thermal_cam_mount_common.scad>
$fn = 64;
_tray();
