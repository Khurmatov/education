### yandex_compute_image vars

variable "vm_db_image_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Имя образа ОС"
}

### yandex_compute_instance vars

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Имя виртуальной машины"
}
variable "vm_db_platform_id" {
  type = string
  default = "standard-v3"
  description = "ID виртуальной платформы"
}
variable "vm_db_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 1
    core_fraction  = 20
 }
}