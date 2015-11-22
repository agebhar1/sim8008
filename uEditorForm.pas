unit uEditorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls, EnhCtrls, Buttons,
  uAssembler, uProcessor, uTimer, uResourceStrings, uMisc, Registry,
  SynEdit, SynEditPrint, SynEditHighlighter, SynHighlighterAsm, ImgList,
  SynEditOptionsDialog, uSynHighlighteri8008ASM;

type
  { *********** Projectfile Structure *********** }
  { 1. Processor Data                             }
  {    1.1 - Fileheader                           }
  {    1.2 - 'Halt'                               }
  {    1.3 - Stack Data                           }
  {    1.4 - RAM Data                             }
  {    1.5 - Register Data                        }
  {    1.6 - Flag Data                            }
  {    1.7 - IN Port Data                         }
  {    1.8 - OUT Port Data                        }
  {  2. Editor - 'CodeModified'                   }
  {  [3. i8008 Program, if CodeModefied is false] }
  {  4. Sourcecode                                }
  { *********** Projectfile Structure *********** }

  TSingleStepEnabledEvent = procedure(Sender: TObject; Enabled: Boolean) of object;
  TRunningEnabledEvent = procedure(Sender: TObject; Enabled: Boolean) of object;

  TPCRefreshRequestEvent = procedure(Listener: IProgramCounter) of object;

  TLoadEvent = procedure(Stream: TStream; var Check: Boolean) of object;
  TSaveEvent = procedure(Stream: TStream; var Check: Boolean) of object;

  TSupportPlugin = class;

  TEditorForm = class(TForm, IProgramCounter, ILanguage, IRegistry)
    pBottom: TPanel;
    lbError: TListBox;
    pLeft: TPanel;
    sbHide: TSpeedButton;
    pStatus: TPanel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SaveProjectDialog: TSaveDialog;
    OpenProjectDialog: TOpenDialog;
    iProject: TImage;
    iSourcecode: TImage;
    LblFilename: TFilenameLabel;
    synEditor: TSynEdit;
    synEditorPrint: TSynEditPrint;
    imglGutter: TImageList;
    PrinterSetupDialog: TPrinterSetupDialog;
    pMainBottom: TPanel;
    procedure sbHideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbErrorClick(Sender: TObject);
    procedure OnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure synEditorChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure synEditorGutterClick(Sender: TObject; Button: TMouseButton;
      X, Y, Line: Integer; Mark: TSynEditMark);
    procedure synEditorSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
  private
    _HideErrors: Boolean;
    _SizeHeight: Integer;
    _StepLine: Integer;
    _ErrorLine: Integer;
    _isSingleStep: Boolean;
    _isRunning: Boolean;
    _EnableKeys: Boolean;
    _CodeModified: Boolean;
    _BreakpointList: TBreakpointList;
    _i8008Assembler: Ti8008Assembler;
    _Program: TProgram;
    _AssembleRequest: TNotifyEvent;
    _AfterAssemble: TNotifyEvent;
    _OnSingleStepEnabled: TSingleStepEnabledEvent;
    _OnRunningEnabled: TRunningEnabledEvent;    
    _OnTimerEnabledRequest: TTimerEnabledRequestEvent;
    _OnTick: TTickEvent;
    _OnPCRefreshRequest: TPCRefreshRequestEvent;
    _OnLoadProject: TLoadEvent;
    _OnLoadProgram: TLoadEvent;
    _OnSaveProject: TSaveEvent;
    _OnSaveProgram: TSaveEvent;
    _SupportPlugin: TSupportPlugin;
    _i8008ASMSyn: Ti8008ASMSyn;
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);
    procedure PCUpdate(Sender: TObject; Value: Word);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
    procedure ErrorInsert(Sender: TObject; Index: Integer);
    procedure ErrorDelete(Sender: TObject; Index: Integer);
    procedure setErrorList(Hide: Boolean);
    function getFilename: TFilename;
    procedure Stop(ClearArrow: Boolean); overload;
    procedure goToLine(Line: Integer);
    procedure OnAfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer);
  public
    procedure Start;
    procedure Stop; overload;
    procedure SingleStep;
    function Assemble: Boolean;
    function New: Boolean;
    procedure Open(Filename: TFilename);
    function OpenFile: Boolean; overload;
    function OpenFile(Filename: TFilename): Boolean; overload;
    function OpenProject: Boolean; overload;
    function OpenProject(Filename: TFilename): Boolean; overload;
    function SaveRequest: Integer;
    procedure Save;
    function SaveFile: Boolean;
    function SaveFileAs: Boolean;
    function SaveProject: Boolean;
    function SaveProjectAs: Boolean;
    procedure Print;
    procedure ShowProgress(Value: Boolean);
    procedure LoadLanguage;
    procedure Show(ATop, ALeft, AWidth, AHeight: Integer); overload;
    property AProgram: TProgram read _Program write _Program;
    property Filename: TFilename read getFilename;
    property EnableKeys: Boolean read _EnableKeys write _EnableKeys;
    property OnAssembleRequest: TNotifyEvent read _AssembleRequest write _AssembleRequest;
    property OnSingleStepEnabled: TSingleStepEnabledEvent read _OnSingleStepEnabled write _OnSingleStepEnabled;
    property OnRunningEnabled: TRunningEnabledEvent read _OnRunningEnabled write _OnRunningEnabled;
    property OnAfterAssemble: TNotifyEvent read _AfterAssemble write _AfterAssemble;
    property OnTimerEnabledRequest: TTimerEnabledRequestEvent read _OnTimerEnabledRequest write _OnTimerEnabledRequest;
    property OnTick: TTickEvent read _OnTick write _OnTick;
    property OnPCRefreshRequest: TPCRefreshRequestEvent read _OnPCRefreshRequest write _OnPCRefreshRequest;
    property OnLoadProject: TLoadEvent read _OnLoadProject write _OnLoadProject;
    property OnLoadProgram: TLoadEvent read _OnLoadProgram write _OnLoadProgram;
    property OnSaveProject: TSaveEvent read _OnSaveProject write _OnSaveProject;
    property OnSaveProgram: TSaveEvent read _OnSaveProgram write _OnSaveProgram;
  end;

  TSynPaintEvent = procedure(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer) of object;

  TSupportPlugin = class(TSynEditPlugin)
  private
    _OnAfterPaint: TSynPaintEvent;
  protected
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: Integer); override;
    procedure LinesInserted(FirstLine, Count: Integer); override;
    procedure LinesDeleted(FirstLine, Count: Integer); override;
  public
    constructor Create(AOwner: TSynEdit);
    property OnAfterPaint: TSynPaintEvent read _OnAfterPaint write _OnAfterPaint;
  end;

