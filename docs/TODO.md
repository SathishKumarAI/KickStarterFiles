# Roadmap & Future Tasks

Tracks planned work. Move items to issues/PRs as they get picked up.

## Near term

- [ ] Finish Win11 + Rocky9 VM connectivity test (bridge network) — see [NOTES.md](NOTES.md).
- [ ] Build the KS file that drives the HTTP(S) installation path end to end.
- [ ] Document the bridge-network setup steps as a reproducible recipe.
- [ ] Add ISO checksum pinning to both Packer templates (`iso_checksum`).

## Build & test

- [ ] CI: run `packer build` in a VM for both distros on PR.
- [ ] Smoke test for `write-usb.sh` against a loopback device (no real USB needed).
- [ ] Cache downloaded ISOs between CI runs.

## Safety hardening

- [ ] Dry-run flag for `write-usb.sh` (print plan, write nothing).
- [ ] Refuse to write to a device that is currently mounted.
- [ ] Optional target-disk allowlist instead of "largest disk wins".

## Docs

- [ ] Screenshots / asciinema of a full unattended run.
- [ ] Per-distro config reference (every field in `ks.cfg` / `user_credentials.json`).
- [ ] Troubleshooting page (boot order, Secure Boot, network ping issues — see [NOTES.md](NOTES.md)).

## Distros (new branches off `main`)

- [ ] Debian / Ubuntu (preseed / autoinstall).
- [ ] openSUSE (AutoYaST).
