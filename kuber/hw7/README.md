
---

## 4. Выбор конфигурации ноды

### 4.1 Рассматриваемые варианты

| Тип ноды | Всего CPU | Всего RAM | Доступно CPU (85%) | Доступно RAM (85%) |
|----------|-----------|-----------|--------------------|--------------------|
| Малая | 8 vCPU | 32 ГБ | 6.8 vCPU | 27.2 ГБ |
| Средняя | 16 vCPU | 64 ГБ | 13.6 vCPU | 54.4 ГБ |
| Крупная | 32 vCPU | 128 ГБ | 27.2 vCPU | 108.8 ГБ |

### 4.2 Расчёт необходимого количества нод

**Для малой ноды (8/32):**
- По CPU: 17 / 6.8 ≈ 2.5 → нужно 3 ноды
- По RAM: 30.25 / 27.2 ≈ 1.11 → нужно 2 ноды
- **Итог: 3 ноды** (ограничение по CPU)

**Для средней ноды (16/64):**
- По CPU: 17 / 13.6 ≈ 1.25 → нужно 2 ноды
- По RAM: 30.25 / 54.4 ≈ 0.56 → нужна 1 нода
- **Итог: 2 ноды** (ограничение по CPU)

**Для крупной ноды (32/128):**
- По CPU: 17 / 27.2 ≈ 0.625 → нужна 1 нода
- По RAM: 30.25 / 108.8 ≈ 0.278 → нужна 1 нода
- **Итог: 1 нода** (теоретически)

### 4.3 Выбор оптимальной конфигурации

Выбираем **среднюю ноду 16 vCPU / 64 ГБ RAM** как оптимальную по соотношению цена/производительность и гибкости распределения подов.

---

## 5. Учёт отказоустойчивости (N+1)

При выходе из строя **одной ноды** оставшиеся должны выдержать полную нагрузку.

### 5.1 Расчёт с запасом

**Исходные требования:** 17 CPU, 30.25 ГБ RAM

**При 2 нодах (без запаса):**
- Отказ 1 ноды → остаётся 1 нода
- Доступно на 1 ноде: 13.6 CPU, 54.4 ГБ RAM
- **CPU:** 13.6 < 17 → ❌ не проходит

**При 3 нодах (с запасом):**
- Отказ 1 ноды → остаётся 2 ноды
- Доступно на 2 нодах: 2 × 13.6 = 27.2 CPU, 2 × 54.4 = 108.8 ГБ RAM
- **CPU:** 27.2 > 17 ✅
- **RAM:** 108.8 > 30.25 ✅

### 5.2 Итоговое количество нод с запасом

| Параметр | Значение |
|----------|----------|
| **Тип ноды** | 16 vCPU, 64 ГБ RAM |
| **Количество нод (с запасом N+1)** | **3 ноды** |
| Всего CPU в кластере | 48 vCPU |
| Всего RAM в кластере | 192 ГБ |
| Доступно приложениям (85%) | 40.8 CPU / 163.2 ГБ RAM |
| Требуется приложениям | 17 CPU / 30.25 ГБ RAM |
| **Запас по CPU** | ~140% |
| **Запас по RAM** | ~440% |

---

## 6. Распределение подов по нодам (Affinity/Anti-Affinity)

### 6.1 Стратегия распределения

| Компонент | Реплик | Требование к распределению |
|-----------|--------|---------------------------|
| База данных | 3 | Каждая реплика на отдельной ноде (hard anti-affinity) |
| Кеш | 3 | Каждая реплика на отдельной ноде (hard anti-affinity) |
| Бекенд | 10 | Равномерно по 3-4 пода на ноду (soft anti-affinity) |
| Фронтенд | 5 | Равномерно по 2 пода на ноду (soft anti-affinity) |

### 6.2 Примерное распределение по 3 нодам

| Нода | БД | Кеш | Бекенд | Фронтенд | Итого подов | CPU (approx) | RAM (approx) |
|------|----|----|---------|----------|-------------|--------------|---------------|
| Нода 1 | 1 | 1 | 4 | 2 | 8 | ~5.5 | ~11.5 ГБ |
| Нода 2 | 1 | 1 | 3 | 2 | 7 | ~5.3 | ~11.5 ГБ |
| Нода 3 | 1 | 1 | 3 | 1 | 6 | ~5.2 | ~11.5 ГБ |

---

## 7. Для нескольких окружений

### 7.1 Вариант 1: Изолированные кластеры

| Окружение | Тип ноды | Кол-во нод | Всего CPU | Всего RAM |
|-----------|----------|------------|-----------|-----------|
| Dev | 8 vCPU / 32 ГБ | 1 | 8 vCPU | 32 ГБ |
| Stage | 16 vCPU / 64 ГБ | 2 | 32 vCPU | 128 ГБ |
| Prod | 16 vCPU / 64 ГБ | 3 | 48 vCPU | 192 ГБ |
| **Итого** | - | **6 нод** | **88 vCPU** | **352 ГБ** |

### 7.2 Вариант 2: Общий кластер с Resource Quotas

При использовании одного кластера с namespace и resource quotas:

| Окружение | CPU limit | RAM limit | Доля от кластера |
|-----------|-----------|-----------|------------------|
| Dev | 8 CPU | 16 ГБ | 20% |
| Stage | 12 CPU | 32 ГБ | 30% |
| Prod | 20 CPU | 40 ГБ | 50% |
| **Итого** | **40 CPU** | **88 ГБ** | **100%** |

Требуется всё та же конфигурация: **3 ноды 16/64** (48 CPU, 192 ГБ всего), что даёт запас ~20% по CPU и ~118% по RAM.

---

## 8. Итоговая спецификация для Helm-чарта

### 8.1 values.yaml (production окружение)

```yaml
# Ресурсы приложений
resources:
  database:
    requests:
      cpu: "1"
      memory: "4Gi"
    limits:
      cpu: "1.5"
      memory: "6Gi"
    replicas: 3
  
  cache:
    requests:
      cpu: "1"
      memory: "4Gi"
    limits:
      cpu: "1.5"
      memory: "6Gi"
    replicas: 3
  
  backend:
    requests:
      cpu: "1"
      memory: "600Mi"
    limits:
      cpu: "1.2"
      memory: "800Mi"
    replicas: 10
  
  frontend:
    requests:
      cpu: "200m"
      memory: "50Mi"
    limits:
      cpu: "300m"
      memory: "100Mi"
    replicas: 5

# Конфигурация распределения подов
affinity:
  database:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: database
          topologyKey: kubernetes.io/hostname
  
  cache:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: cache
          topologyKey: kubernetes.io/hostname

  backend:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            labelSelector:
              matchLabels:
                app: backend
            topologyKey: kubernetes.io/hostname

# Topology Spread Constraints
topologySpreadConstraints:
  backend:
    maxSkew: 1
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: ScheduleAnyway
    labelSelector:
      matchLabels:
        app: backend

# Node selector для критичных компонентов
nodeSelector:
  database:
    node-type: "high-memory"
  cache:
    node-type: "high-memory"

# Tolerations для критичных подов
tolerations:
  database:
    - key: "critical"
      operator: "Equal"
      value: "true"
      effect: "NoSchedule"