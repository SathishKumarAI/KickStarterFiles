# Build env for Arch USB ISO.
# archiso provides mkarchiso (official Arch ISO builder). jq for config injection.
FROM archlinux:latest

RUN pacman -Sy --noconfirm archiso jq curl squashfs-tools libisoburn \
    && pacman -Scc --noconfirm

WORKDIR /work
# mkarchiso needs root + loop devices; run container with --privileged (see compose).
CMD ["/bin/bash"]
