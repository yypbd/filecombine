object FormFileCombineMain: TFormFileCombineMain
  Left = 0
  Top = 0
  Caption = 'FormFileCombineMain'
  ClientHeight = 561
  ClientWidth = 927
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ListViewFile: TListView
    Left = 0
    Top = 0
    Width = 525
    Height = 561
    Align = alLeft
    Columns = <
      item
        Caption = 'FileName'
        Width = 500
      end>
    DragMode = dmAutomatic
    MultiSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDragDrop = ListViewFileDragDrop
    OnDragOver = ListViewFileDragOver
    ExplicitLeft = -5
  end
  object PanelMain: TPanel
    Left = 525
    Top = 0
    Width = 402
    Height = 561
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 531
    ExplicitTop = 208
    ExplicitWidth = 381
    ExplicitHeight = 305
    object PanelButton: TPanel
      Left = 1
      Top = 1
      Width = 400
      Height = 44
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 467
      object ButtonCombine: TButton
        Left = 12
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Combine'
        TabOrder = 0
        OnClick = ButtonCombineClick
      end
    end
    object MemoLog: TMemo
      Left = 1
      Top = 45
      Width = 400
      Height = 515
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 48
      ExplicitTop = 83
      ExplicitWidth = 345
      ExplicitHeight = 510
    end
  end
  object SaveDialogCombined: TSaveDialog
    Left = 580
    Top = 128
  end
end