var
  EditorForm: TEditorForm;

implementation

{$R *.dfm}

constructor TSupportPlugin.Create(AOwner: TSynEdit);
begin
  inherited Create(AOwner);
end;

procedure TSupportPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: integer);
begin
 if Assigned(OnAfterPaint) then OnAfterPaint(ACanvas, AClip, FirstLine, LastLine);
end;

procedure TSupportPlugin.LinesInserted(FirstLine, Count: integer);
begin
end;

procedure TSupportPlugin.LinesDeleted(FirstLine, Count: integer);
begin
end;

procedure TEditorForm.FormCreate(Sender: TObject);
begin
  _i8008Assembler:= Ti8008Assembler.Create;
  _i8008Assembler.ErrorList.OnItemInsert:= ErrorInsert;
  _i8008Assembler.ErrorList.OnItemDelete:= ErrorDelete;
  _HideErrors:= false;
  _SizeHeight:= lbError.Height;
  iSourcecode.Left:= 3;
  iSourcecode.Top:= 3;
  iSourcecode.Visible:= false;
  iProject.Left:= 3;
  iProject.Top:= 3;
  iProject.Visible:= false;
  LblFilename.Caption:= '';
  synEditor.Modified:= false;
  _i8008ASMSyn:= Ti8008ASMSyn.Create(self);
  synEditor.Highlighter:= _i8008ASMSyn;
  _SupportPlugin:= TSupportPlugin.Create(synEditor);
  _SupportPlugin.OnAfterPaint:= OnAfterPaint;
  _BreakpointList:= TBreakpointList.Create;
  _BreakpointList.ClearAllBreakpoints;
  _CodeModified:= true; //false;
  _isSingleStep:= false;
  _isRunning:= false;
  _ErrorLine:= -1;
  _StepLine:= -1;
  EnableKeys:= false;
  LoadLanguage;
