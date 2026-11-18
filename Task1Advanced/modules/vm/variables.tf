# Входные параметры модуля vm_module.
# Всё окружение-специфичное приходит переменными — внутри модуля
# нет ни одного захардкоженного значения среды (dev/stage/prod).

variable "name_prefix" {
  description = "Префикс имени ресурсов (например, env-название: dev-vm, prod-vm)"
  type        = string
}

variable "zone" {
  description = "Зона доступности Yandex Cloud (например, ru-central1-a)"
  type        = string
  default     = "ru-central1-a"
}

variable "cores" {
  description = "Количество vCPU виртуальной машины"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Объём RAM виртуальной машины, ГБ"
  type        = number
  default     = 4
}

variable "platform_id" {
  description = "Платформа (линейка CPU) для ВМ"
  type        = string
  default     = "standard-v3"
}

variable "disk_size" {
  description = "Размер подключаемого диска, ГБ"
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "Тип подключаемого диска (network-ssd, network-hdd, network-ssd-nonreplicated)"
  type        = string
  default     = "network-ssd"
}

variable "disk_name" {
  description = "Имя подключаемого диска (по умолчанию — от префикса ВМ)"
  type        = string
  default     = ""
}

variable "image_family" {
  description = "Семейство образов загрузочного диска (например, ubuntu-2204-lts)"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "subnet_id" {
  description = "Идентификатор подсети, к которой подключается ВМ"
  type        = string
}

variable "nat" {
  description = "Выдавать ли ВМ публичный IP (NAT)"
  type        = bool
  default     = true
}

variable "ssh_key_path" {
  description = "Путь к публичному SSH-ключу, который будет записан в метаданные ВМ"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  description = "Пользователь ОС, для которого добавляется SSH-ключ"
  type        = string
  default     = "ubuntu"
}

variable "labels" {
  description = "Метки ресурсов (например, env=dev для учёта и политик)"
  type        = map(string)
  default     = {}
}
