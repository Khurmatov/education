resource "yandex_compute_disk" "virtual_disks" {
  zone = var.default_zone
  count = var.vd.counter
  name = "${ var.vd.name }-${ count.index + 1 }"
  type = var.vd.type
  size = var.vd.size
}

resource "yandex_compute_instance" "storage" {
  name              = var.storage.name
  hostname          = var.storage.hostname
  platform_id       = var.common_platform
  zone              = var.default_zone

  resources {
    cores           = var.storage.cores
    memory          = var.storage.memory
    core_fraction   = var.storage.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id     = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.virtual_disks.*.id
    content {
      disk_id = secondary_disk.value
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