end;

procedure TEditorForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  CanClose:= SaveRequest <> mrCancel;
end;

procedure TEditorForm.FormDestroy(Sender: TObject);
begin
  _BreakpointList.Free;
  synEditor.Highlighter:= nil;
  _i8008ASMSyn.Free;
  _SupportPlugin.Free;
  _i8008Assembler.Free;
end;

procedure TEditorForm.Start;
begin
  if _CodeModified or not Assigned(AProgram) then begin
    if Assigned(OnAssembleRequest) then OnAssembleRequest(Self);
  end else
    if Assigned(AProgram) then begin
      Caption:= 'Editor ( '+getString(rsRunning)+' )';
      synEditor.ReadOnly:= true;
      if Visible then goToLine(-1);
      _isRunning:= true;
      _isSingleStep:= false;
      if Assigned(OnRunningEnabled) then OnRunningEnabled(Self,_isRunning);
      if Assigned(OnTimerEnabledRequest) then OnTimerEnabledRequest(true);
    end;
end;

procedure TEditorForm.sbHideClick(Sender: TObject);
begin
  setErrorList(not _HideErrors);
end;

procedure TEditorForm.lbErrorClick(Sender: TObject);
begin
  if (lbError.ItemIndex >= 0) and Visible then begin
    _ErrorLine:= _i8008Assembler.ErrorList.Items[lbError.ItemIndex].Line;
    goToLine(_ErrorLine);
    synEditor.Invalidate;
  end;
  lbError.SetFocus;
end;

procedure TEditorForm.synEditorChange(Sender: TObject);
begin
  if synEditor.Modified then begin
    _CodeModified:= true;
    LblFilename.Font.Style:= [fsBold];
  end;
end;

procedure TEditorForm.OnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if EnableKeys then
    case Key of
      VK_F2   : if (Shift = [ssCtrl]) then // stop
                  begin
                    Stop;
                    if Visible then goToLine(-1);
                  end;
      VK_F9   : if Assigned(OnAssembleRequest) and (Shift = [ssCtrl]) then
                  OnAssembleRequest(Self)  // assemble
                else                       // start
                  Start;
      ord('O'): if Shift = [ssCtrl] then   // open file
                  OpenFile;
      ord('P'): if Shift = [ssCtrl] then   // open project
                  OpenProject;
      ord('S'): if Shift = [ssCtrl] then   // save file/project
                  Save;
    end;
end;

procedure TEditorForm.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F7) then                    // single step
    SingleStep;
end;

procedure TEditorForm.RefreshObject(Sender: TObject);
var
  PItem: TProgramItem;
begin
  if (Sender is Ti8008Stack) and (_isSingleStep or _isRunning) then
    begin
      if Assigned(AProgram) then
        begin
          PItem:= AProgram.FindItem((Sender as Ti8008Stack).ProgramCounter);
          if Assigned(PItem) and _isSingleStep then begin
            if Visible then goToLine(PItem.Link);
          end else begin
            if Visible then goToLine(-1);
          end;
        end;
    end;
end;

procedure TEditorForm.Reset(Sender: TObject);
var
  PItem: TProgramItem;
begin
  if (Sender is Ti8008Stack) and (_isSingleStep or _isRunning) then
    begin
      if Assigned(AProgram) then
        begin
          PItem:= AProgram.FindItem((Sender as Ti8008Stack).ProgramCounter);
          if Assigned(PItem) and _isSingleStep then begin
            if Visible then goToLine(PItem.Link);
          end else begin
            if Visible then goToLine(-1);
          end;
        end;
    end;
end;

procedure TEditorForm.PCUpdate(Sender: TObject; Value: Word);
var
  PItem: TProgramItem;
