unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Graphics, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.Threading, uDownloader;

type
  TfrmMain = class(TForm, IObserver)
    edtDownloadLink: TEdit;
    pnlSidePanel: TPanel;
    lblDownloadLink: TLabel;
    btnIniciarDownload: TButton;
    btnExibirMensagem: TButton;
    btnPararDownload: TButton;
    procedure btnIniciarDownloadClick(Sender: TObject);
    procedure btnExibirMensagemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPararDownloadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FStatusDownload: TStatusDownload;
    FDownloader: TDownloader;
    FTask: ITask;
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function Removed: Boolean;
    procedure habilitaDesabilitaBotoes;
    procedure iniciarDownload;
    procedure pararDownload;
  public
    procedure atualizaPrograsso(statusDownload: TStatusDownload);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.atualizaPrograsso(statusDownload: TStatusDownload);
begin
  FStatusDownload := statusDownload;
  Self.habilitaDesabilitaBotoes;
  if statusDownload.OcorreuErro then
  begin
    ShowMessage(FStatusDownload.MensagemErro);
    Exit;
  end;
  if statusDownload.DownloadConcluido then
  begin
    ShowMessage('Download concluído. Confira em: ' + ExtractFilePath(Application.ExeName));
    Exit;
  end;
end;

procedure TfrmMain.btnExibirMensagemClick(Sender: TObject);
begin
  ShowMessage('Progresso do download: ' + FStatusDownload.PercentualDownload.toString + '%');
end;

procedure TfrmMain.btnIniciarDownloadClick(Sender: TObject);
begin
  if FTask = nil then
  begin
    FTask := TTask.Create(Self.iniciarDownload);
  end;
  FTask.Start;
end;

procedure TfrmMain.btnPararDownloadClick(Sender: TObject);
begin
  Self.pararDownload;
  FTask.Wait(2000);
  ShowMessage('O download foi interrompido pelo usuário.');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDownloader <> nil then
  begin
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
  Self.pararDownload;
  FTask.Wait(2000);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.habilitaDesabilitaBotoes;
end;

procedure TfrmMain.habilitaDesabilitaBotoes;
begin
  if FStatusDownload.DownloadIniciado then
  begin
    btnIniciarDownload.Enabled := false;
    btnExibirMensagem.Enabled := true;
    btnPararDownload.Enabled := true;
  end
  else
  begin
    btnIniciarDownload.Enabled := true;
    btnExibirMensagem.Enabled := false;
    btnPararDownload.Enabled := false;
  end;
end;

procedure TfrmMain.iniciarDownload;
begin
  if FDownloader = nil then
  begin
    FDownloader := TDownloader.Create;
  end;
  FDownloader.addObserver(Self);
  FDownloader.startDownload(edtDownloadLink.Text, ExtractFilePath(Application.ExeName));
end;

procedure TfrmMain.pararDownload;
begin
  if FStatusDownload.DownloadIniciado then
  begin
    FDownloader.stopDownload;
  end;
end;

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

