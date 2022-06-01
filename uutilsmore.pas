unit uUtilsMore;

{$mode objfpc}{$H+}
{$modeSwitch advancedRecords}
{$modeswitch TypeHelpers}

interface

uses
  Classes, SysUtils;

type

  { TProgramVersion }

  TProgramVersion = record
    Major, Minor, Revision, Build: Cardinal;

    class function Create(AMajor: Cardinal = 0; AMinor: Cardinal = 0;
             ARevision: Cardinal = 0; ABuild: Cardinal = 0): TProgramVersion; static; overload;
    class function Create(const AStr: String): TProgramVersion; static; overload;
    function ToString(ADropTrailingZeros: Boolean = False): String;
  end;

operator = (AVer1, AVer2: TProgramVersion): Boolean;
operator <> (AVer1, AVer2: TProgramVersion): Boolean;
operator > (AVer1, AVer2: TProgramVersion): Boolean;
operator < (AVer1, AVer2: TProgramVersion): Boolean;

implementation

uses
  RegExpr;

type
  { TJoinInteger }

  { Thanks to Zvoni!
    https://forum.lazarus.freepascal.org/index.php/topic,59519.msg443738.html#msg443738 }
  TJoinInteger=Type helper(TStringHelper) for AnsiString
    class function Join(const Separator: string; const Values: array of Integer): string; overload; static;
  end;

operator = (AVer1, AVer2: TProgramVersion): Boolean;
begin
  Result := (AVer1.Major = AVer2.Major) and (AVer1.Minor = AVer2.Minor)
        and (AVer1.Revision = AVer2.Revision) and (AVer1.Build = AVer2.Build);
end;

operator <> (AVer1, AVer2: TProgramVersion): Boolean;
begin
  Result := not (AVer1 = AVer2);
end;

operator>(AVer1, AVer2: TProgramVersion): Boolean;
begin
  Result := False;

  if AVer1.Major > AVer2.Major then
    Result := True
  else if AVer1.Major = AVer2.Major then
  begin
    if AVer1.Minor > AVer2.Minor then
      Result := True
    else if AVer1.Minor = AVer2.Minor then
    begin
      if AVer1.Revision > AVer2.Revision then
        Result := True
      else if AVer1.Revision = AVer2.Revision then
      begin
        if AVer1.Build > AVer2.Build then
          Result := True;
      end;
    end;
  end;
end;

operator<(AVer1, AVer2: TProgramVersion): Boolean;
begin
  Result := (not (AVer1 > AVer2)) and (AVer1 <> AVer2);
end;

{ TJoinInteger }

class function TJoinInteger.Join(const Separator: string;
  const Values: array of Integer): string;
Var
  SValues:Array Of String;
  i:SizeInt;
begin
  SetLength(SValues,System.Length(Values));
  For i:=Low(SValues) To High(SValues) Do SValues[i]:=Values[i].ToString;
  Result:=String.Join(Separator,SValues);
end;

{ TProgramVersion }

class function TProgramVersion.Create(AMajor: Cardinal; AMinor: Cardinal;
  ARevision: Cardinal; ABuild: Cardinal): TProgramVersion; static;
begin
  with Result do
  begin
    Major := AMajor;
    Minor := AMinor;
    Revision := ARevision;
    Build := ABuild;
  end;
end;

class function TProgramVersion.Create(const AStr: String): TProgramVersion;
var
  Re: TRegExpr;
begin
  // RegEx test: https://regex101.com/r/sEeva5/1

  Result := TProgramVersion.Create(0, 0, 0, 0);

  Re := TRegExpr.Create('^v?(\d+)(?:\.(\d+))?(?:\.(\d+))?(?:\.(\d+))?$');
  Re.ModifierI := True;
  if Re.Exec(AStr) then
  begin
    if Re.Match[1] <> '' then
      Result.Major := StrToInt(Re.Match[1]);

    if Re.Match[2] <> '' then
      Result.Minor := StrToInt(Re.Match[2]);

    if Re.Match[3] <> '' then
      Result.Revision := StrToInt(Re.Match[3]);

    if Re.Match[4] <> '' then
      Result.Build := StrToInt(Re.Match[4]);
  end;
  Re.Free;
end;

function TProgramVersion.ToString(ADropTrailingZeros: Boolean): String;
type
  TVersionNumbers = Array of {Cardinal} Integer;
var
  Numbers: TVersionNumbers;
  I: Integer;
begin
  Numbers := TVersionNumbers.Create(Major, Minor, Revision, Build);

  if ADropTrailingZeros then
  begin
    for I := High(Numbers) downto Low(Numbers) do
    begin
      if (Numbers[I] = 0) then
        Delete(Numbers, I, 1)
      else
        Break;
    end;
  end;

  Result := String.Join('.', Numbers);
end;

end.
