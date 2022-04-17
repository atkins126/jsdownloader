unit uBasePersistence;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.SysUtils, System.Variants, System.Classes, Vcl.Controls;

type
  TBasePersistence = class
  private
    procedure createTable;
  protected
    FQuery: TFDQuery;
    procedure createQuery;
    procedure closeQuery;
    function getLastInsertedId(var query: TFDQuery): integer;
  end;

implementation

uses
  uDatabase, uLogDownloadPersistence;

{ TBasePersistence }

procedure TBasePersistence.createQuery;
begin
  try
    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := TSQLiteConnection.getConnection;
    FQuery.SQL.Clear;
    Self.createTable;
  except
    on E: Exception do
      raise Exception.Create('Erro ao iniciar conexão com o banco de dados.' + sLineBreak + e.Message);
  end;
end;

procedure TBasePersistence.closeQuery;
begin
  try
    FQuery.Close;
    FreeAndNil(FQuery);
  except
    on E: Exception do
      raise Exception.Create('Erro ao iniciar conexão com o banco de dados.' + sLineBreak + e.Message);
  end;
end;

procedure TBasePersistence.createTable;
begin
  if Self is TLogDownloadPersistence then
  begin
    TLogDownloadPersistence(Self).createTable;
  end;
end;

function TBasePersistence.getLastInsertedId(var query: TFDQuery): integer;
begin
  try
    Result := 0;
    query.SQL.Clear;
    query.SQL.Add('SELECT last_insert_rowid() as codigo');
      // Executa o comando SQL
    query.OpenOrExecute;
    if query.RecordCount <= 0 then
    begin
      Exit;
    end;
    Result := query.FieldByName('codigo').AsInteger;
  except
    on E: Exception do
      raise Exception.Create('Ocorreu um erro ao tentar buscar o último código.' + sLineBreak + e.Message);
  end;
end;

end.

