#!/usr/bin/env bash
# Build a custom Arch ISO that auto-runs archinstall on boot.
# Uses the OFFICIAL releng profile + mkarchiso. We only add an autostart hook
# and our config files into airootfs — no reinventing of the ISO build.
# Run inside the arch-builder container (needs --privileged for loop devices).
source "$(dirname "$0")/lib.sh"

PROFILE=/tmp/archlive
OUT="$OUTPUT"

command -v mkarchiso >/dev/null || die "mkarchiso not found — run inside arch-builder container."
[ -f "$REPO_ROOT/configs/arch/user_credentials.json" ] \
  || die "Create configs/arch/user_credentials.json from the .example.json first."

log "Copying official releng profile..."
rm -rf "$PROFILE"; cp -r /usr/share/archiso/configs/releng "$PROFILE"

log "Adding our config + autostart hook into airootfs..."
install -Dm644 "$REPO_ROOT/configs/arch/user_configuration.json" "$PROFILE/airootfs/root/user_configuration.json"
install -Dm600 "$REPO_ROOT/configs/arch/user_credentials.json"   "$PROFILE/airootfs/root/user_credentials.json"
install -Dm755 "$REPO_ROOT/configs/arch/automated_install.sh"     "$PROFILE/airootfs/root/automated_install.sh"

# archiso auto-logs in as root on tty1 and sources /root/.zlogin. Hook our script.
cat >> "$PROFILE/airootfs/root/.zlogin" <<'EOF'

# --- unattended install autostart (added by build-arch-usb.sh) ---
if [ "$(tty)" = "/dev/tty1" ]; then
  /root/automated_install.sh 2>&1 | tee /root/install.log
fi
EOF

log "Building ISO with mkarchiso (this takes a while)..."
mkarchiso -v -w /tmp/archwork -o "$OUT" "$PROFILE"

log "Built Arch ISO in: $OUT"
log "Next: scripts/write-usb.sh $OUT/archlinux-*.iso /dev/sdX   (on the HOST)"
