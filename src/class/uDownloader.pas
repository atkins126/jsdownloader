unit uDownloader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, uLogDownload;

type
  TStatusDownload = record
    PercentualDownload: integer;
    DownloadIniciado: boolean;
    DownloadConcluido: boolean;
    OcorreuErro: boolean;
    MensagemErro: string;
  end;

  IObserver = interface
    ['{D1B7A184-0BB1-452F-84B2-9717BA70957F}']
    procedure atualizaPrograsso(statusDownload: TStatusDownload);
  end;

  ISubject = interface
    ['{A4182718-8449-4C11-9E95-7BB9EAC611D6}']
    procedure addObserver(Observer: IObserver);
    procedure deleteObserver(Observer: IObserver);
    procedure notify;
  end;

  TDownloader = class(TInterfacedObject, ISubject)
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  private
    FTamanhoArquivo: double;
    FUrl: string;
    FObservers: TInterfaceList;
    FStatusDownload: TStatusDownload;
    FLogDownload: TLogDownload;
    FIdHttp: TIdHTTP;
    FStopDownload: boolean;
    function ExtractUrlFileName(url: string): string;
    procedure initialize;
    procedure sendLog;
  public
    constructor Create;
    destructor Destroy;
    procedure startDownload(url, filePath: string);
    procedure stopDownload;
    procedure addObserver(Observer: IObserver);
    procedure deleteObserver(Observer: IObserver);
    procedure notify;
  end;

implementation

{ TDownloader }

constructor TDownloader.Create;
begin
  inherited;
  FObservers := TInterfaceList.Create;
  FLogDownload := TLogDownload.Create;
  FIdHttp := TIdHTTP.Create(nil);
end;

destructor TDownloader.Destroy;
begin
  FIdHttp.Free;
  FObservers.Free;
  FLogDownload.Free;
  inherited;
end;

procedure TDownloader.addObserver(Observer: IObserver);
begin
  if FObservers.IndexOf(Observer) < 0 then
  begin
    FObservers.Add(Observer);
  end;
end;

procedure TDownloader.deleteObserver(Observer: IObserver);
begin
  FObservers.Delete(FObservers.IndexOf(Observer));
end;

procedure TDownloader.notify;
var
  observer: IInterface;
begin
  if FObservers.Count <= 0 then
  begin
    Exit;
  end;
  for observer in FObservers do
  begin
    IObserver(observer).atualizaPrograsso(FStatusDownload);
  end;
end;

procedure TDownloader.startDownload(url, filePath: string);
var
  newFile: TFileStream;
begin
  try
    Self.initialize;
    newFile := TFileStream.Create(filePath + Self.ExtractUrlFileName(url), fmCreate);
    try
      FUrl := url;
      FIdHttp.Get(FUrl, newFile);
    finally
      newFile.Free;
    end;
  except
    on E: Exception do
    begin
      if FStopDownload then
      begin
        Exit;
      end;
      FStatusDownload.OcorreuErro := True;
      FStatusDownload.MensagemErro := 'Ocorreu um erro durante o download do arquivo.' + sLineBreak + e.Message;
      Self.notify;
      Self.initialize;
    end;
  end;
end;

procedure TDownloader.initialize;
begin
  FStatusDownload.DownloadIniciado := false;
  FStatusDownload.DownloadConcluido := false;
  FStatusDownload.PercentualDownload := 0;
  FStopDownload := false;
  FUrl := '';
  FIdHttp.OnWorkBegin := IdHTTPWorkBegin;
  FIdHttp.OnWork := IdHTTPWork;
  FIdHttp.OnWorkEnd := IdHTTPWorkEnd;
end;

function TDownloader.ExtractUrlFileName(url: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('/', url);
  Result := Copy(url, i + 1, Length(url) - (i));
end;

procedure TDownloader.stopDownload;
begin
  FStopDownload := true;
end;

procedure TDownloader.sendLog;
begin
  FLogDownload.Url := FUrl;
  FLogDownload.DataInicio := Now;
  if FStatusDownload.DownloadConcluido then
  begin
    FLogDownload.DataFim := Now;
    FLogDownload.update;
  end
  else
  begin
    FLogDownload.Codigo := 0;
    FLogDownload.DataFim := 0;
    FLogDownload.insert;
  end;
end;

procedure TDownloader.IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  FTamanhoArquivo := AWorkCountMax;
  FStatusDownload.DownloadIniciado := True;
  Self.sendLog;
  Self.notify;
end;

procedure TDownloader.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  if FStopDownload then
  begin
    FIdHttp.Disconnect;
    FStatusDownload.DownloadIniciado := false;
    FIdHttp.OnWorkBegin := nil;
    FIdHttp.OnWork := nil;
    FIdHttp.OnWorkEnd := nil;
  end
  else
  if (AWorkCount <> 0) and (FTamanhoArquivo <> 0) then
  begin
    FStatusDownload.PercentualDownload := Trunc((AWorkCount / FTamanhoArquivo) * 100);
  end;
  Self.notify;
end;

procedure TDownloader.IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if FStatusDownload.PercentualDownload = 100 then
  begin
    FStatusDownload.DownloadConcluido := True;
    Self.sendLog;
    Self.notify;
  end;
end;

end.

