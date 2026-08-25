# Rotary tool station

![Rotary tool station](preview.png)

**Gridfinity** holder for a **HARDELL mini rotary tool** and its accessory bits — the tool standing upright in a cup, the bits in a drilled block.

## Design notes

**The tool stands vertical in a 1 × 1 cup**, like a pen in a pen cup, capturing the bottom 45 mm. Laying a rotary tool flat needs a 4 × 1 trough — four times the bench for the same tool.

(The "131 mm long" that used to appear here was the *engraver's* length, carried over with the mis-attributed diameter. The HARDELL's own length has never been measured, and doesn't need to be — see below.)

**Cord slot.** The cup has a channel open to the rim for the lead — without one the cord drapes over the edge and levers the tool sideways. ⚠️ Its 6 mm width was measured on the *engraver's* barrel jack and is unverified for this tool.

**Stored collet-down** so the burr is shrouded. A pointed bit at hand height on a reach-across bench is a snag you notice exactly once.

## ✅ The fit gauge has been run

`coupons/bit_fit_gauge.scad` is a calibration coupon, **not** a bench part. Small vertical holes come off an FDM printer undersize — inner-perimeter over-extrusion, typically 0.15–0.3 mm, and the exact amount is specific to your printer, nozzle, and filament.

The gauge is a strip of five holes (2.5–2.9 mm), each engraved with its modelled diameter. It was printed on 2026-08-25 and **the shanks go into the 2.7**; the 2.6 does not take them. So `BIT_BORE = 2.70` and `BIT_CLR` is derived from it (0.319) rather than set by feel.

The old `BIT_CLR = 0.25` guess cut **2.631** — *under* the smallest hole that actually takes a shank. Every one of these holes would have needed reaming. That is exactly what the coupon exists to prevent.

**The HARDELL and the small engraver take the same bits**, confirmed 2026-08-25, so both share this bore. `../engraver-station/` uses the same 2.70.



## The cup was cut for the wrong tool for months

`TOOL_D = 19.66` sat here labelled HARDELL, and `bin_tool` was bored to it. On 2026-08-25 the
HARDELL measured **28 mm at the base, tapering to ≈30** — so 19.66 was never this tool. It's the
small engraver's, matching its ~20 mm to within 0.34 mm.

The old cup was watertight, 2-manifold, and exactly the size it claimed. It simply would not have
taken the tool named on it. **Nothing in the toolchain catches a right-shaped part cut for the
wrong object** — not the mesh check, not the asserts, not CI. Only a caliper on the right tool
does.

So the file moved rather than being deleted — it's now
[`../engraver-station/bin_tool_engraver.scad`](../engraver-station/), because the part was always
correct and only the label was wrong. `bin_tool` here is new, bored to the real 30.

**It's a taper, so the bore goes to the widest section (30), not the base (28)** — cut to the 28
and the tool jams partway down.

**Capture depth is a comfort choice, not a fit constraint.** The HARDELL's overall length has
never been measured and doesn't need to be: the bin latches into the grid so nothing tips, and
with 1 mm of clearance in a 45 mm bore the tool leans about 1.3°. Override with
`-D TOOL_CAPTURE=` once you've held the printed one.

> ⚠️ **`CORD_W = 6` is inherited and unverified for this tool.** That barrel-jack slot was
> measured on the engraver, back when the two were conflated. A slot too narrow stops the tool
> seating — check the HARDELL's lead before printing, or just widen it, since an oversized notch
> costs nothing.

## Parts

| File | What | Size |
|---|---|---|
| `coupons/bit_fit_gauge.scad` | **Print first** — five test holes, 2.5–2.9 mm, engraved | 95 × 24 × 9 mm |
| `bin_tool.scad` | 1 × 1 cup, HARDELL vertical (⌀30 bore), cord slot | 42 × 42 × 51 mm |
| `bin_bits.scad` | 1 × 1 block, 5 × 3 grid, 15 bit holes | 42 × 42 × 24 mm |

**15 holes, counted 2026-08-25.** The kit came with about 15 shank bits, a stack of cut-off wheels and ~20 sanding disks.

It was 70 on a 2×1 — an upper bound from a 69-piece set, on the assumption every piece was shank-mounted. Most aren't, and the block was oversized by more than 4×. 5 × 3 on a 1×1 at an 8.4 × 14 pitch gives a cell back. The engraver's block took exactly this correction, 70 → 35.

The wheels and sanding disks are mandrel-mounted and want a **pocket, not a bore** — largest wheel is 25 mm across. Their bin is blocked on one measurement: the collet wrench's L × W × thickness.

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
