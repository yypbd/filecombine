unit Form.FileCombineMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TFormFileCombineMain = class(TForm)
    ListViewFile: TListView;
    Button1: TButton;
    SaveDialogCombined: TSaveDialog;
    Memo1: TMemo;
    procedure ListViewFileDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListViewFileDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FListViewWndProc: TWndMethod;

    procedure ListViewWndProc(var Message: TMessage);
    procedure WMDropFiles(var Msg: TMessage);

    procedure DoCreate; override;
    procedure DoDestroy; override;
  public
    { Public declarations }
  end;

var
  FormFileCombineMain: TFormFileCombineMain;

implementation

uses
  ShellAPI;

{$R *.dfm}

{ TForm1 }

procedure TFormFileCombineMain.Button1Click(Sender: TObject);
var
  I: Integer;
  FileStream: TFileStream;
  FileStreamItem: TFileStream;
begin
  if SaveDialogCombined.Execute then
  begin
    FileStream := TFileStream.Create( SaveDialogCombined.FileName, fmCreate );

    for I := 0 to ListViewFile.Items.Count - 1 do
    begin
      FileStreamItem := TFileStream.Create( ListViewFile.Items[I].Caption, fmOpenRead );
      try
        if FileStreamItem.Size > 0 then
        begin
          FileStream.CopyFrom( FileStreamItem, FileStreamItem.Size );
        end;
      finally
        FileStreamItem.Free;
      end;
    end;

    FileStream.Free;
  end;
end;

procedure TFormFileCombineMain.DoCreate;
begin
  inherited;

  FListViewWndProc := ListViewFile.WindowProc;
  ListViewFile.WindowProc := ListViewWndProc;
  DragAcceptFiles( ListViewFile.Handle, True );
end;

procedure TFormFileCombineMain.DoDestroy;
begin
  ListViewFile.WindowProc := FListViewWndProc;
  DragAcceptFiles( ListViewFile.Handle, False );

  inherited;
end;

procedure TFormFileCombineMain.ListViewFileDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DragItem, DropItem, CurrentItem, NextItem: TListItem;
begin
  if Sender = Source then
    with TListView(Sender) do
    begin
      DropItem    := GetItemAt(X, Y);
      CurrentItem := Selected;
      while CurrentItem <> nil do
      begin
        NextItem := GetNextItem(CurrentItem, SdAll, [IsSelected]);
        if DropItem = nil then DragItem := Items.Add
        else
          DragItem := Items.Insert(DropItem.Index);
        DragItem.Assign(CurrentItem);
        CurrentItem.Free;
        CurrentItem := NextItem;
      end;
    end;
end;

procedure TFormFileCombineMain.ListViewFileDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Sender = ListViewFile;
end;

procedure TFormFileCombineMain.ListViewWndProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
  begin
    WMDropFiles( Message );
  end;

  FListViewWndProc( Message );
end;

procedure TFormFileCombineMain.WMDropFiles(var Msg: TMessage);
var
  FileName: PWideChar;
  I, Size, FileCount: integer;
  ListItem: TListItem;
begin
  FileName := '';
  FileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, FileName, 255);
  for I := 0 to FileCount - 1 do
  begin
    Size := DragQueryFile(Msg.wParam, I, nil, 0) + 1;
    FileName := StrAlloc(Size);
    DragQueryFile(Msg.wParam, I, FileName, Size);
    if FileExists(FileName) then
    begin
      ListItem := ListViewFile.Items.Add;
      ListItem.Caption := FileName;
    end;
    StrDispose(FileName);
  end;
  DragFinish(Msg.wParam);

  ListViewFile.AlphaSort;
end;

end.