begin
  if Assigned(AProgram) then begin
    PItem:= AProgram.FindItem(Value);
    if _isRunning and Assigned(PItem) then begin
      // stop the timer if a breakpoint is reached
      if _BreakpointList.Breakpoint(PItem.Link+1) and _isRunning then begin
        Stop(false);
        // go to the specified sourcecodeline
        _StepLine:= PItem.Link;
        if Visible then goToLine(PItem.Link);
        Caption:= 'Editor ( Breakpoint )';
      end;
    end else begin
      // go to the specified sourcecodeline
      if _isSingleStep and Assigned(PItem) then begin
        _StepLine:= PItem.Link;
        if Visible then begin
          goToLine(PItem.Link);
          synEditor.Invalidate;
        end;
      end else begin
        if Visible then goToLine(-1);
      end;
    end;
  end;
end;

procedure TEditorForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY, false) then begin
    RegistryList.LoadFormSettings(Self, true);
    if RegistryList.Registry.ValueExists('ErrorVisible') then
      setErrorList(RegistryList.Registry.ReadInteger('ErrorVisible') = 1);
  end;
end;

procedure TEditorForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    begin
      RegistryList.SaveFormSettings(Self,true);
      if lbError.Visible then
        RegistryList.Registry.WriteInteger('ErrorVisible',1)
      else
        RegistryList.Registry.WriteInteger('ErrorVisible',0);
    end;
end;
    
procedure TEditorForm.ErrorInsert(Sender: TObject; Index: Integer);
var
  Text: String;
  Error: TErrorList;

begin
  Error:= _i8008Assembler.ErrorList;
  case Error.Items[Index].State of
    isError     : Text:= '['+getString(rsError)+'] : ('+IntToStr(Error.Items[Index].Line)+')';
    isFatalError: Text:= '['+getString(rsFatalError)+'] : ('+IntToStr(Error.Items[Index].Line)+')';
    isWarning   : Text:= '['+getString(rsWarning)+'] : ('+IntToStr(Error.Items[Index].Line)+')';
    isHint      : Text:= '['+getString(rsHint)+'] : ('+IntToStr(Error.Items[Index].Line)+')';
    isUndefined : Text:= '['+getString(rsError)+'] : ('+IntToStr(Error.Items[Index].Line)+')';
  end;
  Text:= Text + ' ' + Error.Items[Index].Text;
  lbError.Items.Insert(Index,Text);
end;

procedure TEditorForm.ErrorDelete(Sender: TObject; Index: Integer);
begin
  lbError.Items.Delete(Index);
end;

procedure TEditorForm.setErrorList(Hide: Boolean);
begin
  _HideErrors:= Hide;
  if Hide then pMainBottom.Height:= pMainBottom.Height - _SizeHeight
  else pMainBottom.Height:= pMainBottom.Height + _SizeHeight;
  if _HideErrors then sbHide.Down:= true
  else                sbHide.Down:= false;
end;

function TEditorForm.getFilename: TFilename;
begin
  result:= LblFilename.Caption;
end;

procedure TEditorForm.Stop(ClearArrow: Boolean);
begin
  if Assigned(AProgram) then
    begin
      Caption:= 'Editor';
      synEditor.ReadOnly:= false;
      if _isSingleStep then
        begin
          _isSingleStep:= false;
          if Assigned(OnSingleStepEnabled) then
            OnSingleStepEnabled(Self,_isSingleStep);
        end;
      if _isRunning then
        begin
         if Assigned(OnTimerEnabledRequest) then
           OnTimerEnabledRequest(false);
          _isRunning:= false;
          if Assigned(OnRunningEnabled) then
            OnRunningEnabled(Self,_isRunning);
        end;
      if ClearArrow and Visible then goToLine(-1);
    end;
end;

procedure TEditorForm.Stop;
begin
  Stop(true);
end;

procedure TEditorForm.SingleStep;
begin
  if not _isRunning then
    if _CodeModified or not Assigned(AProgram) then begin
        if Assigned(OnAssembleRequest) then OnAssembleRequest(Self);
    end else if Assigned(AProgram) then begin
      if not _isSingleStep then begin
        Caption:= 'Editor ( '+getString(rsSingleStep)+' )';
        synEditor.ReadOnly:= true;
        _isSingleStep:= true;
        _isRunning:= false;
        if Assigned(OnPCRefreshRequest) then
          OnPCRefreshRequest(Self);
        if Assigned(OnSingleStepEnabled) then
          OnSingleStepEnabled(Self, _isSingleStep);
      end else if Assigned(OnTick) then OnTick;
    end;
