object FormFileCombineMain: TFormFileCombineMain
  Left = 0
  Top = 0
  Caption = 'FormFileCombineMain'
  ClientHeight = 561
  ClientWidth = 928
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 523
    Top = 0
    Height = 561
    Align = alRight
    ExplicitLeft = 925
    ExplicitTop = -8
  end
  object PanelRight: TPanel
    Left = 526
    Top = 0
    Width = 402
    Height = 561
    Align = alRight
    TabOrder = 0
    object PanelButton: TPanel
      Left = 1
      Top = 1
      Width = 400
      Height = 44
      Align = alTop
      TabOrder = 0
      object ButtonCombine: TButton
        Left = 12
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Combine'
        TabOrder = 0
        OnClick = ButtonCombineClick
      end
      object ButtonClearFiles: TButton
        Left = 120
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Clear Files'
        TabOrder = 1
        OnClick = ButtonClearFilesClick
      end
    end
    object MemoLog: TMemo
      Left = 1
      Top = 45
      Width = 400
      Height = 515
      Align = alClient
      TabOrder = 1
    end
  end
  object ListViewFile: TListView
    Left = 0
    Top = 0
    Width = 523
    Height = 561
    Align = alClient
    Columns = <
      item
        Caption = 'FileName'
        Width = 500
      end>
    DragMode = dmAutomatic
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = ListViewFileColumnClick
    OnDragDrop = ListViewFileDragDrop
    OnDragOver = ListViewFileDragOver
    OnResize = ListViewFileResize
  end
  object SaveDialogCombined: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 580
    Top = 128
  end
end
