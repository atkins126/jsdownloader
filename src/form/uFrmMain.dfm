object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'JSDownloader'
  ClientHeight = 299
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Font.Quality = fqClearType
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object lblDownloadLink: TLabel
    Left = 198
    Top = 57
    Width = 115
    Height = 17
    Caption = 'Link para download'
  end
  object edtDownloadLink: TEdit
    Left = 79
    Top = 80
    Width = 353
    Height = 25
    TabOrder = 0
  end
  object btnIniciarDownload: TButton
    Left = 152
    Top = 127
    Width = 212
    Height = 25
    Caption = 'Iniciar Download'
    TabOrder = 1
    OnClick = btnIniciarDownloadClick
  end
  object btnExibirMensagem: TButton
    Left = 152
    Top = 167
    Width = 212
    Height = 25
    Caption = 'Exibir mensagem'
    TabOrder = 2
    OnClick = btnExibirMensagemClick
  end
  object btnPararDownload: TButton
    Left = 152
    Top = 206
    Width = 212
    Height = 25
    Caption = 'Parar download'
    TabOrder = 3
    OnClick = btnPararDownloadClick
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 514
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object lblTitle: TLabel
      Left = 0
      Top = 8
      Width = 514
      Height = 25
      Alignment = taCenter
      AutoSize = False
      BiDiMode = bdRightToLeftNoAlign
      Caption = 'Download de arquivos com Delphi + Multithread + SQLite'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = []
      Font.Quality = fqClearType
      ParentBiDiMode = False
      ParentFont = False
    end
  end
  object btnHistoricoDownloads: TButton
    Left = 152
    Top = 246
    Width = 212
    Height = 25
    Caption = 'Exibir hist'#243'rico de downloads'
    TabOrder = 5
    OnClick = btnHistoricoDownloadsClick
  end
end
