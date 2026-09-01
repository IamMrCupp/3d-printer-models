// jar_fit_coupon — PRINT THIS BEFORE THE TRAY.
//
// One CORNER pocket cut straight out of the real tray: the nested ⌀45.6/⌀35.6
// pocket, plus two genuine outer walls and the outer corner radius. ~12 g against
// the tray's ~173 g.
//
// It is an intersection() against the actual tray_jars(), not a re-derivation. If
// the tray changes this changes with it — a coupon that restates the geometry can
// pass while the part it stands in for fails.
//
// WHAT IT TESTS
//   - the WIDE jar seats on the shoulder and stands proud enough to pinch out
//   - the SLIM jar drops through and is held by the lower bore without rattling
//   - JAR_CLR. 0.6 on a ⌀45 bore is 1.3%; PETG shrink over 45 mm is real and this
//     is the only number here that can be wrong in a way you feel
//   - the outer corner, so you can check it clears the case's corner radius
//
// WHAT IT DOES NOT TEST
//   Whether the whole 197.4 mm tray fits the 199.5 cavity. That is 2.1 mm of
//   total slack across a big flat print, and one corner cannot tell you about
//   warp over 197 mm. Check the tray's own first layer against the case.
//
// HOW TO READ IT
//   both jars drop in, sit flat, lift out easily   -> print the tray
//   wide jar tight or won't seat                   -> raise JAR_CLR
//   slim jar rattles in the lower bore             -> lower JAR_CLR
//   corner fouls the case                          -> raise CORNER
//
// PRINT: flat, as emitted. No supports.
//
// SPDX-License-Identifier: CC-BY-NC-4.0
// Copyright (c) 2026 Aaron Cupp
include <../concentrate_tray_common.scad>

// The corner pocket's centre, and a cut that takes the two real outer walls and
// stops MID-WALL on the other two sides — a plane through solid material, never
// tangent to a bore.
CPX = -(COLS-1)/2 * (WIDE + WALL);
CPY = -(ROWS-1)/2 * (WIDE + WALL);
HALF = (WIDE + WALL)/2;

intersection() {
    tray_jars();
    translate([-OX/2 - 1, -OY/2 - 1, -1])
        cube([CPX + HALF + OX/2 + 1, CPY + HALF + OY/2 + 1, H + 2]);
}
