# Build env for Rocky USB ISO injection.
# lorax provides mkksiso (official RHEL/Rocky kickstart-into-ISO tool).
FROM rockylinux:9

RUN dnf -y install lorax xorriso syslinux genisoimage curl which \
    && dnf clean all

WORKDIR /work
# Mount the repo at /work (see docker-compose.yml). Outputs land in /work/output.
CMD ["/bin/bash"]