end;

function TEditorForm.Assemble: Boolean;
var
  Str: String;
  Text: String;
  i: Integer;

begin
  Str:= '';
  Text:= '';
  for i:= 0 to synEditor.Lines.Count-1 do Text:= Text + synEditor.Lines.Strings[i]+#10#13;
  result:= _i8008Assembler.Assemble(Text, _Program, LblFilename.Caption);
  // Update Breakpoints
  for i:= 0 to _BreakpointList.Count-1 do _BreakpointList.Items[i].State:= false;
  for i:= 0 to _Program.Count-1 do _BreakpointList.BreakpointState[_Program.Items[i].Link+1]:= true;
  if Visible then goToLine(-1);
  // Show Errors
  if not result and _HideErrors then setErrorList(false);
  if result and Assigned(OnAfterAssemble) then OnAfterAssemble(Self);
  _CodeModified:= not result;
end;

function TEditorForm.New: Boolean;
begin
  if not (_isRunning or _isSingleStep) and
    (SaveRequest <> mrCancel) then
    begin
        synEditor.Clear;
        LblFilename.Caption:= '';
        _BreakpointList.ClearAllBreakpoints;
        synEditor.Modified:= false;
        _CodeModified:= true;
        AProgram:= nil;
        result:= true;
        iProject.Visible:= false;
        iSourcecode.Visible:= false;
      end
   else
     result:= false;
end;

function TEditorForm.OpenFile: Boolean;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      if OpenDialog.Execute then
        try
          if SaveRequest <> mrCancel then
            begin
              synEditor.Lines.LoadFromFile(OpenDialog.Filename);
              LblFilename.Caption:= OpenDialog.Filename;
              _BreakpointList.ClearAllBreakpoints;
              if not Visible then
                Show;
              if Visible then goToLine(-1);
              result:= true;
              synEditor.Modified:= false;
              _CodeModified:= true;
              iProject.Visible:= false;
              iSourcecode.Visible:= true;
            end
          else
            result:= false;
        except
          result:= false;
        end
      else
        result:= false;
      if synEditor.Modified then
        LblFilename.Font.Style:= [fsBold]
      else
        LblFilename.Font.Style:= [];
      AProgram:= nil;
    end
  else
    result:= false;
end;

procedure TEditorForm.Open(Filename: TFilename);
begin
  if LowerCase(ExtractFileExt(Filename)) = '.pj' then
    OpenProject(Filename)
  else
    OpenFile(Filename);
end;

function TEditorForm.OpenFile(Filename: TFilename): Boolean;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      try
        if SaveRequest <> mrCancel then
          begin
            synEditor.Lines.LoadFromFile(Filename);
            LblFilename.Caption:= Filename;
            _BreakpointList.ClearAllBreakpoints;
            result:= true;
            synEditor.Modified:= false;
            _CodeModified:= true;
            iProject.Visible:= false;
            iSourcecode.Visible:= true;
          end
        else
          result:= false;
      except
        result:= false;
      end;
      if synEditor.Modified then LblFilename.Font.Style:= [fsBold]
      else LblFilename.Font.Style:= [];
      AProgram:= nil;
    end
  else
    result:= false;
end;

