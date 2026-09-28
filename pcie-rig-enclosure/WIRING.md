# PCIe test rig — wiring guide

The power box for a bench PCIe GPU test rig: a fused, switched, metered 12 V feed with keyed XT60 outputs for the riser and the card, banana pairs on both ends for probing and for a bench supply with plain leads, and a ground post for your scope or DMM. This guide is the build order and the wire-by-wire list. The schematic it follows is [`wiring/pcie_rig_power.kicad_sch`](wiring/pcie_rig_power.kicad_sch) — open it in KiCad, or read the [PDF](wiring/pcie_rig_power.pdf) / [SVG](wiring/pcie_rig_power.svg). Rev C.

![Schematic](wiring/pcie_rig_power.svg)

**What it is, and isn't.** The source is an OWON bench supply set to **12.0 V, OVP ~12.6 V, current limit 5 A** — Northwest Repair's ceiling, and the right one for watching a card come up without letting a short cook anything. A 5 A blade fuse in the box is the backstop. Everything else in the path is overrated on purpose: 20 A switch, 30 A connectors, 14 AWG wire. This is a diagnostic rig, not a load tester.

## Parts

| Ref | Part | Where it mounts | Source |
|---|---|---|---|
| **J1** | **XT60E-M** panel-mount, male — 12 V IN. The PSU lead ends in a female XT60H | rear wall | ordered ×2 (1 spare) |
| **J2a, J2b** | 4 mm binding posts, red + black — 12 V IN, in parallel with J1 | rear wall | uxcell 10-pack, [B08LN5T9D7](https://www.amazon.com/dp/B08LN5T9D7) |
| **F1** | inline blade fuse holder + **5 A** fuse (7.5 A at most) | inside, on the + input wire | to get |
| **M1** | Peacefair **PZEM-031** — DC 8–100 V / 0–20 A, LCD, built-in shunt | top deck | sold as HiLetgo, [B079JVGRSL](https://www.amazon.com/dp/B079JVGRSL) |
| **SW1** | Ampper 20 mm round rocker, 12 V 20 A, 3-pin, illuminated dot | top deck | [B0BZPY5D9L](https://www.amazon.com/dp/B0BZPY5D9L) |
| **W1** | **WAGO 221-415** five-port lever nut — the ground bus | inside | from the 221 assortment |
| **J3** | **XT60E-F** panel-mount, female — OUT, **RISER** | right wall | ordered ×2 |
| **J4** | XT60E-F — OUT, **CARD**. Optional second output, wired in parallel with J3 | right wall | same |
| **J5a, J5b** | 4 mm binding posts, red + black — OUT +/− | right wall | same pack as J2 |
| **J6** | 4 mm binding post, black — PROBE GND | top deck | same pack |
| — | Kingwin PCIe 1x→16x riser kit (x16 board, x1 card, USB 3.0 lead, SATA→6-pin) | docks on the top deck | [B07QBF2X6C](https://www.amazon.com/dp/B07QBF2X6C) |

**Wire and terminations.** 14 AWG silicone, red and black, for everything inside. 6.3 mm insulated female spades (blue, 16–14 AWG) on the rocker's tabs. Ferrules into the meter's screw terminals and the WAGO. Ring terminals or solder on the binding posts. Heat-shrink over every splice. Four **M3 × 10** screws hold the cup to the frame (self-tapping into printed pilots, no inserts) and a drop of CA fixes the two riser dock rails.

## Where things go

| Face | Carries |
|---|---|
| **Top deck** | M1, SW1, J6, and the riser dock |
| **Rear** | J1, J2a, J2b |
| **Right** | J3, J4, J5a, J5b |
| **Inside** | F1 on the + input wire, W1 wherever it lands |
| **Front** | the drawer, nothing else |

The top is fixed — service is four screws on the sides and the cup lifts off with all its wiring intact. Nothing that carries current is on a part you remove to get at something else.

## Signal path

**12 V IN → F1 → M1 → SW1 → outputs.** The meter sits *ahead* of the switch, so it reads the supply whenever the supply is on; the switch only gates the outputs. That's deliberate: you see 12.0 V on the box before you ever enable the card.

## Wire by wire

Net names match the schematic. All 14 AWG unless noted.

| # | From | To | Net | Notes |
|---|---|---|---|---|
| 1 | J1 **+** | F1, either end | `12V_IN` | J2a (red post) ties to the same point — parallel input |
| 2 | F1, other end | M1 terminal **3** — DC IN + | `12V_IN_FUSED` | |
| 3 | J1 **−** | M1 terminal **2** — DC IN − | `GND_IN` | J2b (black post) ties here too. **Not to the WAGO** — see below |
| 4 | M1 terminal **4** — LOAD + | SW1 **A** (power) | `12V_METERED` | |
| 5 | SW1 **B** (load) | J3 +, J4 +, J5a | `+12V_OUT` | three wires off the B tab, or B → J5a and daisy from there |
| 6 | M1 terminal **1** — LOAD − | W1 port **5** | `GND_OUT` | the ground bus starts here |
| 7 | W1 port **4** | J3 − | `GND_OUT` | RISER |
| 8 | W1 port **3** | J4 − | `GND_OUT` | CARD |
| 9 | W1 port **2** | J5b (black post) | `GND_OUT` | |
| 10 | W1 port **1** | J6 (probe post) | `GND_OUT` | |
| 11 | SW1 **yellow** (LED −) | J5b's terminal | `GND_OUT` | 18 AWG is fine; it shares the OUT − post's ring terminal |

**PZEM-031 terminals**, top to bottom as printed on its back: **1 LOAD −, 2 DC IN −, 3 DC IN +, 4 LOAD +.** The + side passes straight through 3 → 4; the shunt sits between 2 and 1.

**Why the input negative does not go on the WAGO.** The meter measures current as the drop across its internal shunt, which is in the negative leg between terminals 2 and 1. Land the input negative on the bus and the current bypasses the shunt: the meter reads 0.00 A forever and the rig looks dead when it isn't. Input − goes to terminal 2, the bus hangs off terminal 1, and the probe post — J6 — is on that bus, so a scope reference sees exactly what the card sees.

**Why the rocker's B and yellow must never swap.** A = supply, B = load, yellow = LED return to ground. Put the load wire on yellow and ground on B and the first flick of the switch is a dead short across the meter. Beep the three pins in continuity mode before you crimp: A–B closes when the rocker is on, yellow never closes to either.

## Leads (you build these, they live in the drawer)

All from the six-pack of 6+2 dual-output PCIe cords. Cut the PSU-side 8-pin off each and put a **male XT60H** (AMASS, with the sheath housing) on the cut end: yellows to +, blacks to −.

- **Dual lead.** One cord → XT60H → 2 × 8(6+2). Feeds the riser's 6-pin (leave the +2 tail off) and one card connector, or two card connectors.
- **Quad lead.** Two cords → 4 × 8-pin, for the 4×8-pin → 12VHPWR adapter. Twelve 18 AWG wires won't go in one XT60 solder cup — splice them to a short **12 AWG XT60 pigtail** instead, heat-shrunk.
- **Riser lead.** Only if the riser gets its own 12 V feed rather than sharing the dual lead.

Beep every lead end-to-end before it touches a card: + to every yellow pin, − to every black, nothing between.

## Build order

1. **Dry-fit every panel part** in the printed cup before wiring anything — meter, rocker, XT60s, five posts. If something doesn't fit, fix the print, not the part.
2. **Mount the panel parts.** Posts get their nuts and a ring terminal each. XT60E panels screw to their ears.
3. **Input side** (rows 1–3): J1 + and J2a → F1 → M1.3. J1 − and J2b → M1.2. Ferrules into the meter.
4. **Meter to switch** (row 4): M1.4 → spade → SW1 A.
5. **Outputs** (row 5): SW1 B → J3 +, J4 +, J5a.
6. **Ground bus** (rows 6–11): M1.1 into W1 port 5, then one lever per consumer. LED yellow onto J5b's terminal.
7. **Fuse in.** 5 A blade.
8. **Leave slack.** For service the four side screws come out and the cup lifts off with the shelf; nothing crosses that joint, but make sure no wire pulls tight against the shelf's edge when it does.

## Before first power

Do these with nothing plugged into J1 or J2.

- **Continuity.** J1 + to M1.3 through the fuse. M1.4 to SW1 A. Rocker on: SW1 A to every output +. Rocker off: open. M1.1 to every output −, J5b and J6.
- **Polarity.** Every + is on the meter's LOAD + side of the switch and *only* there. Every − lands on M1.1's bus and nowhere else. J1 − and J2b go to M1.2, not to the bus.
- **No shorts.** + bus to − bus reads open, rocker on and off. J1 + to J1 − reads open.
- **The rocker's yellow** does not beep to A or B.

Then: OWON at 12.0 V, OVP 12.6 V, current limit turned down to 0.5 A for this step, into J1 or J2 — **nothing on the outputs.** The meter wakes reading ~12 V, 0.00 A. Rocker on: the dot lights, outputs read 12 V. Rocker off: outputs dead, meter still lit. Raise the limit to 5 A. Only now does a lead go on.

## Limits

- **5 A working limit**, set at the supply. Fuse at 5 A, 7.5 A at most. Never above the meter's 20 A.
- The meter needs ≥ 8 V to run. Below that it goes dark; the rig still passes power.
- Everything downstream of an XT60 runs on the lead's 18 AWG yellows. Fine at 5 A. Fine at 20. Not at 30.
- If the rig is ever fed from something other than the OWON, add a reverse-polarity module on the input first. XT60 is keyed; banana posts are not.

## Files

- [`wiring/pcie_rig_power.kicad_sch`](wiring/pcie_rig_power.kicad_sch) — KiCad 10 schematic, the source. ERC clean with every severity on.
- [`wiring/pcie_rig_power.pdf`](wiring/pcie_rig_power.pdf), [`wiring/pcie_rig_power.svg`](wiring/pcie_rig_power.svg) — renders. Regenerate with `kicad-cli sch export pdf` / `svg`.
