#!/usr/bin/env bash
# Download official Rocky + Arch ISOs into ./downloads (cached).
source "$(dirname "$0")/lib.sh"

case "${1:-all}" in
  rocky) download "$ROCKY_ISO_URL" "$DOWNLOADS/rocky9-minimal.iso" ;;
  arch)  download "$ARCH_ISO_URL"  "$DOWNLOADS/archlinux.iso" ;;
  all)
    download "$ROCKY_ISO_URL" "$DOWNLOADS/rocky9-minimal.iso"
    download "$ARCH_ISO_URL"  "$DOWNLOADS/archlinux.iso"
    ;;
  *) die "usage: $0 [rocky|arch|all]" ;;
esac
log "Done. ISOs in $DOWNLOADS"
