unit Logging;

{$mode objfpc}{$H+}

interface
{$M+}
{$MODESWITCH TYPEHELPERS}

uses Classes, Sysutils, FileUtil, Forms,
     ResourceStrings;

type

  { TLog_File }

  TLog_File = class(TObject)
  private
    strlist                : TStringList;
    FileStream1            : TFileStream;
    FLogFolder, FUserName  : String;
    FAppendCurrentLogfile, FActivateLogging  : Boolean;
    szCurrentTime          : String;

    function GetAppendCurrentLogfile: Boolean;
    function GetLogFolder: String;
    function GetCurUserName: String;
    procedure SetAppendCurrentLogfile(AValue: Boolean);
    procedure SetLogFolder(AValue: String);
    procedure SetCurUserName(AValue: String);

    function    CurrentDate: String;                      //Bepalen huidige datum
    procedure   Logging;                                  //De gegevens worden in het bestand gezet
    procedure   CurrentTime;

    procedure   WriteToLog(Comment : String);          //Tekst naar logbestand schrijven
    procedure   WriteToLogAndFlush(Comment : String);  //Tekst direct naar logbestand schrijven

    property LogFolder        : String  Read GetLogFolder            Write SetLogFolder;
    property Username         : String  Read GetCurUserName          Write SetCurUserName;

  public
    constructor Create();
    destructor  Destroy; override;
    procedure   StartLogging;                             //Aanmaken/openen log bestand
    procedure   StopLogging;                              //Bestand opslaan en sluiten
    procedure   WriteToLogInfo(Comment : String);          //Tekst naar logbestand schrijven
    procedure   WriteToLogWarning(Comment : String);          //Tekst naar logbestand schrijven
    procedure   WriteToLogError(Comment : String);          //Tekst naar logbestand schrijven
    procedure   WriteToLogDebug(Comment : String);          //Tekst naar logbestand schrijven

    procedure   WriteToLogAndFlushInfo(Comment : String);  //Tekst direct naar logbestand schrijven
    procedure   WriteToLogAndFlushWarning(Comment : String);  //Tekst direct naar logbestand schrijven
    procedure   WriteToLogAndFlushError(Comment : String);  //Tekst direct naar logbestand schrijven
    procedure   WriteToLogAndFlushDebug(Comment : String);  //Tekst direct naar logbestand schrijven

    property AppendLogFile    : Boolean Read GetAppendCurrentLogfile Write SetAppendCurrentLogfile;
    property ActivateLogging  : Boolean Read FActivateLogging        Write FActivateLogging;


end;

implementation

uses lazfileutils,
     Settings;

{ TLog_File.TLogTypeHelper }



{ TLog_File }

//Public

{%region% properties}
function TLog_File.GetLogFolder: String;
begin
  Result := FLogFolder;
end;

procedure TLog_File.SetLogFolder(AValue: String);
begin
  FLogFolder := AValue;
end;

function TLog_File.GetCurUserName: String;
begin
  Result := FUserName;
end;
procedure TLog_File.SetCurUserName(AValue: String);
begin
  FUserName := AValue;
end;

function TLog_File.GetAppendCurrentLogfile: Boolean;
begin
  Result := FAppendCurrentLogfile;
end;

procedure TLog_File.SetAppendCurrentLogfile(AValue: Boolean);
begin
  FAppendCurrentLogfile := AValue;
end;

{%endregion% properties}



constructor TLog_File.Create();
begin
  LogFolder := AppendPathDelim(ExtractFilePath(Application.ExeName) + Settings.LoggingFolder);
  strlist := TStringList.Create;
  UserName := StringReplace(GetEnvironmentVariable('USERNAME'), ' ', '_', [rfIgnoreCase, rfReplaceAll]);
end;

destructor TLog_File.Destroy;
begin
  FileStream1.Free;
  strlist.Free;
  inherited;
end;

procedure TLog_File.CurrentTime;  // Get current time
begin
  szCurrentTime := FormatDateTime('hh:mm:ss', Now) + ' --> | ';
end;

function TLog_File.CurrentDate: String;
var
  Present           : TDateTime;
  Year, Month, Day  : Word;
