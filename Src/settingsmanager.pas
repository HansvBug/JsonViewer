unit Settingsmanager;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls,
  ResourceStrings, FileLocations;


type

  { TSettingsmanager }

  TSettingsmanager = class(TObject)
    private
      FConfigurationFile, FDefaultLanguage, FBaseFolder: String;

      FActivateLogging, FAppendLogFile, FDisplayHelpText : Boolean;
      FTreeViewHotTrack, FCaseSensitiveSearch : Boolean;
      FStringAttribColor, FSymbolAttribColor, FNumberattribColor: Integer;
      FKeyAttribColor, FBracketAttribColor, FCommentAtribColor : Integer;
      FTrvOrMemoSearch : Integer;
      FPrintLeftMargin, FPrintRightMargin, FPrintTopMargin, FPrintBottomMargin : Integer;

      function  CheckFormIsEntireVisible(Rect: TRect): TRect;
      procedure ReadSettings;
      procedure GetConfigurationFileLocation;

      property ConfigurationFile : String  Read FConfigurationFile Write FConfigurationFile;
      property BaseFolder : String Read FBaseFolder Write FBaseFolder;
    public
      constructor Create; overload;
      destructor  Destroy; override;
      procedure SaveSettings;
      procedure StoreFormState(aForm: TForm);
      procedure RestoreFormState(aForm: TForm);
      procedure StoreSplitterPos(aSplitter: TSplitter);
      procedure RestoreSplitterPos(aSplitter: TSplitter; aPanel: TPanel);

      procedure StoreMruList(Files : AllFileObjects);
      function GetMruList : AllFileObjects;

      // Configure form
      property ActivateLogging       : Boolean Read FActivateLogging     Write FActivateLogging default True;
      property AppendLogFile         : Boolean Read FAppendLogFile       Write FAppendLogFile default True;
      property DefaultLanguage       : String  Read FDefaultLanguage     Write FDefaultLanguage;
      property SetTreeViewHotTrack   : Boolean Read FTreeViewHotTrack    Write FTreeViewHotTrack default False;
      property DisplayHelpText       : Boolean Read FDisplayHelpText     Write FDisplayHelpText default False;

      property StringAttribColor     : Integer Read FStringAttribColor   Write FStringAttribColor default 9633792;
      property SymbolAttribColor     : Integer Read FSymbolAttribColor   Write FSymbolAttribColor default 8388608;
      property NumberattribColor     : Integer Read FNumberattribColor   Write FNumberattribColor default 32768;
      property KeyAttribColor        : Integer Read FKeyAttribColor      Write FKeyAttribColor default 255;
      property BracketAttribColor    : Integer Read FBracketAttribColor  Write FBracketAttribColor default 16711935;
      property CommentAtribColor     : Integer Read FCommentAtribColor   Write FCommentAtribColor default 65280;

      property TrvOrMemoSearch       : Integer Read FTrvOrMemoSearch     write FTrvOrMemoSearch default 0;
      property CaseSensitiveSearch   : Boolean Read FCaseSensitiveSearch Write FCaseSensitiveSearch default False;

      property PrintLeftMargin       : Integer Read FPrintLeftMargin     Write FPrintLeftMargin default 20;
      property PrintRightMargin      : Integer Read FPrintRightMargin    Write FPrintRightMargin default 20;
      property PrintTopMargin        : Integer Read FPrintTopMargin      Write FPrintTopMargin default 20;
      property PrintBottomMargin     : Integer Read FPrintBottomMargin   Write FPrintBottomMargin default 20;
  end;

const
  NumberOfRecentFiles : Integer = 10;

implementation
uses Settings, IniFiles, Form_Main;

{ TSettingsmanager }

{%region constructor - destructor}
constructor TSettingsmanager.Create;
begin
  inherited;
  BaseFolder := ExtractFilePath(Application.ExeName);
  GetConfigurationFileLocation;
  ReadSettings;
end;

destructor TSettingsmanager.Destroy;
begin
  // ..
  inherited Destroy;
end;

{%endregion constructor - destructor}

procedure TSettingsmanager.GetConfigurationFileLocation;
var
  UserName : string;
