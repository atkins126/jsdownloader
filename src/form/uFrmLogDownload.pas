unit uFrmLogDownload;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.Generics.Collections;

type
  TfrmLogDownload = class(TForm)
    lvLogDownload: TListView;
  private
  public
    procedure CarregarLogs;
  end;

var
  frmLogDownload: TfrmLogDownload;

implementation

uses uLogDownload;

{$R *.dfm}

procedure TfrmLogDownload.CarregarLogs;
var
  logDownload: TLogDownload;
  logDownloadList: TObjectList<TLogDownload>;
  I: Integer;
  logItem: TListItem;
begin
  logDownload := TLogDownload.Create;
  logDownloadList := logDownload.getAll;
  try
    lvLogDownload.Clear;
    for I := 0 to logDownloadList.Count -1 do
    begin
      logItem := lvLogDownload.Items.Add;
      logItem.Caption := logDownloadList[I].Codigo.ToString;
      logItem.SubItems.Add(logDownloadList[I].Url);
      logItem.SubItems.Add(FormatDateTime('c', logDownloadList[I].DataInicio));
      if logDownloadList[I].DataFim > 0 then
      begin
        logItem.SubItems.Add(FormatDateTime('c', logDownloadList[I].DataFim));
      end;
    end;
  finally
    logDownload.Free;
    logDownloadList.Free;
  end;
end;

end.
