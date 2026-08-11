#!/usr/bin/env bash
#
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
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

# The second argument is an OUT-DIR, not a version — this script doesn't tag
# anything. Passing "v1.0.4" quietly creates ./v1.0.4/ in the repo root, whose
# PNGs then get swept in by `git add -A` (happened 2026-07-31 and again
# 2026-08-08). Catch it instead of silently obeying.
case "$out_dir" in
  v[0-9]*)
    echo "refusing: out-dir '$out_dir' looks like a version." >&2
    echo "  build_release.sh takes <model-slug> [out-dir] — it does not tag." >&2
    echo "  Did you mean:  tools/build_release.sh $slug" >&2
    echo "  (artifacts go to dist/; tag separately with git tag / gh release)" >&2
    exit 2
    ;;
esac

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
  png="$out_dir/$base.png"
  echo "▶ render $scad → $stl"
  # Clear prior artifacts first. The library-skip check below keys on the STL's
  # absence, so a stale STL makes a module-only source "pass" — validated and
  # previewed as a mesh it never produced. A stale PNG outlives the skip
  # entirely. Either would ship as a release asset (`gh release create dist/*`).
  # (dist/ is fresh on the CI runner, but persists across local invocations.)
  rm -f "$stl" "$png"
  "$OPENSCAD" -o "$stl" --export-format binstl "$scad" 2>&1 | grep -iE "error|warning" || true
  [ -f "$stl" ] || { echo "  ↳ skip (library file, no geometry)"; continue; }

  echo "  validate"
  python3 tools/validate_stl.py "$stl"

  echo "  preview → $png"
  "$BLENDER" -b -P tools/render_preview.py -- "$stl" "$png" $color >/dev/null
  count=$((count + 1))
done < <(find "$model_dir" -name '*.scad' -print0)

echo "—"
echo "release artifacts for '$slug' in $out_dir/:"
ls -1 "$out_dir"
[ "$count" -gt 0 ] || { echo "no renderable models found in $model_dir" >&2; exit 1; }
