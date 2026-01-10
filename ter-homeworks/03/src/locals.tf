locals {
  ssh_file = file( "~/.ssh/id_ed25519.pub")
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_file}"
  }
}