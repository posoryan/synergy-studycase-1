# Кейс-задача 2.1

Сумма отрицательных элементов массива между max и min (сами max и min не входят).

## Правила

1. Индекс первого `max(A)` и первого `min(A)`.
2. Элементы строго между этими индексами.
3. Сумма только элементов `< 0`; иначе `0`.

Пример: `[8, -1, -2, -3, 2]` -> max индекс 0, min индекс 3 -> `-1 + (-2) = -3`.

## Запуск

```
cd task_2_1
python test_sum_negative.py
python sum_negative_between_extremes.py 8 -1 -2 -3 2
python sum_negative_between_extremes.py
```

Файлы:
- `sum_negative_between_extremes.py` — программа
- `test_sum_negative.py` — тесты
- `CORNER_CASES.md` — граничные случаи

Успех: `итог: 13/13 пройдено`.
