# Полезные выходы модуля: id и сетевые атрибуты ВМ, id диска

output "vm_id" {
  description = "Идентификатор виртуальной машины"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "vm_external_ip" {
  description = "Публичный IP-адрес ВМ (если включён NAT)"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "vm_fqdn" {
  description = "FQDN виртуальной машины"
  value       = yandex_compute_instance.vm.fqdn
}

output "disk_id" {
  description = "Идентификатор подключаемого диска"
  value       = yandex_compute_disk.data.id
}

output "disk_name" {
  description = "Имя подключаемого диска"
  value       = yandex_compute_disk.data.name
}
