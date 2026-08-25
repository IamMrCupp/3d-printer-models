# Rotary tool station

![Rotary tool station](preview.png)

**Gridfinity** holder for a **HARDELL mini rotary tool** and its accessory bits — the tool standing upright in a cup, the bits in a drilled block.

## Design notes

**The tool stands vertical in a 1 × 1 cup.** It's 131 mm long; the cup captures the bottom ~45 mm and the rest sticks up, like a pen in a pen cup. Laying it flat would need a 4 × 1 trough — four times the bench for the same tool.

**Cord slot.** The tool is corded (barrel jack), so the cup has a channel open to the rim for the lead. Without it the cord drapes over the edge and levers the tool sideways.

**Stored collet-down** so the burr is shrouded. A pointed bit at hand height on a reach-across bench is a snag you notice exactly once.

## ✅ The fit gauge has been run

`coupons/bit_fit_gauge.scad` is a calibration coupon, **not** a bench part. Small vertical holes come off an FDM printer undersize — inner-perimeter over-extrusion, typically 0.15–0.3 mm, and the exact amount is specific to your printer, nozzle, and filament.

The gauge is a strip of five holes (2.5–2.9 mm), each engraved with its modelled diameter. It was printed on 2026-08-25 and **the shanks go into the 2.7**. So `BIT_BORE = 2.70` is the finished hole this printer needs, and `BIT_CLR` is derived from it (0.319) rather than set by feel — the gauge reading is the measurement, the clearance is arithmetic.

2.6 does *not* take them, so 2.70 is the smallest that works. The old 0.25 guess would have cut **2.631** — under the smallest hole that fits, i.e. 35 holes all needing reaming. That is exactly what the coupon exists to prevent.

**Re-run it** if the nozzle, filament or layer height changes; the number is a property of the printer, not the tool.



## Parts

| File | What | Size |
|---|---|---|
| `coupons/bit_fit_gauge.scad` | **Print first** — five test holes, 2.5–2.9 mm, engraved | 95 × 24 × 9 mm |
| `bin_tool.scad` | 1 × 1 cup, tool vertical, cord slot | 42 × 42 × 51 mm |
| `bin_bits.scad` | 1 × 1 block, 7 × 5 grid of 3/32″ holes | 42 × 42 × 24 mm |

**35 holes, counted 2026-08-25** — that's how many bits actually take this grinder's 3/32″ shank.

It was 70 on a 2×1, an upper bound taken from the 69-piece set on the assumption every piece was shank-mounted. Most aren't: cut-off discs and sanding drums come on mandrels, and the micro drill bits have their own shanks. At the same 6.0 × 8.4 pitch, 7 × 5 halves the block to a 1×1 and gives a grid cell back — 36.4 cm³ instead of 73.8, for no change to the holes themselves.

Built on [`lib/vessel.scad`](../lib/vessel.scad) (the cup) and [`lib/syringe.scad`](../lib/syringe.scad) (the bore grid — the same module that racks syringes; a bit block is that with a smaller pitch).

## Source

```sh
openscad -o bin_tool.stl --export-format binstl bin_tool.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm (**0.12 for the bit block** — finer layers hold small-hole diameter better) |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** — the cord slot and all bores print without them |
