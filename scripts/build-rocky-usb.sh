#!/usr/bin/env bash
# Inject ks.cfg into the Rocky ISO using the OFFICIAL mkksiso tool.
# Produces output/rocky9-auto.iso — a hybrid ISO ready for dd to USB.
# Run inside the rocky-builder container (mkksiso lives there).
source "$(dirname "$0")/lib.sh"

IN="$DOWNLOADS/rocky9-minimal.iso"
OUT="$OUTPUT/rocky9-auto.iso"
KS="$REPO_ROOT/configs/rocky/ks.cfg"

[ -f "$IN" ] || die "Missing $IN — run scripts/download-isos.sh rocky first."
command -v mkksiso >/dev/null || die "mkksiso not found — run inside rocky-builder container."

log "Injecting kickstart + setting boot to auto-start install (timeout 0)..."
# mkksiso embeds the ks and rewrites the bootloader to pass inst.ks + auto-boot.
mkksiso --ks "$KS" "$IN" "$OUT"

log "Built: $OUT"
log "Next: scripts/write-usb.sh $OUT /dev/sdX   (on the HOST, choose your USB)"
