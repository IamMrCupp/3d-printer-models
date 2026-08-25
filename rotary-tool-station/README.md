# Rotary tool station

![Rotary tool station](preview.png)

**Gridfinity** holder for a **HARDELL mini rotary tool** and its accessory bits — the tool standing upright in a cup, the bits in a drilled block.

## Design notes

**The tool stands vertical in a 1 × 1 cup.** It's 131 mm long; the cup captures the bottom ~45 mm and the rest sticks up, like a pen in a pen cup. Laying it flat would need a 4 × 1 trough — four times the bench for the same tool.

**Cord slot.** The tool is corded (barrel jack), so the cup has a channel open to the rim for the lead. Without it the cord drapes over the edge and levers the tool sideways.

**Stored collet-down** so the burr is shrouded. A pointed bit at hand height on a reach-across bench is a snag you notice exactly once.

## ✅ The fit gauge has been run

`coupons/bit_fit_gauge.scad` is a calibration coupon, **not** a bench part. Small vertical holes come off an FDM printer undersize — inner-perimeter over-extrusion, typically 0.15–0.3 mm, and the exact amount is specific to your printer, nozzle, and filament.

The gauge is a strip of five holes (2.5–2.9 mm), each engraved with its modelled diameter. It was printed on 2026-08-25 and **the shanks go into the 2.7**; the 2.6 does not take them. So `BIT_BORE = 2.70` and `BIT_CLR` is derived from it (0.319) rather than set by feel.

The old `BIT_CLR = 0.25` guess cut **2.631** — *under* the smallest hole that actually takes a shank. Every one of these holes would have needed reaming. That is exactly what the coupon exists to prevent.

**The HARDELL and the small engraver take the same bits**, confirmed 2026-08-25, so both share this bore. `../engraver-station/` uses the same 2.70.



## 🛑 Which tool is 19.66 mm?

`TOOL_D = 19.66` / `TOOL_L = 131.36` are labelled HARDELL and were recorded before the small
engraver was bought — which argues they really are the HARDELL's. But as of 2026-08-25 the
engraver reads **~20 mm across** and the HARDELL is reported to be **bigger**. A 0.34 mm gap
between them; those cannot all hold.

Either 19.66 is the engraver's diameter wearing the HARDELL's label, or the HARDELL isn't bigger.
**`bin_tool` is bored to 19.66 and may be cut for the wrong tool.**

Resolving it takes both tools on calipers in one pass, together, with a note saying which is
which. The numbers stay put until then — changing them on a guess moves the error rather than
fixing it — and no cup gets built for the other tool.

**The bit bore is unaffected.** Bits are bits, and both tools take the same ones.

## Parts

| File | What | Size |
|---|---|---|
| `coupons/bit_fit_gauge.scad` | **Print first** — five test holes, 2.5–2.9 mm, engraved | 95 × 24 × 9 mm |
| `bin_tool.scad` | 1 × 1 cup, tool vertical, cord slot | 42 × 42 × 51 mm |
| `bin_bits.scad` | 2 × 1 block, 14 × 5 grid of 3/32″ holes | 84 × 42 × 24 mm |

**70 is still an upper bound, not a count.** Confirmed 2026-08-25 that the kit is mixed: extra bits, grinding wheels, cut-off wheels and sanders. The wheels are mandrel-mounted and don't want a shank hole at all — the largest cut-off wheel is **25 mm** across and needs somewhere flat, not a bore.

So this grid is oversized by an unknown amount. Count the shank-mounted pieces and drop `BIT_COLS` / `BIT_ROWS`; the engraver's block went 70 → 35 on exactly that correction.

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
