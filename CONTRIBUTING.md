# Contributing

Thanks for helping out. This project automates **destructive** OS installs, so the
bar is: change it safely, test in a VM, never surprise a user with data loss.

## Ground rules

- **Test in a VM first.** Use the Packer loop (`docs/USAGE.md`). Never validate on real hardware or a daily-driver machine.
- **Keep `main` configs-agnostic.** Shared scaffold only (docs, `scripts/`, `Makefile`). Distro specifics (Kickstart, `archinstall` creds, Packer templates) live on `distro/rocky` / `distro/arch`.
- **Never commit secrets.** Passwords, `user_credentials.json`, and per-host config stay gitignored.
- **Preserve the safety guards.** `confirm_destructive()` in `scripts/lib.sh` and the explicit-device requirement in `write-usb.sh` must stay. Don't add auto-disk-picking.

## Workflow

1. Fork the repo.
2. Branch from the right base — `main` for shared scaffold, `distro/*` for distro work:
   ```sh
   git checkout -b feature/AmazingFeature
   ```
3. Make the change. Test it in a VM.
4. Commit with a clear message:
   ```sh
   git commit -m "Add AmazingFeature"
   ```
5. Push and open a Pull Request describing **what** changed and **how you tested it**.

## Opening issues

Before filing, search existing issues. Then include:

- **What you ran** — exact command, branch, distro.
- **What happened vs. expected** — paste error output verbatim, no paraphrasing.
- **Environment** — host OS, Docker version, Packer version, target (VM vs. bare metal).
- **Data loss?** — state whether any disk was wiped, so it can be triaged by severity.

Labels: `bug` (defect), `enhancement` (request), `safety` (anything that could cause
unintended data loss — these jump the queue).

## Reporting a safety/security issue

If a change could wipe the wrong disk, leak credentials, or bypass a confirm prompt,
flag it with the `safety` label (or mark the issue private if the repo supports it).
Describe the trigger and the blast radius. These are top priority.

## Thanks

Every issue, repro, and PR makes the installer safer and more reliable. Appreciated. 🙏
