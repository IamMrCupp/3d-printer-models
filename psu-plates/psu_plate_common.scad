// psu_plate_common — shared parameters for the power-supply plates.
//
// These are PLATES, not bins: a power supply stands on top, and the only wall is
// a short lip to stop it walking off. They latch into the baseplate on standard
// Gridfinity feet like everything else, so the PSU stops sliding on the desk and
// the grid underneath it stays usable.
include <../lib/gridfinity.scad>

// Lip height ABOVE the plate floor. Deliberately small — tall enough to catch a
// foot that shifts, short enough not to interfere with a PSU's own feet or make
// the unit a lift-out. Total part height is BIN_BASE_H + FLOOR + LIP.
LIP   = 3.0;   // [1:0.5:8]
FLOOR = 1.4;

PLATE_H = BIN_BASE_H + FLOOR + LIP;
