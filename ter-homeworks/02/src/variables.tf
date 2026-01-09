###cloud vars

variable "cloud_id" {
  type        = string
  default     = "b1gr1jpfke2d4ha6mb8u"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1glu738ickrd0srogut"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "default_zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZ8JS3GqbSgTYGq8CzTYhfYG5nhcrn83RV7pXccbBTz"
  description = "ssh-keygen -t ed25519"
}

### yandex_compute_image vars

variable "vm_web_image_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Имя образа ОС"
}

### yandex_compute_instance vars

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя виртуальной машины"
}
variable "vm_web_platform_id" {
  type = string
  default = "standard-v3"
  description = "ID виртуальной платформы"
}
variable "vm_web_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 1
    core_fraction  = 20
 }
}