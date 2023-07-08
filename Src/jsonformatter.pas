unit JsonFormatter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, ComCtrls, fpjson, StdCtrls, Dialogs, SynEdit,
  ResourceStrings;

type

  { TJsonFormatter }

  TJsonFormatter = class(TObject)
    private
      Trv: TTreeView;
      FieldNames : array of String;
      FJsonFormatSuccess : Boolean;

      procedure ShowJSONData(AParent : TTreeNode; Data : TJSONData);
      function FormatJsonData(json : TJSONData) : String;
      procedure ExpandTreeNodes(Nodes: TTreeNodes; Level: Integer);

    public
      constructor Create; overload;
      procedure GetJsonTextFile(aTrv : TTreeView; StatusBar : TStatusBar; SourceMemo: TMemo; DestMemo : TSynEdit);

      property JsonFormatSuccess : Boolean Read FJsonFormatSuccess Write FJsonFormatSuccess;
  end;

type

  { TJSONFloat4Number }

  TJSONFloat4Number = class(TJSONFloatNumber)
  protected
    function GetAsString: TJSONStringType; override;
  end;


Resourcestring
  SEmpty   = 'Empty document';
  SArray   = 'Array (%d elements)';
  SObject  = 'Object (%d members)';
  SNull    = 'null';

implementation

uses Form_Main;

{ TJSONFloat4Number }

function TJSONFloat4Number.GetAsString: TJSONStringType;
var
  F: TJSONFloat;
  fs: TFormatSettings;
begin
  fs := DefaultFormatSettings;
  fs.DecimalSeparator := '.';
  F := GetAsFloat;
  Result := FormatFloat('0.0###############', F, fs); // format with your preferences
end;

{ TJsonFormatter }

procedure TJsonFormatter.ShowJSONData(AParent: TTreeNode; Data: TJSONData);
var
  Node_1 , Node_2 : TTreeNode;
  I : Integer;
  JsonData : TJSONData;
  aString : String;
  Strlist : TStringList;
begin
  if AParent <> Nil then
    Node_1 := AParent
  else
    Node_1 := Trv.Items.AddChild(AParent,'');

  Case Data.JSONType of
    jtArray, jtObject:
    begin
      If (Data.JSONType=jtArray) then
        aString := SArray
      else
        aString := SObject;

      aString := Format(aString,[Data.Count]); // format the string, add number of objects
      Strlist := TstringList.Create;

      try
        For I := 0 to Data.Count - 1 do
          If Data.JSONtype = jtArray then begin
            Strlist.AddObject(IntToStr(I),Data.items[i]);
          end
          else begin
            Strlist.AddObject(TJSONObject(Data).Names[i],Data.items[i]);
            //FrmMain.Logging.WriteToLogAndFlushDebug(Strlist[i] + ': ');  // Write field names  moet naar een tstringlist

            SetLength(FieldNames, Length(FieldNames)+1);
            FieldNames[Length(FieldNames)-1] := Strlist[i];
          end;
        //S.Sort;

        For I := 0 to Strlist.Count - 1 do begin
          Node_2 := Trv.Items.AddChild(Node_1 , Strlist[i]);
          JsonData := TJSONData(Strlist.Objects[i]);

          //Node_2.ImageIndex := ImageTypeMap[JsonData.JSONType];
          //Node_2.SelectedIndex := ImageTypeMap[JsonData.JSONType];
          ShowJSONData(Node_2 , JsonData);

          if Strlist.Objects[i].ToString = 'TJSONString' then begin
            //FrmMain.Logging.WriteToLogAndFlushDebug(Strlist[i]);

            SetLength(FieldNames, Length(FieldNames)+1);
            FieldNames[Length(FieldNames)-1] := Strlist[i];
          end;
        end
      finally
        Strlist.Free;
      end;
    end;

      jtNull:
      aString := SNull;
    else
      aString := Data.AsString;
    // if Options.FQuoteStrings and  (Data.JSONType=jtString) then
      aString := '"' + aString + '"';
    end;  // end case

  If Assigned(Node_1) then begin
    If Node_1.Text = '' then
      Node_1.Text := aString
    else
      Node_1.Text := Node_1.Text+': '+ aString;
  end;
end;

function TJsonFormatter.FormatJsonData(json: TJSONData): String;
var
  s : String;
begin
  s :=   json.FormatJSON;
  result := s; //json.FormatJSON;  // "pretty print"
end;

procedure TJsonFormatter.ExpandTreeNodes(Nodes: TTreeNodes; Level: Integer);
var
  I: Integer;
begin
  Nodes.BeginUpdate;
    try
      for I := 0 to Nodes.Count - 1 do
        if Nodes[I].Level < Level then
          Nodes[I].Expand(False);
    finally
      Nodes.EndUpdate;
    end;
end;

constructor TJsonFormatter.Create;
begin
  inherited;
  SetJSONInstanceType(jitNumberFloat, TJSONFloat4Number); // Format numbers in the json: https://wiki.freepascal.org/fcl-json
end;

procedure TJsonFormatter.GetJsonTextFile(aTrv: TTreeView;
  StatusBar: TStatusBar; SourceMemo: TMemo; DestMemo: TSynEdit);
var
  JsonText : string;
  jData : TJSONData;
  Node: TTreeNode;
  _StatusBar : TStatusBar;
  _memo : TMemo;
begin
  if StatusBar is TStatusBar then begin
    _StatusBar := TStatusBar(StatusBar);
  end;

  _StatusBar.Panels.Items[0].Text := rsBussyFormatingJson;
  Application.ProcessMessages;
  aTrv.BeginUpdate;

  try
    try
      JsonFormatSuccess := true;  // TODO; maak constructor waar dit in komt te staan.
      JsonText := SourceMemo.Text;
      SourceMemo.Clear;
      jData  := GetJSON(JsonText);
      DestMemo.Clear;

      aTrv.Items.Clear;
      aTrv.Items.Add (nil,'Root Node');
      Node := aTrv.Items[0];
      Trv :=  aTrv;

      ShowJSONData(Node,jData);
      _memo := TMemo.Create(nil);
      _memo.Lines.Add(FormatJsonData(jData));

      DestMemo.Lines := _memo.Lines;
      _memo.Free;
      jData.Free;
    except
      on E : Exception do begin
        JsonFormatSuccess:= False;
        FrmMain.Logging.WriteToLogError('');
        FrmMain.Logging.WriteToLogError(rsMessage);
        FrmMain.Logging.WriteToLogError(E.Message);
        messageDlg(rsError, rsFormatJsonFailed + sLineBreak +
                            '' + sLineBreak +
                            rsErrorMessage + sLineBreak +
                            E.Message,
                    mtError, [mbOK],0);
        _StatusBar.Panels.Items[2].Text := '';
      end
    end;
  finally
    ExpandTreeNodes(aTrv.Items, 2);  // Expand the first level of the treeview
    aTrv.EndUpdate;
    _StatusBar.Panels.Items[0].Text := '';
    Application.ProcessMessages;
  end;
end;

end.

