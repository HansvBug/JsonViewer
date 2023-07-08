unit FormConfigure;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, SynEdit, SynHighlighterJScript,
  ResourceStrings, SettingsManager, Visual;

type

  { TFrm_Configure }

  TFrm_Configure = class(TForm)
    ButtonClose: TButton;
    CheckBoxTrvHotTrack: TCheckBox;
    CheckBoxActivateLogging: TCheckBox;
    CheckBoxAppendLogFile: TCheckBox;
    CheckBoxDisplayHelpText: TCheckBox;
    ColorButtonStringAttib: TColorButton;
    ColorButtonSymbolAttib: TColorButton;
    ColorButtonNumberAttib: TColorButton;
    ColorButtonKeyAttib: TColorButton;
    ColorButtonBracketAttib: TColorButton;
    ColorButtonCommentAttib: TColorButton;
    GroupBox1: TGroupBox;
    GroupBoxDivers: TGroupBox;
    GroupBoxLogging: TGroupBox;
    LabelStringAttrib: TLabel;
    LabelStatus: TLabel;
    LabelStringAttrib1: TLabel;
    LabelStringAttrib2: TLabel;
    LabelStringAttrib3: TLabel;
    LabelStringAttrib4: TLabel;
    LabelStringAttrib5: TLabel;
    SynEdit1: TSynEdit;
    SynJScriptSynConfig: TSynJScriptSyn;
    procedure ButtonCloseClick(Sender: TObject);
    procedure CheckBoxActivateLoggingChange(Sender: TObject);
    procedure CheckBoxActivateLoggingMouseLeave(Sender: TObject);
    procedure CheckBoxActivateLoggingMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxAppendLogFileMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxDisplayHelpTextChange(Sender: TObject);
    procedure CheckBoxDisplayHelpTextMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxTrvHotTrackMouseLeave(Sender: TObject);
    procedure CheckBoxTrvHotTrackMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ColorButtonBracketAttibColorChanged(Sender: TObject);
    procedure ColorButtonCommentAttibColorChanged(Sender: TObject);
    procedure ColorButtonKeyAttibColorChanged(Sender: TObject);
    procedure ColorButtonNumberAttibColorChanged(Sender: TObject);
    procedure ColorButtonStringAttibColorChanged(Sender: TObject);
    procedure ColorButtonSymbolAttibColorChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    SetMan : TSettingsManager;
    Visual : TVisual;

    procedure ReadSettings;
    procedure RestoreFormState;
    procedure SaveSettings;
    procedure SetStatusLabelText(aText : String);

  public

  end;

var
  Frm_Configure: TFrm_Configure;

implementation

{$R *.lfm}

uses Form_Main;

{ TFrm_Configure }

procedure TFrm_Configure.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Configure.CheckBoxActivateLoggingChange(Sender: TObject);
begin
  if CheckBoxActivateLogging.Checked then begin
    CheckBoxAppendLogFile.Enabled := True;
  end
  else begin
    CheckBoxAppendLogFile.Enabled := False;
    CheckBoxAppendLogFile.Checked := False;
  end;
end;

procedure TFrm_Configure.CheckBoxActivateLoggingMouseLeave(Sender: TObject);
begin
  SetStatusLabelText(Visual.Helptext(Sender, ''));
end;

procedure TFrm_Configure.CheckBoxActivateLoggingMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetStatusLabelText(Visual.Helptext(Sender, rsActivateLogging));
end;

procedure TFrm_Configure.CheckBoxAppendLogFileMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetStatusLabelText(Visual.Helptext(Sender, rsAppendLogFile));
end;

procedure TFrm_Configure.CheckBoxDisplayHelpTextChange(Sender: TObject);
begin
  SaveSettings;
  ReadSettings;
  if not CheckBoxDisplayHelpText.Checked then begin
    LabelStatus.Caption := '';
  end;
end;

procedure TFrm_Configure.CheckBoxDisplayHelpTextMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetStatusLabelText(Visual.Helptext(Sender, rsShowHelpText));
end;

procedure TFrm_Configure.CheckBoxTrvHotTrackMouseLeave(Sender: TObject);
begin
  SetStatusLabelText(Visual.Helptext(Sender, ''));
end;

procedure TFrm_Configure.CheckBoxTrvHotTrackMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetStatusLabelText(Visual.Helptext(Sender, rsHighLightTrvNode));
end;

procedure TFrm_Configure.ColorButtonBracketAttibColorChanged(Sender: TObject);
begin
  SynJScriptSynConfig.BracketAttri.Foreground := ColorButtonBracketAttib.ButtonColor;
end;

procedure TFrm_Configure.ColorButtonCommentAttibColorChanged(Sender: TObject);
begin
  SynJScriptSynConfig.CommentAttri.Foreground := ColorButtonCommentAttib.ButtonColor;
end;

