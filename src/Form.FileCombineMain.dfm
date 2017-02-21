object FormFileCombineMain: TFormFileCombineMain
  Left = 0
  Top = 0
  Caption = 'FormFileCombineMain'
  ClientHeight = 610
  ClientWidth = 1030
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListViewFile: TListView
    Left = 36
    Top = 24
    Width = 553
    Height = 541
    Columns = <
      item
        Width = 500
      end>
    DragMode = dmAutomatic
    MultiSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDragDrop = ListViewFileDragDrop
    OnDragOver = ListViewFileDragOver
  end
  object Button1: TButton
    Left = 640
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Combine'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 640
    Top = 80
    Width = 345
    Height = 485
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object SaveDialogCombined: TSaveDialog
    Left = 480
    Top = 420
  end
end
