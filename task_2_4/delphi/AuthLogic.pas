unit AuthLogic;

{
  Образец модуля авторизации для Delphi-проекта (задача 2.4).
  В учебном проекте пароль сравнивается с заглушкой HASH_PLACEHOLDER.
  В реальном приложении используйте хэширование (bcrypt, PBKDF2 и т.д.).
}

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  TAuthResult = record
    Success: Boolean;
    UserId: Integer;
    FullName: string;
    RoleName: string;
  end;

function Authenticate(AConnection: TFDConnection;
  const ALogin, APassword: string): TAuthResult;

implementation

function Authenticate(AConnection: TFDConnection;
  const ALogin, APassword: string): TAuthResult;
var
  Q: TFDQuery;
begin
  Result.Success := False;
  Result.UserId := 0;
  Result.FullName := '';
  Result.RoleName := '';

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text :=
      'SELECT u.UserId, u.FullName, r.RoleName ' +
      'FROM dbo.Users u ' +
      'INNER JOIN dbo.Roles r ON r.RoleId = u.RoleId ' +
      'WHERE u.LoginName = :LoginName ' +
      '  AND u.PasswordHash = :PasswordHash ' +
      '  AND u.IsActive = 1';
    Q.ParamByName('LoginName').AsString := ALogin;
    // Демо: в БД записан HASH_PLACEHOLDER; замените на реальный хэш
    Q.ParamByName('PasswordHash').AsString := APassword;
    Q.Open;

    if not Q.IsEmpty then
    begin
      Result.Success := True;
      Result.UserId := Q.FieldByName('UserId').AsInteger;
      Result.FullName := Q.FieldByName('FullName').AsString;
      Result.RoleName := Q.FieldByName('RoleName').AsString;
    end;
  finally
    Q.Free;
  end;
end;

end.
