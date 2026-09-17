// respool_winder — the spool stands in this while you crank it.
//
// A 2×2 plate with a slot for the spool's spigot and a U-shaped fence whose lip
// holds the spool's LOWER FLANGE DOWN. Slide the spool in from the open side,
// flange under the lip, until the spigot seats at the slot's round end. It
// spins freely and cannot tip out. See respool_common for why the first one —
// a bare ⌀10 socket — let the spool jump every time the wire pulled.
//
// PUT THE CLOSED END TOWARD THE SOURCE SPOOL. Wire tension then pulls the spigot
// into its seat. If cranking walks it back out, stand a stub of 1.75 filament
// in one of the two ⌀2 holes at the open side.
//
// It is a separate plate from respool_stand because a ⌀69.13 source spool and a
// ⌀56 printed spool will not both fit on one 2×2 — and two small plates place
// more freely on a bench than one long one.
//
// PRINT: as emitted, feet down. No supports — the lip's underside is a 45° slope.
include <respool_common.scad>
$fn = 96;

_winder();
