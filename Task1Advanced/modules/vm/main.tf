# vm_module — виртуальная машина с подключаемым диском и сетью.
# Провайдер объявляется на уровне окружения (envs/*), модуль только
# использует ресурсы провайдера — так его можно переиспользовать
# в dev/stage/prod с разными tfvars.

# Актуальный образ из семейства (data — получаем существующий ресурс, не создаём)
data "yandex_compute_image" "boot" {
  family = var.image_family
}

# Подключаемый диск
resource "yandex_compute_disk" "data" {
  name     = var.disk_name != "" ? var.disk_name : "${var.name_prefix}-data-disk"
  type     = var.disk_type
  zone     = var.zone
  size     = var.disk_size
  image_id = data.yandex_compute_image.boot.id
  labels   = var.labels
}

# Виртуальная машина: загрузка с подключаемого диска
resource "yandex_compute_instance" "vm" {
  name        = "${var.name_prefix}-vm"
  platform_id = var.platform_id
  zone        = var.zone
  labels      = var.labels

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.data.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }
}
