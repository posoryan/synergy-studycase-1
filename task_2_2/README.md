# Кейс-задача 2.2

Демонстрация ООП: базовый класс `Vehicle`, наследники `Car` и `Bicycle`.

## Запуск

```
cd task_2_2
python vehicle_demo.py
python test_vehicle_demo.py
```

Успех: `итог: 8/8 пройдено`.

## Что реализовано

- абстрактный класс `Vehicle` и метод `move()`
- наследование: `Car`, `Bicycle`
- переопределение `service_check()` через `super()`
- полиморфизм, `isinstance`, `issubclass`

## Тесты

| № | Что проверяется |
|---|-----------------|
| 1 | создание `Car`, `get_info()`, пробег 0 |
| 2 | создание `Bicycle`, поле `gears` |
| 3 | `Car.refuel()`, `move()`, пробег |
| 4 | `Bicycle.shift_gear()`, `move()` |
| 5 | переопределение `service_check()` |
| 6 | полиморфный вызов `move()` |
| 7 | `isinstance`, `issubclass` |
| 8 | `ValueError` при неверных аргументах |
