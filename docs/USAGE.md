# Usage — Unattended Rocky / Arch installer

Zero-touch OS install from USB. Plug in → boot → installs → reboots. **No keystrokes.**
Built on open-source tools — nothing reinvented:

| Job | Tool | Owner |
|-----|------|-------|
| Rocky config | Kickstart | Rocky/Fedora |
| Rocky ISO inject | `mkksiso` | lorax (official) |
| Arch config | `archinstall --silent` | Arch (official) |
| Arch ISO build | `mkarchiso` (releng) | Arch (official) |
| VM test loop | HashiCorp Packer + QEMU/KVM | HashiCorp |
| Build env | Docker | — |

## Branch layout

- `main` — shared scaffold (this doc, `scripts/lib.sh`, `download-isos.sh`, `write-usb.sh`, `Makefile`).
- `distro/rocky` — Rocky configs + build script + Packer template.
- `distro/arch` — Arch configs + build script + Packer template.

New distro later → new branch off `main`.

```
git switch distro/rocky   # or distro/arch
```

## ⚠️ Safety

- Unattended install **auto-wipes the largest disk** on the target. No confirm at install time.
- `write-usb.sh` is the only destructive host step — it **requires an explicit device** and double-confirms. It never auto-picks a disk.
- **Do not run builds/installs on your daily-driver machine.** Test in a VM (Packer) first.

## Flow

### 1. Download official ISOs (shared)
```
make download D=all        # or D=rocky / D=arch  -> downloads/
```

### 2a. Test in a VM first (recommended)
```
git switch distro/rocky    # or distro/arch
cd packer && packer init . && packer build rocky.pkr.hcl
```

### 2b. Build the bare-metal USB ISO (in Docker)
```
# Rocky (on distro/rocky):
docker compose run --rm rocky-builder ./scripts/build-rocky-usb.sh
# Arch (on distro/arch): create creds first
cp configs/arch/user_credentials.example.json configs/arch/user_credentials.json
docker compose run --rm arch-builder ./scripts/build-arch-usb.sh
```

### 3. Write to USB (HOST, destructive, explicit device)
```
lsblk                      # find your USB, e.g. /dev/sdb
make write-usb ISO=output/rocky9-auto.iso DEV=/dev/sdb
```

### 4. Boot target from USB → unattended install runs.

## Before real use — change these
- `configs/rocky/ks.cfg`: `rootpw`, user, locale/timezone.
- `configs/arch/user_credentials.json`: passwords (gitignored).
- ISO checksums in the Packer templates (`iso_checksum`).
