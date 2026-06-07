#!/usr/bin/env bash
# Build release artifacts for one model: rendered STL(s) + a preview PNG each.
#
#     tools/build_release.sh <model-slug> [out-dir]
#
# Renders every .scad in <model-slug>/ to a binary STL (skipping library files
# with no top-level geometry), then renders a Blender preview PNG for each STL.
# Artifacts land in <out-dir> (default: dist/).
#
# Env:
#   OPENSCAD   openscad binary (default: openscad, or the macOS app)
#   BLENDER    blender binary  (default: blender, or the macOS app)
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

slug="${1:?usage: build_release.sh <model-slug> [out-dir]}"
out_dir="${2:-dist}"
model_dir="$slug"

[ -d "$model_dir" ] || { echo "no such model directory: $model_dir" >&2; exit 1; }

OPENSCAD="${OPENSCAD:-openscad}"
command -v "$OPENSCAD" >/dev/null 2>&1 || OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
BLENDER="${BLENDER:-blender}"
command -v "$BLENDER" >/dev/null 2>&1 || BLENDER="/Applications/Blender.app/Contents/MacOS/Blender"

mkdir -p "$out_dir"
count=0

# optional per-model render color (hex), e.g. "#d2741f"
color=""
[ -f "$model_dir/preview-color.txt" ] && color="$(tr -d '[:space:]' < "$model_dir/preview-color.txt")"

# Release renders run on a denoiser-less CPU runner, once per part — keep them
# fast/light. (Committed README previews are rendered locally at full quality.)
export PREVIEW_SAMPLES="${PREVIEW_SAMPLES:-48}"
export PREVIEW_RES_X="${PREVIEW_RES_X:-1100}"
export PREVIEW_RES_Y="${PREVIEW_RES_Y:-825}"

while IFS= read -r -d '' scad; do
  base="$(basename "${scad%.scad}")"
  stl="$out_dir/$base.stl"
  echo "▶ render $scad → $stl"
  "$OPENSCAD" -o "$stl" --export-format binstl "$scad" 2>&1 | grep -iE "error|warning" || true
  [ -f "$stl" ] || { echo "  ↳ skip (library file, no geometry)"; continue; }

  echo "  validate"
  python3 tools/validate_stl.py "$stl"

  png="$out_dir/$base.png"
  echo "  preview → $png"
  "$BLENDER" -b -P tools/render_preview.py -- "$stl" "$png" $color >/dev/null
  count=$((count + 1))
done < <(find "$model_dir" -name '*.scad' -print0)

echo "—"
echo "release artifacts for '$slug' in $out_dir/:"
ls -1 "$out_dir"
[ "$count" -gt 0 ] || { echo "no renderable models found in $model_dir" >&2; exit 1; }
