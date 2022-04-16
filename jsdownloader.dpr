program jsdownloader;

uses
  Vcl.Forms,
  uFrmMain in 'src\form\uFrmMain.pas' {frmMain},
  uDownloader in 'src\class\uDownloader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
