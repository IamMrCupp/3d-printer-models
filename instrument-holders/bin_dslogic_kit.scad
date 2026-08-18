// bin_dslogic_kit — the DSLogic's flying-lead harness and its grabber clips.
//
// DIVIDED, and that is the whole point. In one undivided 9-cell well the clips
// sink under the wire and you fish for them. Two columns: the harness coils in
// one, the clips stay findable in the other.
//
// Deep (51 mm) because coiled wire wants volume, not floor area — the harness
// is the real storage problem here, not the pod.
//
// PRINT: as emitted, foot down. No supports. x1.
include <instrument_holders_common.scad>

divided_bin(3, 3, H_DSLOGIC_KIT, cols = 2, rows = 1);