begin
  Present := Now;                         // Get current date en time.
  DecodeDate(Present, Year, Month, Day);
  Result :=  IntToStr(Day) + '-' + IntToStr(Month) + '-' + IntToStr(Year);
end;

procedure TLog_File.Logging;
var
  retry      : Boolean;
  retries, i : Integer;
  MyString   : String;
const
  MAXRETRIES = 10;
  RETRYBACKOFFDELAYMS = 50;
begin
  if ActivateLogging then begin
    try
      // Retry mechanisme voor een SaveToFile()
      retry := True;
      retries := 0;
      while retry do
      try
        // Write to file.
        for I := 0 to strlist.Count-1 do
          begin
            try
              FileStream1.seek(0,soFromEnd);  // Place cursor at the end of the file.
              MyString := strlist[i] + sLineBreak;
              FileStream1.WriteBuffer(MyString[1], Length(MyString) * SizeOf(Char));
            finally
              //
            end;
          end;
        strlist.Clear;
        retry := False;
      except
        on EInOutError do
        begin
          Inc(retries);
          Sleep(RETRYBACKOFFDELAYMS * retries);
          if retries > MAXRETRIES then
          begin
            WriteToLog(rsLogInfoAbortLogging);
            Exit;
          end;
        end;
      end;
    finally
      //
    end;
  end;
end;

procedure TLog_File.StartLogging;
begin
  if ActivateLogging then begin
    if AppendLogFile = True then
      begin
        if FileExists(LogFolder
                       + Username
                       + '_'
                       + Settings.LogFileName) then
          begin
            FileStream1 := TFileStream.Create(LogFolder
                                                 + Username
                                                 + '_'
                                                 + Settings.LogFileName,
                           fmOpenReadWrite or fmShareDenyNone);  // fmShareDenyNone : Do not lock file
          end
        else  // Append and file does not exist then create file.
          begin
            FileStream1 := TFileStream.Create(LogFolder
                                                 + Username
                                                 + '_'
                                                 + Settings.LogFileName,
                           fmCreate or fmShareDenyNone);
          end;
      end
    else  // Create new file
      begin
        FileStream1 := TFileStream.Create(LogFolder
                                                   + Username
                                                   + '_'
                                                   + Settings.LogFileName,
                             fmCreate or fmShareDenyNone);

      end;

    try
      strlist.Add('##################################################################################################');
      strlist.Add(rsLogProgram + Settings.ApplicationName);
      strlist.Add(rsLogVersion + Settings.Version);
      strlist.Add(rsLogDate + CurrentDate);
      strlist.Add('##################################################################################################');
      Logging;  // Save direct.
      CurrentTime;
    except
      strlist.Add(rsLogErrStartLogging);
    end;
  end;
end;

procedure TLog_File.StopLogging;
begin
  strlist.Add('');
  strlist.Add('##################################################################################################');
  strlist.Add(rsLogProgram_1 + Settings.ApplicationName + rsLogIsSaved);
  strlist.Add('##################################################################################################');
  strlist.Add('');
  strlist.Add('');
  strlist.Add('');
  Logging;  // Direct save.
end;

procedure TLog_File.WriteToLogInfo(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogInformation + Comment);
end;

procedure TLog_File.WriteToLogWarning(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogWarning + Comment);
end;

procedure TLog_File.WriteToLogError(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogError + Comment);
end;

procedure TLog_File.WriteToLogDebug(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogDebug + Comment);
end;

procedure TLog_File.WriteToLog(Comment : String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + ' :              | ' + Comment);
end;

procedure TLog_File.WriteToLogAndFlushInfo(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogInformation + Comment);
  Logging;
end;

procedure TLog_File.WriteToLogAndFlushWarning(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogWarning + Comment);
  Logging;
end;

procedure TLog_File.WriteToLogAndFlushError(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogError + Comment);
  Logging;
end;

procedure TLog_File.WriteToLogAndFlushDebug(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + rsLogDebug + Comment);
  Logging;
end;

procedure TLog_File.WriteToLogAndFlush(Comment: String);
begin
  CurrentTime;
  strlist.Add(szCurrentTime + ' :              | ' + Comment);
  Logging;
end;

end.
