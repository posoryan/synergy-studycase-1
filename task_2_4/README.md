# Кейс-задача 2.4

Веб-приложение «Туристическое агентство»: анализ рынка, БД MS SQL Server, образцы модулей Delphi 10.2 + IIS.

## Состав

| Файл / папка | Назначение |
|--------------|------------|
| MARKET_ANALYSIS.md | анализ рынка веб-ИС для туристического агентства |
| database/tourism_webapp_mssql.sql | скрипт БД |
| delphi/WebModule_u.pas | WebBroker: страница каталога `/tours` |
| delphi/AuthLogic.pas | авторизация менеджера |
| delphi/BookingLogic.pas | создание заявки на бронирование |
| delphi/SampleQueries.sql | примеры SQL для FireDAC |

Стек: Delphi 10.2, IIS, MS SQL Server, FireDAC.

## База данных

1. Установить SQL Server Express и SSMS.
2. Открыть `database/tourism_webapp_mssql.sql` в SSMS.
3. Подключиться к `localhost\SQLEXPRESS` и выполнить скрипт (F5).

Проверка:

```sql
USE TourismWebApp;
EXEC dbo.sp_GetPublishedTours;
SELECT * FROM dbo.Bookings;
```

Должны появиться 2 опубликованных тура и 1 тестовая заявка.

## Приложение Delphi

В папке `delphi/` — модули для проекта WebBroker/IntraWeb:

- `WebModule_u.pas` — отдаёт HTML-каталог туров из `sp_GetPublishedTours`
- `AuthLogic.pas` — проверка логина по таблице `Users`
- `BookingLogic.pas` — INSERT в `Bookings` с проверкой свободных мест

Модули подключаются к `TourismWebApp` на `localhost\SQLEXPRESS` (Windows-аутентификация).

Сборка и публикация на IIS выполняются в RAD Studio 10.2 (ISAPI DLL или IntraWeb Standalone Server). После публикации в браузере: `/tours` — каталог, форма бронирования и вход менеджера — по ТЗ проекта.

## Функциональность (по ТЗ)

Публичная часть: каталог туров, заявка на бронирование.

Админ-часть: вход менеджера, просмотр и обработка заявок, управление турами.

## Ручная проверка (без Delphi)

После создания БД достаточно для сдачи скрипта и модулей. Дополнительно можно проверить логику SQL:

```sql
-- свободные места на тур 1
SELECT SeatsTotal - SeatsBooked FROM dbo.Tours WHERE TourId = 1;

-- новая заявка (аналог BookingLogic)
INSERT INTO dbo.Bookings (TourId, ClientName, ClientEmail, ClientPhone, PersonsCount, TotalAmount, Status)
VALUES (1, N'Тестов Тест', N'test@mail.ru', N'+7-900-000-00-00', 1, 75000.00, N'new');
```