function TEditorForm.OpenProject: Boolean;
var
  FStringStream: TStringStream;
  FStream: TFileStream;
  CodeModified: Boolean;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      AProgram:= nil;
      if OpenProjectDialog.Execute then
        try
          FStream:= TFileStream.Create(OpenProjectDialog.FileName,fmOpenRead,fmShareDenyWrite);
          if SaveRequest <> mrCancel then begin
            result:= true;
            // Load i8008
            if Assigned(OnLoadProject) then OnLoadProject(FStream,result);
            // Load Editor State
            result:= result and
                     (FStream.Read(CodeModified,SizeOf(CodeModified)) = SizeOf(CodeModified));
            // Load i8008 Program
            if result and (not CodeModified) and Assigned(OnLoadProgram) then
              OnLoadProgram(FStream,result);
            // Load Sourcecode
            if result then begin
              FStringStream:= TStringStream.Create('');
              try
                FStringStream.CopyFrom(FStream, FStream.Size-FStream.Position);
                synEditor.Lines.LoadFromStream(FStringStream);
              finally
                FreeAndNil(FStringStream);
              end;
              LblFilename.Caption:= OpenProjectDialog.Filename;
              _BreakpointList.ClearAllBreakpoints;
              if not Visible then Show;
              if Visible then goToLine(-1);
              synEditor.Modified:= false;
              _CodeModified:= CodeModified;
              iProject.Visible:= true;
              iSourcecode.Visible:= false;
            end else MessageDlg(getString(rs_msg_OpenError),mtError,[mbOk],0);
          end else result:= false;
          FStream.Free;
        except
          result:= false;
          MessageDlg(getString(rs_msg_OpenError),mtError,[mbOk],0);
        end
      else
        result:= false;
      if synEditor.Modified then
        LblFilename.Font.Style:= [fsBold]
      else
        LblFilename.Font.Style:= [];
    end
  else
    result:= false;
end;

function TEditorForm.OpenProject(Filename: TFilename): Boolean;
var
  FStringStream: TStringStream;
  FStream: TFileStream;
  CodeModified: Boolean;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      AProgram:= nil;    
      try
        FStream:= TFileStream.Create(FileName,fmOpenRead,fmShareDenyWrite);
        if SaveRequest <> mrCancel then begin
          result:= true;
          // Load i8008
          if Assigned(OnLoadProject) then
            OnLoadProject(FStream,result);
          // Load Editor State
          result:= result and
                   (FStream.Read(CodeModified,SizeOf(CodeModified)) = SizeOf(CodeModified));
          // Load i8008 Program
          if result and (not CodeModified) and Assigned(OnLoadProgram) then
            OnLoadProgram(FStream,result);
          // Load Sourcecode
          if result then begin
            FStringStream:= TStringStream.Create('');
            try
              FStringStream.CopyFrom(FStream, FStream.Size-FStream.Position);
              synEditor.Lines.LoadFromStream(FStringStream);
            finally
              FreeAndNil(FStringStream);
            end;
            LblFilename.Caption:= Filename;
            _BreakpointList.ClearAllBreakpoints;
            synEditor.Modified:= false;
            _CodeModified:= CodeModified;
            iProject.Visible:= true;
            iSourcecode.Visible:= false;
          end else MessageDlg(getString(rs_msg_OpenError),mtError,[mbOk],0);
        end else result:= false;
        FStream.Free;
      except
        result:= false;
        MessageDlg(getString(rs_msg_OpenError),mtError,[mbOk],0);
      end;
      if synEditor.Modified then
        LblFilename.Font.Style:= [fsBold]
      else
        LblFilename.Font.Style:= [];
    end
  else
    result:= false;
end;

function TEditorForm.SaveRequest: Integer;
begin
  result:= mrNone;
  if synEditor.Modified then
    result:= MessageDlg(getString(rsSaveChanges),mtConfirmation,[mbYes,mbNo,mbCancel],0);
  if result = mrYes then begin
    if SaveFile then result:= mrYes
    else result:= mrCancel;
  end else if result = mrNo then synEditor.Modified:= false;
end;

procedure TEditorForm.Save;
begin
  if LowerCase(ExtractFileExt(LblFilename.Caption)) = '.pj' then SaveProject
  else SaveFile;
end;

function TEditorForm.SaveFile: Boolean;
var
  BackupName: TFilename;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      if synEditor.Modified then
        AProgram:= nil;
      if LblFilename.Caption <> '' then
        try
          if FileExists(LblFilename.Caption) then
            begin
              BackupName:= ChangeFileExt(LblFilename.Caption,'.~asm');
              if FileExists(BackupName) then
                DeleteFile(BackupName);
              RenameFile(LblFilename.Caption,BackupName);
            end;
          synEditor.Lines.SaveToFile(LblFilename.Caption);
          result:= true;
          synEditor.Modified:= false;
        except
          result:= false;
        end
      else
        result:= false;
      if not result then
        result:= SaveFileAs;
      if synEditor.Modified then
        LblFilename.Font.Style:= [fsBold]
      else
        LblFilename.Font.Style:= [];
    end
  else
    result:= false;
