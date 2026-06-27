-- Кейс-задача 2.4: БД веб-приложения «Туристическое агентство» (MS SQL Server)

IF DB_ID(N'TourismWebApp') IS NOT NULL
BEGIN
    ALTER DATABASE TourismWebApp SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TourismWebApp;
END;
GO

CREATE DATABASE TourismWebApp;
GO

USE TourismWebApp;
GO

-- Справочник: роли
CREATE TABLE dbo.Roles (
    RoleId   INT IDENTITY(1,1) NOT NULL,
    RoleName NVARCHAR(50)      NOT NULL,
    CONSTRAINT PK_Roles PRIMARY KEY CLUSTERED (RoleId),
    CONSTRAINT UQ_Roles_RoleName UNIQUE (RoleName)
);
GO

CREATE NONCLUSTERED INDEX IX_Roles_RoleName ON dbo.Roles (RoleName);
GO

-- Справочник: направления
CREATE TABLE dbo.Destinations (
    DestinationId   INT IDENTITY(1,1) NOT NULL,
    DestinationName NVARCHAR(120)     NOT NULL,
    Country         NVARCHAR(80)      NOT NULL,
    Description     NVARCHAR(500)     NULL,
    IsActive        BIT               NOT NULL CONSTRAINT DF_Destinations_IsActive DEFAULT (1),
    CONSTRAINT PK_Destinations PRIMARY KEY CLUSTERED (DestinationId),
    CONSTRAINT UQ_Destinations_Name_Country UNIQUE (DestinationName, Country)
);
GO

CREATE NONCLUSTERED INDEX IX_Destinations_Country ON dbo.Destinations (Country);
GO

-- Справочник: категории туров
CREATE TABLE dbo.TourCategories (
    CategoryId   INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(80)      NOT NULL,
    CONSTRAINT PK_TourCategories PRIMARY KEY CLUSTERED (CategoryId),
    CONSTRAINT UQ_TourCategories_Name UNIQUE (CategoryName)
);
GO

-- Справочник: пользователи
CREATE TABLE dbo.Users (
    UserId       INT IDENTITY(1,1) NOT NULL,
    LoginName    NVARCHAR(50)      NOT NULL,
    PasswordHash NVARCHAR(256)     NOT NULL,
    FullName     NVARCHAR(120)     NOT NULL,
    Email        NVARCHAR(120)     NOT NULL,
    RoleId       INT               NOT NULL,
    IsActive     BIT               NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
    CreatedAt    DATETIME2(0)      NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId),
    CONSTRAINT UQ_Users_LoginName UNIQUE (LoginName),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId)
        REFERENCES dbo.Roles (RoleId)
);
GO

CREATE NONCLUSTERED INDEX IX_Users_RoleId ON dbo.Users (RoleId);
GO

-- Туры (переменная информация)
CREATE TABLE dbo.Tours (
    TourId        INT IDENTITY(1,1) NOT NULL,
    TourTitle     NVARCHAR(200)     NOT NULL,
    DestinationId INT               NOT NULL,
    CategoryId    INT               NOT NULL,
    StartDate     DATE              NOT NULL,
    EndDate       DATE              NOT NULL,
    Price         DECIMAL(12, 2)    NOT NULL,
    SeatsTotal    INT               NOT NULL,
    SeatsBooked   INT               NOT NULL CONSTRAINT DF_Tours_SeatsBooked DEFAULT (0),
    CreatedByUser INT               NOT NULL,
    CreatedAt     DATETIME2(0)      NOT NULL CONSTRAINT DF_Tours_CreatedAt DEFAULT (SYSUTCDATETIME()),
    IsPublished   BIT               NOT NULL CONSTRAINT DF_Tours_IsPublished DEFAULT (0),
    CONSTRAINT PK_Tours PRIMARY KEY CLUSTERED (TourId),
    CONSTRAINT FK_Tours_Destinations FOREIGN KEY (DestinationId)
        REFERENCES dbo.Destinations (DestinationId),
    CONSTRAINT FK_Tours_Categories FOREIGN KEY (CategoryId)
        REFERENCES dbo.TourCategories (CategoryId),
    CONSTRAINT FK_Tours_Users FOREIGN KEY (CreatedByUser)
        REFERENCES dbo.Users (UserId),
    CONSTRAINT CK_Tours_Dates CHECK (EndDate >= StartDate),
    CONSTRAINT CK_Tours_Price CHECK (Price >= 0),
    CONSTRAINT CK_Tours_Seats CHECK (SeatsTotal >= 1 AND SeatsBooked >= 0 AND SeatsBooked <= SeatsTotal)
);
GO

