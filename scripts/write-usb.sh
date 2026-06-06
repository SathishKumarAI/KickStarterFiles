#!/usr/bin/env bash
# Write a built ISO to a USB stick. DESTRUCTIVE — guarded by lib.sh confirm.
# Runs on the HOST (needs the physical USB + root). NOT for use in containers.
#
#   sudo ./scripts/write-usb.sh output/rocky9-auto.iso /dev/sdX
#
# Pass the device EXPLICITLY. The script never auto-picks a disk.
source "$(dirname "$0")/lib.sh"

ISO="${1:-}"; DEV="${2:-}"

if [ -z "$ISO" ] || [ -z "$DEV" ]; then
  warn "Available removable devices:"
  lsblk -dno NAME,SIZE,MODEL,TRAN | awk '$4=="usb"{print "/dev/"$0}' || true
  die "usage: sudo $0 <iso> <device>   e.g. sudo $0 output/rocky9-auto.iso /dev/sdb"
fi
[ -f "$ISO" ] || die "ISO not found: $ISO"

confirm_destructive "$DEV"

log "Writing $ISO -> $DEV ..."
dd if="$ISO" of="$DEV" bs=4M status=progress oflag=sync
sync
log "Done. Eject, plug into target machine, boot from USB."
