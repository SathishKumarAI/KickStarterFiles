# Packer VM test for Rocky — QEMU/KVM builder.
# Boots the official Rocky ISO, serves configs/rocky/ks.cfg over HTTP (Packer's
# built-in http server = the "KS over HTTPS" idea from the README), types the
# boot command once, then the install is fully unattended.
#
#   packer init . && packer build rocky.pkr.hcl
packer {
  required_plugins {
    qemu = { source = "github.com/hashicorp/qemu", version = "~> 1" }
  }
}

variable "iso_path"     { default = "../downloads/rocky9-minimal.iso" }
variable "iso_checksum" { default = "none" } # set to sha256:... for real runs

source "qemu" "rocky" {
  iso_url          = var.iso_path
  iso_checksum     = var.iso_checksum
  output_directory = "../output/rocky-vm"
  disk_size        = "20G"
  memory           = 2048
  cpus             = 2
  headless         = true
  accelerator      = "kvm"

  http_directory   = "../configs/rocky"          # serves ks.cfg
  boot_wait        = "5s"
  boot_command     = [
    "<up><tab> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]

  # archinstall/kickstart sets the password; Packer connects to verify the build.
  ssh_username     = "admin"
  ssh_password     = "changeme123"
  ssh_timeout      = "30m"
  shutdown_command = "sudo systemctl poweroff"
}

build {
  sources = ["source.qemu.rocky"]
  provisioner "shell" { inline = ["echo 'Rocky unattended install OK'", "cat /etc/rocky-release"] }
}
