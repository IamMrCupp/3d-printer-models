# Donation QR stand

![Donation QR stand](preview.png)

A desk stand with two scannable QR codes side-by-side — **Venmo** and **CashApp** — for tips and donations. The codes print as a **two-colour flat inset**: dark modules recessed into a light faceplate and filled flush by a matching inlay, so a phone reads them by colour contrast (far more reliable than raised single-colour relief). A separate easel holds the faceplate upright.

Encoded out of the box:

- Venmo — `https://venmo.com/u/IamMrCupp`
- CashApp — `https://cash.app/$IamMrCupp`

Codes are 29×29 (version 3) at error-correction level **Q** (~25 % redundancy) — robust to print imperfection and partial wear.

## Parts

| File | What | Colour |
|---|---|---|
| `donation_qr_stand_body.scad` | Light faceplate — the plate plus recessed pockets for the QR modules, labels, and header. | Light |
| `donation_qr_stand_codes.scad` | Dark inlay — the QR modules + text that drop into the body pockets and top out flush. | Dark |
| `donation_qr_stand_easel.scad` | Angled trough base; the faceplate slots in and leans back ~18°. Print in any colour. | Accent |

Built from `donation_qr_stand_common.scad` (layout + part modules) and `qr_data.scad` (the QR matrices). All three parts print **flat and support-free**.

## Printing the two-colour faceplate

The body and codes share one origin, so on a multi-toolhead printer (Snapmaker U1) you don't assemble them — you co-print them:

1. Load **both** `donation_qr_stand_body` and `donation_qr_stand_codes` STLs into the slicer at the same position (they're already aligned).
2. Assign a **light** filament to the body and a **dark** filament to the codes.
3. Slice and print as one object — the inlay fills the body's pockets flush.

No multi-material printer? Print the body alone and colour the recessed modules by hand (paint pen / inlay), or print the codes as a thin raised relief — but two-colour scans best.

The **easel** prints separately. Slide the finished faceplate into its slot; it leans back for scanning.

## Changing the codes

The QR matrices are generated, not hand-authored — regenerate `qr_data.scad` for any URL with `tools/qrgen.py` (needs [`segno`](https://pypi.org/project/segno/), pure-Python):

```sh
pip install segno
tools/qrgen.py --out donation-qr-stand/qr_data.scad --error q \
  venmo='https://venmo.com/u/YourName' \
  cashapp='https://cash.app/$YourCashtag'
```

Each `name=url` pair becomes a `<name>_qr` variable. The `.scad` reads whatever's there, so the committed matrices are the source of truth — CI never needs a QR library.

## Parameters

Key dials at the top of `donation_qr_stand_common.scad`:

| Parameter | Default | What |
|---|---|---|
| `MODULE_MM` | 1.6 | Printed size of one QR cell. Bigger = easier to scan, larger plate. |
| `QUIET` | 4 | Quiet-zone modules around each code (spec minimum is 4 — don't go lower). |
| `INLAY_T` | 0.8 | Inlay depth / pocket depth. |
| `PLATE_T` | 2.4 | Faceplate thickness. |
| `TITLE_TXT` / `SUBHEAD_TXT` | "DONATIONS ACCEPTED" / "SCAN TO DONATE" | Two-line header. Shrink `TITLE_H` if you lengthen the title. |
| `LABEL_L` / `LABEL_R` | "VENMO" / "CASH APP" | Per-code labels. |
| `LABELS` | true | Set false for codes only, no text. |
| `LEAN` | 18 | Faceplate lean-back from vertical (deg). |

At defaults the faceplate is ~146 × 103 × 2.4 mm and the easel ~146 × 72 × 20 mm — both well within the U1's 270 mm bed.

## Recommended print settings

| Setting | Value |
|---|---|
| Orientation | Faceplate flat, QR face up. Easel base on the bed. No supports. |
| Material | PLA (matte light + dark for best contrast) |
| Layer height | 0.2 mm |
| Faceplate / inlay | Light body + dark inlay co-printed (multi-toolhead) |
| First layers | Make sure `INLAY_T` (0.8 mm) ≥ a few layers so the dark fully covers |
| Infill | 15 % |
| Supports | None |

> Scan-test both codes from the sliced preview or a first print before running copies — phone cameras vary, and a too-small `MODULE_MM` or a busy background can hurt reads. Bump `MODULE_MM` if a code is hard to scan.
