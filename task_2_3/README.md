# Кейс-задача 2.3

База данных «Туризм»: 4 справочника и 1 таблица переменной информации (заказы туров).

## Структура

Справочники: `countries`, `cities`, `tour_types`, `clients`.

Переменная информация: `tour_orders` (FK на все справочники).

У каждой таблицы первичный ключ. Связи — внешние ключи из `tour_orders`.

## Запуск

MySQL Workbench: File -> Open SQL Script -> `tourism_db_mysql.sql` -> Execute.

Или из командной строки:

```
mysql -u root -p < tourism_db_mysql.sql
```

## Проверка

После выполнения скрипта в конце выводится отчётный SELECT по заказам — должны быть 2 строки (Анталья, Рим).

Дополнительно:

```sql
USE tourism_db;
SHOW TABLES;
SELECT COUNT(*) FROM tour_orders;
```

Ожидается 5 таблиц и 2 заказа.