begin
  UserName := StringReplace(GetEnvironmentVariable('USERNAME') , ' ', '_', [rfIgnoreCase, rfReplaceAll]) + '_';
  ConfigurationFile := BaseFolder + Settings.SettingsFolder + PathDelim + UserName + Settings.ConfigurationFile;
end;

procedure TSettingsmanager.ReadSettings;
begin
  With TIniFile.Create(ConfigurationFile) do
    try
      // Form_Configure
      if ReadInteger('Configure', 'ActivateLogging', 1) = 1 then begin
        ActivateLogging := True;
      end
      else begin
        ActivateLogging := False;
      end;

      if ReadInteger('Configure', 'AppendLogFile', 1) = 1 then begin
        AppendLogFile := True;
      end
      else begin
        AppendLogFile := False;
      end;

      if ReadInteger('Configure', 'TreeViewHotTrack', 0) = 0 then begin
        SetTreeViewHotTrack := False;
      end
      else begin
        SetTreeViewHotTrack := True;
      end;

      if ReadInteger('Configure', 'DisplayHelpText', 0) = 0 then begin
        DisplayHelpText := False;
      end
      else begin
        DisplayHelpText := True;
      end;

      StringAttribColor := ReadInteger('Configure', 'StringAttribColor', 0);
      SymbolAttribColor := ReadInteger('Configure', 'SymbolAttribColor', 0);

      NumberattribColor := ReadInteger('Configure', 'NumberattribColor', 0);
      KeyAttribColor := ReadInteger('Configure', 'KeyAttribColor', 0);
      BracketAttribColor := ReadInteger('Configure', 'BracketAttribColor', 0);
      CommentAtribColor := ReadInteger('Configure', 'CommentAtribColor', 0);
      DefaultLanguage := ReadString('Configure', 'DefaultLanguage', 'en');
      if ReadInteger('Configure', 'CaseSensitiveSearch', 0) = 0 then begin
        CaseSensitiveSearch := False;
      end
      else begin
        CaseSensitiveSearch := True;
      end;

      TrvOrMemoSearch := ReadInteger('Configure', 'TrvOrMemoSearch', 0);

      PrintLeftMargin := ReadInteger('Configure', 'PrintLeftMargin', 0);
      PrintRightMargin := ReadInteger('Configure', 'PrintRightMargin', 0);
      PrintTopMargin := ReadInteger('Configure', 'PrintTopMargin', 0);
      PrintBottomMargin := ReadInteger('Configure', 'PrintBottomMargin', 0);

    finally
      Free;
    end;
end;

procedure TSettingsmanager.SaveSettings;
begin
  With TIniFile.Create(ConfigurationFile) do
    try
      WriteString('Application', 'Name', Settings.ApplicationName);
      WriteString('Application', 'Version', Settings.Version);
      WriteString('Application', 'Build Date' , Settings.BuildDate);

      WriteBool('Configure', 'ActivateLogging', ActivateLogging);
      WriteBool('Configure', 'AppendLogFile', AppendLogFile);
      WriteBool('Configure', 'TreeViewHotTrack', SetTreeViewHotTrack);
      WriteBool('Configure', 'DisplayHelpText', DisplayHelpText);

      WriteInteger('Configure', 'StringAttribColor', StringAttribColor);
      WriteInteger('Configure', 'SymbolAttribColor', SymbolAttribColor);

      WriteInteger('Configure', 'NumberattribColor', NumberattribColor);
      WriteInteger('Configure', 'KeyAttribColor', KeyAttribColor);
      WriteInteger('Configure', 'BracketAttribColor', BracketAttribColor);
      WriteInteger('Configure', 'CommentAtribColor', CommentAtribColor);
      WriteString('Configure', 'DefaultLanguage', DefaultLanguage);
      WriteBool('Configure', 'CaseSensitiveSearch', CaseSensitiveSearch);
      WriteInteger('Configure', 'TrvOrMemoSearch', TrvOrMemoSearch);

      WriteInteger('Configure', 'PrintLeftMargin', PrintLeftMargin);
      WriteInteger('Configure', 'PrintRightMargin', PrintRightMargin);
      WriteInteger('Configure', 'PrintTopMargin', PrintTopMargin);
      WriteInteger('Configure', 'PrintBottomMargin', PrintBottomMargin);

    finally
      Free;
    end;
