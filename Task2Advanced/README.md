# Task2Advanced — Terraform с S3-backend и CI/CD

Инфраструктура из Task1Advanced разворачивается через пайплайн с **удалённым
состоянием** (Yandex Object Storage, S3-совместимое) — локально `.tfstate`
не хранится.

## Состав

| Файл | Назначение |
|---|---|
| `backend.tf` | S3-backend: бакет `future-2-0-tfstate`, ключ `prod/terraform.tfstate` |
| `versions.tf` | пины terraform/провайдера |
| `main.tf` | provider + вызов `../Task1Advanced/modules/vm` (переиспользование) |
| `variables.tf` | входные переменные (креды — sensitive, приходят из секретов) |
| `terraform.tfvars.example` | шаблон значений (реальный tfvars в `.gitignore`) |
| `.github/workflows/terraform.yml` | пайплайн: plan на PR, apply по кнопке с approval |

## Пайплайн (GitHub Actions)

- **plan** — на каждый PR, затрагивающий `Task2Advanced/**`: `init` (S3-backend,
  креды из Secrets) → `plan`; падение плана блокирует мерж.
- **apply** — только `workflow_dispatch` (кнопка) и только после ручного
  одобрения: job привязан к environment `production` с required reviewers
  (Settings → Environments → production → Required reviewers).
  Перед apply план сохраняется в артефакт `tfplan` — аудит «что применили».

## Безопасность и изоляция

- **Состояние не локально**: backend S3; креды бэкенда передаются через
  `AWS_ACCESS_KEY_ID/SECRET` (переменные окружения/Secrets), в коде их нет;
- **Секреты** — только GitHub Secrets: `YC_TOKEN`, `YC_CLOUD_ID`,
  `YC_FOLDER_ID`, `YC_SUBNET_ID`, `TF_STATE_AWS_KEY/SECRET`;
  `yc_token` помечен `sensitive` — не попадёт в логи;
- **Права workflow** минимальны (`contents: read`, `pull-requests: write`
  для публикации плана);
- **Изоляция окружений**: state-ключ на окружение (`prod/…`, при
  необходимости `stage/…`), параметры — через переменные;
- `.gitignore` корня исключает `*.tfstate*`, `.terraform/`, `terraform.tfvars`.

## Запуск

```bash
# бакет состояния (один раз):
yc storage bucket create --name future-2-0-tfstate
# локально (для проверки):
cd Task2Advanced
export AWS_ACCESS_KEY_ID=… AWS_SECRET_ACCESS_KEY=…   # ключи Object Storage
terraform init && terraform plan
# в CI: PR -> plan; Run workflow -> apply (после approval)
```
