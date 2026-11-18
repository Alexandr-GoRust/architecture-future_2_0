# Task4Advanced — каталог доменных событий

Формат контракта: событие = `name + version + occurredAt + {агрегат}Id + payload`.
Все события публикуются в шину (Kafka, топик `events.<домен>.<событие>.v<N>`),
регистрируются в каталоге схем (Schema Registry), ошибки обработки — в DLQ.

| Событие | Источник (контекст) | Подписчики | Семантика | Минимальный контракт (payload) |
|---|---|---|---|---|
| `PatientRegistered` v1 | Клиники / Пациентский поток | Витрина (метрики), Финтех (онбординг клиента) | новый пациент зарегистрирован | patientId, clinicId, occurredAt, channel |
| `VisitScheduled` v1 | Клиники / Пациентский поток | Витрина, Клиники/напоминания | приём назначен | visitId, patientId, specialistId, slotStart |
| `VisitCompleted` v1 | Клиники / Пациентский поток | Витрина, Финтех (выставление счёта) | приём состоялся (без диагноза!) | visitId, patientId, completedAt, serviceCodes[] |
| `StudyCompleted` v1 | Клиники / Медданные (изолированный) | ИИ-сервисы (запуск inference), Витрина (факт) | исследование выполнено; наружу — без PHI | studyId, studyType, occurredAt (клинических деталей нет) |
| `AIStudyPassed` v1 | ИИ / Диагностика | Клиники (направление врачу), Витрина | ИИ-исследование обработано | studyId, modelId, modelVersion, confidence, completedAt |
| `AIDiagnosisConfirmed` v1 | ИИ / Диагностика (после врача) | Витрина, Качество моделей | врач подтвердил/скорректировал результат ИИ | studyId, confirmedBy, corrected, occurredAt |
| `ModelPromoted` v1 | ИИ / MLOps | ИИ/Диагностика, Витрина | версия модели прошла валидационный гейт | modelId, version, metrics{}, promotedAt |
| `CreditApplicationSubmitted` v1 | Финтех / Кредитование | Скоринг (внутр.), Витрина | подана заявка | applicationId, clientId, productCode, amount, submittedAt |
| `CreditDecisionMade` v1 | Финтех / Кредитование | Витрина | решение по заявке | applicationId, decision, decidedAt, reasonCode |
| `CreditContractCreated` v1 | Финтех / Кредитование | Платежи (график), Витрина | создан кредитный договор | contractId, clientId, amount, rate, firstPaymentDate |
| `PaymentCompleted` v1 | Финтех / Платежи | Финансы (консолидация), Витрина | платёж проведён | paymentId, contractId, amount, completedAt, idempotencyKey |
| `PeriodClosed` v1 | Офис / Финансы | Витрина, Архив | отчётный период закрыт (данные заморожены) | periodId, closedAt |
| `EmployeeHired` / `AssetAssigned` v1 | Офис / HR-инвентарь | Витрина (операционные метрики) | кадровое/инвентарное событие | employeeId/assetId, clinicId, occurredAt |

Правила:
- события — факты в прошедшем времени, immutable; контракт версионируется
  (обратная совместимость, breaking change = новая мажорная версия + период двойной публикации);
- PHI в payload отсутствует архитектурно (контекст медданных публикует только обезличенные факты);
- ключ партиционирования — идентификатор агрегата (порядок внутри агрегата гарантирован).
