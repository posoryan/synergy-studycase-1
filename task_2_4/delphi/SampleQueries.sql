-- Образцы SQL-запросов для Delphi-приложения (FireDAC -> FDQuery.SQL.Text)

-- GetPublishedTours: каталог туров для главной страницы
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

-- GetTourById: данные тура для формы бронирования
SELECT TourId, TourTitle, Price, (SeatsTotal - SeatsBooked) AS SeatsAvailable
FROM dbo.Tours
WHERE TourId = :TourId AND IsPublished = 1;

-- InsertBooking: новая заявка
INSERT INTO dbo.Bookings (TourId, ClientName, ClientEmail, ClientPhone, PersonsCount, TotalAmount, Status)
VALUES (:TourId, :ClientName, :ClientEmail, :ClientPhone, :PersonsCount, :TotalAmount, N'new');

-- AuthenticateUser: проверка логина (в продакшене сравнивайте хэш пароля!)
SELECT u.UserId, u.FullName, u.RoleId, r.RoleName
FROM dbo.Users u
INNER JOIN dbo.Roles r ON r.RoleId = u.RoleId
WHERE u.LoginName = :LoginName
  AND u.PasswordHash = :PasswordHash
  AND u.IsActive = 1;

-- GetBookingsForAdmin: список заявок для менеджера
SELECT
    b.BookingId,
    b.ClientName,
    b.ClientEmail,
    t.TourTitle,
    b.PersonsCount,
    b.TotalAmount,
    b.Status,
    b.BookingDate
FROM dbo.Bookings b
INNER JOIN dbo.Tours t ON t.TourId = b.TourId
ORDER BY b.BookingDate DESC;

-- UpdateBookingStatus: подтверждение или отмена
UPDATE dbo.Bookings
SET Status = :NewStatus,
    ProcessedBy = :UserId
WHERE BookingId = :BookingId;
