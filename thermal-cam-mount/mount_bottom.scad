// mount_bottom — bottom plate + front-corner bosses + cam cradle. Print plate-down.
include <thermal_cam_mount_common.scad>
// EMITTED ON ITS FRONT, not in assembly orientation.
//
// Sitting the way it is modelled, this part has ZERO facets on the bed — it
// balances on edges, so the first layer is nothing to hold on to. Rotated onto
// its front it lands on 350 mm2 of flat face and the overhang more than halves:
//
//   as modelled     26.8% overhang   2117 mm2 flat ceiling     0 mm2 on the bed
//   on its front    11.1% overhang    758 mm2 flat ceiling   350 mm2 on the bed
//   on its side      8.1% overhang    590 mm2 flat ceiling   140 mm2 on the bed
//
// On its side is a shade cheaper in support but sits on 140 mm2 and stands
// 70 mm tall, which is a poor trade for a part that then has to be clamped down
// hard. Front-down wins on adhesion.
//
// SUPPORTS: GRID / NORMAL, everywhere — NOT tree. What needs holding up is a
// large FLAT ceiling, and tree supports are pathological on those: the same
// choice on an earlier plate here was 4 h 25 m of support against 57 min for
// grid. Interface/roof on.
rotate([90, 0, 0]) mount_bottom();