end;

procedure TSettingsmanager.StoreFormState(aForm: TForm);
begin
  With TIniFile.Create(ConfigurationFile) do
    try
      try
        writeinteger('Position', aForm.Name + '_Windowstate', integer(aForm.WindowState));
        WriteInteger('Position', aForm.Name + '_Left', aForm.Left);
        WriteInteger('Position', aForm.Name + '_Top', aForm.Top);
        WriteInteger('Position', aForm.Name + '_Width', aForm.Width);
        WriteInteger('Position', aForm.Name + '_Height', aForm.Height);

        WriteInteger('Position', aForm.Name + '_RestoredLeft', aForm.RestoredLeft);
        WriteInteger('Position', aForm.Name + '_RestoredTop', aForm.RestoredTop);
        WriteInteger('Position', aForm.Name + '_RestoredWidth', aForm.RestoredWidth);
        WriteInteger('Position', aForm.Name + '_RestoredHeight', aForm.RestoredHeight);

        FrmMain.Logging.WriteToLogInfo(rsStoreScreenPos + ' (' + aForm.Name + ').' );
      Except
        FrmMain.Logging.WriteToLogError(rsStoreScreenPos + aForm.Name + ' is mislukt.' );
      end;
    finally
      Free;
    end;
end;

procedure TSettingsmanager.RestoreFormState(aForm: TForm);
var
  LastWindowState: TWindowState;
begin
  With TIniFile.Create(ConfigurationFile) do
    try
      try
        LastWindowState := TWindowState(ReadInteger('Position', aForm.Name + '_WindowState', Integer(aForm.WindowState)));

        if LastWindowState = wsMaximized then
          begin
            aForm.WindowState := wsNormal;
            aForm.BoundsRect := Bounds(
            ReadInteger('Position', aForm.Name + '_RestoredLeft', aForm.RestoredLeft),
            ReadInteger('Position', aForm.Name + '_RestoredTop', aForm.RestoredTop),
            ReadInteger('Position', aForm.Name + '_RestoredWidth', aForm.RestoredWidth),
            ReadInteger('Position', aForm.Name + '_RestoredHeight', aForm.RestoredHeight));

            aForm.WindowState := wsMaximized;
          end
        else
          begin
            aForm.WindowState := wsNormal;
            aForm.BoundsRect := Bounds(
            ReadInteger('Position', aForm.Name + '_Left', aForm.Left),
            ReadInteger('Position', aForm.Name + '_Top', aForm.Top),
            ReadInteger('Position', aForm.Name + '_Width', aForm.Width),
            ReadInteger('Position', aForm.Name + '_Height', aForm.Height));

            aForm.BoundsRect := CheckFormIsEntireVisible(aForm.BoundsRect);
        end;

        FrmMain.Logging.WriteToLogInfo(rsGetScreenPos + aForm.Name + rsIsReady );
      finally
        Free;
      end;
    Except
      FrmMain.Logging.WriteToLogError(rsGetScreenPos + aForm.Name + rsHasFailed);
    end;
end;

function TSettingsmanager.CheckFormIsEntireVisible(Rect: TRect): TRect;
var
  Width: Integer;
  Height: Integer;
begin
  Result := Rect;
  Width := Rect.Right - Rect.Left;
  Height := Rect.Bottom - Rect.Top;
  if Result.Left < (Screen.DesktopLeft) then begin
    Result.Left := Screen.DesktopLeft;
    Result.Right := Screen.DesktopLeft + Width;
  end;
  if Result.Right > (Screen.DesktopLeft + Screen.DesktopWidth) then begin
    Result.Left := Screen.DesktopLeft + Screen.DesktopWidth - Width;
    Result.Right := Screen.DesktopLeft + Screen.DesktopWidth;
  end;
  if Result.Top < Screen.DesktopTop then begin
    Result.Top := Screen.DesktopTop;
    Result.Bottom := Screen.DesktopTop + Height;
  end;
  if Result.Bottom > (Screen.DesktopTop + Screen.DesktopHeight) then begin
    Result.Top := Screen.DesktopTop + Screen.DesktopHeight - Height;
    Result.Bottom := Screen.DesktopTop + Screen.DesktopHeight;
  end;
