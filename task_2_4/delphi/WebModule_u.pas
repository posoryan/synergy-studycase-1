unit WebModule_u;

{
  Образец WebBroker WebModule для ISAPI DLL (задача 2.4).
  URL: /tours — HTML-список опубликованных туров.
}

interface

uses
  System.SysUtils, System.Classes, HTTPApp, FireDAC.Comp.Client;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    FDConnection: TFDConnection;
    function BuildToursHtml: string;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

var
  WebModuleClass: TWebModuleClass = TWebModule1;

implementation

{$R *.dfm}

procedure TWebModule1.AfterConstruction;
begin
  inherited;
  FDConnection := TFDConnection.Create(nil);
  FDConnection.Params.DriverID := 'MSSQL';
  FDConnection.Params.Database := 'TourismWebApp';
  FDConnection.Params.Add('Server=localhost\SQLEXPRESS');
  FDConnection.Params.Add('OSAuthent=Yes');
  FDConnection.Connected := True;
end;

procedure TWebModule1.BeforeDestruction;
begin
  FDConnection.Free;
  inherited;
end;

function TWebModule1.BuildToursHtml: string;
var
  Q: TFDQuery;
  Html: TStringBuilder;
begin
  Html := TStringBuilder.Create;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDConnection;
    Q.SQL.Text := 'EXEC dbo.sp_GetPublishedTours';
    Q.Open;

    Html.AppendLine('<html><head><meta charset="utf-8"><title>Туры</title></head><body>');
    Html.AppendLine('<h1>Каталог туров</h1><ul>');

    while not Q.Eof do
    begin
      Html.AppendFormat(
        '<li><b>%s</b> — %s (%s), %s — %s, %.2f руб.</li>',
        [Q.FieldByName('TourTitle').AsString,
         Q.FieldByName('DestinationName').AsString,
         Q.FieldByName('Country').AsString,
         FormatDateTime('dd.mm.yyyy', Q.FieldByName('StartDate').AsDateTime),
         FormatDateTime('dd.mm.yyyy', Q.FieldByName('EndDate').AsDateTime),
         Q.FieldByName('Price').AsFloat]
      );
      Html.AppendLine;
      Q.Next;
    end;

    Html.AppendLine('</ul></body></html>');
    Result := Html.ToString;
  finally
    Q.Free;
    Html.Free;
  end;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'text/html; charset=utf-8';
  if SameText(Request.PathInfo, '/tours') then
    Response.Content := BuildToursHtml
  else
    Response.Content := '<html><body><p>Туристическое агентство</p>' +
      '<a href="/tours">Каталог туров</a></body></html>';
  Handled := True;
end;

end.
