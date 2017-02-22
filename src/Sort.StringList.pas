unit Sort.StringList;

interface

uses
  Classes;

type
  TStringListSort = record
  private
    class var
      FCaseSensitive: Boolean;
      FAsc: Boolean;
    class function CompareStrings(List: TStringList; Index1, Index2: Integer): Integer; static;
  public
    class procedure Sort( AStringList: TStringList; ACaseSensitive, AAsc: Boolean ); static;
  end;

implementation

uses
  Sort.StringCompare;

{ TStringListSort }

class procedure TStringListSort.Sort(AStringList: TStringList; ACaseSensitive,
  AAsc: Boolean);
begin
  FCaseSensitive := ACaseSensitive;
  FAsc := AAsc;
  AStringList.CustomSort( CompareStrings );
end;

class function TStringListSort.CompareStrings(List: TStringList;
  Index1, Index2: Integer): Integer;
begin
  Result := NaturalOrderCompareString( List.Strings[Index1], List.Strings[Index2], FCaseSensitive );
  if FAsc = False then Result := -Result;
end;

end.
