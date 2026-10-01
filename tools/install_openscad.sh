#!/usr/bin/env bash
#
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Aaron Cupp
# Install the one pinned OpenSCAD development snapshot that CI renders with.
#
#     tools/install_openscad.sh        # then: openscad --version
#
# Shared by .github/workflows/validate.yml, release.yml, and the local Docker
# repro, so every renderer that gates or ships a model is the same build. The
# dev machine's own 2026.09.23 renders identical meshes, so it needs none of
# this; the Docker line is for any other machine:
#
#     docker run --rm --platform linux/amd64 -v "$PWD":/w -w /w ubuntu:24.04 \
#       bash -c 'tools/install_openscad.sh && tools/render.sh'
#
# Why a snapshot: 2021.01 is the last official stable release and the only one
# Ubuntu packages. It disagrees with current builds on what's manifold (hull of
# circles fails on 2021.01, offset(R) offset(-R) on 2026.06), so CI and the dev
# machine used to judge the same model differently. ppa:openscad/releases was
# tried in 658bc7c and has no noble archive — apt 404'd and every PR broke.
#
# Pinned by exact filename + sha256, never a "latest" URL. To bump: pick a
# build from https://files.openscad.org/snapshots/, update both values below,
# and diff every model's volume against the old pin before merging.
# files.openscad.org keeps roughly a year of snapshots (oldest on 2026-09-28
# was 2025.09.28), so this pin 404s around 2027-09 — bump before then.
#
# Linux x86_64 only (the AppImage). Uses sudo when not root.
set -euo pipefail

OPENSCAD_VERSION="2026.09.23"
OPENSCAD_SHA256="033762f4e0b0de7a2c6cf2b5a12febb29d60ba62ede227d57b1c8b675a94710a"
OPENSCAD_HOME="${OPENSCAD_HOME:-/opt/openscad}"

appimage="OpenSCAD-${OPENSCAD_VERSION}-x86_64.AppImage"
url="https://files.openscad.org/snapshots/${appimage}"

sudo=""
[ "$(id -u)" -eq 0 ] || sudo="sudo"

# The AppImage bundles Qt/CGAL/Manifold but links the host's GL, X and font
# stack — without these it fails with "libEGL.so.1 => not found" even for a
# headless STL export. Most are already on the GitHub runner image; the list
# is what a bare ubuntu:24.04 is missing. DEBIAN_FRONTEND stops apt blocking
# on a prompt nobody can answer.
pkgs=(ca-certificates curl libegl1 libgl1 libglx0 libopengl0 libx11-6
      libx11-xcb1 libxcb1 libdrm2 libgbm1 libwayland-client0 libexpat1
      libfontconfig1 libfreetype6 libharfbuzz0b)
command -v python3 >/dev/null 2>&1 || pkgs+=(python3)
$sudo env DEBIAN_FRONTEND=noninteractive apt-get update -qq -o Acquire::Retries=3
$sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
  --no-install-recommends -o Acquire::Retries=3 "${pkgs[@]}" >/dev/null

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL --retry 3 -o "$tmp/$appimage" "$url"
echo "${OPENSCAD_SHA256}  $tmp/$appimage" | sha256sum -c -

# Extract rather than mount: --appimage-extract needs no FUSE, which neither
# the runner nor a container has. Bytes 8-10 of an AppImage are its "AI\x02"
# magic, which the kernel ignores on native x86_64 but which stops binfmt_misc
# matching it under amd64 emulation (Docker on Apple Silicon: "Exec format
# error"). Zeroing them — after the checksum — makes one path work in both.
printf '\0\0\0' | dd of="$tmp/$appimage" bs=1 seek=8 conv=notrunc status=none
chmod +x "$tmp/$appimage"
(cd "$tmp" && "./$appimage" --appimage-extract >/dev/null)

$sudo rm -rf "$OPENSCAD_HOME"
$sudo mkdir -p "$OPENSCAD_HOME"
$sudo mv "$tmp/squashfs-root" "$OPENSCAD_HOME/"
# A wrapper, not a symlink: AppRun locates its bundled libraries from its own
# path, so it must be exec'd from inside squashfs-root.
printf '#!/bin/sh\nexec %s/squashfs-root/AppRun "$@"\n' "$OPENSCAD_HOME" \
  | $sudo tee /usr/local/bin/openscad >/dev/null
$sudo chmod +x /usr/local/bin/openscad

openscad --version
