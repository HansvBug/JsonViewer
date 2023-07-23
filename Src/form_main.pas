unit Form_Main;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, LCLType, Classes, Types, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls, ExtCtrls, SynEdit, SynHighlighterJScript,  strutils, LazUTF8,
  LCLTranslator, ResourceStrings,
  Settings, Logging, Settingsmanager, Visual, FormConfigure, FileLocations,
  SynEditTypes, Printers, PrintersDlgs, fppdf
  ;



type

  { TFrmMain }

  TFrmMain = class(TForm)
    Button1: TButton;
    ButtonClear: TButton;
    ButtonClose: TButton;
    ButtonSave: TButton;
    ButtonSearch: TButton;
    cbCaseSensitive: TCheckBox;
    ComboBoxSearch: TComboBox;
    ImageList1: TImageList;
    imgBookMarks: TImageList;
    LabelSearchResult: TLabel;
    LabelSynEditPos: TLabel;
    ListBoxFileNames: TListBox;
    MainMenu1: TMainMenu;
    MenuItemProgramPrint: TMenuItem;
    Separator4: TMenuItem;
    MenuItemPrint: TMenuItem;
    Separator3: TMenuItem;
    MenuItemSortDesc: TMenuItem;
    MenuItemSortAsc: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PanelBottom: TPanel;
    PanelListBoxFileNames: TPanel;
    PanelMainClient: TPanel;
    PanelMainRight: TPanel;
    PanelMemo: TPanel;
    PanelTrv: TPanel;
    PanelTrvTop: TPanel;
    PopupMenuListBoxFileNames: TPopupMenu;
    RadioGroupSearchOptions: TRadioGroup;
    Separator2: TMenuItem;
    MenuItemJsonSave: TMenuItem;
    MenuItemJsonClear: TMenuItem;
    MenuItemJsonPrettify: TMenuItem;
    MenuItemJson: TMenuItem;
    MenuItemProgramMruList: TMenuItem;
    MenuItemIncomingOrder: TMenuItem;
    MenuItemSort: TMenuItem;
    MenuItemOptionsLanguageEN: TMenuItem;
    MenuItemOptionsLanguageNL: TMenuItem;
    MenuItemOptionsLanguage: TMenuItem;
    MenuItemOptionsSep1: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemClear: TMenuItem;
    MenuItemPrettify: TMenuItem;
    MenuItemCollapseSelectedNode: TMenuItem;
    MenuItemExpandSelectedNode: TMenuItem;
    MenuItemCollapseAll: TMenuItem;
    MenuItemExpandAll: TMenuItem;
    MenuItemOptionsConfigure: TMenuItem;
    MenuItemOptions: TMenuItem;
    MenuItemProgram: TMenuItem;
    MenuItemProgramClose: TMenuItem;
    MenuItemProgramOpenFile: TMenuItem;
    PanelTop: TPanel;
    PopupMenuFileNames: TPopupMenu;
    PopupMenuSynEdit: TPopupMenu;
    PopupMenuTrv: TPopupMenu;
    Separator1: TMenuItem;
    SplitterMainFrm1: TSplitter;
    SplitterMainFrm2: TSplitter;
    StatusBarMainFrm: TStatusBar;
    SynEditJsonData: TSynEdit;
    SynJScriptSynJson: TSynJScriptSyn;
    TreeViewJsonItems: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonClearMouseLeave(Sender: TObject);
    procedure ButtonClearMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonCloseMouseLeave(Sender: TObject);
    procedure ButtonCloseMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonPrettifyMouseLeave(Sender: TObject);
    procedure ButtonPrettifyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonSaveMouseLeave(Sender: TObject);
    procedure ButtonSaveMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonSearchClick(Sender: TObject);
    procedure cbCaseSensitiveChange(Sender: TObject);
    procedure ComboBoxSearchChange(Sender: TObject);
    procedure ComboBoxSearchEnter(Sender: TObject);
    procedure ComboBoxSearchExit(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListBoxFileNamesClick(Sender: TObject);
    procedure ListBoxFileNamesMouseLeave(Sender: TObject);
    procedure ListBoxFileNamesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MenuItemPrintClick(Sender: TObject);
    procedure MenuItemProgramPrintClick(Sender: TObject);
    procedure MenuItemSelectAllClick(Sender: TObject);
    procedure MenuItemCollapseSelectedNodeClick(Sender: TObject);
    procedure MenuItemCollapseAllClick(Sender: TObject);
    procedure MenuItemExpandAllClick(Sender: TObject);
    procedure MenuItemExpandSelectedNodeClick(Sender: TObject);
    procedure MenuItemJsonClearClick(Sender: TObject);
    procedure MenuItemJsonPrettifyClick(Sender: TObject);
    procedure MenuItemJsonSaveClick(Sender: TObject);
    procedure MenuItemOptionsConfigureClick(Sender: TObject);
    procedure MenuItemOptionsLanguageENClick(Sender: TObject);
    procedure MenuItemOptionsLanguageNLClick(Sender: TObject);
    procedure MenuItemProgramCloseClick(Sender: TObject);
    procedure MenuItemProgramOpenFileClick(Sender: TObject);
    procedure MenuItemSortAscClick(Sender: TObject);
    procedure MenuItemSortDescClick(Sender: TObject);
    procedure PanelBottomMouseLeave(Sender: TObject);
    procedure RadioGroupSearchOptionsSelectionChanged(Sender: TObject);
    procedure SynEditJsonDataChange(Sender: TObject);
    procedure SynEditJsonDataKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SynEditJsonDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SynEditJsonDataPaste(Sender: TObject; var AText: String;
      var AMode: TSynSelectionMode; ALogStartPos: TPoint;
      var AnAction: TSynCopyPasteAction);
    procedure TreeViewJsonItemsClick(Sender: TObject);
    procedure TreeViewJsonItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FTreeViewItemIndex : Integer;
    FFileCounter : Integer; // number of opened files in current session
    FCurrFile : String;     // current filename if available. Used for the printjob name.
    FPtrFilename : PtrFileObject;

    procedure SetStatusbarText(aText : String; overrideSetting : Boolean);
    procedure CheckAppEnvironment;
    procedure Initialize;
    procedure ReadSettings;
    procedure SaveSettings;
    procedure RestoreFormState;
    procedure StartLogging;
    procedure PrettifyJson(synEdit : TSynEdit);
    procedure ClearData(synEdit : TSynEdit);
    procedure SaveSynEdit(synEdit : TSynEdit);
    function FindTextInSynEdit(AString: String; StartPos: Integer): Integer;
    procedure FindNext;
    procedure DeleteListBoxObjects;
    procedure AddFileNameToListBox(FileName : String);
    procedure PrepareOpenedFile(aMemo : TMemo; aFileName : String);
    function SynEditCaretPosition : String;
    procedure AddToMruMenu;
    procedure MenuItemMRUItemClick(Sender: TObject);
    procedure GetMruList;
    procedure ParseDroppedFiles(FileNames: array of string);
    function GetTrvNodePath(aText : String) : String;
    procedure PrintSynEdit(synEdit : TSynEdit);
    function mm2px(mm: Double; ppi: Integer): Integer;

  public
    Logging : TLog_File;
    Visual  : TVisual;
    lbSort : TListBox;
  end;

var
  FrmMain: TFrmMain;
  SetMan  : TSettingsManager;
  AllFileNames :  AllFileObjects;

const
  SearchStart : Integer = 0;
  SearchStr   : string = '';
  NumberOfRecentFiles : Integer = 10;

implementation

uses ApplicationEnvironment, JsonFormatter, TreeviewUtils;

{$R *.lfm}

{ TFrmMain }

{%region sort function}
function CompareAscending(List: TStringList; Index1, Index2: Integer
  ): Integer;
begin
  result := CompareStr(List[Index1], List[Index2])
end;

function CompareDescending(List: TStringList; Index1, Index2: Integer
  ): Integer;
begin
  result := CompareStr(List[Index1], List[Index2]) * -1
end;

{%endregion sort function}

procedure TFrmMain.MenuItemProgramOpenFileClick(Sender: TObject);
var
  OpenFileDlg : TOpenDialog;
  Memo : TMemo;
begin
  Screen.Cursor := crHourGlass;

  TreeViewJsonItems.Selected := nil;
  Memo := TMemo.Create(Self);
  OpenFileDlg := TOpenDialog.Create(Self);
  //OpenFileDlg.InitialDir := ...
  OpenFileDlg.Filter := 'Json file|*.json||Text file|*.txt';
  OpenFileDlg.Title := rsOpenFileDlgTitle;

  if OpenFileDlg.Execute then
    begin
      Memo.Lines.LoadFromFile(OpenFileDlg.FileName);
      StatusBarMainFrm.Panels.Items[2].Text := rsFile + extractFilename(OpenFileDlg.FileName) + '     ';
      PrepareOpenedFile(Memo, OpenFileDlg.FileName);
    end;

  OpenFileDlg.Free;
  Memo.Free;
  Screen.Cursor := crDefault;
end;

procedure TFrmMain.MenuItemSortAscClick(Sender: TObject);
var
  sl: TStringList;
begin
  try
   ListBoxFileNames.Sorted := False;
   sl:= TStringList.Create;
   sl.Assign(ListBoxFileNames.Items);
   sl.CustomSort(@CompareAscending);
   ListBoxFileNames.Items.Assign(sl);
  finally
    sl.free;
  end;
end;

procedure TFrmMain.MenuItemSortDescClick(Sender: TObject);
var
  sl: TStringList;
begin
  try
   ListBoxFileNames.Sorted := False;
   sl:= TStringList.Create;
   sl.Assign(ListBoxFileNames.Items);
   sl.CustomSort(@CompareDescending);
   ListBoxFileNames.Items.Assign(sl);
  finally
    sl.free;
  end;
end;

procedure TFrmMain.PanelBottomMouseLeave(Sender: TObject);
begin
  SetStatusbarText('', true);
end;

procedure TFrmMain.RadioGroupSearchOptionsSelectionChanged(Sender: TObject);
var
  s : string;
begin
  SetMan.TrvOrMemoSearch := RadioGroupSearchOptions.ItemIndex;
  if  RadioGroupSearchOptions.ItemIndex = 1 then begin
    LabelSearchResult.Enabled := false;
    LabelSearchResult.Caption := '0 st.';
  end
  else begin
    if ComboBoxSearch.Text <> '' then begin            // trigger the onchage for searching
      if Assigned(ComboBoxSearch.OnChange) then begin  // Onchange works different for a combobox see: https://forum.lazarus.freepascal.org/index.php?topic=53626.0
        ComboBoxSearch.OnChange(ComboBoxSearch);

        s := ComboBoxSearch.Text;
        ComboBoxSearch.Text := '';
        ComboBoxSearch.Text := s;
      end;
    end;

    LabelSearchResult.Enabled := true;
  end;
end;

procedure TFrmMain.SynEditJsonDataChange(Sender: TObject);
var
  s : String;
begin
  s := SynEditJsonData.lines[0];
  if s = '' then begin
    if  SynEditJsonData.Lines.Count <= 1  then begin
      ButtonSave.Enabled := False;
      MenuItemJsonSave.Enabled := False;
      ButtonClear.Enabled := False;
      MenuItemJsonClear.Enabled := False;
      MenuItemJsonPrettify.Enabled := False;
      SynEditJsonData.PopupMenu := nil;
      MenuItemProgramPrint.Enabled := False;
      Separator4.Enabled := False;

      TreeViewJsonItems.Items.Clear;  // Clear the treeview when delete is pressed
    end;
  end
  else if (s <> '') or (SynEditJsonData.Lines.Count > 1) then begin
    ButtonSave.Enabled := True;
    MenuItemJsonSave.Enabled := True;
    ButtonClear.Enabled := True;
    MenuItemJsonClear.Enabled := True;
    MenuItemJsonPrettify.Enabled := True;
    SynEditJsonData.PopupMenu := PopupMenuSynEdit;
    MenuItemProgramPrint.Enabled := True;
    Separator4.Enabled := True;

    if TreeViewJsonItems.Items.Count = 0 then begin // Refill treeview when json was deleted en get back with CTRL+z
      PrettifyJson(SynEditJsonData);
    end;
  end
  else begin
    ButtonSave.Enabled := False;
    MenuItemJsonSave.Enabled := False;
    ButtonClear.Enabled := False;
    MenuItemJsonClear.Enabled := False;
    MenuItemJsonPrettify.Enabled := False;
    SynEditJsonData.PopupMenu := nil;
    MenuItemProgramPrint.Enabled := False;
    Separator4.Enabled := False;

    TreeViewJsonItems.Items.Clear;
    TreeViewJsonItems.Items.Clear;  // Clear the treeview when delete is pressed
  end;
end;

procedure TFrmMain.SynEditJsonDataKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LabelSynEditPos.Caption := SynEditCaretPosition;
end;

procedure TFrmMain.SynEditJsonDataMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LabelSynEditPos.Caption := SynEditCaretPosition;
end;

procedure TFrmMain.SynEditJsonDataPaste(Sender: TObject; var AText: String;
  var AMode: TSynSelectionMode; ALogStartPos: TPoint;
  var AnAction: TSynCopyPasteAction);
var
  s : String;
  CanPaste : Boolean;

  i, j,k  : Integer;
begin

  i := SynEditJsonData.SelStart;
  j := SynEditJsonData.SelEnd;
  k := Length(SynEditJsonData.Text);

  if (SynEditJsonData.SelStart = 1) and (SynEditJsonData.SelEnd = Length(SynEditJsonData.Text) - 1) then begin
    s := SynEditJsonData.lines[0];
    if  s = '' then begin
      if  SynEditJsonData.Lines.Count <= 1  then begin
        CanPaste := true;
      end
      else begin
        CanPaste := false;
      end;
    end
    else if (s <> '') or (SynEditJsonData.Lines.Count > 1) then begin
      CanPaste := false;
    end
    else begin
      CanPaste := false;
    end;

    if CanPaste then begin
      SynEditJsonData.LineText := AText;
      AText := '';  // Clear the pasted text.
      PrettifyJson(SynEditJsonData);
    end
    else begin
      if MessageDlg(rsWarning, rsOverwritetext,
                    mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes then begin
        SynEditJsonData.Clear;
        SynEditJsonData.LineText := AText;
        AText := '';  // Clear the pasted text.
        PrettifyJson(SynEditJsonData);
      end
      else begin
        AText := '';
      end;
    end;
  end;
end;

function TFrmMain.SynEditCaretPosition: String;
var
  x, y : Integer;
begin
  x := SynEditJsonData.CaretX;
  y := SynEditJsonData.CaretY;

  result := Format('Line: %s - col: %s', [IntToStr(y), IntToStr(x)]);
end;

procedure TFrmMain.AddToMruMenu;
var
  mi : TMenuItem;
  i, j : Integer;
begin
  if AllFileNames <> nil then begin
    MenuItemProgramMruList.Clear;

    if length(AllFileNames) <= NumberOfRecentFiles then begin
      //for i:= length(AllFileNames)-1 downto 0 do begin
      for i:= 0 to length(AllFileNames)-1 do begin
        mi := TMenuItem.Create(MenuItemProgramMruList);
        mi.Caption := AllFileNames[i].Name;
        mi.Tag := AllFileNames[i].Counter;

        mi.OnClick := @MenuItemMRUItemClick;
        MenuItemProgramMruList.Add(mi);
      end;
    end
    else begin
      for i:= length(AllFileNames)-1 downto length(AllFileNames)-NumberOfRecentFiles do begin
        mi := TMenuItem.Create(MenuItemProgramMruList);
        mi.Caption := AllFileNames[i].Name;
        mi.Tag := AllFileNames[i].Counter;

        mi.OnClick := @MenuItemMRUItemClick;
        MenuItemProgramMruList.Add(mi);
      end;
    end;

    SetMan.StoreMruList(AllFileNames);
  end;

  if MenuItemProgramMruList.Count > 0 then begin
    MenuItemProgramMruList.Enabled := True;
    MenuItemProgramMruList[0].Checked := True;  // The cliked item is allways at the top of the list. So check the first item.
  end
  else
    MenuItemProgramMruList.Enabled := False;
end;

procedure TFrmMain.MenuItemMRUItemClick(Sender: TObject);
var
  i, j : Integer;
  MenuItemCaption, FileToOpen : String;
  MenuItemTag : Integer;
  Memo : TMemo;
begin
  j := (Sender as tMenuItem).MenuIndex;

  // uncheck menu item
  for i := 0 to MenuItemProgramMruList.Count-1 do begin
    MenuItemProgramMruList[i].Checked := False;
  end;

  MenuItemCaption := (Sender as tMenuItem).Caption;
  MenuItemTag := (Sender as tMenuItem).Tag;
  Memo := TMemo.Create(nil);

  for i := 0 to length(AllFileNames) - 1 do begin
    if (MenuItemCaption = AllFileNames[i].Name) and (MenuItemTag = AllFileNames[i].Counter) then begin
      Memo.Clear;
      FileToOpen := AllFileNames[i].Location + AllFileNames[i].Name;

      if FileExists(FileToOpen) then begin
        Memo.Lines.LoadFromFile(FileToOpen);
        StatusBarMainFrm.Panels.Items[2].Text := rsFile + (Sender as tMenuItem).Caption + '     ';
        PrepareOpenedFile(Memo, FileToOpen);
        MenuItemProgramMruList[0].Checked := True;  // The cliked item is allways at the top of the list. So check the first item.
      end
      else begin
        if MessageDlg(rsWarning, rsFileDoesNotExists + sLineBreak + sLineBreak +
                      rsFile +  FileToOpen + sLineBreak + sLineBreak +
                      rsRemoveFileFromList,
                      mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes then begin
          MenuItemProgramMruList.Delete(j); // Delete menu item
          delete(AllFileNames,i,1);         // Delete from the array
          SetMan.StoreMruList(AllFileNames);
        end;
      end;

      break;
    end;
  end;

  memo.Free;
end;

procedure TFrmMain.TreeViewJsonItemsClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  if TreeViewJsonItems.Items.Count > 0 then begin
    Node := TreeViewJsonItems.Selected;
    FTreeViewItemIndex := Node.AbsoluteIndex;  // Get the index of the selected node

    // Geth the path of the selected node.
    SetStatusbarText(GetTrvNodePath(Node.GetTextPath), true);
  end;
end;

function TFrmMain.GetTrvNodePath(aText : String) : String;
var
  startPos, EndPos, sLength : Integer;
begin
  if Pos(':', aText) > 0 then begin
    StartPos := Pos(':', aText);
    if StartPos > 0 then begin
      EndPos := Pos(')/', aText) + 2;
      if EndPos > StartPos then begin
        sLength := EndPos - StartPos;
        delete(aText, StartPos, sLength);
        insert(' => ', aText, StartPos);
        Result := GetTrvNodePath(aText);
      end
      else begin
        sLength := Length(aText);
        delete(aText, StartPos, sLength);
        result := aText;
      end;
    end;
  end;
end;

procedure TFrmMain.TreeViewJsonItemsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TreeViewJsonItems.PopupMenu := nil;

  if TreeViewJsonItems.Items.Count > 0 then begin
    if Button = mbRight then begin
      TreeViewJsonItems.PopupMenu := PopupMenuTrv;
    end;
  end;
end;

procedure TFrmMain.SetStatusbarText(aText: String; overrideSetting : Boolean);
begin
  if not overrideSetting then begin
    if SetMan.DisplayHelpText then begin
      if aText <> '' then begin
        StatusBarMainFrm.Panels.Items[0].Text := ' ' + aText;
      end
      else begin
        StatusBarMainFrm.Panels.Items[0].Text := '';
      end;

      Application.ProcessMessages;
    end;
  end
  else begin
    if aText <> '' then begin
      StatusBarMainFrm.Panels.Items[0].Text := ' ' + aText;
    end
    else begin
      StatusBarMainFrm.Panels.Items[0].Text := '';
    end;

    Application.ProcessMessages;
  end;
end;

procedure TFrmMain.CheckAppEnvironment;
var
  CheckEnvironment : TApplicationEnvironment;
  BaseFolder : string;
begin
  BaseFolder :=  ExtractFilePath(Application.ExeName);

  if BaseFolder <> '' then begin//create the folders
    CheckEnvironment := TApplicationEnvironment.Create;
    CheckEnvironment.CreateFolder(BaseFolder, Settings.SettingsFolder);
    CheckEnvironment.CreateFolder(BaseFolder, Settings.LoggingFolder);

    //create the settings file
    CheckEnvironment.CreateSettingsFile(BaseFolder + Settings.SettingsFolder + PathDelim);

    CheckEnvironment.Free;
  end;
end;

procedure TFrmMain.GetMruList;
begin
  AllFileNames := SetMan.GetMruList;

  AddToMruMenu;

  if MenuItemProgramMruList.Count > 0 then begin
    MenuItemProgramMruList.Enabled := True;
  end
  else begin
    MenuItemProgramMruList.Enabled := False;
  end;
end;

procedure TFrmMain.Initialize;
var
  i : Integer;
begin
  Visual := TVisual.Create;
  Visual.AlterSystemMenu;
  Visual.Free;  // Voorlopig
  // TreeViewJsonItems.ReadOnly := True; TODO Optie van maken
  // SynEditJsonData.ReadOnly := True; TODO Optie van maken
  ButtonSave.Enabled := False;
  FrmMain.KeyPreview := True;  // Used for find next in TSynEdit. F3
  StatusBarMainFrm.Panels.Items[2].Text := '';
  ComboBoxSearch.Sorted := True;
  ComboBoxSearch.AutoCompleteText := [cbactEnabled, cbactSearchCaseSensitive];
  FFileCounter := 0;

  SplitterMainFrm1.ResizeStyle := rsLine;  // Avoid strange drawing lines while moving the splitter.

  GetMruList; // MRU list
  MenuItemProgramPrint.Enabled := False;

  // uncheck menu item
  for i := 0 to MenuItemProgramMruList.Count-1 do begin
    MenuItemProgramMruList[i].Checked := False;
  end;
end;

procedure TFrmMain.ReadSettings;
begin
  if assigned(SetMan) then SetMan.Free;
  SetMan := TSettingsManager.Create();

  if SetMan.SetTreeViewHotTrack then begin
    TreeViewJsonItems.HotTrack := True;
  end
  else begin
    TreeViewJsonItems.HotTrack := False;
  end;

  SynJScriptSynJson.StringAttri.Foreground := SetMan.StringAttribColor;
  SynJScriptSynJson.SymbolAttri.Foreground := SetMan.SymbolAttribColor;
  SynJScriptSynJson.NumberAttri.Foreground := SetMan.NumberattribColor;
  SynJScriptSynJson.KeyAttri.Foreground := SetMan.KeyAttribColor;
  SynJScriptSynJson.BracketAttri.Foreground := SetMan.BracketAttribColor;
  SynJScriptSynJson.CommentAttri.Foreground := SetMan.CommentAtribColor;
  cbCaseSensitive.Checked := SetMan.CaseSensitiveSearch;
  RadioGroupSearchOptions.ItemIndex := SetMan.TrvOrMemoSearch;
end;

procedure TFrmMain.SaveSettings;
begin
  SetMan.SaveSettings;
  SetMan.StoreFormState(self);
  SetMan.StoreSplitterPos(SplitterMainFrm1);
  SetMan.StoreSplitterPos(SplitterMainFrm2);
end;

procedure TFrmMain.RestoreFormState;
begin
  SetMan.RestoreFormState(self);
  Setman.RestoreSplitterPos(SplitterMainFrm1, PanelTrv);
  Setman.RestoreSplitterPos(SplitterMainFrm2, PanelTrvTop);
end;

procedure TFrmMain.StartLogging;
begin
  Logging := TLog_File.Create();
  Logging.ActivateLogging := SetMan.ActivateLogging;
  Logging.AppendLogFile := Setman.AppendLogFile;
  Logging.StartLogging;
end;

procedure TFrmMain.MenuItemProgramCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ButtonSaveClick(Sender: TObject);
begin
  SaveSynEdit(SynEditJsonData);
end;

procedure TFrmMain.ButtonSaveMouseLeave(Sender: TObject);
begin
  SetStatusbarText(Visual.Helptext(Sender, ''), False);
end;

procedure TFrmMain.ButtonSaveMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SetStatusbarText(Visual.Helptext(Sender, rsSaveJsontext), False);
end;

procedure TFrmMain.ButtonSearchClick(Sender: TObject);
begin
  if RadioGroupSearchOptions.ItemIndex = 0 then begin
    SearchNextTrv(TreeViewJsonItems);
  end
  else begin
    FindNext;
  end;
end;

procedure TFrmMain.cbCaseSensitiveChange(Sender: TObject);
begin
  if cbCaseSensitive.Checked then begin
    SetMan.CaseSensitiveSearch := True;
  end
  else begin
    SetMan.CaseSensitiveSearch := False;
  end;

  if ComboBoxSearch.Text = '' then exit;

  if RadioGroupSearchOptions.ItemIndex = 0 then begin
    LabelSearchResult.Caption := IntToStr(GetNodeByText(TreeViewJsonItems, ComboBoxSearch.Text, cbCaseSensitive.Checked)) + ' st.';
    SearchNextTrv(TreeViewJsonItems);
  end;
end;

procedure TFrmMain.ComboBoxSearchChange(Sender: TObject);
begin
  if (TreeViewJsonItems.Items.Count = 0) or (ComboBoxSearch.Text = '') then
    exit;

  if RadioGroupSearchOptions.ItemIndex = 0 then begin
    LabelSearchResult.Caption := IntToStr(GetNodeByText(TreeViewJsonItems, ComboBoxSearch.Text, cbCaseSensitive.Checked)) + ' st.';
    SearchNextTrv(TreeViewJsonItems);
  end;
end;

procedure TFrmMain.ComboBoxSearchEnter(Sender: TObject);
begin
  FrmMain.Visual.ActiveTextBackGroundColor(TComboBox(Sender));
end;

procedure TFrmMain.ComboBoxSearchExit(Sender: TObject);
var
  CB: TComboBox;
  item: string;
  IsInList: boolean = false;
begin
  CB:= Sender as TComboBox;

  for item in CB.Items do
  begin
    IsInList:= (item = CB.Text);
    if IsInList then break;
  end;

  if not isInList
    then CB.Items.Add(CB.Text);

  // background color
  FrmMain.Visual.NotActiveTextBackGroundColor(TComboBox(Sender));
end;

procedure TFrmMain.FindNext;
begin
  if SearchStr <> ComboBoxSearch.Text then
    begin
      SearchStart := 0;
      SearchStr := ComboBoxSearch.Text;
    end;

  SearchStart := FindTextInSynEdit(SearchStr, SearchStart + 1);
end;

procedure TFrmMain.DeleteListBoxObjects;
var
  i : Integer;
begin
  for i := 0 to ListBoxFileNames.Items.Count - 1 do
    Dispose(PtrFileObject(ListBoxFileNames.Items.Objects[i]));
end;

procedure TFrmMain.AddFileNameToListBox(FileName: String);
var
  OpenedFileName, FileLocation : String;
  i, arlength : Integer;
  lbFileName, lbFileLoc : String;
  CanLoad : Boolean;
begin
  CanLoad := true;
  OpenedFileName := ExtractFileName(FileName);
  FileLocation := ExtractFilepath(FileName);

  for i := 0 to  ListBoxFileNames.Count -1 do begin
    lbFileName := PtrFileObject(ListBoxFileNames.Items.Objects[i])^.Name;
    lbFileLoc := PtrFileObject(ListBoxFileNames.Items.Objects[i])^.Location;

    if (lbFileName = OpenedFileName) and (lbFileLoc = FileLocation) then begin
      CanLoad := false;
    end;
  end;

  if CanLoad then begin
    // add object to listbox
    new(FPtrFilename);
    FPtrFilename^.Name := OpenedFileName;
    FPtrFilename^.Location := extractFilepath(FileName);
    FPtrFilename^.FileDate :=  Now;
    Inc(FFileCounter);
    FPtrFilename^.Counter := FFileCounter;

    // Check if file name and location is in the array
    for i := 0 to length(AllFileNames)-1 do begin
      lbFileName := AllFileNames[i].Name;
      lbFileLoc := AllFileNames[i].Location;
      if (lbFileName = OpenedFileName) and (lbFileLoc = extractFilepath(FileName)) then begin
        delete(AllFileNames, i,1);  // Delete the existing file from the array.
        break;
      end;
    end;

    // Add to array with file names and locations.
    arlength := length(AllFileNames) + 1;
    SetLength(AllFileNames, arlength);
    AllFileNames[arlength-1].Name := OpenedFileName;
    AllFileNames[arlength-1].Location := extractFilepath(FileName);
    AllFileNames[arlength-1].Counter := FFileCounter;
    AllFileNames[arlength-1].FileDate := Now;

    // Add to listbox.
    ListBoxFileNames.AddItem(OpenedFileName, TObject(FPtrFilename));

    // Add to MRU list
    AddToMruMenu;
  end;

  if ListBoxFileNames.Items.Count > 0 then begin
    ListBoxFileNames.PopupMenu := PopupMenuListBoxFileNames;
  end
  else begin
    ListBoxFileNames.PopupMenu := nil;
  end;
end;

procedure TFrmMain.PrepareOpenedFile(aMemo: TMemo; aFileName : String);
var
  JsonFormatter : TJsonFormatter;
begin
  if aMemo.Lines.Count > 0 then begin
    JsonFormatter := TJsonFormatter.Create();
    JsonFormatter.GetJsonTextFile(TreeViewJsonItems, StatusBarMainFrm, aMemo, SynEditJsonData);

    if JsonFormatter.JsonFormatSuccess then begin
      AddFileNameToListBox(aFileName);
      FCurrFile := ExtractFileName(aFileName);

      JsonFormatter.Free;

      TreeViewJsonItems.Selected := TreeViewJsonItems.Items.GetFirstNode;
      SynEditJsonData.SetFocus;
      SynEditJsonData.SelStart := 0;
    end
    else begin
      FCurrFile := '';
    end;

    if  SynEditJsonData.Lines.Count > 0 then begin
      ButtonSave.Enabled := True;
      SynEditJsonData.PopupMenu := PopupMenuSynEdit;
      MenuItemProgramPrint.Enabled := True;
      Separator4.Enabled := True;
    end
    else begin
      ButtonSave.Enabled := False;
      SynEditJsonData.PopupMenu := nil;
      MenuItemProgramPrint.Enabled := False;
      Separator4.Enabled := False;
    end;

  end;
end;

function TFrmMain.FindTextInSynEdit(AString: String; StartPos: Integer): Integer;
begin
  if cbCaseSensitive.Checked then begin
    Result := PosEx(AString, SynEditJsonData.Text, StartPos);
  end
  else begin
    Result := PosEx(UpperCase(AString), UpperCase(SynEditJsonData.Text), StartPos);
  end;

  if Result > 0 then begin
    SynEditJsonData.SelStart  := UTF8Length(PChar(SynEditJsonData.Text), Result);
    SynEditJsonData.SelectWord;
    SynEditJsonData.SetFocus;
    SetStatusbarText(AString + '', True);
  end
  else begin
    SetStatusbarText(AString + rsNotFound, True);
  end;
end;

procedure TFrmMain.FormClose(Sender: TObject);
begin
  // Clear search synedit vars
  SearchStr := '';
  SearchStart := 0;

  SaveSettings;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Caption := rsFormMain;

  CheckAppEnvironment;
  ReadSettings;

  if SetMan.DefaultLanguage = 'nl' then begin
    MenuItemOptionsLanguageEN.Checked := False;
    MenuItemOptionsLanguageNL.Checked := True;
    SetDefaultLang('nl');

  end
  else begin
    MenuItemOptionsLanguageEN.Checked := True;
    MenuItemOptionsLanguageNL.Checked := False;
    SetDefaultLang('en');
  end;

  StartLogging;
  Initialize;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  DeleteListBoxObjects;
  Logging.StopLogging;
  Logging.Free;
  SetMan.Free;
end;

procedure TFrmMain.FormDropFiles(Sender: TObject;
  const FileNames: array of string);
var
  s : String;
  CanDrop : Boolean;
begin
  Screen.Cursor := crHourGlass;

  s := SynEditJsonData.lines[0];
  if  s = '' then begin
    if  SynEditJsonData.Lines.Count <= 1  then begin
      CanDrop := true;
    end
    else begin
      CanDrop := false;
    end;
  end
  else if (s <> '') or (SynEditJsonData.Lines.Count > 1) then begin
    CanDrop := false;
  end
  else begin
    CanDrop := false;
  end;

  if CanDrop then begin
    ParseDroppedFiles(FileNames);
  end
  else begin
    if MessageDlg(rsWarning, rsOverwritetext,
                  mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes then begin
      ParseDroppedFiles(FileNames);
    end;
  end;

  Screen.Cursor := crDefault;
end;

procedure TFrmMain.ParseDroppedFiles(FileNames: array of string);
var
  i: Integer;
  Memo : TMemo;
  JsonFormatter : TJsonFormatter;
begin
  for i := Low(FileNames) to High(FileNames) do begin
    TreeViewJsonItems.Selected := nil;
    Memo := TMemo.Create(Self);
    Memo.Lines.LoadFromFile(FileNames[i]);

    if Memo.Lines.Count > 0 then begin
      JsonFormatter := TJsonFormatter.Create();
      JsonFormatter.GetJsonTextFile(TreeViewJsonItems, StatusBarMainFrm, Memo, SynEditJsonData);

      if JsonFormatter.JsonFormatSuccess then begin
        AddToMruMenu;
        AddFileNameToListBox(FileNames[i]);

        FCurrFile := ExtractFileName(FileNames[i]);
        StatusBarMainFrm.Panels.Items[2].Text := rsFile + extractFilename(FileNames[i]) + '     ';

        TreeViewJsonItems.Selected := TreeViewJsonItems.Items.GetFirstNode;
        SynEditJsonData.SetFocus;
        SynEditJsonData.SelStart := 0;
      end
      else begin
        FCurrFile := '';
      end;

      if  SynEditJsonData.Lines.Count > 0 then begin
        ButtonSave.Enabled := True;
        SynEditJsonData.PopupMenu := PopupMenuSynEdit;
        MenuItemProgramPrint.Enabled := True;
        Separator4.Enabled := True;
      end
      else begin
        ButtonSave.Enabled := False;
        SynEditJsonData.PopupMenu := nil;
        MenuItemProgramPrint.Enabled := False;
        Separator4.Enabled := False;
      end;

      JsonFormatter.Free;
      Memo.Free;
    end;
  end;
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 114) and (ComboBoxSearch.Text <> '') then begin  // 114 = F3
    if RadioGroupSearchOptions.ItemIndex = 0 then begin
      SearchNextTrv(TreeViewJsonItems);
    end
    else begin
      FindNext;
    end;
  end
  else if (ssCtrl in Shift) and (Key = ord('F')) then begin
    activecontrol := ComboBoxSearch;
  end;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  RestoreFormState();
end;

procedure TFrmMain.ListBoxFileNamesClick(Sender: TObject);
var
  aFileName, aFileLocation, FileToOpen : String;
  i : Integer;
  Memo : TMemo;
begin
   if ListBoxFileNames.ItemIndex > -1 then begin
     FPtrFilename := PtrFileObject(ListBoxFileNames.Items.Objects[ ListBoxFileNames.ItemIndex ]);
     aFileName := FPtrFilename^.Name;
     aFileLocation := FPtrFilename^.Location;
     Memo := TMemo.Create(Self);

     for i := 0 to length(AllFileNames) - 1 do begin
       if (aFileName = AllFileNames[i].Name) and (aFileLocation = AllFileNames[i].Location) then begin
         FileToOpen := aFileLocation + aFileName;
         Memo.Lines.LoadFromFile(FileToOpen);

         StatusBarMainFrm.Panels.Items[2].Text := rsFile + extractFilename(FileToOpen) + '     ';

         PrepareOpenedFile(Memo, FileToOpen);
         break;
       end;
     end;

     Memo.Free;
   end;
end;

procedure TFrmMain.ListBoxFileNamesMouseLeave(Sender: TObject);
begin
  SetStatusbarText('', true);
end;

procedure TFrmMain.ListBoxFileNamesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer;
  p: TPoint;
begin
  if ListBoxFileNames.ItemIndex > -1 then begin
    p.x := x;
    p.y := y;
    i := ListBoxFileNames.ItemAtPos(P, True);

    if i > -1 then begin
      FPtrFilename := PtrFileObject(ListBoxFileNames.Items.Objects[ i ]);
      SetStatusbarText(FPtrFilename^.Location + FPtrFilename^.Name, true);
    end
    else begin
      SetStatusbarText('', true);
    end;
  end;
end;

procedure TFrmMain.PrintSynEdit(synEdit : TSynEdit);
var
  printDialog: TPrintDialog;
  i, yline : Integer;
  pageWidth: Integer;
  pageHeight: Integer;
  leftMargin: Integer;
  topMargin: Integer;
  h: Integer;
  R: TRect;
  s: String = '';
  dist: Integer;
  fd: TFontData;
begin
  printDialog := TPrintDialog.Create(nil);
  try
    if printDialog.Execute then
    begin
      SetStatusbarText(rsPrinting, true);
      screen.Cursor := crHourglass;
      Printer.BeginDoc;
      try
        if FCurrFile <> '' then begin
          //The print job title, which will show up in the printer queue dialog.
          Printer.Title := 'JsonViewer - ' + FCurrFile;
        end;
        // Calculate margins and printable pagesize in printer resolution
        leftMargin := mm2px(SetMan.PrintLeftMargin, Printer.XDPI);
        topMargin := mm2px(SetMan.PrintTopMargin, Printer.YDPI);
        pageWidth := Printer.PageWidth - leftMargin - mm2px(SetMan.PrintRightMargin, Printer.XDPI);
        pageHeight := Printer.PageHeight - topMargin - mm2px(SetMan.PrintBottomMargin, Printer.YDPI);
        // Assign the memo font to the printer.
        Printer.Canvas.Font.Assign(synEdit.Font);
        // Special treatment for the default font size:
        if synEdit.Font.Size = 0 then
        begin
          // Use GetFontData to determine the font height in the memo, at screen resolution
          fd := GetFontData(synEdit.Font.Reference.Handle);
          // fd.Height tells us the height of the font in screen pixels.
          // Calculate the font size in pts from fd.Height: 1pt = 1/72 inch
          // and assign this to the printer's Font.Size which automatically converts
          // to the printer resolution
          Printer.Canvas.Font.Size := round(abs(fd.Height) / synEdit.Font.PixelsPerInch * 72);

          // or:
          // convert fd.Height to inches (value / screen ppi) and multiply by the
          // printer's ppi to get the height in printer pixels.
          // Assign this to the printer's Font.Height (rather than Font.Size).
          // And note that there is a convention that Font.Height should be
          // a negative value because it is measured in pixels.
          //Printer.canvas.Font.Height := -round(abs(fd.Height) / Memo1.Font.PixelsPerInch * Printer.YDPI);
        end;

        // Calculate the extra spacing between paragraphs
        dist := Printer.Canvas.TextHeight('Tg') div 2;

        // Iterate over all (non-wrapped) lines of the memo.
        yLine := 0;
        for I := 0 to synEdit.Lines.Count - 1 do
        begin
          // Extract the text in a paragraph.
          s := synEdit.Lines[I];
          // Calculate the rectangle which encloses the word-wrapped paragraph
          R := Rect(0, 0, pageWidth, 0);
          DrawText(Printer.Canvas.Handle, PChar(s), Length(s), R, DT_WORDBREAK or DT_CALCRECT);
          // h is the height of the printed paragraph plus some spacing between
          // paragraphs.
          h := R.Bottom - R.Top + dist;
          // If the full paragraph does not fit on the current page, we must
          // generate a page-break.
          if yLine + h > pageHeight then
          begin
            yLine := 0;
            Printer.NewPage;
          end;
          // Print the word-wrapped paragraph
          OffsetRect(R, leftMargin, topmargin + yLine);
          DrawText(Printer.Canvas.Handle, PChar(s), Length(s), R, DT_WORDBREAK);
          // Advance the y position to the next paragraph.
          yLine := yLine + h;
        end;
      finally
        Printer.EndDoc;
        SetStatusbarText('', true);
        screen.Cursor := crDefault;
      end;
    end;
  finally
    printDialog.Free;
  end;
end;

function TFrmMain.mm2px(mm: Double; ppi: Integer): Integer;
begin
  // Converts millimeters to pixels for the specified resolution, given in
  // pixels per inch (ppi).
  Result := round(mm/25.4 * ppi);
end;

procedure TFrmMain.MenuItemPrintClick(Sender: TObject);
begin
  PrintSynEdit(SynEditJsonData);
end;

procedure TFrmMain.MenuItemProgramPrintClick(Sender: TObject);
begin
  PrintSynEdit(SynEditJsonData);
end;

procedure TFrmMain.MenuItemSelectAllClick(Sender: TObject);
begin
  SynEditJsonData.SelectAll;
end;

procedure TFrmMain.MenuItemCollapseSelectedNodeClick(Sender: TObject);
begin
  if FTreeViewItemIndex >= 0 then begin
    if TreeViewJsonItems.items[FTreeViewItemIndex] <> nil then
  TreeViewJsonItems.items[FTreeViewItemIndex].Collapse(True);
  end;
end;

procedure TFrmMain.MenuItemCollapseAllClick(Sender: TObject);
begin
  TreeViewJsonItems.FullCollapse;
end;

procedure TFrmMain.MenuItemExpandAllClick(Sender: TObject);
begin
  TreeViewJsonItems.FullExpand;
end;

procedure TFrmMain.MenuItemExpandSelectedNodeClick(Sender: TObject);
begin
  if FTreeViewItemIndex >= 0 then begin
    if TreeViewJsonItems.items[FTreeViewItemIndex] <> nil then
  TreeViewJsonItems.items[FTreeViewItemIndex].Expand(True);
  end;
end;

procedure TFrmMain.MenuItemJsonClearClick(Sender: TObject);
begin
  ClearData(SynEditJsonData);
end;

procedure TFrmMain.MenuItemJsonPrettifyClick(Sender: TObject);
begin
  PrettifyJson(SynEditJsonData);
end;

procedure TFrmMain.MenuItemJsonSaveClick(Sender: TObject);
begin
  SaveSynEdit(SynEditJsonData);
end;

procedure TFrmMain.MenuItemOptionsConfigureClick(Sender: TObject);
var
  frm : TFrm_Configure;
  ActivateLogging : Boolean;
begin
  ActivateLogging := SetMan.ActivateLogging;
  SetMan.SaveSettings;
  frm := TFrm_Configure.Create(Self);

  try
    //if DebugMode then Logging.WriteToLogDebug('Openen configuratie scherm.');
    frm.ShowModal;
  finally
    frm.Free;
    ReadSettings();

    //if DebugMode then Logging.WriteToLogDebug('Sluiten configuratie scherm.');

    if (SetMan.ActivateLogging) and not ActivateLogging then begin
      Logging.Free;
      StartLogging();
    end;
  end;
end;

procedure TFrmMain.MenuItemOptionsLanguageENClick(Sender: TObject);
begin
  MenuItemOptionsLanguageEN.Checked := True;
  MenuItemOptionsLanguageNL.Checked := False;
  SetDefaultLang('en');
  SetMan.DefaultLanguage := 'en';
  {%H-}GetLocaleFormatSettings($409, DefaultFormatSettings);{%H+}  // Supress warning, it will be Windows only.

  SetMan.SaveSettings;
  Application.ProcessMessages;
end;

procedure TFrmMain.MenuItemOptionsLanguageNLClick(Sender: TObject);
begin
  MenuItemOptionsLanguageEN.Checked := False;
  MenuItemOptionsLanguageNL.Checked := True;
  SetDefaultLang('nl');
  SetMan.DefaultLanguage := 'nl';
  {%H-}GetLocaleFormatSettings($413, DefaultFormatSettings);{%H+}

  SetMan.SaveSettings;
  Application.ProcessMessages;
end;

procedure TFrmMain.PrettifyJson(synEdit : TSynEdit);
var
  Memo : TMemo;
  JsonFormatter : TJsonFormatter;
begin
  Screen.Cursor := crHourGlass;

  TreeViewJsonItems.Selected := nil;

  try
    Memo := TMemo.Create(Self);
    Memo.Lines := synEdit.Lines;

    if Memo.Lines.Count > 0 then begin
      JsonFormatter := TJsonFormatter.Create();
      JsonFormatter.GetJsonTextFile(TreeViewJsonItems, StatusBarMainFrm, Memo, synEdit);
      JsonFormatter.Free;
      Memo.Free;

      TreeViewJsonItems.Selected := TreeViewJsonItems.Items.GetFirstNode;
      synEdit.SetFocus;
      synEdit.SelStart := 0;
    end;
  except
    on E : Exception do begin
      FrmMain.Logging.WriteToLogError('');
      FrmMain.Logging.WriteToLogError(rsMessage);
      FrmMain.Logging.WriteToLogError(E.Message);
      // never gets here.
      StatusBarMainFrm.Panels.Items[2].Text := '';
    end
  end;

  Screen.Cursor := crDefault;
end;

procedure TFrmMain.ClearData(synEdit: TSynEdit);
begin
  TreeViewJsonItems.Items.Clear;
  synEdit.Clear;
  LabelSearchResult.Caption := '0 st.';
  StatusBarMainFrm.Panels.Items[2].Text := '';
  ButtonSave.Enabled := False;
  SynEditJsonData.PopupMenu := nil;
  MenuItemProgramPrint.Enabled := False;
  Separator4.Enabled := False;
  LabelSynEditPos.Caption := 'Line: 1 - col: 1';

end;

procedure TFrmMain.SaveSynEdit(synEdit: TSynEdit);
var
  dlg : TSaveDialog;
begin
  if synEdit.Lines.Count <= 0 then exit;

  Screen.Cursor := crHourGlass;
  dlg := TSaveDialog.Create(nil);
  try
   dlg.Title := rsSaveAsJsonFile;
   dlg.InitialDir := GetCurrentDir;
   dlg.Filter := 'Json file|*.json|Text file|*.txt';
   dlg.DefaultExt := 'json';
   dlg.FilterIndex := 0;

   if dlg.Execute then begin
     Screen.Cursor := crHourGlass;
     SetStatusbarText(rsSaving, True);
     synEdit.Lines.SaveToFile(dlg.FileName);
     SetStatusbarText(rsReady, True);
     StatusBarMainFrm.Panels.Items[2].Text := rsFile + extractFilename(dlg.FileName) + '     ';
     AddFileNameToListBox(dlg.FileName);
     AddToMruMenu;
   end;
  finally
    dlg.Free;
    Screen.Cursor := crDefault;
    SetStatusbarText('', True);
  end;
end;

procedure TFrmMain.ButtonPrettifyMouseLeave(Sender: TObject);
begin
  SetStatusbarText(Visual.Helptext(Sender, ''), False);
end;

procedure TFrmMain.ButtonPrettifyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  SetStatusbarText(Visual.Helptext(Sender, rsFormatjsonText), False);
end;

procedure TFrmMain.ButtonClearClick(Sender: TObject);
begin
  ClearData(SynEditJsonData);
end;



procedure TFrmMain.Button1Click(Sender: TObject);
const
  LEFT_MARGIN = 20;   // mm
  RIGHT_MARGIN = 20;  // mm
  TOP_MARGIN = 20;    // mm
  BOTTOM_MARGIN = 20; // mm
var
  printDialog: TPrintDialog;
  i, yline : Integer;
  pageWidth: Integer;
  pageHeight: Integer;
  leftMargin: Integer;
  topMargin: Integer;
  h: Integer;
  R: TRect;
  s: String = '';
  hasWordWrap: Boolean;
  dist: Integer;
  fd: TFontData;
begin


  printDialog := TPrintDialog.Create(nil);
  try
    if printDialog.Execute then
    begin
//      hasWordWrap := SynEditJsonData.WordWrap;
      // Because word-wrapping will be different in the print-out than on the
      // screen we turn the memo's WordWrap property off. Now Memo.Lines[i]
      // indicate the individual paragraphs in the text.
//      SynEditJsonData.WordWrap := false;
      Printer.BeginDoc;
      try
        //if
        Printer.Title := 'JsonViewer'; // The print job title, which will show up in the printer queue dialog.
        // Calculate margins and printable pagesize in printer resolution
        leftMargin := mm2px(LEFT_MARGIN, Printer.XDPI);
        topMargin := mm2px(TOP_MARGIN, Printer.YDPI);
        pageWidth := Printer.PageWidth - leftMargin - mm2px(RIGHT_MARGIN, Printer.XDPI);
        pageHeight := Printer.PageHeight - topMargin - mm2px(BOTTOM_MARGIN, Printer.YDPI);
        // Assign the memo font to the printer.
        Printer.Canvas.Font.Assign(SynEditJsonData.Font);
        // Special treatment for the default font size:
        if SynEditJsonData.Font.Size = 0 then
        begin
          // Use GetFontData to determine the font height in the memo, at screen resolution
          fd := GetFontData(SynEditJsonData.Font.Reference.Handle);
          // fd.Height tells us the height of the font in screen pixels.
          // Calculate the font size in pts from fd.Height: 1pt = 1/72 inch
          // and assign this to the printer's Font.Size which automatically converts
          // to the printer resolution
          Printer.Canvas.Font.Size := round(abs(fd.Height) / SynEditJsonData.Font.PixelsPerInch * 72);

          // or:
          // convert fd.Height to inches (value / screen ppi) and multiply by the
          // printer's ppi to get the height in printer pixels.
          // Assign this to the printer's Font.Height (rather than Font.Size).
          // And note that there is a convention that Font.Height should be
          // a negative value because it is measured in pixels.
          //Printer.canvas.Font.Height := -round(abs(fd.Height) / Memo1.Font.PixelsPerInch * Printer.YDPI);
        end;

        // Calculate the extra spacing between paragraphs
        dist := Printer.Canvas.TextHeight('Tg') div 2;

        // Iterate over all (non-wrapped) lines of the memo.
        yLine := 0;
        for I := 0 to SynEditJsonData.Lines.Count - 1 do
        begin
          // Extract the text in a paragraph.
          s := SynEditJsonData.Lines[I];
          // Calculate the rectangle which encloses the word-wrapped paragraph
          R := Rect(0, 0, pageWidth, 0);
          DrawText(Printer.Canvas.Handle, PChar(s), Length(s), R, DT_WORDBREAK or DT_CALCRECT);
          // h is the height of the printed paragraph plus some spacing between
          // paragraphs.
          h := R.Bottom - R.Top + dist;
          // If the full paragraph does not fit on the current page, we must
          // generate a page-break.
          if yLine + h > pageHeight then
          begin
            yLine := 0;
            Printer.NewPage;
          end;
          // Print the word-wrapped paragraph
          OffsetRect(R, leftMargin, topmargin + yLine);
          DrawText(Printer.Canvas.Handle, PChar(s), Length(s), R, DT_WORDBREAK);
          // Advance the y position to the next paragraph.
          yLine := yLine + h;
        end;
      finally
        Printer.EndDoc;
        // Restore the WordWrap of the memo.
//        SynEditJsonData.WordWrap := hasWordWrap;
      end;
    end;
  finally
    printDialog.Free;
  end;
end;

procedure TFrmMain.ButtonClearMouseLeave(Sender: TObject);
begin
  SetStatusbarText(Visual.Helptext(Sender, ''), False);
end;

procedure TFrmMain.ButtonClearMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SetStatusbarText(Visual.Helptext(Sender, rsClearTrvAndMemo), False);
end;

procedure TFrmMain.ButtonCloseMouseLeave(Sender: TObject);
begin
  SetStatusbarText(Visual.Helptext(Sender, ''), False);
end;

procedure TFrmMain.ButtonCloseMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    SetStatusbarText(Visual.Helptext(Sender, rsCloseProgram), False);
end;

end.

