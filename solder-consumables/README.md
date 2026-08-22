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

## On the rosin tin — retired

There isn't one. The old tin went off and isn't being replaced; flux now comes from Blackhorse
(in-house rosin flux), in a different container.

That settles a sizing question that was open: 42.5 mm is awkward, because with clearance the bore
is 43.5, which fits neither a 1×1 (41.5) nor a 2×1 — a 2×1's short interior is also 41.5. So a
single tin costs a 2×2. Two tins would have shared a 3×2 more efficiently, but with the rosin
gone the solo cup is right.

Whatever the Blackhorse flux arrives in will need its own measurement.

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
