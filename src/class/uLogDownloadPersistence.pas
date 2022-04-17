unit uLogDownloadPersistence;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Controls,
  uBasePersistence, uLogDownload, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TLogDownloadPersistence = class(TBasePersistence)
  private
    procedure setQueryParams(logDownload: TLogDownload);
  public
    procedure insert(var logDownload: TLogDownload);
    procedure update(logDownload: TLogDownload);
    procedure getAll(var logDownload: TLogDownload);
    procedure createTable;
  end;

implementation

{ TLogDownload }

procedure TLogDownloadPersistence.setQueryParams(logDownload: TLogDownload);
begin
  // Preenche os parâmetros do SQL
  if logDownload.Codigo <= 0 then
  begin
    FQuery.ParamByName('codigo').DataType := ftVariant;
    FQuery.ParamByName('codigo').value := System.Variants.Null;
  end
  else
  begin
    FQuery.ParamByName('codigo').AsInteger := logDownload.Codigo;
  end;
  FQuery.ParamByName('url').AsString := logDownload.Url;
  FQuery.ParamByName('datainicio').AsDateTime := logDownload.DataInicio;
  if logDownload.DataFim <= 0 then
  begin
    FQuery.ParamByName('datafim').DataType := ftVariant;
    FQuery.ParamByName('datafim').value := System.Variants.Null;
  end
  else
  begin
    FQuery.ParamByName('datafim').AsDateTime := logDownload.DataFim;
  end;
end;

procedure TLogDownloadPersistence.insert(var logDownload: TLogDownload);
begin
  try
    createQuery;
    try
      FQuery.SQL.Add('insert into logdownload (codigo, url, datainicio, datafim) ');
      FQuery.SQL.Add('values (:codigo, :url, :datainicio, :datafim) ');
      Self.setQueryParams(logDownload);
      // Executa o comando SQL
      FQuery.Prepare;
      FQuery.ExecSQL;
      if FQuery.RowsAffected = 1 then
      begin
        logDownload.Codigo := getLastInsertedId(FQuery);
      end;
    finally
      closeQuery;
    end;
  except
    on E: Exception do
      raise Exception.Create('Ocorreu um erro ao tentar incluir um log de download.' + sLineBreak + e.Message);
  end;
end;

procedure TLogDownloadPersistence.update(logDownload: TLogDownload);
begin
  try
    createQuery;
    try
      FQuery.SQL.Add('update logdownload set ');
      FQuery.SQL.Add(' url = :url,');
      FQuery.SQL.Add(' datainicio = :datainicio,');
      FQuery.SQL.Add(' datafim = :datafim');
      FQuery.SQL.Add(' where codigo = :codigo');
      Self.setQueryParams(logDownload);
      // Executa o comando SQL
      FQuery.Prepare;
      FQuery.ExecSQL;
    finally
      closeQuery;
    end;
  except
    on E: Exception do
      raise Exception.Create('Ocorreu um erro ao tentar atualizar um log de download.' + sLineBreak + e.Message);
  end;
end;

procedure TLogDownloadPersistence.getAll(var logDownload: TLogDownload);
begin
  try
    createQuery;
    try
      FQuery.SQL.Add('select * from logdownload');
      // Executa o comando SQL
      FQuery.OpenOrExecute;
      logDownload.createLogDownloadList(FQuery);
    finally
      closeQuery;
    end;
  except
    on E: Exception do
      raise Exception.Create('Ocorreu um erro ao tentar atualizar um log de download.' + sLineBreak + e.Message);
  end;
end;

procedure TLogDownloadPersistence.createTable;
begin
  try
    FQuery.SQL.Add('create table if not exists logdownload (');
    FQuery.SQL.Add(' codigo integer primary key autoincrement,');
    FQuery.SQL.Add(' url varchar(600) not null,');
    FQuery.SQL.Add(' datainicio datetime not null,');
    FQuery.SQL.Add(' datafim datetime)');
    // Executa o comando SQL
    FQuery.ExecSQL;
    FQuery.SQL.Clear;
  except
    on E: Exception do
      raise Exception.Create('Ocorreu um erro ao tentar criar a tabela LOGDOWNLOAD no banco de dados.' + sLineBreak + e.Message);
  end;
end;

end.