end;

procedure TSettingsmanager.StoreSplitterPos(aSplitter: TSplitter);
begin
  With TIniFile.Create(ConfigurationFile) do
    try
      try
        writeinteger('Position', aSplitter.Name + '_Left', aSplitter.Left);
        writeinteger('Position', aSplitter.Name + '_Top', aSplitter.Top);
      Except
        FrmMain.Logging.WriteToLogError(rsStoreScreenPos + aSplitter.Name + rsHasFailed);
      end;
    finally
      Free;
    end;
end;

procedure TSettingsmanager.RestoreSplitterPos(aSplitter: TSplitter; aPanel: TPanel);
begin
  With TIniFile.Create(ConfigurationFile) do
    try
      try
        if aSplitter.Align = alLeft then begin
          aPanel.Width :=  ReadInteger('Position', aSplitter.Name + '_Left', aSplitter.Left);
        end
        else if aSplitter.Align = alTop then begin
          aPanel.Height :=  ReadInteger('Position', aSplitter.Name + '_Top', aSplitter.Top);
        end;

        aSplitter.Left := ReadInteger('Position', aSplitter.Name + '_Left', aSplitter.Left);
        aSplitter.Top := ReadInteger('Position', aSplitter.Name + '_Top', aSplitter.Top);
      Except
        FrmMain.Logging.WriteToLogError(rsGetScreenPos + aSplitter.Name + rsHasFailed);
      end;
    finally
      Free;
    end;
end;

procedure TSettingsmanager.StoreMruList(Files: AllFileObjects);
var
  Settings : TIniFile;
  i, counter : Integer;
begin
  Settings := TIniFile.Create(ConfigurationFile);
  With Settings do
    try
      try
        if Files <> nil then begin
          Counter := 1;
          Settings.EraseSection('MRU');

          if length(Files) <= NumberOfRecentFiles then begin
            for i := 0 to length(Files)-1 do begin
              WriteString('MRU', 'File_' + IntToStr(Counter), Files[i].Location + Files[i].Name);
              Inc(Counter);
            end;
          end
          else begin
            for i:= length(Files)-1 downto length(Files)-NumberOfRecentFiles do begin
              WriteString('MRU', 'File_' + IntToStr(Counter), Files[i].Location + Files[i].Name);
              Inc(Counter);
            end;
          end;
        end;
      finally
        Settings.Free;
      end;
    Except
      FrmMain.Logging.WriteToLogError(rsStoreMruError);
    end;
end;

function TSettingsmanager.GetMruList: AllFileObjects;
var
  Settings : TIniFile;
  i,j, Counter : Integer;
  sections, idents : TstringList;
  FilenameAndLoc : String;
  MruObject : AllFileObjects;
begin
  Settings := TIniFile.Create(ConfigurationFile);
  sections := TstringList.Create;
  idents := TStringList.Create;

  With Settings do begin
    try
      try
        ReadSections(sections);

        ReadSections(sections);
        for i := 0 to sections.Count-1 do begin
          if sections[i] = 'MRU'then begin
            Counter := 1;
            idents.Clear;
            ReadSection(sections[i], idents);  // Get number of key within the section and then read the keys

            if idents.Count > 0 then begin;
              for j:=0 to idents.Count - 1 do begin
                Setlength(MruObject, Counter);
                FilenameAndLoc := readString('MRU', 'File_' + IntToStr(Counter), '');

                MruObject[j].Name := ExtractFileName(FilenameAndLoc);
                MruObject[j].Location := ExtractFilepath(FilenameAndLoc);
                MruObject[j].Counter := Counter;
                Inc(Counter);
              end;

            end;
          end;
        end;

      Except
        FrmMain.Logging.WriteToLogError(rsGetMruError);
      end;
    finally
      Settings.Free;
      sections.Free;
      idents.Free;
    end;
  end;

  Result := MruObject;
end;

end.

