###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

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
  type = list(string)
  default = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "version_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Версия ОС"
}

variable "common_platform" {
  type        = string
  default     = "standard-v1"
  description = "Платформа"
}

variable "vm_resources" {
  type = map(number)
  description = "Ресурсы для виртуальных машин"
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

variable "interrupt" {
  type        = bool
  default     = true
  description = "Всегда прерываемая"
}

variable "nat" {
  type        = bool
  default     = true
  description = "Включение NAT"
}

variable "common_metadata" {
  description = "Общая метадата для SSH"
  type = map(string)
  default = {
    serial-port-enable = "1"
  }
}

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 1
      disk_volume = 5
    }
  ]
}

variable "vd" {
  type = object({
    name    = string
    counter = number
    type    = string
    size    = number
  })
  default = {
    name    = "virtual-disk"
    counter = 3
    type    = "network-hdd"
    size    = 1
  }
  description = "Информация о дисках"
}

variable "storage" {
  type = object({
    name          = string
    hostname      = string
    cores         = number
    memory        = number
    core_fraction = number
  })
  default = {
    name          = "storage"
    hostname      = "storage"
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}