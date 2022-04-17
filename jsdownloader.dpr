program jsdownloader;

uses
  Vcl.Forms,
  uFrmMain in 'src\form\uFrmMain.pas' {frmMain},
  uDownloader in 'src\class\uDownloader.pas',
  uDatabase in 'src\class\uDatabase.pas',
  uLogDownloadPersistence in 'src\class\uLogDownloadPersistence.pas',
  uBasePersistence in 'src\class\uBasePersistence.pas',
  uLogDownload in 'src\class\uLogDownload.pas',
  uFrmLogDownload in 'src\form\uFrmLogDownload.pas' {frmLogDownload};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
