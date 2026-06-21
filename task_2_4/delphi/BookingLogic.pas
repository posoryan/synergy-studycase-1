unit BookingLogic;

{
  Образец модуля бронирования для Delphi-проекта (задача 2.4).
}

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

function CreateBooking(AConnection: TFDConnection;
  ATourId: Integer;
  const AClientName, AClientEmail, AClientPhone: string;
  APersonsCount: Integer;
  out AErrorMessage: string): Boolean;

implementation

function CreateBooking(AConnection: TFDConnection;
  ATourId: Integer;
  const AClientName, AClientEmail, AClientPhone: string;
  APersonsCount: Integer;
  out AErrorMessage: string): Boolean;
var
  QTour, QInsert: TFDQuery;
  Price: Currency;
  SeatsAvailable: Integer;
  TotalAmount: Currency;
begin
  Result := False;
  AErrorMessage := '';

  if Trim(AClientName) = '' then
  begin
    AErrorMessage := 'Укажите ФИО клиента.';
    Exit;
  end;

  if APersonsCount < 1 then
  begin
    AErrorMessage := 'Количество человек должно быть не менее 1.';
    Exit;
  end;

  QTour := TFDQuery.Create(nil);
  QInsert := TFDQuery.Create(nil);
  try
    QTour.Connection := AConnection;
    QTour.SQL.Text :=
      'SELECT Price, (SeatsTotal - SeatsBooked) AS SeatsAvailable ' +
      'FROM dbo.Tours WHERE TourId = :TourId AND IsPublished = 1';
    QTour.ParamByName('TourId').AsInteger := ATourId;
    QTour.Open;

    if QTour.IsEmpty then
    begin
      AErrorMessage := 'Тур не найден или не опубликован.';
      Exit;
    end;

    Price := QTour.FieldByName('Price').AsCurrency;
    SeatsAvailable := QTour.FieldByName('SeatsAvailable').AsInteger;

    if APersonsCount > SeatsAvailable then
    begin
      AErrorMessage := 'Недостаточно свободных мест.';
      Exit;
    end;

    TotalAmount := Price * APersonsCount;

    QInsert.Connection := AConnection;
    QInsert.SQL.Text :=
      'INSERT INTO dbo.Bookings ' +
      '(TourId, ClientName, ClientEmail, ClientPhone, PersonsCount, TotalAmount, Status) ' +
      'VALUES (:TourId, :ClientName, :ClientEmail, :ClientPhone, :PersonsCount, :TotalAmount, N''new'')';
    QInsert.ParamByName('TourId').AsInteger := ATourId;
    QInsert.ParamByName('ClientName').AsString := AClientName;
    QInsert.ParamByName('ClientEmail').AsString := AClientEmail;
    QInsert.ParamByName('ClientPhone').AsString := AClientPhone;
    QInsert.ParamByName('PersonsCount').AsInteger := APersonsCount;
    QInsert.ParamByName('TotalAmount').AsCurrency := TotalAmount;
    QInsert.ExecSQL;

    Result := True;
  finally
    QInsert.Free;
    QTour.Free;
  end;
end;

end.
