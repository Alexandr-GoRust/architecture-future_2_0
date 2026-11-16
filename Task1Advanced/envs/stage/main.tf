# Окружение STAGE
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone
}

module "vm" {
  source = "../../modules/vm"

  name_prefix  = "stage"
  zone         = var.zone
  cores        = 4
  memory       = 8
  disk_size    = 30
  disk_type    = "network-ssd"
  subnet_id    = var.subnet_id
  ssh_key_path = var.ssh_key_path
  labels       = { env = "stage", project = "future-2-0" }
}
