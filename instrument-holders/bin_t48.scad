// bin_t48 — dock for an XGecu T48 programmer (66 x 107 x 37).
//
// Plain open-top pocket: the ZIF socket and its lever face UP, so nothing needs
// a cut-away side. Rear notch for the USB lead to the computer.
//
// 66 into a 2-cell interior leaves ~7.5 mm a side. The repo briefly believed
// this part needed a flared body, on a width reading of 88.69 that turned out
// to be 22 mm wrong. It does not.
//
// PRINT: as emitted, foot down. No supports. x1.
include <instrument_holders_common.scad>

difference() {
    bin(2, 3, H_T48);
    rear_cord_notch(2, 3, H_T48, x_off = T48_NOTCH_X);
}
