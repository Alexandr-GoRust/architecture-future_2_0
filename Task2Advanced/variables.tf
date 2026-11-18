variable "yc_token" {
  type        = string
  sensitive   = true
  description = "Yandex Cloud OAuth/IAM token (из секретов CI, не в git)"
}

variable "yc_cloud_id" { type = string }
variable "yc_folder_id" { type = string }

variable "subnet_id" {
  type        = string
  description = "Подсеть для ВМ"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "cores" {
  type    = number
  default = 8
}

variable "memory" {
  type    = number
  default = 16
}

variable "disk_size" {
  type    = number
  default = 100
}

variable "ssh_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
