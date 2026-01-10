data "yandex_compute_image" "ubuntu" {
  family = var.version_image
}

resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.database]
  count       = 2
  name        = "web-${count.index + 1}"
  hostname    = "${ yandex_vpc_network.develop.name }-web-${ count.index + 1 }"
  platform_id = var.common_platform
  zone        = var.default_zone
  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible    = var.interrupt
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.develop.id
    nat            = var.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = merge(var.common_metadata, local.metadata)
}