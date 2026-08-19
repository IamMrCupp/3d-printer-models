// bin_uv_mask — deep-bore opaque block, UV-mask syringes tip-down (print opaque).
//
// Four dimples near the top take the cap's detents — see uvm_detents in
// uv_mask_common.scad. Their height is derived from the cap's engagement, so the
// two parts cannot drift apart.
include <uv_mask_common.scad>
difference() {
    syringe_rack(UVM_NX, UVM_NY, UVM_COLS, UVM_ROWS, UVM_D, UVM_DEPTH);
    uvm_block_detents();
}
