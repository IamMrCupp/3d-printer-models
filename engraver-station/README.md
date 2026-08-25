# Engraver station

![Engraver station](preview.png)

Gridfinity storage for the **small engraver rotary tool** — not the HARDELL.

> ⚠️ **This is a different tool from `rotary-tool-station/`, and none of its numbers transfer.**
> That directory is HARDELL-only: `TOOL_D = 19.66`, `TOOL_L = 131.36`, a barrel-jack cord slot,
> and a bit count taken from a 69-piece set. Different body, different length, different
> accessories. The two were briefly conflated and this tool's gauge reading nearly got written
> into the HARDELL's bit block — which would have recalibrated a part nobody had measured for.

## Parts

| File | What | Size |
|---|---|---|
| `bin_bits_engraver.scad` | 1 × 1 block, 7 × 5 grid, 35 bit holes | 42 × 42 × 24 mm |

## The bore is measured, not derived

`BIT_BORE = 2.70`. That's a **gauge reading**, taken 2026-08-25 with
`../rotary-tool-station/coupons/bit_fit_gauge.scad` — five holes at 2.5 / 2.6 / 2.7 / 2.8 / 2.9,
each engraved with its modelled diameter. The engraver's bits go into the **2.7**. The 2.6 does
not take them, so 2.70 is the smallest that works.

The block is cut to 2.70 with `clr = 0`, and that zero is deliberate rather than reckless: **the
clearance is already inside the 2.70.** A finished-hole reading folds the shank diameter and this
printer's hole shrinkage into one number. Adding a nominal clearance on top would double-count it.

**This is why the block exists while the tool cup doesn't.** A drilled block only ever needed the
finished hole, so the engraver's collet size stays unmeasured and stays irrelevant *here*. Calipers
on a bit would have given half the answer and left the shrinkage unknown.

Re-run the coupon and update `BIT_BORE` if the nozzle, filament or layer height changes — the
number is as much a property of the printer as of the tool.

## 35 holes

Counted, not estimated: **35** bits. 7 × 5 at a 6.0 × 8.4 mm pitch fits a 1×1 with 3.3 mm of
material between bores. `BIT_COLS` / `BIT_ROWS` are parametric and an assert fires if the grid
ever drops below `BIT_COUNT`.

## Still blocked — the tool cup

No cup yet. It needs three numbers, and **borrowing the HARDELL's is exactly the mistake this
directory exists to prevent**:

| Need | Sets |
|---|---|
| Body ⌀ at its widest | the cup bore |
| Overall length | `TOOL_CAPTURE`, about a third of it |
| Corded? lead ⌀ | whether there's a cord slot at all, and how wide |

## Source

```sh
openscad -o bin_bits_engraver.stl --export-format binstl bin_bits_engraver.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** — the bores are vertical |
