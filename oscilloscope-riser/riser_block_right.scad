// riser_block_right.scad — the block under the RIGHT side of the scope.
//
// Mirror of the left block whenever the scope's feet do not land on grid
// centres (POCKET_DX != 0). If POCKET_DX comes out 0 against real measurements,
// the two blocks are identical and you can print this one twice.
//
// SKELETON — see riser_common.scad. Sized against placeholder measurements.
//
// PRINT: as emitted (top face on the bed, feet up). No supports.

include <riser_common.scad>

riser_block_emit("right");
