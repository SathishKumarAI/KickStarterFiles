#!/usr/bin/env bash
# Shared helpers + SAFETY guards. Sourced by the other scripts.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOWNLOADS="${REPO_ROOT}/downloads"
OUTPUT="${REPO_ROOT}/output"
mkdir -p "$DOWNLOADS" "$OUTPUT"

# Official mirrors. Pin versions/URLs as needed.
ROCKY_ISO_URL="https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9-latest-x86_64-minimal.iso"
ARCH_ISO_URL="https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"

log()  { printf '\033[1;34m>> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*" >&2; }
die()  { printf '\033[1;31mXX %s\033[0m\n' "$*" >&2; exit 1; }

# --- SAFETY: refuse to write to a disk unless caller passed it EXPLICITLY and
#     confirmed. Never auto-pick a device for a destructive write. ---
confirm_destructive() {
  local dev="$1"
  [ -b "$dev" ] || die "Not a block device: $dev"
  warn "About to OVERWRITE ALL DATA on: $dev"
  lsblk "$dev" || true
  warn "This is IRREVERSIBLE."
  read -r -p "Type the device path again to confirm ($dev): " ans
  [ "$ans" = "$dev" ] || die "Mismatch. Aborting — nothing written."
}

download() {
  local url="$1" dest="$2"
  [ -f "$dest" ] && { log "Cached: $dest"; return; }
  log "Downloading $url"
  curl -L --fail -o "$dest" "$url"
}