end;

function TEditorForm.SaveFileAs: Boolean;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      if SaveDialog.Execute then
        begin
          if synEditor.Modified then
            AProgram:= nil;
          try
            LblFilename.Caption:= SaveDialog.Filename;
            synEditor.Lines.SaveToFile(LblFilename.Caption);
            result:= true;
            synEditor.Modified:= false;
          except
            result:= false;
          end
        end
      else
        result:= false;
      if synEditor.Modified then
        LblFilename.Font.Style:= [fsBold]
      else
        LblFilename.Font.Style:= [];
    end
  else
    result:= false;
end;

function TEditorForm.SaveProject: Boolean;
var
  BackupName: TFilename;
  FStream: TFileStream;
begin
  if not (_isRunning or _isSingleStep) then
    begin
      if synEditor.Modified then
        AProgram:= nil;
      if LblFilename.Caption <> '' then
        try
          if FileExists(LblFilename.Caption) then
            begin
              BackupName:= ChangeFileExt(LblFilename.Caption,'.~pj');
              if FileExists(BackupName) then
                DeleteFile(BackupName);
              RenameFile(LblFilename.Caption,BackupName);
            end;
          FStream:= TFileStream.Create(LblFilename.Caption,fmCreate,fmShareExclusive);
          result:= true;
          // Save i8008
          if Assigned(OnSaveProject) then
            OnSaveProject(FStream,result);
          // Save Editor State
          result:= result and
                   (FStream.Write(_CodeModified,SizeOf(_CodeModified)) = SizeOf(_CodeModified));
          // Save i8008 Program
          if result and (not _CodeModified) and Assigned(OnSaveProgram) then
            OnSaveProgram(FStream,result);
          // Save Sourcecode
          synEditor.Lines.SaveToStream(FStream);
          synEditor.Modified:= false;
          if not result then
            MessageDlg(getString(rs_msg_SaveError),mtError,[mbOk],0);
          FStream.Free;  
        except
          result:= false;
          MessageDlg(getString(rs_msg_SaveError),mtError,[mbOk],0);
        end
      else
        result:= false;
      if not result then
        result:= SaveProjectAs;
      if synEditor.Modified then
        LblFilename.Font.Style:= [fsBold]
      else
        LblFilename.Font.Style:= [];
    end
  else
    result:= false;
end;

function TEditorForm.SaveProjectAs: Boolean;
var
  FStream: TFileStream;  
begin
  if not (_isRunning or _isSingleStep) then
    begin
      if SaveProjectDialog.Execute then
        begin
          if synEditor.Modified then
            AProgram:= nil;
          try
            LblFilename.Caption:= SaveProjectDialog.Filename;
            FStream:= TFileStream.Create(LblFilename.Caption,fmCreate,fmShareExclusive);
            result:= true;
            // Save i8008
            if Assigned(OnSaveProject) then
              OnSaveProject(FStream,result);
            // Save Editor State
            result:= result and
                     (FStream.Write(_CodeModified,SizeOf(_CodeModified)) = SizeOf(_CodeModified));
            // Save i8008 Program
            if result and (not _CodeModified) and Assigned(OnSaveProgram) then
              OnSaveProgram(FStream,result);
            // Save Sourcecode
            synEditor.Lines.SaveToStream(FStream);
            synEditor.Modified:= false;
            if not result then
              MessageDlg(getString(rs_msg_SaveError),mtError,[mbOk],0);
            FStream.Free;
          except
            result:= false;
            MessageDlg(getString(rs_msg_SaveError),mtError,[mbOk],0);
          end
        end
      else result:= false;
      if synEditor.Modified then LblFilename.Font.Style:= [fsBold]
      else LblFilename.Font.Style:= [];
    end
  else result:= false;
end;

procedure TEditorForm.Print;
var
  old: Boolean;
