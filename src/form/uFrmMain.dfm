object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 
    'JSDownloader | Download de arquivos com Delphi + Multithread + S' +
    'QLite'
  ClientHeight = 299
  ClientWidth = 589
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
    Left = 192
    Top = 8
    Width = 115
    Height = 17
    Caption = 'Link para download'
  end
  object edtDownloadLink: TEdit
    Left = 192
    Top = 23
    Width = 353
    Height = 25
    TabOrder = 0
  end
  object pnlSidePanel: TPanel
    Left = 0
    Top = 0
    Width = 145
    Height = 299
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object btnIniciarDownload: TButton
      Left = 16
      Top = 23
      Width = 121
      Height = 25
      Caption = 'Iniciar Download'
      TabOrder = 0
      OnClick = btnIniciarDownloadClick
    end
    object btnExibirMensagem: TButton
      Left = 16
      Top = 63
      Width = 121
      Height = 25
      Caption = 'Exibir mensagem'
      TabOrder = 1
      OnClick = btnExibirMensagemClick
    end
    object btnPararDownload: TButton
      Left = 16
      Top = 102
      Width = 121
      Height = 25
      Caption = 'Parar download'
      TabOrder = 2
      OnClick = btnPararDownloadClick
    end
  end
end
