# Solder consumables

![Solder consumables](preview.png)

**Gridfinity** bins for the small consumables that live beside the iron — chip-removal alloy,
rosin, tip tinner.

## Parts

| File | What | Size |
|---|---|---|
| `bin_chip_remover.scad` | 1 × 5 trough for the chip-removal alloy tube | 41.5 × 209.5 × 30 mm |

**Plain bin, not a contoured cradle.** The tube is rigid and the bin has walls; a shaped channel
would only earn its place if the tube had to sit in one particular orientation, and it doesn't.
`TUBE_H` is the only parameter — raise it if the tube stands proud of the rim.

## Still to come — the rosin tin

Measured: the **tip tinner tin is 42.5 mm ⌀ × 17 mm tall, lid on** — see `bin_tip_tinner`.

The **rosin tin** is still unmeasured (outer ⌀ + height). 42.5 is an awkward diameter: with
clearance the bore is 43.5, which does not fit a 1×1 (41.5) *or* a 2×1 — a 2×1's short interior
is also 41.5. So one tin needs a 2×2, and **two tins side by side need 105 mm, i.e. a 3×2**.

If the rosin tin is a similar size, the better part is a single 3×2 holding both, which is
20 mm² of grid cheaper than two 2×2 cups. Worth measuring before printing the solo cup.

## Source

```sh
openscad -o bin_chip_remover.stl --export-format binstl bin_chip_remover.scad
```

## Recommended print settings

| | |
|---|---|
| Material | PLA or PETG |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15 % |
| Supports | **None** |
