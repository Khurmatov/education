resource "yandex_compute_instance" "main_replica" {
  # for_each         = var.each_vm
  for_each         = { for i in var.each_vm : i.vm_name => i }

  name             = each.value.vm_name
  hostname         = each.value.vm_name
  platform_id      = var.common_platform
  zone             = var.default_zone

  resources {
    cores          = each.value.cpu
    memory         = each.value.ram
    core_fraction  = var.common_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id     = data.yandex_compute_image.ubuntu.image_id
      size         = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible    = var.preempt_on
  }

  network_interface {

    subnet_id      = yandex_vpc_subnet.develop.id
    nat            = var.nat_is_on
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = merge(var.common_metadata, local.metadata)

}