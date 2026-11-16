provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone
}

# Переиспользуем модуль из Task1Advanced — код инфраструктуры един,
# окружения и state-хранилище различаются.
module "vm" {
  source = "../Task1Advanced/modules/vm"

  name_prefix  = "prod"
  cores        = var.cores
  memory       = var.memory
  disk_size    = var.disk_size
  subnet_id    = var.subnet_id
  ssh_key_path = var.ssh_key_path
  labels       = { env = "prod", managed = "cicd" }
}
