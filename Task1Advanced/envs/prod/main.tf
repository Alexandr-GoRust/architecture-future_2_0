# Окружение PROD
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone
}

module "vm" {
  source = "../../modules/vm"

  name_prefix  = "prod"
  zone         = var.zone
  cores        = 8
  memory       = 16
  disk_size    = 100
  disk_type    = "network-ssd"
  nat          = true
  subnet_id    = var.subnet_id
  ssh_key_path = var.ssh_key_path
  labels       = { env = "prod", project = "future-2-0" }
}