CREATE NONCLUSTERED INDEX IX_Tours_DestinationId ON dbo.Tours (DestinationId);
CREATE NONCLUSTERED INDEX IX_Tours_CategoryId ON dbo.Tours (CategoryId);
CREATE NONCLUSTERED INDEX IX_Tours_StartDate ON dbo.Tours (StartDate);
CREATE NONCLUSTERED INDEX IX_Tours_IsPublished ON dbo.Tours (IsPublished);
GO

-- Заявки на бронирование
CREATE TABLE dbo.Bookings (
    BookingId     INT IDENTITY(1,1) NOT NULL,
    TourId        INT               NOT NULL,
    ClientName    NVARCHAR(120)     NOT NULL,
    ClientEmail   NVARCHAR(120)     NOT NULL,
    ClientPhone   NVARCHAR(20)      NULL,
    PersonsCount  INT               NOT NULL,
    BookingDate   DATETIME2(0)      NOT NULL CONSTRAINT DF_Bookings_BookingDate DEFAULT (SYSUTCDATETIME()),
    Status        NVARCHAR(20)      NOT NULL CONSTRAINT DF_Bookings_Status DEFAULT (N'new'),
    TotalAmount   DECIMAL(12, 2)    NOT NULL,
    ProcessedBy   INT               NULL,
    CONSTRAINT PK_Bookings PRIMARY KEY CLUSTERED (BookingId),
    CONSTRAINT FK_Bookings_Tours FOREIGN KEY (TourId)
        REFERENCES dbo.Tours (TourId),
    CONSTRAINT FK_Bookings_Users FOREIGN KEY (ProcessedBy)
        REFERENCES dbo.Users (UserId),
    CONSTRAINT CK_Bookings_Persons CHECK (PersonsCount >= 1),
    CONSTRAINT CK_Bookings_Amount CHECK (TotalAmount >= 0),
    CONSTRAINT CK_Bookings_Status CHECK (Status IN (N'new', N'confirmed', N'cancelled', N'completed'))
);
GO

CREATE NONCLUSTERED INDEX IX_Bookings_TourId ON dbo.Bookings (TourId);
CREATE NONCLUSTERED INDEX IX_Bookings_Status ON dbo.Bookings (Status);
CREATE NONCLUSTERED INDEX IX_Bookings_BookingDate ON dbo.Bookings (BookingDate);
GO

-- Начальные данные
INSERT INTO dbo.Roles (RoleName) VALUES (N'Admin'), (N'Manager'), (N'Guest');

INSERT INTO dbo.TourCategories (CategoryName) VALUES
    (N'Пляжный'),
    (N'Экскурсионный'),
    (N'Горнолыжный');

INSERT INTO dbo.Destinations (DestinationName, Country, Description) VALUES
    (N'Анталья', N'Турция', N'Курорт на Средиземном море'),
    (N'Рим', N'Италия', N'Исторический центр и музеи'),
    (N'Сочи', N'Россия', N'Черноморское побережье');

-- Пароль в реальном приложении хэшируется! Здесь заглушка для демо.
INSERT INTO dbo.Users (LoginName, PasswordHash, FullName, Email, RoleId) VALUES
    (N'admin', N'HASH_PLACEHOLDER', N'Администратор Системы', N'admin@tourism.local', 1),
    (N'manager', N'HASH_PLACEHOLDER', N'Менеджер Туров', N'manager@tourism.local', 2);

INSERT INTO dbo.Tours (
    TourTitle, DestinationId, CategoryId,
    StartDate, EndDate, Price, SeatsTotal, CreatedByUser, IsPublished
) VALUES
    (N'Анталья All Inclusive', 1, 1, '2026-07-01', '2026-07-10', 75000.00, 20, 2, 1),
    (N'Рим — 7 дней', 2, 2, '2026-09-05', '2026-09-12', 68000.00, 15, 2, 1);

INSERT INTO dbo.Bookings (TourId, ClientName, ClientEmail, ClientPhone, PersonsCount, Status, TotalAmount) VALUES
    (1, N'Иванов Иван', N'ivanov@mail.ru', N'+7-900-111-22-33', 2, N'new', 150000.00);
GO

-- sp_GetPublishedTours
CREATE OR ALTER PROCEDURE dbo.sp_GetPublishedTours
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.TourId,
        t.TourTitle,
        d.DestinationName,
        d.Country,
        c.CategoryName,
        t.StartDate,
        t.EndDate,
        t.Price,
        (t.SeatsTotal - t.SeatsBooked) AS SeatsAvailable
    FROM dbo.Tours t
    INNER JOIN dbo.Destinations d ON d.DestinationId = t.DestinationId
    INNER JOIN dbo.TourCategories c ON c.CategoryId = t.CategoryId
    WHERE t.IsPublished = 1
    ORDER BY t.StartDate;
END;
GO

EXEC dbo.sp_GetPublishedTours;
GO
