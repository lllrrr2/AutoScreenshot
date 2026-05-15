unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, IniPropStorage, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    DirectoryEdit1: TDirectoryEdit;
    ImportFromTransifexButton: TButton;
    ExportToTransifexButton: TButton;
    IniPropStorage1: TIniPropStorage;
    Label1: TLabel;
    Label2: TLabel;
    procedure ExportToTransifexButtonClick(Sender: TObject);
    procedure ImportFromTransifexButtonClick(Sender: TObject);
    procedure IniPropStorage1RestoreProperties(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses StrUtils;

{$R *.lfm}

{ TForm1 }

procedure TForm1.ExportToTransifexButtonClick(Sender: TObject);
const
  INI_SECTION='translation';
var
  {langs,} files: TStringList;
  inFileName, outFileName: string;
  inIni, outIni: TIniFile;
  k: string;
  allKeys: TStringList;
  //engStringsCount: Integer=0;
  msg: TStringList;
begin
  //langs:=TStringList.Create;
  files:=TStringList.Create;
  msg:=TStringList.Create;
  try
    FindAllFiles(files, ConcatPaths([DirectoryEdit1.Directory, 'lang']), '*.ini', false);
    for infilename in files do
    begin
      writeln(inFileName);
      outFileName:=ConcatPaths([ExtractFilePath(inFileName), 'export', ExtractFileName(inFileName)]);
      ForceDirectories(ExtractFilePath(outFileName));
      Writeln(outFileName);
      DeleteFile(outFileName);

      try
        allKeys:=TStringList.Create;
        outIni:=TIniFile.Create(outFileName);
        inIni:=TIniFile.Create(inFileName);
        inIni.ReadSection(INI_SECTION, allKeys);

        {if EndsStr('en.ini', outFileName) then
          engStringsCount:=allKeys.Count;}

        for k in allkeys do
        begin
          writeln(k);
          outIni.WriteString(INI_SECTION, k, inIni.ReadString(INI_SECTION, k, ''));
        end;
        outini.UpdateFile;

        msg.Append(Format('%s '#9'-'#9'%d строк', [ExtractFileName(outFileName), allKeys.Count]));
      finally
        FreeAndNil(allKeys);
        FreeAndNil(outini);
        FreeAndNil(inIni);
      end;
    end;

    msg.Insert(0, 'Готово!'+LineEnding+LineEnding);
    ShowMessage(msg.Text);

  finally
    msg.free;
    files.free;
    //langs.free;
  end;
end;

procedure TForm1.ImportFromTransifexButtonClick(Sender: TObject);
begin
  ShowMessage('Not implemented!');
end;

procedure TForm1.IniPropStorage1RestoreProperties(Sender: TObject);
begin

end;

end.

