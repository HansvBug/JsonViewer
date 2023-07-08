unit ApplicationEnvironment;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, lazfileutils, Dialogs,
  ResourceStrings;

type
  { TApplicationEnvironment }
  TApplicationEnvironment = class

    private

    public
      procedure CreateFolder(const BaseFolderPath : string; const NewFolderName : string);
      procedure CreateSettingsFile(SettingsFileName : string);
  end;

implementation

uses Settings;

{ TApplicationEnvironment }

procedure TApplicationEnvironment.CreateFolder(const BaseFolderPath: string;
  const NewFolderName: string);
begin
  if not DirectoryExists(BaseFolderPath + NewFolderName) then
  begin
    if DirectoryIsWritable(BaseFolderPath) then
    begin
      CreateDir(BaseFolderPath+NewFolderName);
    end
    else
    begin
      MessageDlg(rsError, rsMissingFolderWriteRights + '', mtWarning, [mbOk], 0);
    end;
  end;
end;

procedure TApplicationEnvironment.CreateSettingsFile(SettingsFileName: string);
var
  UserName : string;
  tfOut: TextFile;
begin
  UserName := StringReplace(GetEnvironmentVariable('USERNAME') , ' ', '_', [rfIgnoreCase, rfReplaceAll]) + '_';
  SettingsFileName := SettingsFileName +  UserName + Settings.ConfigurationFile;
  if not FileExists(SettingsFileName) then
  begin
    try
      AssignFile(tfOut, SettingsFileName);
      //FileCreate (SettingsFileName, fmShareDenyNone);
      rewrite(tfOut);   //Create the file.
      CloseFile(tfOut);
    except
      MessageDlg(rsError, rsCreateSettngsFileFaild + '', mtWarning, [mbOk], 0);
    end;
  end;
end;

end.

