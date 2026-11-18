# Task1Advanced — переиспользуемый Terraform-модуль VM

`modules/vm` создаёт виртуальную машину Yandex Cloud с подключаемым диском
и сетевым интерфейсом. Внутри модуля нет ни одного захардкоженного значения
окружения — всё приходит переменными, окружения отличаются только `.tfvars`.

## Структура

```
Task1Advanced/
├── modules/vm/
│   ├── main.tf        # ресурсы: yandex_compute_disk + yandex_compute_instance
│   ├── variables.tf   # вход модуля (cores, memory, disk, subnet_id, ssh_key и др.)
│   ├── outputs.tf     # vm_id, vm_name, внешний/внутренний IP, FQDN, disk_id/name
│   └── versions.tf    # required_providers (yandex-cloud/yandex ~> 0.13)
└── envs/
    ├── dev/           # 2 vCPU / 2 ГБ / 10 ГБ hdd  — дешёвая разработка
    ├── stage/         # 4 vCPU / 8 ГБ / 30 ГБ ssd   — предпрод
    └── prod/          # 8 vCPU / 16 ГБ / 100 ГБ ssd — прод, зона ru-central1-b
```

Каждое окружение: `versions.tf` (пин провайдера), `variables.tf`
(облачные креды/subnet/zone/ssh — общие для окружений), `main.tf`
(provider + вызов модуля со своими значениями), `terraform.tfvars`.

## Параметры модуля

| Переменная | Описание | По умолчанию |
|---|---|---|
| name_prefix | префикс имён ресурсов | — (обяз.) |
| cores / memory | vCPU / RAM, ГБ | 2 / 4 |
| disk_size / disk_type | диск, ГБ / тип | 20 / network-ssd |
| image_family | семейство образа | ubuntu-2204-lts |
| subnet_id | подсеть ВМ | — (обяз.) |
| nat | публичный IP | true |
| ssh_key_path / ssh_user | ключ и пользователь для metadata | ~/.ssh/id_rsa.pub / ubuntu |
| zone | зона доступности | ru-central1-a |
| labels | метки ресурсов (env=…) | {} |

## Выходы

`vm_id`, `vm_name`, `vm_external_ip`, `vm_internal_ip`, `vm_fqdn`,
`disk_id`, `disk_name`.

## Запуск окружения

```bash
cd envs/dev
export YC_TOKEN=$(yc iam create-token)   # креды не хранятся в git
terraform init
terraform plan   -var-file=terraform.tfvars
terraform apply  -var-file=terraform.tfvars
terraform output # vm_external_ip и др.
```

Аналогично для `stage` и `prod` — различия только в `terraform.tfvars`
и параметрах вызова модуля. Проверено: `terraform fmt -recursive` чист,
`terraform validate` проходит для всех трёх окружений (init выполняется
через зеркало провайдеров, при необходимости — см. `~/.terraformrc`).
