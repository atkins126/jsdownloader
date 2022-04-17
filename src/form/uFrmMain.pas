unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Graphics, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.Threading, uDownloader, Vcl.WinXCtrls,
  Vcl.ComCtrls;

type
  TfrmMain = class(TForm, IObserver)
    edtDownloadLink: TEdit;
    lblDownloadLink: TLabel;
    btnIniciarDownload: TButton;
    btnExibirMensagem: TButton;
    btnPararDownload: TButton;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    btnHistoricoDownloads: TButton;
    pbDownload: TProgressBar;
    procedure btnExibirMensagemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPararDownloadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnHistoricoDownloadsClick(Sender: TObject);
    procedure btnIniciarDownloadClick(Sender: TObject);
  private
    FStatusDownload: TStatusDownload;
    FDownloader: TDownloader;
    FTask: ITask;
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function Removed: Boolean;
    procedure habilitaDesabilitaControles;
    procedure preparaDownload;
    procedure pararDownload;
    procedure inicializaStatusDownload;
    procedure validaAtualizaJanela;
    function validaLink: Boolean;
    procedure iniciarDownload;
    procedure atualizaProgresso;
  public
    procedure progressCallback(statusDownload: TStatusDownload);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uFrmLogDownload;

{$R *.dfm}

procedure TfrmMain.progressCallback(statusDownload: TStatusDownload);
begin
  FStatusDownload.PercentualDownload := statusDownload.PercentualDownload;
  FStatusDownload.DownloadIniciado := statusDownload.DownloadIniciado;
  FStatusDownload.DownloadConcluido := statusDownload.DownloadConcluido;
  FStatusDownload.OcorreuErro := statusDownload.OcorreuErro;
  FStatusDownload.MensagemErro := statusDownload.MensagemErro;
  Self.habilitaDesabilitaControles;
  Self.validaAtualizaJanela;
end;

procedure TfrmMain.validaAtualizaJanela;
begin
  if FStatusDownload.OcorreuErro then
  begin
    ShowMessage(FStatusDownload.MensagemErro);
    Self.inicializaStatusDownload;
  end
  else
  if FStatusDownload.DownloadConcluido then
  begin
    ShowMessage('Download concluído. Confira em: ' + ExtractFilePath(Application.ExeName));
    Self.inicializaStatusDownload;
    FTask.Cancel;
  end
  else
  if not FStatusDownload.DownloadIniciado then
  begin
    Self.inicializaStatusDownload;
  end
  else
  begin
    Self.atualizaProgresso;
  end;
  Self.habilitaDesabilitaControles;
end;

procedure TfrmMain.atualizaProgresso;
begin
  pbDownload.Max := 100;
  pbDownload.Position := FStatusDownload.PercentualDownload;
  Application.ProcessMessages;
end;

procedure TfrmMain.inicializaStatusDownload;
begin
  FStatusDownload.PercentualDownload := 0;
  FStatusDownload.DownloadIniciado := false;
  FStatusDownload.DownloadConcluido := false;
  FStatusDownload.OcorreuErro := false;
  FStatusDownload.MensagemErro := '';
  pbDownload.Position := 0;
end;

procedure TfrmMain.btnExibirMensagemClick(Sender: TObject);
begin
  ShowMessage('Progresso do download: ' + FStatusDownload.PercentualDownload.toString + '%');
end;

procedure TfrmMain.btnHistoricoDownloadsClick(Sender: TObject);
begin
  frmLogDownload := TfrmLogDownload.Create(Self);
  try
    frmLogDownload.CarregarLogs;
    frmLogDownload.ShowModal;
  finally
    frmLogDownload.Free;
    frmLogDownload := nil;
  end;
end;

procedure TfrmMain.btnIniciarDownloadClick(Sender: TObject);
begin
  Self.preparaDownload;
end;

procedure TfrmMain.btnPararDownloadClick(Sender: TObject);
begin
  Self.pararDownload;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDownloader <> nil then
  begin
    if FStatusDownload.DownloadIniciado then
    begin
      FDownloader.stopDownload;
      Sleep(2000);
      FTask.Cancel;
    end;
    FDownloader.deleteObserver(Self);
    FDownloader.Free;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if not FStatusDownload.DownloadIniciado then
  begin
    Exit;
  end;
  if Application.MessageBox('Existe um download em andamento, deseja interrompe-lo?', 'Atenção', MB_YESNO + MB_ICONQUESTION) = IDNO then
  begin
    CanClose := False;
    Exit;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.habilitaDesabilitaControles;
end;

procedure TfrmMain.habilitaDesabilitaControles;
begin
  if FStatusDownload.DownloadIniciado and (not FStatusDownload.OcorreuErro) then
  begin
    btnIniciarDownload.Enabled := false;
    btnExibirMensagem.Enabled := true;
    btnPararDownload.Enabled := true;
    pbDownload.visible := true;
    pbDownload.Enabled := true;
  end
  else
  begin
    btnIniciarDownload.Enabled := true;
    btnExibirMensagem.Enabled := false;
    btnPararDownload.Enabled := false;
    pbDownload.visible := false;
    pbDownload.Enabled := false;
  end;
end;

procedure TfrmMain.preparaDownload;
begin
  if not Self.validaLink then
  begin
    Exit;
  end;
  FTask := TTask.Create(procedure
    begin
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          Self.iniciarDownload;
        end);
    end);
  FTask.start;
end;

procedure TfrmMain.iniciarDownload;
begin
  Self.inicializaStatusDownload;
  if FDownloader = nil then
  begin
    FDownloader := TDownloader.Create;
    FDownloader.addObserver(Self);
  end;
  FDownloader.startDownload(edtDownloadLink.Text, ExtractFilePath(Application.ExeName));
end;

function TfrmMain.validaLink: Boolean;
begin
  Result := true;
  if Trim(edtDownloadLink.Text) = '' then
  begin
    Result := false;
    ShowMessage('Informe um link para realizar o download.');
    if edtDownloadLink.CanFocus then
    begin
      edtDownloadLink.SetFocus;
    end;
  end;
end;

procedure TfrmMain.pararDownload;
begin
  if FStatusDownload.DownloadIniciado then
  begin
    FDownloader.stopDownload;
    Sleep(2000);
    FTask.Cancel;
    ShowMessage('O download foi interrompido pelo usuário.');
  end;
end;

// Estes métodos foram declarados devido ao impelentar a interface IObserver
function TfrmMain.GetActive: Boolean;
begin
  Result := Self.Enabled;
end;

procedure TfrmMain.SetActive(Value: Boolean);
begin
  Self.Enabled := Value;
end;

function TfrmMain.Removed: Boolean;
begin
  Result := false;
end;

end.

