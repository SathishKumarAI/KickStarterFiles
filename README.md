# KickStarterFiles

Zero-touch (unattended) OS installer for **Rocky Linux** and **Arch Linux** from a USB stick.
Plug in → boot → installs → reboots. No keystrokes.

## What this is

A small, configs-agnostic scaffold that turns official OS install media into fully
unattended USB installers, plus a Packer/QEMU loop to test the whole thing in a VM
before touching real hardware. Nothing here reinvents the wheel — it wires together
the official, distro-supported automation tools:

| Job | Tool | Owner |
|-----|------|-------|
| Rocky config | Kickstart | Rocky / Fedora |
| Rocky ISO inject | `mkksiso` | lorax (official) |
| Arch config | `archinstall --silent` | Arch (official) |
| Arch ISO build | `mkarchiso` (releng) | Arch (official) |
| VM test loop | HashiCorp Packer + QEMU/KVM | HashiCorp |
| Build env | Docker | — |

## Who it's for

Anyone provisioning lab machines, VMs, or bare metal repeatably — homelab, CI runners,
classroom fleets, reinstall-heavy dev boxes. If you reinstall the same OS more than
twice, this saves the clicking.

## ⚠️ Safety — read first

Unattended installs **auto-wipe the largest disk** on the target with **no confirmation
at install time**. Once a target boots from the USB, it installs unattended.

- `write-usb.sh` is the only destructive step on your host. It **requires an explicit
  device** (`DEV=/dev/sdX`) and **double-confirms**. It never auto-picks a disk.
- **Never build or boot this on your daily-driver machine.** Test in a VM (Packer) first.
- Treat any plugged-in USB installer as live ammunition — label it, unplug it when done.

Full safety walkthrough: [docs/USAGE.md](docs/USAGE.md#%EF%B8%8F-safety).

## Layout

- `main` — shared scaffold: docs, `scripts/`, `Makefile`.
- `distro/rocky` — Rocky configs, build script, Packer template.
- `distro/arch` — Arch configs, build script, Packer template.

New distro later → new branch off `main`.

## Quick start

```sh
make download D=all                                     # fetch official ISOs -> downloads/
git switch distro/rocky                                 # or distro/arch
# build the ISO on the distro branch (see docs/USAGE.md), then:
make write-usb ISO=output/rocky9-auto.iso DEV=/dev/sdX  # DESTRUCTIVE, explicit device
```

## Docs

- [docs/USAGE.md](docs/USAGE.md) — full build → write → install flow, plus what to change before real use.
- [docs/NOTES.md](docs/NOTES.md) — working notes and references.
- [docs/TODO.md](docs/TODO.md) — roadmap and future tasks.
- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute, report bugs, and open issues.
- [docs/REGENERATE.md](docs/REGENERATE.md) — system prompt to regenerate these docs.

## Contributing

PRs and issues welcome. Quick version:

1. Fork, branch (`git checkout -b feature/thing`), commit, push, open a PR.
2. Test changes in a VM (Packer), never on real hardware.
3. Keep `main` configs-agnostic — distro specifics belong on `distro/*` branches.

Full guide: [CONTRIBUTING.md](CONTRIBUTING.md).

## Reporting bugs / opening issues

Open an issue with:

- **What you ran** — exact command, branch, and distro.
- **What happened vs. expected** — include error output verbatim.
- **Environment** — host OS, Docker/Packer versions, target (VM or bare metal).
- **Safety note** — confirm whether data loss occurred so it can be prioritized.

Label `bug` for defects, `enhancement` for requests. See [CONTRIBUTING.md](CONTRIBUTING.md#opening-issues).

## Acknowledgments & thanks

Standing on the shoulders of the projects that do the real work:

- [Rocky Linux](https://rockylinux.org/) & [Fedora Kickstart](https://docs.fedoraproject.org/en-US/fedora/latest/install-guide/) — `mkksiso`, Kickstart.
- [Arch Linux](https://archlinux.org/) — `archinstall`, `mkarchiso` / releng.
- [HashiCorp Packer](https://www.packer.io/) + [QEMU/KVM](https://www.qemu.org/) — the VM test loop.
- [Docker](https://www.docker.com/) — reproducible build env.

Thanks to everyone filing issues and PRs — it keeps the installer honest.

## License

Distributed under the MIT License.
