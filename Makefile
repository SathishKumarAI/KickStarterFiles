# Shared entrypoints. Distro-specific build targets live on the distro branches
# (distro/rocky, distro/arch). This Makefile holds only cross-distro helpers.
.PHONY: help download write-usb clean

help:
	@echo "Shared targets (run distro builds on the distro/* branches):"
	@echo "  make download D=rocky|arch|all   # fetch official ISOs -> downloads/"
	@echo "  make write-usb ISO=path DEV=/dev/sdX   # DESTRUCTIVE, host only, confirms"
	@echo "  make clean                       # remove build outputs"
	@echo ""
	@echo "Per-distro build lives on its branch:"
	@echo "  git switch distro/rocky && make build   (Rocky)"
	@echo "  git switch distro/arch  && make build   (Arch)"

download:
	./scripts/download-isos.sh $(or $(D),all)

write-usb:
	@test -n "$(ISO)" -a -n "$(DEV)" || { echo "usage: make write-usb ISO=path DEV=/dev/sdX"; exit 1; }
	sudo ./scripts/write-usb.sh "$(ISO)" "$(DEV)"

clean:
	rm -rf output/* packer/packer_cache
