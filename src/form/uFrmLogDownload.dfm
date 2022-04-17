object frmLogDownload: TfrmLogDownload
  Left = 0
  Top = 0
  Caption = 'Hist'#243'rico de downloads'
  ClientHeight = 299
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lvLogDownload: TListView
    Left = 0
    Top = 0
    Width = 578
    Height = 299
    Align = alClient
    Columns = <
      item
        Caption = 'C'#243'digo'
        MaxWidth = 50
        MinWidth = 50
      end
      item
        Caption = 'Url'
        MaxWidth = 280
        MinWidth = 280
        Width = 280
      end
      item
        Caption = 'Data de In'#237'cio'
        MaxWidth = 120
        MinWidth = 120
        Width = 120
      end
      item
        Caption = 'Data de Fim'
        MaxWidth = 120
        MinWidth = 120
        Width = 120
      end>
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
  end
end
