# Packer VM test for Arch — QEMU/KVM builder.
# Boots the official Arch ISO, then drives the OFFICIAL archinstall tool over
# SSH using our configs. No reinvented installer.
#
#   packer init . && packer build arch.pkr.hcl
packer {
  required_plugins {
    qemu = { source = "github.com/hashicorp/qemu", version = "~> 1" }
  }
}

variable "iso_path"     { default = "../downloads/archlinux.iso" }
variable "iso_checksum" { default = "none" } # set to sha256:... for real runs

source "qemu" "arch" {
  iso_url          = var.iso_path
  iso_checksum     = var.iso_checksum
  output_directory = "../output/arch-vm"
  disk_size        = "20G"
  memory           = 2048
  cpus             = 2
  headless         = true
  accelerator      = "kvm"

  # Arch live ISO auto-logs in as root on tty; enable sshd + set passwd so Packer
  # can connect, then we push configs and run archinstall --silent.
  boot_wait    = "30s"
  boot_command = [
    "passwd<enter>packer<enter>packer<enter>",
    "systemctl start sshd<enter>"
  ]
  ssh_username = "root"
  ssh_password = "packer"
  ssh_timeout  = "20m"

  shutdown_command = "systemctl poweroff"
}

build {
  sources = ["source.qemu.arch"]

  provisioner "file" {
    sources     = ["../configs/arch/user_configuration.json",
                   "../configs/arch/user_credentials.json",
                   "../configs/arch/automated_install.sh"]
    destination = "/root/"
  }
  provisioner "shell" {
    inline = ["chmod +x /root/automated_install.sh", "/root/automated_install.sh"]
  }
}
