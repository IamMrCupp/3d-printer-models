// riser_spacer_2in — 2" spacer that clicks UNDER a pedestal.
//
// The hot air pedestals dropped from 8" to 6" so all four fit an overnight
// print. If 6" turns out short, four of these restore the original 8" without
// reprinting the pedestals.
//
// Gridfinity feet below, a baseplate ON TOP: the pedestal's own feet drop into
// its sockets. Net rise is body + BP_H - BIN_BASE_H, because the pedestal's feet
// sink into the sockets — so the body is 49.7, not 50.8.
//
// ⚠️ The socket LOCATES, it does not latch. On a Clickfinity desk plate the
// spacer itself latches down, but the pedestal only sits in the spacer. That is
// fine under load and worth knowing when you lift one off.
//
// PRINT: as emitted, feet down. No supports.
include <../lib/gridfinity.scad>

RISE  = 50.8;   // [25.4:0.1:101.6] net height added — 2"
VENT  = 10.0;   // [0:1:20] vent through the floor. NOT optional: stack_base's
                //   cavity is otherwise sealed, which traps air and renders as a
                //   SECOND CONNECTED COMPONENT — a mesh that passes every CI check
                //   and is still wrong. Same trap riser_common documents.
BODY = RISE - (BP_H - BIN_BASE_H);

echo(str("spacer body ", BODY, " mm, part ", BODY + BP_H, " mm tall, net rise ", RISE));

difference() {
    stack_base(2, 2, BODY, open_front = false);
    if (VENT > 0)
        for (ix = [-1, 1], iy = [-1, 1])
            translate([ix*GF/2, iy*GF/2, -1]) cylinder(d = VENT, h = BIN_BASE_H + 3, $fn = 48);
}
