variable "yc_token" {
  description = "Yandex Cloud OAuth/IAM token (YC_TOKEN в окружении, в git не хранится)"
  type        = string
  default     = null # берётся из env, см. README
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Идентификатор облака"
  type        = string
}

variable "yc_folder_id" {
  description = "Идентификатор каталога"
  type        = string
}

variable "subnet_id" {
  description = "Идентификатор подсети для ВМ"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_key_path" {
  description = "Путь к публичному SSH-ключу"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
