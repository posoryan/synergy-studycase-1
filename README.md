# Synergy — кейс-задачи 2.1–2.5

Репозиторий с решениями учебных кейс-задач по программированию, ООП, проектированию БД и веб-разработке.

## Структура проекта

```
synergy/
├── task_2_1/          # Алгоритм: сумма отрицательных между max и min
├── task_2_2/          # ООП на Python: базовый класс и наследники
├── task_2_3/          # БД «Туризм» (MySQL)
├── task_2_4/          # Веб-приложение: анализ рынка, ТЗ, MS SQL, Delphi
└── task_2_5/          # Аналитический обзор задачи 2.4
```

---

## Задача 2.1 — Алгоритмы

**Условие:** найти сумму отрицательных элементов массива, расположенных между максимальным и минимальным элементами.

```bash
cd task_2_1
python sum_negative_between_extremes.py
```

**Пример ввода:**
```
N = 6
Массив: 3 -1 -2 7 -4 1
```
Max = 7 (индекс 3), min = -4 (индекс 4) → между ними нет элементов → сумма = 0.

```
N = 5
Массив: 10 -3 -5 1 20
```
Min (индекс 1) … max (индекс 4) → между: -5, 1 → сумма отрицательных = **-5**.

**Тесты:**
```bash
python -m unittest test_sum_negative.py -v
```

---

## Задача 2.2 — ООП (Python)

**Условие:** демонстрация методов базового класса `Vehicle` и наследников `Car`, `Bicycle`.

```bash
cd task_2_2
python vehicle_demo.py
```

Демонстрируются: наследование, `@abstractmethod`, переопределение методов, `super()`, полиморфизм, `isinstance` / `issubclass`.

---

## Задача 2.3 — БД «Туризм» (MySQL)

**Условие:** 4 справочные таблицы + 1 таблица переменной информации (заказы).

| Тип | Таблицы |
|-----|---------|
| Справочники | `countries`, `cities`, `tour_types`, `clients` |
| Переменные данные | `tour_orders` |

**Установка:**
```bash
mysql -u root -p < task_2_3/tourism_db_mysql.sql
```

Или через MySQL Workbench: File → Open SQL Script → Execute.

---

## Задача 2.4 — Веб-приложение (Delphi + IIS + MS SQL Server)

| Файл | Описание |
|------|----------|
| [MARKET_ANALYSIS.md](task_2_4/MARKET_ANALYSIS.md) | Анализ рынка веб-ИС |
| [TZ_STEP_BY_STEP.md](task_2_4/TZ_STEP_BY_STEP.md) | **Пошаговое ТЗ** (установка SQL, IIS, Delphi, публикация) |
| [database/tourism_webapp_mssql.sql](task_2_4/database/tourism_webapp_mssql.sql) | Скрипт БД MS SQL Server |
| [delphi/](task_2_4/delphi/) | Образцы модулей Delphi (Auth, Booking, WebModule) |

**Быстрый старт БД:**
1. Установите SQL Server Express + SSMS.
2. Выполните `task_2_4/database/tourism_webapp_mssql.sql`.
3. Следуйте [TZ_STEP_BY_STEP.md](task_2_4/TZ_STEP_BY_STEP.md) для Delphi и IIS.

---

## Задача 2.5 — Аналитический обзор

Обзор веб-приложения из задачи 2.4 по критериям: функциональность, производительность, юзабилити, безопасность, масштабируемость, сопровождаемость, переносимость, качество кода, тестирование.

📄 [task_2_5/ANALYTICAL_REVIEW.md](task_2_5/ANALYTICAL_REVIEW.md)

---

## Требования

| Задача | Технологии |
|--------|------------|
| 2.1, 2.2 | Python 3.10+ |
| 2.3 | MySQL 8.0+ |
| 2.4 | Delphi 10.2, IIS, MS SQL Server 2019+ |
| 2.5 | Markdown |

---

## Публикация на GitHub

```bash
git init
git add .
git commit -m "Add synergy case tasks 2.1-2.5"
git remote add origin https://github.com/YOUR_USERNAME/synergy.git
git push -u origin main
```

Замените `YOUR_USERNAME` на ваш логин GitHub и используйте ссылку на репозиторий при сдаче заданий.
