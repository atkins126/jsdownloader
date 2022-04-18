unit uLogDownload;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Controls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.Generics.Collections;

type
  TLogDownload = class
  private
    FCodigo: integer;
    FUrl: string;
    FDataInicio: TDateTime;
    FDataFim: TDateTime;
    FLogDownloadList: TObjectList<TLogDownload>;
    procedure validate;
  public
    property Codigo: integer read FCodigo write FCodigo;
    property Url: string read FUrl write FUrl;
    property DataInicio: TDateTime read FDataInicio write FDataInicio;
    property DataFim: TDateTime read FDataFim write FDataFim;
    procedure insert;
    procedure update;
    function getAll: TObjectList<TLogDownload>;
    procedure createLogDownloadList(query: TFDQuery);
  end;

implementation

uses
  uLogDownloadPersistence;

{ TLogDownload }

procedure TLogDownload.validate;
begin
  if FDataInicio <= 0 then
  begin
    raise Exception.Create('A data de início do download não foi informada.');
  end;
  if URL = '' then
  begin
    raise Exception.Create('A URL de download não foi informada.');
  end;
end;

procedure TLogDownload.insert;
var
  persistence: TLogDownloadPersistence;
begin
  persistence := TLogDownloadPersistence.Create;
  try
    Self.validate;
    persistence.insert(Self);
  finally
    persistence.Free;
  end;
end;

procedure TLogDownload.update;
var
  persistence: TLogDownloadPersistence;
begin
  persistence := TLogDownloadPersistence.Create;
  try
    Self.validate;
    persistence.update(Self);
  finally
    persistence.Free;
  end;
end;

function TLogDownload.getAll: TObjectList<TLogDownload>;
var
  persistence: TLogDownloadPersistence;
begin
  persistence := TLogDownloadPersistence.Create;
  FLogDownloadList := TObjectList<TLogDownload>.Create;
  try
    persistence.getAll(Self);
    Result := FLogDownloadList;
  finally
    persistence.Free;
  end;
end;

procedure TLogDownload.createLogDownloadList(query: TFDQuery);
begin
  while not query.Eof do
  begin
    FLogDownloadList.Add(TLogDownload.Create);
    FLogDownloadList.Last.Codigo := query.FieldByName('codigo').AsInteger;
    FLogDownloadList.Last.Url := query.FieldByName('url').AsString;
    FLogDownloadList.Last.DataInicio := query.FieldByName('datainicio').AsDateTime;
    FLogDownloadList.Last.DataFim := query.FieldByName('datafim').AsDateTime;
    query.Next;
  end;
end;

end.

