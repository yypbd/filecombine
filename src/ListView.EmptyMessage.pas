unit ListView.EmptyMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Graphics;

type
  TListView = class( Vcl.ComCtrls.TListView )
  private
    FEmptyMessage: string;

    procedure SetEmptyMessage(const Value: string);
    procedure DrawEmptyMessage;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    property EmptyMessage: string read FEmptyMessage write SetEmptyMessage;
  end;

implementation

uses
  CommCtrl;

{ TListView }

procedure TListView.DrawEmptyMessage;
var
  Text: string;
  TextWidth, TextHeight, TextLeft, TextTop: Integer;
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
    StringList.Text := FEmptyMessage;

    TextTop := 80;
    for Text in StringList do
    begin
      TextWidth := Canvas.TextWidth( Text );
      TextLeft := ( Width - TextWidth ) div 2;
      Canvas.TextOut( TextLeft, TextTop, Text );

      TextHeight := Canvas.TextHeight( Text );
      TextTop := TextTop + TextHeight + 5;
    end;
  finally
    StringList.Free;
  end;
end;

procedure TListView.SetEmptyMessage(const Value: string);
begin
  FEmptyMessage := Value;
end;

procedure TListView.WMPaint(var Message: TWMPaint);
begin
  inherited;

  if (Items.Count = 0) and (FEmptyMessage <> '') then
  begin
    DrawEmptyMessage;
  end;
end;

end.

