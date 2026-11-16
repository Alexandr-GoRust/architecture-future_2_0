# Архитектура «Будущее 2.0» — проектная работа спринта 11

Кейс: медицинский холдинг с банком и ИИ-сервисами (DWH SQL Server 2008 +
Camel ESB + PowerBuilder) → целевая событийная платформа с доменной
аналитикой (Data Mesh) и витриной самообслуживания в облаке.

## Состав решения

| Задание | Артефакты | Суть |
|---|---|---|
| **Task1Advanced** Модульная инфраструктура | `modules/vm/` (main/variables/outputs/versions) + `envs/{dev,stage,prod}` с tfvars + README | переиспользуемый Terraform-модуль ВМ (ядра/RAM/диск/subnet/SSH), три окружения одним модулем; `fmt`/`validate` чистые для всех env |
| **Task2Advanced** CI/CD + удалённый state | `backend.tf` (S3/Yandex Object Storage), `main.tf`, `.github/workflows/terraform.yml`, README | init → plan (на PR) → apply (по кнопке + environment `production` с approval); state только в S3, секреты — в Secrets |
| **Task3Advanced** Целевая архитектура и риски | `c4-target-architecture.drawio` (контейнеры + компоненты витрины), `risks-and-mitigation.md` | C4 на 3 года: событийная платформа, домены, Lakehouse, витрина, мосты Camel/DWH; карта 10 рисков (вероятность×влияние) и план мер (технические/управленческие) |
| **Task4Advanced** Домены и события | `bounded-contexts.drawio`, `event-storming.drawio`, `aggregates.md`, `events.md`, `justification.md` | DDD-границы доменов, агрегаты (инварианты/ключи), каталог доменных событий с контрактами, Event Storming, обоснование vs Camel/DWH |
| **Task5Advanced** Стек и экономика | `tech-radar.drawio` + `tech-radar.md`, `tco-analysis.md`, `roadmap.md` | расширенный радар (Adopt/Trial/Assess/Hold + паттерны Data Mesh/EDA/Self-service BI), TCO 3 года (as-is vs to-be, окупаемость ~15 мес), роадмап Data Mesh с ролями DPO/Data Engineer/BI |

Диаграммы — draw.io (валидный XML), генераторы — `.sources/build_*.py`
(воспроизводимость); Terraform-код проверен `terraform fmt -recursive`
и `terraform validate` (все окружения).
