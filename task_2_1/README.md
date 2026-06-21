# Кейс-задача 2.1

Сумма отрицательных элементов массива между max и min (сами max и min не входят).

## Правила
1. Индекс первого `max(A)` и первого `min(A)`.
2. Элементы строго между этими индексами.
3. Сумма только элементов `< 0`; иначе `0`.

Пример: `[8, -1, -2, -3, 2]` → max @0, min @3 → `-1 + (-2) = -3`.

## Запуск
```powershell
cd task_2_1
python test_sum_negative.py
python sum_negative_between_extremes.py 8 -1 -2 -3 2
python sum_negative_between_extremes.py
```

| Файл | Назначение |
|------|------------|
| `sum_negative_between_extremes.py` | Программа |
| `test_sum_negative.py` | 8 тестов, по порядку |
| `CORNER_CASES.md` | Граничные случаи для отчёта |

Успех: `Итог: все 8 тестов пройдены.`
