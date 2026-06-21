# Пошаговое ТЗ: веб-приложение «Туристическое агентство»
## Delphi 10.2 + IIS + MS SQL Server

> Эта инструкция написана максимально просто. Идите **строго по шагам**, не перескакивайте.
> Если что-то не получилось — вернитесь на предыдущий шаг и проверьте, всё ли сделали.

---

## ЧАСТЬ 0. Что вам понадобится

### Программы (скачать и установить по порядку)

| № | Программа | Зачем | Где взять |
|---|-----------|-------|-----------|
| 1 | **Windows 10/11 Pro** (или Server) | IIS работает только на Windows | У вас уже есть |
| 2 | **Embarcadero RAD Studio 10.2 Tokyo** (Delphi) | Разработка приложения | [embarcadero.com](https://www.embarcadero.com) — нужна лицензия или пробная |
| 3 | **Microsoft SQL Server Express** | Бесплатная база данных | [microsoft.com/sql-server/sql-server-downloads](https://www.microsoft.com/sql-server/sql-server-downloads) |
| 4 | **SQL Server Management Studio (SSMS)** | Удобно работать с базой | [microsoft.com/ssms](https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms) |
| 5 | **IIS (Компонент Windows)** | Веб-сервер | Включить в Windows (см. Шаг 1) |

### Что должно получиться в конце

- База данных `TourismWebApp` с таблицами и тестовыми данными
- Delphi-проект, который отдаёт веб-страницы через IIS
- В браузере открывается сайт: список туров + форма бронирования + вход для менеджера

---

## ЧАСТЬ 1. Установка SQL Server (база данных)

### Шаг 1.1 — Скачайте SQL Server Express

1. Откройте браузер.
2. Перейдите на страницу загрузки SQL Server Express.
3. Нажмите **Download now**.
4. Запустите скачанный файл `SQL2022-SSEI-Expr.exe` (или аналог).

### Шаг 1.2 — Установите SQL Server

1. Выберите **Basic** (базовая установка).
2. Примите лицензию → **Accept**.
3. Папку установки оставьте по умолчанию → **Install**.
4. Дождитесь надписи **Installation completed**.
5. **Запишите** строку подключения, которую покажет установщик. Пример:
   ```
   Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=True;
   ```

### Шаг 1.3 — Установите SSMS

1. Скачайте SSMS с сайта Microsoft.
2. Установите с настройками по умолчанию.
3. Запустите **SQL Server Management Studio**.

### Шаг 1.4 — Создайте базу данных

1. В SSMS в поле **Server name** введите: `localhost\SQLEXPRESS`
2. Нажмите **Connect**.
3. Меню **File → Open → File**.
4. Выберите файл из этого репозитория:
   ```
   task_2_4/database/tourism_webapp_mssql.sql
   ```
5. Нажмите **Execute** (кнопка ▶ или F5).
6. В левой панели нажмите правой кнопкой на **Databases → Refresh**.
7. Вы должны увидеть базу **TourismWebApp**.

### Шаг 1.5 — Проверьте, что данные есть

1. В SSMS выполните:
   ```sql
   USE TourismWebApp;
   EXEC dbo.sp_GetPublishedTours;
   ```
2. Должна появиться таблица с турами (Анталья, Рим).

**Если ошибка «Cannot connect»** — проверьте, что служба **SQL Server (SQLEXPRESS)** запущена:
- Нажмите Win+R → введите `services.msc` → Enter
- Найдите **SQL Server (SQLEXPRESS)** → статус должен быть **Running**

---

## ЧАСТЬ 2. Включение IIS (веб-сerver)

### Шаг 2.1 — Включите IIS в Windows

1. Нажмите **Win + S**, введите: `Turn Windows features on or off`
2. Откройте найденный пункт.
3. Поставьте галочки:
   - ☑ **Internet Information Services**
   - Раскройте IIS и отметьте:
     - ☑ **Web Management Tools → IIS Management Console**
     - ☑ **World Wide Web Services → Application Development Features → ISAPI Extensions**
     - ☑ **World Wide Web Services → Application Development Features → ISAPI Filters**
     - ☑ **World Wide Web Services → Common HTTP Features → Default Document**
     - ☑ **World Wide Web Services → Common HTTP Features → Static Content**
4. Нажмите **OK**. Подождите установку.
5. Перезагрузите компьютер (рекомендуется).

### Шаг 2.2 — Проверьте IIS

1. Откройте браузер.
2. Введите адрес: `http://localhost`
3. Должна открыться стартовая страница IIS (синий фон, надпись IIS).

**Если страница не открывается:**
- Win+R → `inetmgr` → Enter (откроется диспетчер IIS)
- Слева кликните на имя вашего компьютера
- Справа **Start** (если сайт остановлен)

---

## ЧАСТЬ 3. Установка Delphi 10.2

### Шаг 3.1 — Установите RAD Studio / Delphi 10.2 Tokyo

1. Запустите установщик Embarcadero.
2. Выберите **Delphi** (можно без C++Builder).
3. Установите компоненты:
   - ☑ **Web Development** (IntraWeb или WebBroker)
   - ☑ **FireDAC** (работа с базами данных)
   - ☑ **InterBase / Firebird** (можно снять, если не нужен)
4. Дождитесь окончания установки.

### Шаг 3.2 — Запустите Delphi

1. Пуск → **RAD Studio 10.2 Tokyo**
2. При первом запуске можно выбрать **Starter / Professional** — зависит от лицензии.

---

## ЧАСТЬ 4. Создание проекта в Delphi

> Ниже — два варианта. **Вариант A (IntraWeb)** проще для новичка.
> **Вариант B (WebBroker + ISAPI DLL)** — ближе к «классическому» IIS-приложению.

---

### ВАРИАНТ A — IntraWeb (рекомендуется для начинающих)

#### Шаг 4A.1 — Новый проект

1. **File → New → Other**
2. **Delphi Projects → IntraWeb → Server Application**
3. Нажмите **OK**
4. Сохраните проект в папку: `C:\TourismWebApp\`
   - Project name: `TourismWebApp`
   - Unit name: `MainForm`

#### Шаг 4A.2 — Подключите FireDAC к SQL Server

1. На форме IntraWeb (MainForm) добавьте компоненты с палитры **FireDAC**:
   - `TFDConnection` — назовите `FDConnection1`
   - `TFDQuery` — назовите `FDQueryTours`
   - `TFDPhysMSSQLDriverLink` — драйвер MS SQL

2. Выберите `FDConnection1`, в Object Inspector:
   - **ConnectionDef** → нажмите `...` → **Add** новое подключение:
     - Driver ID: `MSSQL`
     - Database: `TourismWebApp`
     - Server: `localhost\SQLEXPRESS`
     - Authentication: Windows (или SQL Server, если настроили логин/пароль)
   - **Connected** = `True` (для проверки)

3. Выберите `FDQueryTours`:
   - **Connection** = `FDConnection1`
   - **SQL** = скопируйте из файла `task_2_4/delphi/SampleQueries.sql` запрос `GetPublishedTours`

#### Шаг 4A.3 — Сделайте страницу «Каталог туров»

1. На форме добавьте компонент **TIWGrid** (таблица).
2. В коде формы (событие `IWAppFormCreate`):

```pascal
procedure TMainForm.IWAppFormCreate(Sender: TObject);
begin
  FDQueryTours.Open;
  IWGrid1.DataSource := IWDataSource1; // привяжите TIWDBGrid через DataSource
end;
```

3. Добавьте кнопку **TIWButton** с надписью «Забронировать тур».

#### Шаг 4A.4 — Страница бронирования

1. **File → New → Other → IntraWeb → Form**
2. Имя: `BookingForm`
3. Добавьте поля ввода:
   - `TIWEdit` — ФИО клиента
   - `TIWEdit` — Email
   - `TIWEdit` — Телефон
   - `TIWEdit` — Количество человек
   - `TIWButton` — «Отправить заявку»
4. На кнопку повесьте код вставки в таблицу `Bookings` (см. `task_2_4/delphi/BookingLogic.pas`).

#### Шаг 4A.5 — Страница входа (менеджер)

1. Создайте форму `LoginForm` с полями Login и Password.
2. При успешном входе проверяйте таблицу `Users` (см. образец в `AuthLogic.pas`).
3. После входа открывайте `AdminForm` — список всех заявок и кнопки «Подтвердить» / «Отменить».

#### Шаг 4A.6 — Скомпилируйте

1. **Project → Build TourismWebApp**
2. Убедитесь: **Build succeeded** (0 errors).

---

### ВАРИАНТ B — WebBroker ISAPI DLL (для IIS напрямую)

#### Шаг 4B.1 — Новый проект

1. **File → New → Other → WebBroker → ISAPI/NSAPI DLL**
2. Сохраните как `TourismWebApp.dll`

#### Шаг 4B.2 — Добавьте WebModule

1. В WebModule создайте обработчики (`TWebActionItem`) для URL:
   - `/tours` — JSON или HTML список туров
   - `/book` — POST заявка
   - `/login` — POST авторизация

2. Пример обработчика `/tours` — см. `task_2_4/delphi/WebModule_u.pas`

#### Шаг 4B.3 — Скомпилируйте DLL

1. **Project → Build**
2. Файл `TourismWebApp.dll` появится в папке `Win32\Release\`

---

## ЧАСТЬ 5. Публикация на IIS

### Шаг 5.1 — IntraWeb Standalone Server (быстрая проверка)

1. Запустите проект: **Run → Run (F9)**
2. IntraWeb откроет браузер на порту (обычно `http://localhost:8888`)
3. Проверьте каталог туров и форму бронирования.

### Шаг 5.2 — Публикация IntraWeb на IIS

1. Win+R → `inetmgr`
2. Правой кнопкой **Sites → Add Website**
   - Site name: `TourismWebApp`
   - Physical path: `C:\TourismWebApp\`
   - Port: `8080`
3. Настройте Application Pool:
   - .NET CLR version: **No Managed Code**
   - Enable 32-Bit Applications: **True** (если DLL 32-bit)
4. Для IntraWeb следуйте докуменции **Deploying IntraWeb on IIS** в справке Embarcadero.

### Шаг 5.3 — Публикация ISAPI DLL на IIS

1. Скопируйте `TourismWebApp.dll` в `C:\inetpub\wwwroot\tourism\`
2. В IIS создайте приложение:
   - Правой кнопкой на **Default Web Site → Add Application**
   - Alias: `tourism`
   - Physical path: `C:\inetpub\wwwroot\tourism\`
3. Убедитесь, что ISAPI Extensions разрешены:
   - Выберите сайт → **ISAPI and CGI Restrictions**
   - DLL должна быть **Allowed**
4. Откройте: `http://localhost/tourism/tours`

---

## ЧАСТЬ 6. Проверка (чек-лист сдачи)

Отметьте каждый пункт:

- [ ] База `TourismWebApp` создана, скрипт выполнен без ошибок
- [ ] `EXEC sp_GetPublishedTours` возвращает туры
- [ ] IIS открывается по `http://localhost`
- [ ] Delphi-проект компилируется без ошибок
- [ ] В браузере виден **каталог туров**
- [ ] Можно **отправить заявку** — запись появляется в таблице `Bookings`
- [ ] Менеджер может **войти** и **подтвердить заявку**
- [ ] Код залит на **GitHub**, в README указаны шаги запуска

### Как проверить заявку в SSMS

```sql
USE TourismWebApp;
SELECT * FROM dbo.Bookings ORDER BY BookingId DESC;
```

---

## ЧАСТЬ 7. Структура файлов проекта (что сдавать)

```
TourismWebApp/
├── TourismWebApp.dpr          # главный файл проекта
├── MainForm.pas / .dfm        # главная страница (каталог)
├── BookingForm.pas / .dfm     # форма бронирования
├── LoginForm.pas / .dfm       # вход менеджера
├── AdminForm.pas / .dfm       # панель менеджера
├── DataModule.pas / .dfm      # подключение к БД (FireDAC)
├── AuthLogic.pas              # проверка логина
├── BookingLogic.pas           # логика бронирования
└── README.md                  # как запустить

database/
└── tourism_webapp_mssql.sql   # скрипт БД (из репозитория)
```

---

## ЧАСТЬ 8. Частые ошибки и решения

| Проблема | Решение |
|----------|---------|
| SQL Server не подключается | Проверьте имя сервера `localhost\SQLEXPRESS`, запустите службу |
| FireDAC: driver not found | Установите `Microsoft ODBC Driver for SQL Server` |
| IIS: 403 Forbidden | Дайте права папке: IIS_IUSRS → Read & Execute |
| IIS: 500 ошибка | Смотрите **Event Viewer → Windows Logs → Application** |
| Delphi: IntraWeb не видит БД | ConnectionDef → Test → Connected = True |
| Пустой каталог туров | Проверьте `IsPublished = 1` в таблице Tours |

---

## ЧАСТЬ 9. Минимальный набор экранов (макеты)

### Экран 1 — Главная / Каталог
```
+--------------------------------------------------+
|  Туристическое агентство                         |
+--------------------------------------------------+
|  Направление: [все ▼]   Категория: [все ▼]      |
+--------------------------------------------------+
|  Анталья All Inclusive | 01.07-10.07 | 75000 руб |
|  [ Забронировать ]                               |
|  Рим — 7 дней          | 05.09-12.09 | 68000 руб |
|  [ Забронировать ]                               |
+--------------------------------------------------+
|  [ Вход для менеджера ]                          |
+--------------------------------------------------+
```

### Экран 2 — Бронирование
```
+--------------------------------------------------+
|  Бронирование тура: Анталья All Inclusive      |
+--------------------------------------------------+
|  ФИО:     [________________________]             |
|  Email:   [________________________]             |
|  Телефон: [________________________]             |
|  Человек: [__2__]                                |
|  [ Отправить заявку ]  [ Назад ]                 |
+--------------------------------------------------+
```

### Экран 3 — Вход менеджера
```
+--------------------------------------------------+
|  Вход                                            |
+--------------------------------------------------+
|  Логин:    [________]                            |
|  Пароль:   [________]                            |
|  [ Войти ]                                       |
+--------------------------------------------------+
```

### Экран 4 — Панель менеджера
```
+--------------------------------------------------+
|  Заявки на бронирование                          |
+--------------------------------------------------+
|  ID | Клиент      | Тур            | Статус | ... |
|  1  | Иванов И.   | Анталья AI     | new    | [✓][✗]|
+--------------------------------------------------+
|  [ Добавить тур ]  [ Выйти ]                     |
+--------------------------------------------------+
```

---

## ЧАСТЬ 10. Что написать в отчёте по задаче 2.4

1. **Анализ рынка** — возьмите файл `MARKET_ANALYSIS.md`
2. **Описание БД** — ER-диаграмма (можно нарисовать в draw.io) + скрипт `tourism_webapp_mssql.sql`
3. **Описание приложения** — скриншоты 4 экранов + структура проекта
4. **Стек технологий** — Delphi 10.2, IntraWeb/WebBroker, FireDAC, IIS, MS SQL Server
5. **Ссылка на GitHub** — репозиторий с кодом и SQL

---

**Удачи! Если застряли на конкретном шаге — вернитесь к таблице ошибок (Часть 8) или проверьте, что предыдущий шаг выполнен полностью.**
