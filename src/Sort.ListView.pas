unit Sort.ListView;

interface

uses
  Windows, ComCtrls;

type
  PSortData = ^TSortData;
  TSortData = record
    Column: Integer;
    CaseSensitive: Boolean;
    Asc: Boolean;
  end;

  TListViewSort = record
  private
    class function ListViewCompare(lParam1, lParam2, lParamSort: LPARAM): Integer stdcall; static;
  public
    class procedure SortByColumn( AListView: TListView; AColumn: Integer; ACaseSensitive, AAsc: Boolean ); static;
  end;

implementation

uses
  Sort.StringCompare;

{ TListViewSort }

class function TListViewSort.ListViewCompare(lParam1, lParam2,
  lParamSort: LPARAM): Integer;
var
  ListItem1, ListItem2: TListItem;
  SortData: PSortData;
begin
  ListItem1 := TListItem(lParam1);
  ListItem2 := TListItem(lParam2);
  SortData := PSortData(lParamSort);

  if SortData^.Column = 0 then
    Result := NaturalOrderCompareString( ListItem1.Caption, ListItem2.Caption, SortData^.CaseSensitive )
  else
    Result := NaturalOrderCompareString( ListItem1.SubItems[SortData^.Column - 1], ListItem2.SubItems[SortData^.Column - 1], SortData^.CaseSensitive );

  if SortData^.Asc = False then
    Result := -Result;
end;

class procedure TListViewSort.SortByColumn(AListView: TListView; AColumn: Integer;
  ACaseSensitive, AAsc: Boolean);
var
  SortData: TSortData;
begin
  SortData.Column := AColumn;
  SortData.CaseSensitive := ACaseSensitive;
  SortData.Asc := AAsc;

  AListView.CustomSort( ListViewCompare, Integer(@SortData) );
end;

end.