begin
  old:= synEditor.Modified;
  if PrinterSetupDialog.Execute then begin
    synEditorPrint.SynEdit:= synEditor;
    synEditorPrint.DocTitle:= ExtractFilename(LblFilename.Caption);
    synEditorPrint.Title:= ExtractFilename(LblFilename.Caption);
    synEditorPrint.Print;
  end;
  synEditor.Modified:= old;
end;

procedure TEditorForm.ShowProgress(Value: Boolean);
begin
  _i8008Assembler.ShowProgress:= Value;
end;

procedure TEditorForm.LoadLanguage;
begin
  { Dialog                   }
  OpenDialog.Filter:= getString(rs_filter_File);
  OpenDialog.Title:= getString(rs_m_Open)+' ...';
  SaveDialog.Filter:= getString(rs_filter_File);
  SaveDialog.Title:= getString(rs_m_SaveAs)+' ...';
  OpenProjectDialog.Filter:= getString(rs_filter_Project);
  OpenProjectDialog.Title:=  getString(rs_m_ProjectOpen)+' ...';
  SaveProjectDialog.Filter:= getString(rs_filter_Project);
  SaveProjectDialog.Title:= getString(rs_m_ProjectSaveAs)+' ...';
end;

procedure TEditorForm.Show(ATop, ALeft, AWidth, AHeight: Integer);
begin
  Top:= ATop;
  Left:= ALeft;
  Height:= AHeight;
  Width:= AWidth;
  Show;
end;

procedure TEditorForm.goToLine(Line: Integer);
var
  FirstLine, LastLine: Integer;
begin
  if Line < 0 then begin
    _StepLine:= -1;
    _ErrorLine:= -1;
    synEditor.Invalidate;
  end else begin
    Line:= Line + 1;
    FirstLine:= synEditor.TopLine;
    LastLine:= FirstLine + synEditor.LinesInWindow - 1;
    if (Line < FirstLine) or (Line > LastLine) then synEditor.TopLine:= Line;
    synEditor.Invalidate;
  end;
end;

procedure TEditorForm.synEditorGutterClick(Sender: TObject;
  Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  i: Integer;
begin
  _BreakpointList.ToggleBreakpoint(Line);
  // Update Breakpoints
  for i:= 0 to _BreakpointList.Count-1 do _BreakpointList.Items[i].State:= false;
  if Assigned(_Program) then
    for i:= 0 to _Program.Count-1 do _BreakpointList.BreakpointState[_Program.Items[i].Link+1]:= true;
  synEditor.InvalidateLine(Line);
end;

procedure TEditorForm.synEditorSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  // Error
  Special:= Line = (_ErrorLine+1);
  if Special then begin
    FG:= clWhite;
    BG:= clRed;
  end;
  // Programcounter
  if not Special then begin
    Special:= Line = (_StepLine+1);
    if Special then begin
      FG:= clWhite;
      BG:= clAqua;
    end;
    // Breakpoint
    if not Special then begin
      Special:= _BreakpointList.Breakpoint(Line);
      if Special then begin
        FG:= clWhite;
        BG:= clRed;
      end;
    end;
  end;
end;

procedure TEditorForm.OnAfterPaint(ACanvas: TCanvas; const AClip: TRect;
  FirstLine, LastLine: Integer);
var
  X, Y, ImageIndex: Integer;
begin
  if true then begin
    X:= 14;
    Y:= (synEditor.LineHeight - imglGutter.Height) div 2
       + synEditor.LineHeight * (FirstLine - synEditor.TopLine);
    while FirstLine <= LastLine do begin

      if (_StepLine+1) = FirstLine then begin
        if _BreakpointList.Breakpoint(FirstLine) then ImageIndex:= 3
        else ImageIndex:= 2
      end else begin
        if _BreakpointList.Breakpoint(FirstLine) then begin
          if _BreakpointList.BreakpointState[FirstLine] then ImageIndex:= 1
          else ImageIndex:= 0;
        end else ImageIndex:= -1;
      end;

      if ImageIndex >= 0 then imglGutter.Draw(ACanvas, X, Y, ImageIndex);
      Inc(FirstLine);
      Inc(Y, synEditor.LineHeight);
    end;
  end;
end;

end.
