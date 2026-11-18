# Удалённое состояние в S3-совместимом хранилище (Yandex Object Storage).
# Креды бэкенда НЕ хранятся в коде: подхватываются из переменных окружения
# AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY (в CI — из секретов).
terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "future-2-0-tfstate" # создать заранее (см. README)
    key                         = "prod/terraform.tfstate"
    region                      = "us-east-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    # lock-таблица DynamoDB для Yandex Object Storage недоступна —
    # блокировка через state-файл (для команды достаточно, apply — по кнопке)
  }
}
