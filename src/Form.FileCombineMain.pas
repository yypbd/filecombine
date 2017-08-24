unit Form.FileCombineMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  ListView.EmptyMessage;

type
  TFormFileCombineMain = class(TForm)
    SaveDialogCombined: TSaveDialog;
    PanelRight: TPanel;
    PanelButton: TPanel;
    ButtonCombine: TButton;
    MemoLog: TMemo;
    Splitter1: TSplitter;
    ListViewFile: TListView;
    ButtonClearFiles: TButton;
    procedure ListViewFileDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListViewFileDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ButtonCombineClick(Sender: TObject);
    procedure ListViewFileColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewFileResize(Sender: TObject);
    procedure ButtonClearFilesClick(Sender: TObject);
  private
    { Private declarations }
    FAsc: Boolean;

    function CombineFiles( const AFileName: string ): Boolean;
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
  ShellAPI, Sort.ListView, Sort.StringList;

{$R *.dfm}

{ TForm1 }

procedure TFormFileCombineMain.ButtonClearFilesClick(Sender: TObject);
begin
  ListViewFile.Items.Clear;
end;

procedure TFormFileCombineMain.ButtonCombineClick(Sender: TObject);
begin
  if ListViewFile.Items.Count = 0 then
  begin
    ShowMessage( 'File list is empty.' + sLineBreak + 'Add files first.' );
    Exit;
  end;

  if SaveDialogCombined.Execute then
  begin
    if CombineFiles( SaveDialogCombined.FileName ) then
    begin
    end;
  end;
end;

function TFormFileCombineMain.CombineFiles(const AFileName: string): Boolean;
var
  FileStreamTotal: TFileStream;
  FileStreamItem: TFileStream;
  I: Integer;
  FileName: string;
begin
  FileStreamTotal := TFileStream.Create( AFileName, fmCreate );

  try
    MemoLog.Lines.Clear;
    MemoLog.Lines.Add( '== Start combining process ==' );
    for I := 0 to ListViewFile.Items.Count - 1 do
    begin
      FileName := ListViewFile.Items[I].Caption;

      MemoLog.Lines.Add( 'Combine file: ' + ExtractFileName(FileName) );
      if FileExists( FileName ) then
      begin
        FileStreamItem := TFileStream.Create( FileName, fmOpenRead );
        try
          if FileStreamItem.Size > 0 then
          begin
            FileStreamTotal.CopyFrom( FileStreamItem, FileStreamItem.Size );

            MemoLog.Lines.Add( Format('  filesize: %d, totalsize: %d', [FileStreamItem.Size, FileStreamTotal.Size]) );
          end
          else
          begin
            MemoLog.Lines.Add( '  pass: size is 0' );
          end;
        finally
          FileStreamItem.Free;
        end;
      end
      else
      begin
        MemoLog.Lines.Add( '  pass: not exists file' );
      end;

      Application.ProcessMessages;
      Sleep(1);
    end;
    MemoLog.Lines.Add( '== Finish combining process ==' );
  finally
    FileStreamTotal.Free;
  end;

  Result := True;
end;

procedure TFormFileCombineMain.DoCreate;
begin
  inherited;

  Caption := Application.Title;

  FListViewWndProc := ListViewFile.WindowProc;
  ListViewFile.WindowProc := ListViewWndProc;
  DragAcceptFiles( ListViewFile.Handle, True );

  FAsc := True;

  ListViewFile.EmptyMessage := 'Drag&drop files from Windows Explorer.';
end;

procedure TFormFileCombineMain.DoDestroy;
begin
  ListViewFile.WindowProc := FListViewWndProc;
  DragAcceptFiles( ListViewFile.Handle, False );

  inherited;
end;

procedure TFormFileCombineMain.ListViewFileColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  TListViewSort.SortByColumn( ListViewFile, Column.Index, False, FAsc );
  FAsc := not FAsc;
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

procedure TFormFileCombineMain.ListViewFileResize(Sender: TObject);
begin
  ListViewFile.Column[0].Width := ListViewFile.Width - 30;
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
  FileList: TStringList;
begin
  FileList := TStringList.Create;
  try
    FileName := '';
    FileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, FileName, 255);
    for I := 0 to FileCount - 1 do
    begin
      Size := DragQueryFile(Msg.wParam, I, nil, 0) + 1;
      FileName := StrAlloc(Size);
      DragQueryFile(Msg.wParam, I, FileName, Size);
      if FileExists(FileName) then
      begin
        FileList.Add( FileName );
      end;
      StrDispose(FileName);
    end;
    DragFinish(Msg.wParam);

    TStringListSort.Sort( FileList, False, True );

    for I := 0 to FileList.Count - 1 do
    begin
      ListItem := ListViewFile.Items.Add;
      ListItem.Caption := FileList.Strings[I];
    end;
  finally
    FileList.Free;
  end;
end;

end.
