unit Sort.StringCompare;

interface

uses
  Windows, SysUtils, Classes, ComCtrls;

  function NaturalOrderCompareString( const A1, A2: string; ACaseSensitive: Boolean ): Integer;
  function StrCmpLogicalW(psz1, psz2: PWideChar): Integer; stdcall; external 'shlwapi.dll';

type
  TStringListSortCompare = record
    class function DoNatural(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function DoCompareStr(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function DoWinAPI(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function DoStrCmpLogicalW(List: TStringList; Index1, Index2: Integer): Integer; static;
  end;

  TStringListSortCompareDesc = record
    class function DoNatural(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function DoCompareStr(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function DoWinAPI(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function DoStrCmpLogicalW(List: TStringList; Index1, Index2: Integer): Integer; static;
  end;

  PGroupSortData = ^TGroupSortData;
  TGroupSortData = record
    ListView: TListview;
    ColumnIndex: Integer;
    Ascend: Boolean;
  end;

implementation

function NaturalOrderCompareString( const A1, A2: string; ACaseSensitive: Boolean ): Integer;
var
  Str1, Str2: PChar;
  Pos1, Pos2: Integer;
  EndPos1, EndPos2: Integer;
begin
  Str1 := PChar(A1);
  Str2 := PChar(A2);

  Pos1 := -1;
  Pos2 := -1;

  while True do
  begin
    Inc( Pos1 );
    Inc( Pos2 );

    if (Str1[Pos1] = #0) and (Str2[Pos2] = #0) then
    begin
      Result := 0;
      Exit;
    end
    else if Str1[Pos1] = #0 then
    begin
      Result := -1;
      Exit;
    end
    else if Str2[Pos2] = #0 then
    begin
      Result := 1;
      Exit;
    end;

    if (Str1[Pos1] >= '0') and (Str1[Pos1] <= '9') and
       (Str2[Pos2] >= '0') and (Str2[Pos2] <= '9') then
    begin
      EndPos1 := Pos1;
      repeat
        Inc(EndPos1);
      until not ((Str1[EndPos1] >= '0') and (Str1[EndPos1] <= '9'));

      EndPos2 := Pos2;
      repeat
        Inc(EndPos2);
      until not ((Str2[EndPos2] >= '0') and (Str2[EndPos2] <= '9'));

      while True do
      begin
        if EndPos1 - Pos1 = EndPos2 - Pos2 then
        begin
          // 이부분이 숫자비교임. StrToInt 한 다음에 빼도 될 것임
          Result := CompareStr( Copy(Str1, Pos1+1, EndPos1 - Pos1),  Copy(Str2, Pos2+1, EndPos1 - Pos1) ) ;

          if Result = 0 then
          begin
            Pos1 := EndPos1 - 1;
            Pos2 := EndPos2 - 1;
            Break;
          end
          else
          begin
            Exit;
          end;
        end
        else if EndPos1 - Pos1 > EndPos2 - Pos2 then
        begin
          if Str1[Pos1] = '0' then
            Inc(Pos1)
          else
          begin
            Result := 1;
            Exit;
          end;
        end
        else
        begin
          if Str2[Pos2] = '0' then
            Inc( Pos2 )
          else
          begin
            Result := -1;
            Exit;
          end;
        end;
      end;
    end
    else
    begin
      if ACaseSensitive then
        Result := CompareStr( Copy(Str1, Pos1, 1), Copy(Str2, Pos2, 1) )
      else
        Result := CompareText( Copy(Str1, Pos1, 1), Copy(Str2, Pos2, 1) );

      if Result <> 0 then
        Exit;
    end;
  end;
end;

{ TStringListSortCompare }

class function TStringListSortCompare.DoCompareStr(List: TStringList; Index1,
  Index2: Integer): Integer;
begin
  Result := CompareStr( List.Strings[Index1], List.Strings[Index2] );
end;

class function TStringListSortCompare.DoNatural(List: TStringList; Index1,
  Index2: Integer): Integer;
begin
  Result := NaturalOrderCompareString( List.Strings[Index1], List.Strings[Index2], True );
end;

class function TStringListSortCompare.DoStrCmpLogicalW(List: TStringList; Index1,
  Index2: Integer): Integer;
begin
  Result := StrCmpLogicalW( PWideChar(List.Strings[Index1]), PWideChar(List.Strings[Index2]) );
end;

class function TStringListSortCompare.DoWinAPI(List: TStringList; Index1,
  Index2: Integer): Integer;
var
  CompareResult: Integer;
begin
  Result := 0;

  CompareResult := CompareString( LOCALE_USER_DEFAULT, 0, PWideChar(List.Strings[Index1]), Length(List.Strings[Index1]), PWideChar(List.Strings[Index2]), Length(List.Strings[Index2]) );

  case CompareResult of
    CSTR_LESS_THAN:     Result := -1;
    CSTR_GREATER_THAN:  Result := 1;
    CSTR_EQUAL:         Result := 0;
  end;
end;

{ TStringListSortCompareDesc }

class function TStringListSortCompareDesc.DoCompareStr(List: TStringList;
  Index1, Index2: Integer): Integer;
begin
  Result := -TStringListSortCompare.DoCompareStr( List, Index1, Index2 );
end;

class function TStringListSortCompareDesc.DoNatural(List: TStringList; Index1,
  Index2: Integer): Integer;
begin
  Result := -TStringListSortCompare.DoNatural( List, Index1, Index2 );
end;

class function TStringListSortCompareDesc.DoStrCmpLogicalW(List: TStringList;
  Index1, Index2: Integer): Integer;
begin
  Result := -TStringListSortCompare.DoStrCmpLogicalW( List, Index1, Index2 );
end;

class function TStringListSortCompareDesc.DoWinAPI(List: TStringList; Index1,
  Index2: Integer): Integer;
begin
  Result := -TStringListSortCompare.DoWinAPI( List, Index1, Index2 );
end;

end.
