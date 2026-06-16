#!/usr/bin/env bash
# Arch Linux — unattended installer wrapper.
# Uses the OFFICIAL `archinstall` tool (shipped in the Arch ISO). We do not
# reinvent partitioning — we only detect the largest disk, inject it into the
# archinstall JSON, then hand off to `archinstall --silent`.
#
# Runs automatically on ISO boot via airootfs hook (see scripts/build-arch-usb.sh).
# Docs: https://github.com/archlinux/archinstall
set -euo pipefail

CONF=/root/user_configuration.json
CREDS=/root/user_credentials.json

# --- detect largest disk (TYPE=disk excludes the USB/loop the live env runs on
#     only if the USB enumerates as 'disk' too — see SAFETY note in README) ---
largest=$(lsblk -dnb -o NAME,TYPE,SIZE | awk '$2=="disk"{print $3,$1}' | sort -rn | head -1 | awk '{print $2}')
dev="/dev/${largest}"
echo ">> Target disk auto-selected: ${dev}"

# Inject the device path into the archinstall config (jq ships on the ISO).
tmp=$(mktemp)
jq --arg d "$dev" '
  .disk_config.device_modifications[0].device = $d
' "$CONF" > "$tmp" && mv "$tmp" "$CONF"

# Hand off to the official tool. --silent = zero prompts.
archinstall --config "$CONF" --creds "$CREDS" --silent

echo ">> Install finished. Rebooting in 10s..."
sleep 10
systemctl reboot
