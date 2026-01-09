output "VMs_output" {
  value = {
    VM_web_name   = yandex_compute_instance.platform_web.name
    VM_web_FQDN   = yandex_compute_instance.platform_web.fqdn
    VM_web_ext_ip = yandex_compute_instance.platform_web.network_interface[0].nat_ip_address
    VM_db_name    = yandex_compute_instance.platform_db.name
    VM_db_FQDN   = yandex_compute_instance.platform_db.fqdn
    VM_db_ext_ip = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
  }
}