procedure TFrm_Configure.ColorButtonKeyAttibColorChanged(Sender: TObject);
begin
 SynJScriptSynConfig.KeyAttri.Foreground := ColorButtonKeyAttib.ButtonColor;
end;

procedure TFrm_Configure.ColorButtonNumberAttibColorChanged(Sender: TObject);
begin
  SynJScriptSynConfig.NumberAttri.Foreground := ColorButtonNumberAttib.ButtonColor;
end;

procedure TFrm_Configure.ColorButtonStringAttibColorChanged(Sender: TObject);
begin
  SynJScriptSynConfig.StringAttri.Foreground := ColorButtonStringAttib.ButtonColor;
end;

procedure TFrm_Configure.ColorButtonSymbolAttibColorChanged(Sender: TObject);
begin
  SynJScriptSynConfig.SymbolAttri.Foreground := ColorButtonSymbolAttib.ButtonColor;
end;

procedure TFrm_Configure.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SaveSettings;
  Visual.Free;
  SetMan.Free;
  CloseAction := caFree;
end;

procedure TFrm_Configure.FormCreate(Sender: TObject);
begin
  SetMan := TSettingsManager.Create;
  Caption := rsFormConfigure;
  ReadSettings;
  Visual := TVisual.Create;
end;

procedure TFrm_Configure.FormShow(Sender: TObject);
begin
  RestoreFormState;
end;

procedure TFrm_Configure.ReadSettings;
begin
  if Setman.AppendLogFile then begin
    CheckBoxAppendLogFile.Checked := True;
  end
  else begin
    CheckBoxAppendLogFile.Checked := False;
  end;

  if SetMan.ActivateLogging then begin
    CheckBoxActivateLogging.Checked := True;
    CheckBoxActivateLogging.Enabled := True;
  end
  else begin
    CheckBoxActivateLogging.Checked := False;
    CheckBoxAppendLogFile.Checked := False;
    CheckBoxAppendLogFile.Enabled := False;
  end;

  if SetMan.SetTreeViewHotTrack then begin
      CheckBoxTrvHotTrack.Checked := True;
    end
    else begin
      CheckBoxTrvHotTrack.Checked := False;
    end;

    ColorButtonStringAttib.ButtonColor := SetMan.StringAttribColor;
    ColorButtonSymbolAttib.ButtonColor := SetMan.SymbolAttribColor;
    ColorButtonNumberAttib.ButtonColor := SetMan.NumberattribColor;
    ColorButtonKeyAttib.ButtonColor := SetMan.KeyAttribColor;
    ColorButtonBracketAttib.ButtonColor := SetMan.BracketAttribColor;
    ColorButtonCommentAttib.ButtonColor := SetMan.CommentAtribColor;

  //..add settings


  // This must always be the last option to read.
  if SetMan.DisplayHelpText then begin
    CheckBoxDisplayHelpText.Checked := True;
  end
  else begin
    CheckBoxDisplayHelpText.Checked := False;
  end;
end;

procedure TFrm_Configure.RestoreFormState;
begin
  SetMan.RestoreFormState(self);
end;

procedure TFrm_Configure.SaveSettings;
begin
  SetMan.StoreFormState(self);

  if CheckBoxActivateLogging.Checked then
    begin
      Setman.ActivateLogging := True;
      FrmMain.Logging.ActivateLogging := True;
    end
  else
    begin
      Setman.ActivateLogging := False;
      FrmMain.Logging.ActivateLogging := False;
      FrmMain.Logging.AppendLogFile := False;
    end;

  if CheckBoxAppendLogFile.Checked then
    begin
      SetMan.AppendLogFile := True;
    end
  else
    begin
      SetMan.AppendLogFile := False;
    end;

  if CheckBoxDisplayHelpText.Checked then begin
    SetMan.DisplayHelpText := True;
  end
  else begin
    SetMan.DisplayHelpText := False;
  end;

  if CheckBoxTrvHotTrack.Checked then begin
    Setman.SetTreeViewHotTrack := True;
  end
  else begin
    Setman.SetTreeViewHotTrack := False;
  end;

  SetMan.StringAttribColor := ColorButtonStringAttib.ButtonColor;
  SetMan.SymbolAttribColor := ColorButtonSymbolAttib.ButtonColor;
  SetMan.NumberattribColor := ColorButtonNumberAttib.ButtonColor;
  SetMan.KeyAttribColor := ColorButtonKeyAttib.ButtonColor;
  SetMan.BracketAttribColor := ColorButtonBracketAttib.ButtonColor;
  SetMan.CommentAtribColor := ColorButtonCommentAttib.ButtonColor;

  // ..add settings

  SetMan.SaveSettings;
end;

procedure TFrm_Configure.SetStatusLabelText(aText: String);
begin
  if SetMan.DisplayHelpText then begin
    if aText <> '' then begin
      LabelStatus.Caption := ' ' + aText;
    end
    else begin
      LabelStatus.Caption := '';
    end;

    Application.ProcessMessages;
  end;
end;

end.

