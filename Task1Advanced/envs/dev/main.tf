# Окружение DEV
provider "yandex" {
  token     = var.yc_token # OAuth или IAM-токен (передаётся через env/секреты, не в git!)
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone
}

module "vm" {
  source = "../../modules/vm"

  name_prefix  = "dev"
  zone         = var.zone
  cores        = 2
  memory       = 2
  disk_size    = 10
  disk_type    = "network-hdd" # dev — дешевле
  subnet_id    = var.subnet_id
  ssh_key_path = var.ssh_key_path
  labels       = { env = "dev", project = "future-2-0" }
}
