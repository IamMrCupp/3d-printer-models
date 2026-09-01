#!/usr/bin/env bash
#
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
#
# Render every model part into the bench print queue.
#
#     tools/export_queue.sh [--check]
#
# WHY THIS EXISTS: STLs were being exported by hand, one model at a time,
# whenever someone remembered. Parts that had just been fixed and released sat in
# the repo with a stale or missing STL in the queue, and "I can't print what I
# can't find" is the entirely reasonable result.
#
# --check reports drift without writing anything. No argument writes.
#
# Queue folders are numbered and curated by hand; this maps a model directory to
# one by looking for the model's name inside the folder's name, with an explicit
# table for the ones that do not match. Coupons go to the gauges folder, because
# the whole point of a coupon is that it is printed first.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
QUEUE="$HOME/Downloads/bench-print-queue"
CHECK=0; [ "${1:-}" = "--check" ] && CHECK=1
OPENSCAD="${OPENSCAD:-openscad}"
command -v "$OPENSCAD" >/dev/null 2>&1 || OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

# model dir -> queue folder, only where the name does not match
declare -a OVERRIDE=(
  "heat-gun-holder:12-heat-gun"
  "rotary-tool-station:3-rotary-tool-station-HARDELL"
  "sticker-holder-inserts:5-status-unknown-ASK-FIRST/sticker-holder-inserts"
  "vj-rig-stand:5-status-unknown-ASK-FIRST/vj-rig-stand"
  "stand-cable-clamp:5-status-unknown-ASK-FIRST/stand-cable-clamp"
  "apache-5800-cord-organizer:5-status-unknown-ASK-FIRST/apache-5800-cord-organizer"
  "donation-qr-stand:5-status-unknown-ASK-FIRST/donation-qr-stand"
  "gridfinity-fillers:5-status-unknown-ASK-FIRST/gridfinity-fillers"
)

# Models deliberately NOT in the queue: printed and confirmed in service, so an
# STL sitting in the print list is noise. See the queue README's "Not here, and
# why". Listed rather than silently skipped, so removing one is a decision.
declare -a NOT_QUEUED=(
  syringe-holders uv-mask-station instrument-holders engindot-shortkiller-topper
  owon-spm8104-tray drybox-splitter-stand bench-cleaning-station-legacy
)

# Models whose CURRENT source lives on an unmerged branch. Exporting these from
# main would overwrite a newer STL with an older one — the exact regression this
# tool exists to prevent. Empty this as the PRs land.
declare -a ON_A_BRANCH=(
)

queue_for() {
  local m="$1" o
  for o in "${OVERRIDE[@]}"; do
    [ "${o%%:*}" = "$m" ] && { echo "$QUEUE/${o#*:}"; return; }
  done
  local hit
  hit="$(find "$QUEUE" -maxdepth 1 -type d -name "*${m}*" | head -1)"
  [ -n "$hit" ] && echo "$hit" || echo ""
}

miss=0; drift=0; ok=0
for dir in "$REPO"/*/; do
  m="$(basename "$dir")"
  case "$m" in lib|tools|.github|build) continue;; esac
  [ -f "$dir/README.md" ] || continue
  skip=0
  for x in "${NOT_QUEUED[@]}"; do [ "$x" = "$m" ] && skip=1; done
  for x in "${ON_A_BRANCH[@]}"; do
    [ "$x" = "$m" ] && { echo "  held     $m — newer source is on an unmerged branch"; skip=1; }
  done
  [ "$skip" = 1 ] && continue

  for f in "$dir"*.scad "$dir"coupons/*.scad; do
    [ -e "$f" ] || continue
    case "$(basename "$f")" in *_common.scad|_*) continue;; esac

    n="$(basename "$f" .scad)"
    if [[ "$f" == *"/coupons/"* ]]; then
      out="$QUEUE/1-print-first-gauges"
    else
      out="$(queue_for "$m")"
    fi
    if [ -z "$out" ]; then
      echo "  UNMAPPED  $m/$n — no queue folder matches '$m'"; miss=$((miss+1)); continue
    fi

    tmp="$(mktemp -t exq).stl"
    "$OPENSCAD" -o "$tmp" --export-format binstl "$f" >/dev/null 2>&1
    # No output means no top-level geometry — a library/data file, not a part.
    # CI skips these the same way; they are not a failure.
    if [ ! -s "$tmp" ]; then rm -f "$tmp"; continue; fi
    if ! python3 "$REPO/tools/validate_stl.py" "$tmp" >/dev/null 2>&1; then
      echo "  INVALID MESH   $m/$n — refusing to export"; miss=$((miss+1)); rm -f "$tmp"; continue
    fi

    dst="$out/$n.stl"
    if [ -f "$dst" ] && cmp -s "$tmp" "$dst"; then
      ok=$((ok+1))
    else
      drift=$((drift+1))
      if [ "$CHECK" = "1" ]; then
        echo "  STALE     ${dst#$QUEUE/}"
      else
        mkdir -p "$out"; cp "$tmp" "$dst"
        echo "  exported  ${dst#$QUEUE/}"
      fi
    fi
    rm -f "$tmp"
  done
done
echo "—"
echo "current: $ok   $( [ "$CHECK" = 1 ] && echo stale || echo written ): $drift   problems: $miss"
[ "$miss" -gt 0 ] && exit 1 || exit 0
