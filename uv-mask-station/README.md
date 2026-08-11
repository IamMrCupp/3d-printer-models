# UV mask station

![UV mask station](preview.png)

**Gridfinity** storage for UV-curable solder mask and the 365 nm lamp that cures it — a deep-bore rack, an opaque cap over it, and a head-down cup for the lamp.

## ⚠️ Print the rack and the cap in opaque filament

The mask cures under UV, and ambient light carries enough of it to skin the syringe over weeks. Clear or natural PLA is a light pipe. **The rack and cap only do their job in an opaque colour** — black, or any dark solid. The lamp cup doesn't care.

That's also why the bores are 65 mm deep for a ~100 mm syringe: the tip and most of the barrel sit inside the block, and the cap covers the stubs that stick up. Deep bores plus a cap, not one or the other — a deep bore alone still leaves the top exposed, and a cap over shallow bores is a tall box.

## Design notes

**Syringes go in tip-down.** The tip is the part that skins first and the part you can't clear without wasting mask. Tip-down puts it at the bottom of the deepest, darkest part of the bore.

**The lamp is stored head-down** in a 2 × 2 cup, ⌀37.83 mm bore. Two reasons, and the second is the one that matters: the head is the widest part, so dropping it in self-centres the lamp — and a lamp knocked on in a head-down cup shines into the well instead of across the bench. 365 nm is an eye hazard, not just an inconvenience.

**Eight slots for seven syringes.** 4 × 2 grid: 2 green mask + 5 others, with one spare. Set `UVM_COLS` / `UVM_ROWS` in `uv_mask_common.scad` if your set is a different size.

**The cap prints open-side down** — no supports, and the one surface that needs to be flat and square (the rim that meets the block) is the one on the bed.

## Parts

| File | What | Size |
|---|---|---|
| `bin_uv_mask.scad` | 2 × 1 rack, 4 × 2 bores at ⌀10.8 × 65 mm deep — **print opaque** | 83.5 × 41.5 × 71.2 mm |
| `uv_mask_cap.scad` | Slip-over cap for the protruding stubs, 0.5 mm clearance — **print opaque** | 88.5 × 46.5 × 44.0 mm |
| `uv_light_holder.scad` | 2 × 2 cup for a TrixHub TH007 365 nm lamp, head-down | 83.5 × 83.5 × 56.2 mm |

Built on [`lib/syringe.scad`](../lib/syringe.scad) (the bore grid) and [`lib/vessel.scad`](../lib/vessel.scad) (the lamp cup).

## Source

```sh
openscad -o bin_uv_mask.stl --export-format binstl bin_uv_mask.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG — **opaque** for the rack and cap |
| Layer height | 0.2 mm |
| Walls | 3 perimeters (don't drop below 2 on the rack — thin walls leak light) |
| Infill | 15 % |
| Supports | **None** — bores are vertical, the cap prints open-side down |
