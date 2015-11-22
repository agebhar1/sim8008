unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ToolWin, ExtCtrls, Buttons, Registry,
  uAssembler, uDisAssembler, uDisAssemblerForm, uEditorForm,
  uIOPortForm, uProcessor, uRAMForm, uRegisterForm, uResourceStrings,
  uStackForm, uTimer, uView, uWatchForm, uMisc, ImgList, StdCtrls, EnhCtrls,
  DdeMan, ShellAPI;

type
  TMainForm = class(TForm, ILanguage, IRadixView, IRegistry)
    ImageList: TImageList;
    cbMain: TControlBar;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miNew: TMenuItem;
    miFileOpen: TMenuItem;
    N1: TMenuItem;
    miSave: TMenuItem;
    miFileSaveAs: TMenuItem;
    N2: TMenuItem;
    miPrint: TMenuItem;
    N5: TMenuItem;
    miClose: TMenuItem;
    miView: TMenuItem;
    miEditor: TMenuItem;
    miRAM: TMenuItem;
    miRegister: TMenuItem;
    miStack: TMenuItem;
    miPorts: TMenuItem;
    miIPort: TMenuItem;
    miOPort: TMenuItem;
    miDebug: TMenuItem;
    miWatch: TMenuItem;
    miDisassembler: TMenuItem;
    miSetup: TMenuItem;
    miRadix: TMenuItem;
    miOctal: TMenuItem;
    miDecimal: TMenuItem;
    miHexadecimal: TMenuItem;
    miBinary: TMenuItem;
    miSplit: TMenuItem;
    N3: TMenuItem;
    miASMProgress: TMenuItem;
    N4: TMenuItem;
    miLanguage: TMenuItem;
    miGerman: TMenuItem;
    miEnglish: TMenuItem;
    miProject: TMenuItem;
    miAssemble: TMenuItem;
    miMStart: TMenuItem;
    miStart: TMenuItem;
    miSinglestep: TMenuItem;
    miStop: TMenuItem;
    miHelp: TMenuItem;
    miHelp2: TMenuItem;
    miInfo: TMenuItem;
    tbProjectStart: TToolBar;
    tbAssemble: TToolButton;
    tbDiv4: TToolButton;
    tbStart: TToolButton;
    tbSingleStep: TToolButton;
    tbStop: TToolButton;
    tbHelp: TToolBar;
    tbtnHelp: TToolButton;
    tbFile: TToolBar;
    tbProjectOpen: TToolButton;
    tbFileOpen: TToolButton;
    tbSave: TToolButton;
    tbDiv2: TToolButton;
    tbEditor: TToolButton;
    tbTimer: TToolBar;
    pTimer: TPanel;
    LblTimer: TLabel;
    eeTimer: TEnhancedEdit;
    Label1: TLabel;
    N6: TMenuItem;
    miResetRAM: TMenuItem;
    miResetStack: TMenuItem;
    miResetRegisterFlags: TMenuItem;
    miResetIPort: TMenuItem;
    miResetOPort: TMenuItem;
    miResetProcessor: TMenuItem;
    N7: TMenuItem;
    miResetAll: TMenuItem;
    tbReset: TToolBar;
    tbResetRAM: TToolButton;
    tbResetStack: TToolButton;
    tbResetRegisterFlags: TToolButton;
    tbResetIPort: TToolButton;
    tbResetOPort: TToolButton;
    tbResetProcessor: TToolButton;
    miProjectSaveAs: TMenuItem;
    miProjectOpen: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    miUseRegistry: TMenuItem;
    miNewProject: TMenuItem;
    miNewFile: TMenuItem;
    tbDiv1: TToolButton;
    tbFileSaveAs: TToolButton;
    tbProjectSaveAs: TToolButton;
    tbDiv3: TToolButton;
    Sim8008DdeServerItem: TDdeServerItem;
    miTools: TMenuItem;
    miIOEditor: TMenuItem;
    miDecimalNeg: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miFileOpenClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miFileSaveAsClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miEditorClick(Sender: TObject);
    procedure miRAMClick(Sender: TObject);
    procedure miRegisterClick(Sender: TObject);
    procedure miStackClick(Sender: TObject);
    procedure miIPortClick(Sender: TObject);
    procedure miOPortClick(Sender: TObject);
    procedure miWatchClick(Sender: TObject);
    procedure miDisassemblerClick(Sender: TObject);
    procedure miAssembleClick(Sender: TObject);
    procedure miStartClick(Sender: TObject);
    procedure miSingleStepClick(Sender: TObject);
    procedure miStopClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure miInfoClick(Sender: TObject);
    procedure miPrintClick(Sender: TObject);
    procedure miOctalClick(Sender: TObject);
    procedure miDecimalClick(Sender: TObject);
    procedure miHexadecimalClick(Sender: TObject);
    procedure miBinaryClick(Sender: TObject);
    procedure miSplitClick(Sender: TObject);
    procedure miGermanClick(Sender: TObject);
    procedure miEnglishClick(Sender: TObject);
    procedure miASMProgressClick(Sender: TObject);
    procedure cbMainResize(Sender: TObject);
    procedure cbMainDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure eeTimerClick(Sender: TObject);
    procedure miResetRAMClick(Sender: TObject);
    procedure miResetStackClick(Sender: TObject);
    procedure miResetRegisterFlagsClick(Sender: TObject);
    procedure miResetIPortClick(Sender: TObject);
    procedure miResetOPortClick(Sender: TObject);
    procedure miResetProcessorClick(Sender: TObject);
    procedure miResetAllClick(Sender: TObject);
    procedure miProjectSaveAsClick(Sender: TObject);
    procedure miProjectOpenClick(Sender: TObject);
    procedure miUseRegistryClick(Sender: TObject);
    procedure miNewProjectClick(Sender: TObject);
    procedure miNewFileClick(Sender: TObject);
    procedure Sim8008DdeServerItemPokeData(Sender: TObject);
    procedure miIOEditorClick(Sender: TObject);
    procedure miDecimalNegClick(Sender: TObject);
  private
    _Block: Boolean;
    _isRunning: Boolean;
    _Height: Integer;
    _ImageStart: Integer;
    _ImageStop: Integer;
    // Forms
    _DisAssembler: TDisAssemblerForm;
    _Editor: TEditorForm;
    _IPort: TIOPortForm;
    _OPort: TIOPortForm;
    _RAM: TRAMForm;
    _Register: TRegisterForm;
    _Stack: TStackForm;
    _Watch: TWatchForm;
    // Listener List's
    _LanguageList: TLanguageList;
    _View: TViewList;
    _RegistryList: TRegistryList;
    // Processor
    _i8008: Ti8008Processor;
    // Program
    _Program: TProgram;
    // Timer
    _Timer: TProcessorTimer;
    procedure AssembleRequest(Sender: TObject);
    procedure AfterAssemble(Sender: TObject);
    procedure OnSingleStepEnabled(Sender: TObject; Enabled: Boolean);
    procedure OnRunningEnabled(Sender: TObject; Enabled: Boolean);
    procedure OnLoadProject(Stream: TStream; var Check: Boolean);
    procedure OnLoadProgram(Stream: TStream; var Check: Boolean);
    procedure OnSaveProject(Stream: TStream; var Check: Boolean);
    procedure OnSaveProgram(Stream: TStream; var Check: Boolean);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
  public
    procedure Open(Filename: TFilename);
    procedure LoadRegistry;
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);
  end;

var
  MainForm: TMainForm;

const
  MAIN_TITLE = 'Sim 8008';

implementation

uses uEditForm, uInfoForm, XPMan;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption:= MAIN_TITLE;
  _Block:= true;
  _isRunning:= false;
  ClientHeight:= cbMain.Height;
  Width:= Screen.WorkAreaWidth;
  _Height:= Height;
  _ImageStop:= miStop.ImageIndex;
  _ImageStart:= miStart.ImageIndex;
  Top:= 0;
  Left:= 0;
  _Block:= false;
  // Create all Forms
  _DisAssembler:= TDisAssemblerForm.Create(Self);
  _Editor:= TEditorForm.Create(Self);
  _IPort:= TIOPortForm.Create(Self);
  _IPort.PortType:= ptIN;
  _OPort:= TIOPortForm.Create(Self);
  _OPort.PortType:= ptOUT;
  _RAM:= TRAMForm.Create(Self);
  _Register:= TRegisterForm.Create(Self);
  _Stack:= TStackForm.Create(Self);
  _Watch:= TWatchForm.Create(Self);
  // Processor
  _i8008:= Ti8008Processor.Create;
  // Program
  _Program:= TProgram.Create;
  // Timer
  _Timer:= TProcessorTimer.Create;
  _Timer.OnTick:= _i8008.Tick;
  // set Eventpointer
  _DisAssembler.Processor:= _i8008;
  _DisAssembler.OnProgramCounterUpdateRequest:= _i8008.setProgramCounter;
  _Editor.OnAssembleRequest:= AssembleRequest;
  _Editor.OnAfterAssemble:= AfterAssemble;
  _Editor.OnPCRefreshRequest:= _i8008.RefreshProgramCounter;
  _Editor.OnTick:= _Timer.Tick;
  _Editor.OnTimerEnabledRequest:= _Timer.RemoteEnabled;
  _Editor.OnSingleStepEnabled:= OnSingleStepEnabled;
  _Editor.OnRunningEnabled:= OnRunningEnabled;
  _Editor.OnLoadProject:= OnLoadProject;
  _Editor.OnLoadProgram:= OnLoadProgram;
  _Editor.OnSaveProject:= OnSaveProject;
  _Editor.OnSaveProgram:= OnSaveProgram;
  _Editor.ShowProgress(true);
  _IPort.OnIPortsRefreshRequest:= _i8008.RefreshIPorts;
  _IPort.OnIPortsUpdateRequest:= _i8008.setIPorts;
  _IPort.OnPortsActiveRequest:= _i8008.setIPortActive;
  _IPort.OnPortsFileRequest:= _i8008.setIPortFile;
  _IPort.OnPortFileResetRequest:= _i8008.ResetIPortFile;
  _OPort.OnOPortsRefreshRequest:= _i8008.RefreshOPorts;
  _OPort.OnPortsActiveRequest:= _i8008.setOPortActive;
  _OPort.OnPortsFileRequest:= _i8008.setOPortFile;
  _RAM.OnRAMRefreshRequest:= _i8008.RefreshRAM;
  _RAM.OnRAMUpdateRequest:= _i8008.setRAM;
  _Register.OnRegisterUpdateRequest:= _i8008.setRegister;
  _Stack.OnStackPointerUpdateRequest:= _i8008.setStackPointer;
  _Stack.OnStackUpdateRequest:= _i8008.setStack;
  _Register.OnFlagUpdateRequest:= _i8008.setFlag;
  _Register.OnProgramCounterUpdateRequest:= _i8008.setProgramCounter;
  _Register.OnReturnFromHaltRequest:= _i8008.ReturnFromHLT;
  _Watch.OnRAMRefreshRequest:= _i8008.RefreshRAM;
  _Watch.OnRAMUpdateRequest:= _i8008.setRAM;
  _Watch.OnIPortsRefreshRequest:= _i8008.RefreshIPorts;
  _Watch.OnIPortsUpdateRequest:= _i8008.setIPorts;
  _Watch.OnOPortsRefreshRequest:= _i8008.RefreshOPorts;
  // Create Listener List's
  _LanguageList:= TLanguageList.Create;
  _View:= TViewList.Create;
  _RegistryList:= TRegistryList.Create;
  // Add Listener
  _i8008.AddFlagsListener(_Register);
  _i8008.AddIPortListener(_IPort);
  _i8008.AddIPortListener(_Watch);
  _i8008.AddOPortListener(_OPort);
  _i8008.AddOPortListener(_Watch);
  _i8008.AddProcessorListener(_DisAssembler);
  _i8008.AddProcessorListener(_IPort);
  _i8008.AddProcessorListener(_OPort);
  _i8008.AddProcessorListener(_Register);
  _i8008.AddProcessorListener(_Watch);
  _i8008.AddProgramCounterListener(_DisAssembler);
  _i8008.AddProgramCounterListener(_Editor);
  _i8008.AddProgramCounterListener(_Register);
  _i8008.AddRAMListener(_DisAssembler);
  _i8008.AddRAMListener(_RAM);
  _i8008.AddRAMListener(_Watch);
  _i8008.AddRegisterListener(_Register);
  _i8008.AddStackListener(_Stack);
  // Language Listener
  _LanguageList.AddListener(_DisAssembler);
  _LanguageList.AddListener(_Editor);
  _LanguageList.AddListener(EditForm);
  _LanguageList.AddListener(_IPort);
  _LanguageList.AddListener(_OPort);
  _LanguageList.AddListener(_RAM);
  _LanguageList.AddListener(_Register);
  _LanguageList.AddListener(Self);
  _LanguageList.AddListener(_Stack);
  _LanguageList.AddListener(_Watch);
  // View Listener
  _View.Radix:= rOctal;
  _View.View:= vShort;
  _View.AddListener(_DisAssembler);
  _View.AddListener(_IPort);
  _View.AddListener(_OPort);
  _View.AddListener(_RAM);
  _View.AddListener(_Register);
  _View.AddListener(Self);
  _View.AddListener(_Stack);
  _View.AddListener(_Watch);
  // Timer
  eeTimer.Text:= IntToStr(_Timer.TickTime);
  // Registry Listener
  _RegistryList.AddListener(_DisAssembler);
  _RegistryList.AddListener(_IPort);
  _RegistryList.AddListener(_OPort);
  _RegistryList.AddListener(_RAM);
  _RegistryList.AddListener(_Register);
  _RegistryList.AddListener(Self);
  _RegistryList.AddListener(_Stack);
  _RegistryList.AddListener(_Watch);
  _RegistryList.AddListener(_Editor);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  // works not correct under Win2k - GetKeyInfo -> Error
  procedure DeleteRegKey;
  var
    Registry: TRegistry;
    Info: TRegKeyInfo;
  begin
    Registry:= TRegistry.Create(KEY_WRITE);
    if Assigned(Registry) then
      begin
        try
          Registry.RootKey:= HKEY_CURRENT_USER;
          // \Software\Andreas Gebhardt\Sim 8008\V2
          if Registry.KeyExists(APPLICATION_MAIN_KEY) then
            begin
              // \Software\Andreas Gebhardt\Sim 8008
              if Registry.OpenKey('\Software\'+COMPANY_KEY+'\'+APPLICATION_KEY,false) then
                if Registry.DeleteKey(VERSION_KEY) then // V2
                  begin
                    // \Software\Andreas Gebhardt\Sim 8008
                    if Registry.GetKeyInfo(Info) and
                       (Info.NumSubKeys = 0) and (Info.NumValues = 0) then
                      begin
                        // \Software\Andreas Gebhardt
                        if Registry.OpenKey('\Software\'+COMPANY_KEY,false) then
                          begin
                            if Registry.DeleteKey(APPLICATION_KEY) then // Sim 8008
                              begin
                                if Registry.GetKeyInfo(Info) and
                                   (Info.NumSubKeys = 0) and (Info.NumValues = 0) and
                                   // \Software
                                   Registry.OpenKey('\Software',false) then
                                  Registry.DeleteKey(COMPANY_KEY); // Andreas Gebhardt
                              end;
                          end;
                      end;
                   end;
            end;
         except
         end;
         Registry.Free;
      end;
  end;

begin
  CanClose:= miClose.Enabled and (_Editor.SaveRequest <> mrCancel);
  if CanClose then
    begin
      if miUseRegistry.Checked then
        _RegistryList.SaveData
      else
        DeleteRegKey;
    end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin    
  // Destroy Timer
  _Timer.Free;
  // Destroy Program
  _Program.Free;
  // Destroy Processor
  _i8008.Free;
  // Destroy Listener List's
  _View.Free;
  _LanguageList.Free;
  _RegistryList.Free;  
  // Destroy all Forms
  _Watch.Free;
  _Stack.Free;
  _Register.Free;
  _RAM.Free;
  _OPort.Free;
  _IPort.Free;
  _Editor.Free;
  _DisAssembler.Free;
end;

procedure TMainForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if not _Block then
    NewHeight:= _Height;
end;

procedure TMainForm.cbMainResize(Sender: TObject);
begin
  _Block:= true;
  ClientHeight:= cbMain.Height;
  _Height:= Height;
  _Block:= false;
end;

procedure TMainForm.cbMainDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept:= Source.Control is TToolBar;
end;

procedure TMainForm.eeTimerClick(Sender: TObject);
var
  P: TPoint;
begin
  if (Sender is TEnhancedEdit) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= StrToInt((Sender as TEnhancedEdit).Text);
      if EditForm.ShowModal(rDecimal,vLong,10,P) = mrOk then
        begin
          _Timer.TickTime:= EditForm.Value;
          eeTimer.Text:= IntToStr(_Timer.TickTime);
        end;  
    end;
end;

procedure TMainForm.miNewProjectClick(Sender: TObject);
begin
  _Editor.New;
  _i8008.ResetAll;
end;

procedure TMainForm.miNewFileClick(Sender: TObject);
begin
  _Editor.New;
end;

procedure TMainForm.miFileOpenClick(Sender: TObject);
begin
  _Editor.OpenFile;
end;

procedure TMainForm.miSaveClick(Sender: TObject);
begin
  _Editor.Save;
end;

procedure TMainForm.miFileSaveAsClick(Sender: TObject);
begin
  _Editor.SaveFileAs;
end;

procedure TMainForm.miProjectSaveAsClick(Sender: TObject);
begin
  _Editor.SaveProjectAs;
end;

procedure TMainForm.miProjectOpenClick(Sender: TObject);
begin
  _Editor.OpenProject;
end;

procedure TMainForm.miPrintClick(Sender: TObject);
begin
  _Editor.Print;
end;

procedure TMainForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.miEditorClick(Sender: TObject);
begin
  _Editor.Show;
end;

procedure TMainForm.miRAMClick(Sender: TObject);
begin
  _RAM.Show;
end;

procedure TMainForm.miRegisterClick(Sender: TObject);
begin
  _Register.Show;
end;

procedure TMainForm.miStackClick(Sender: TObject);
begin
  _Stack.Show;
end;

procedure TMainForm.miIPortClick(Sender: TObject);
begin
  _IPort.Show;
end;

procedure TMainForm.miOPortClick(Sender: TObject);
begin
  _OPort.Show;
end;

procedure TMainForm.miWatchClick(Sender: TObject);
begin
  _Watch.Show;
end;

procedure TMainForm.miDisassemblerClick(Sender: TObject);
begin
  _DisAssembler.Show;
end;

procedure TMainForm.miOctalClick(Sender: TObject);
begin
  _View.Radix:= rOctal;
  _i8008.RefreshAllObjects;
end;

procedure TMainForm.miDecimalClick(Sender: TObject);
begin
  _View.Radix:= rDecimal;
  _i8008.RefreshAllObjects;
end;

procedure TMainForm.miDecimalNegClick(Sender: TObject);
begin
  _View.Radix:= rDecimalNeg;
  _i8008.RefreshAllObjects;
end;

procedure TMainForm.miHexadecimalClick(Sender: TObject);
begin
  _View.Radix:= rHexadecimal;
  _i8008.RefreshAllObjects;
end;

procedure TMainForm.miBinaryClick(Sender: TObject);
begin
  _View.Radix:= rBinary;
  _i8008.RefreshAllObjects;
end;

procedure TMainForm.miSplitClick(Sender: TObject);
begin
  miSplit.Checked:= not miSplit.Checked;
  if miSplit.Checked then
    _View.View:= vShort
  else
    _View.View:= vLong;
  _i8008.RefreshAllObjects;
end;

procedure TMainForm.miASMProgressClick(Sender: TObject);
begin
  miASMProgress.Checked:= not miASMProgress.Checked;
  _Editor.ShowProgress(miASMProgress.Checked);
end;

procedure TMainForm.miGermanClick(Sender: TObject);
begin
  setLanguage(lGerman);
  _LanguageList.Update;
end;

procedure TMainForm.miEnglishClick(Sender: TObject);
begin
  setLanguage(lEnglish);
  _LanguageList.Update;
end;

procedure TMainForm.miUseRegistryClick(Sender: TObject);
begin
  miUseRegistry.Checked:= not miUseRegistry.Checked;
end;

procedure TMainForm.miAssembleClick(Sender: TObject);
begin
  _Program.Clear;
  _Editor.AProgram:= _Program;
  _Editor.Assemble;
end;

procedure TMainForm.miResetRAMClick(Sender: TObject);
begin
  _i8008.ResetRAM;
  _Editor.AProgram:= nil;  
end;

procedure TMainForm.miResetStackClick(Sender: TObject);
begin
  _i8008.ResetStack;
  _i8008.ResetStackPointer;
end;

procedure TMainForm.miResetRegisterFlagsClick(Sender: TObject);
begin
  _i8008.ResetRegister;
  _i8008.ResetFlags;
end;

procedure TMainForm.miResetIPortClick(Sender: TObject);
begin
  _i8008.ResetIPorts;
end;

procedure TMainForm.miResetOPortClick(Sender: TObject);
begin
  _i8008.ResetOPorts;
end;

procedure TMainForm.miResetProcessorClick(Sender: TObject);
begin
  _i8008.ReturnFromHLT;
end;

procedure TMainForm.miResetAllClick(Sender: TObject);
begin
  _i8008.ResetAll;
  _Editor.AProgram:= nil;
end;

procedure TMainForm.miStartClick(Sender: TObject);
begin
  if _isRunning then
    _Editor.Stop
  else
    _Editor.Start;
end;

procedure TMainForm.miSingleStepClick(Sender: TObject);
begin
  _Editor.SingleStep;
end;

procedure TMainForm.miIOEditorClick(Sender: TObject);
var
  Dir, Command: String;
begin
  Dir:= ExtractFileDir(ParamStr(0));
  if Length(Dir) > 0 then
    if Dir[Length(Dir)] <> '\' then
      Dir:= Dir+'\';
  Command:= '-nofile';
  case getLanguage of
    lGerman  : Command:= Command+' -lger';
    lEnglish : Command:= Command+' -leng';
  end;
  case _View.Radix of
    rOctal       : Command:= Command+' -roct';
    rDecimal     : Command:= Command+' -rdec';
    rHexadecimal : Command:= Command+' -rhex';
    rBinary      : Command:= Command+' -rbin';
  end;
  if ShellExecute(Handle,'open','IOEdit.exe',PChar(Command),PChar(Dir),SW_NORMAL) <= 32 then
    MessageDlg(getString(rs_msg_Execute),mtError,[mbOk],0);
end;

procedure TMainForm.miStopClick(Sender: TObject);
begin
  _Editor.Stop;
end;

procedure TMainForm.miHelpClick(Sender: TObject);
var
  Directory: String;
begin
  Directory:= ExtractFileDir(ParamStr(0));
  if Directory[Length(Directory)] <> '\' then
    Directory:= Directory+'\';
  case getLanguage of
    lGerman  : Directory:= Directory+'help\german';
    lEnglish : Directory:= Directory+'help\english';
  end;
  ShellExecute(Handle,'open','index.html',nil,PChar(Directory),SW_MAXIMIZE);
end;

procedure TMainForm.miInfoClick(Sender: TObject);
var
  InfoForm: TInfoForm;
begin
  InfoForm:= TInfoForm.Create(Self);
  InfoForm.ShowInfo;
  InfoForm.Free;
end;

procedure TMainForm.Sim8008DdeServerItemPokeData(Sender: TObject);
var
  Data: String;
  iPos: Integer;
begin
  // Receive Data
  Data:= Sim8008DdeServerItem.Text;
  iPos:= Pos(':',Data);
  if iPos > 0 then
    begin
      if Copy(Data,1,iPos) = 'open:' then
        begin
          Data:= Copy(Data,iPos+1,Length(Data)-iPos);
          if FileExists(Data) then
            begin
              Open(Data);
              _Editor.Show;
            end;
          Application.BringToFront;
        end;
    end;
end;

procedure TMainForm.AssembleRequest(Sender: TObject);
begin
  _Program.Clear;
  _Editor.AProgram:= _Program;
  _Editor.Assemble;
end;

procedure TMainForm.AfterAssemble(Sender: TObject);
begin
  _i8008.Load(_Program);
end;

procedure TMainForm.OnSingleStepEnabled(Sender: TObject; Enabled: Boolean);
begin
  { Menu - File              }
  miNewFile.Enabled:= not Enabled;
  miNewProject.Enabled:= not Enabled;
  miFileOpen.Enabled:= not Enabled;
  miSave.Enabled:= not Enabled;
  miFileSaveAs.Enabled:= not Enabled;
  miProjectSaveAs.Enabled:= not Enabled;
  miProjectOpen.Enabled:= not Enabled;
  miPrint.Enabled:= not Enabled;
  miClose.Enabled:= not Enabled;
  tbFileOpen.Enabled:= not Enabled;
  tbProjectOpen.Enabled:= not Enabled;
  tbSave.Enabled:= not Enabled;
  tbProjectSaveAs.Enabled:= not Enabled;
  tbFileSaveAs.Enabled:= not Enabled;
  { Menu - Project           }
  miAssemble.Enabled:= not Enabled;
  miResetRAM.Enabled:= not Enabled;
  miResetAll.Enabled:= not Enabled;
  tbAssemble.Enabled:= not Enabled;
  tbResetRAM.Enabled:= not Enabled;
  { Menu - Setup             }
  miGerman.Enabled:= not Enabled;
  miEnglish.Enabled:= not Enabled;
  { Toolbar                  }
  eeTimer.Enabled:= not Enabled;
end;

procedure TMainForm.OnRunningEnabled(Sender: TObject; Enabled: Boolean);
begin
  { Menu - File              }
  miNewFile.Enabled:= not Enabled;
  miNewProject.Enabled:= not Enabled;
  miFileOpen.Enabled:= not Enabled;
  miSave.Enabled:= not Enabled;
  miFileSaveAs.Enabled:= not Enabled;
  miProjectSaveAs.Enabled:= not Enabled;
  miProjectOpen.Enabled:= not Enabled;
  miPrint.Enabled:= not Enabled;
  miClose.Enabled:= not Enabled;
  tbFileOpen.Enabled:= not Enabled;
  tbProjectOpen.Enabled:= not Enabled;
  tbSave.Enabled:= not Enabled;
  tbProjectSaveAs.Enabled:= not Enabled;
  tbFileSaveAs.Enabled:= not Enabled;
  { Menu - Project           }
  miAssemble.Enabled:= not Enabled;
  miResetRAM.Enabled:= not Enabled;
  miResetAll.Enabled:= not Enabled;
  tbAssemble.Enabled:= not Enabled;
  tbResetRAM.Enabled:= not Enabled;
  { Menu - Setup             }
  miGerman.Enabled:= not Enabled;
  miEnglish.Enabled:= not Enabled;
  { Menu - Start             }
  miSingleStep.Enabled:= not Enabled;
  tbSingleStep.Enabled:= not Enabled;
  miStop.Enabled:= not Enabled;
  tbStop.Enabled:= not Enabled;
  if Enabled then
    begin
      miStart.ImageIndex:= _ImageStop;
      miStart.Caption:= 'Stop';
      tbStart.ImageIndex:= _ImageStop;
      tbStart.Hint:= 'Stop';
      _isRunning:= true;
    end
  else
    begin
      miStart.ImageIndex:= _ImageStart;
      miStart.Caption:= 'Start';
      tbStart.ImageIndex:= _ImageStart;
      tbStart.Hint:= getString(rs_m_Start);
      _isRunning:= false;      
    end;
  { Toolbar                  }
  eeTimer.Enabled:= not Enabled;
end;

procedure TMainForm.OnLoadProject(Stream: TStream; var Check: Boolean);
begin
  if Check and Assigned(Stream) then
    try
      Check:= _i8008.LoadFromStream(Stream);
    except
      Check:= false;
    end
  else
    Check:= false;
end;

procedure TMainForm.OnLoadProgram(Stream: TStream; var Check: Boolean);
begin
  if Assigned(Stream) then
    try
      Check:= Check and _Program.LoadFromStream(Stream);
      if Check then
        _Editor.AProgram:= _Program
      else
        _Editor.AProgram:= nil;
    except
      Check:= false;
    end
  else
    Check:= false;
end;

procedure TMainForm.OnSaveProject(Stream: TStream; var Check: Boolean);
begin
  if Check and Assigned(Stream) then
    try
      Check:= _i8008.SaveToStream(Stream);
    except
      Check:= false;
    end
  else
    Check:= false;
end;

procedure TMainForm.OnSaveProgram(Stream: TStream; var Check: Boolean);
begin
  if Check and Assigned(Stream) then
    try
      Check:= _Program.SaveToStream(Stream);
    except
      Check:= false;
    end
  else
    Check:= false;
end;

procedure TMainForm.LoadData(RegistryList: TRegistryList);
var
  Language, eLeft, eWidth, Radix: Integer;
  Filename: String;
begin
  miUseRegistry.Checked:= RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false);
  if miUseRegistry.Checked then
    begin
      // Load Language Settings
      if RegistryList.Registry.ValueExists('Language') then
        begin
          Language:= RegistryList.Registry.ReadInteger('Language');
          case Language of
            0: begin
                 setLanguage(lGerman);
                 _LanguageList.Update;
               end;
            1: begin
                 setLanguage(lEnglish);
                 _LanguageList.Update;
               end;
          end;
        end;
      // Load Radix Settings
      if RegistryList.Registry.ValueExists('Radix') then
        begin
          Radix:= RegistryList.Registry.ReadInteger('Radix');
          case Radix of
            0: begin
                 _View.Radix:= rDecimal;
                 _i8008.RefreshAllObjects;
               end;
            1: begin
                 _View.Radix:= rDecimalNeg;
                 _i8008.RefreshAllObjects;
               end;
            2: begin
                 _View.Radix:= rOctal;
                 _i8008.RefreshAllObjects;
               end;
            3: begin
                 _View.Radix:= rHexadecimal;
                 _i8008.RefreshAllObjects;
               end;
            4: begin
                 _View.Radix:= rBinary;
                 _i8008.RefreshAllObjects;
               end;
          end;
        end;
      // Load View Settings
      if RegistryList.Registry.ValueExists('Split') then
        begin
          if RegistryList.Registry.ReadInteger('Split') = 1 then
            begin
              _View.View:= vShort;
              _i8008.RefreshAllObjects;
            end
          else
            begin
              _View.View:= vLong;
              _i8008.RefreshAllObjects;
            end;
        end;
      // Load Assembler Progress Settings  
      if RegistryList.Registry.ValueExists('ASMProgress') then
        begin
          miASMProgress.Checked:= RegistryList.Registry.ReadInteger('ASMProgress') = 1;
          _Editor.ShowProgress(miASMProgress.Checked);
        end;
      // Load Open File/Project
      if RegistryList.Registry.ValueExists('Opened') then
        begin
          Filename:= RegistryList.Registry.ReadString('Opened');
          if Filename <> '' then
            _Editor.Open(Filename);
        end;
      // Load Form Settings
      RegistryList.LoadFormSettings(Self,true);
    end
  else
    begin // Default
      eLeft:= _RAM.Show(Height+1);
      eWidth:= eLeft + _Register.Show(Height+1);
      _Editor.Show(Height+1, eLeft+10,
                   Screen.Width-eWidth-20, Screen.Height-3*Height);
    end;
end;

procedure TMainForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    begin
      // Save Language Settings
      case getLanguage of
        lGerman  : RegistryList.Registry.WriteInteger('Language',0);
        lEnglish : RegistryList.Registry.WriteInteger('Language',1);
      end;
      // Save Radix Settings
      case _View.Radix of
        rDecimal     : RegistryList.Registry.WriteInteger('Radix',0);
        rDecimalNeg  : RegistryList.Registry.WriteInteger('Radix',1);
        rOctal       : RegistryList.Registry.WriteInteger('Radix',2);
        rHexadecimal : RegistryList.Registry.WriteInteger('Radix',3);
        rBinary      : RegistryList.Registry.WriteInteger('Radix',4);
      end;
      // Save View Settings
      case _View.View of
        vShort : RegistryList.Registry.WriteInteger('Split',1);
        vLong  : RegistryList.Registry.WriteInteger('Split',0);
      end;
      // Save Assembler Progress Settings
      if miASMProgress.Checked then
        RegistryList.Registry.WriteInteger('ASMProgress',1)
      else
        RegistryList.Registry.WriteInteger('ASMProgress',0);
      // Save Open File/Project
      RegistryList.Registry.WriteString('Opened',_Editor.Filename);
      // Save Form Settings
      RegistryList.SaveFormSettings(Self,true);
    end;
end;

procedure TMainForm.Open(Filename: TFilename);
begin
  _Editor.Open(Filename);
end;

procedure TMainForm.LoadRegistry;
begin
  // Read Registry Data
  if Assigned(_RegistryList) then
    _RegistryList.LoadData;
end;

procedure TMainForm.LoadLanguage;
begin
  miGerman.Checked:= getLanguage = lGerman;
  miEnglish.Checked:= getLanguage = lEnglish;
  { Menu - File              }
  miFile.Caption:= getString(rs_m_File);
  miNew.Caption:= getString(rs_m_New);
  miNewFile.Caption:= getString(rs_m_SourceCode);
  miNewProject.Caption:= getString(rs_m_Project);
  miFileOpen.Caption:= getString(rs_m_Open)+' ...';
  miSave.Caption:= getString(rs_m_Save);
  miFileSaveAs.Caption:= getString(rs_m_SaveAs)+' ...';
  miProjectSaveAs.Caption:= getString(rs_m_ProjectSaveAs)+' ...';
  miProjectOpen.Caption:= getString(rs_m_ProjectOpen)+' ...';
  miPrint.Caption:= getString(rs_m_Print)+' ...';
  miClose.Caption:= getString(rs_m_Close);
  { Menu - View              }
  miView.Caption:= getString(rs_m_View);
  miWatch.Caption:= getString(rs_m_Watch);
  { Menu - Setup             }
  miSetup.Caption:= getString(rs_m_Setup);
  miRadix.Caption:= getString(rs_m_Radix);
  miOctal.Caption:= getString(rs_m_Octal);
  miDecimal.Caption:= getString(rs_m_Decimal);
  miHexadecimal.Caption:= getString(rs_m_Hexadecimal);
  miBinary.Caption:= getString(rs_m_Binary);
  miSplit.Caption:= getString(rs_m_Split);
  miASMProgress.Caption:= getString(rs_m_ASMProgress);
  miLanguage.Caption:= getString(rs_m_Language);
  miUseRegistry.Caption:= getString(rs_m_UseRegistry);
  { Menu - Project           }
  miProject.Caption:= getString(rs_m_Project);
  miAssemble.Caption:= getString(rs_m_Assemble);
  miResetRAM.Caption:= getString(rs_m_ResetRAM);
  miResetStack.Caption:= getString(rs_m_ResetStack);
  miResetRegisterFlags.Caption:= getString(rs_m_ResetRegisterFlags);
  miResetIPort.Caption:= getString(rs_m_ResetIPort);
  miResetOPort.Caption:= getString(rs_m_ResetOPort);
  miResetProcessor.Caption:= getString(rs_m_ReturnFromHLT);
  miResetAll.Caption:= getString(rs_m_ResetAll);
  { Menu - Start             }
  miMStart.Caption:= getString(rs_m_Start);
  miSingleStep.Caption:= getString(rs_m_Singlestep);
  { Menu - Help              }
  miHelp.Caption:= getString(rs_m_Help);
  miHelp2.Caption:= getString(rs_m_Help)+' ...';
  { Toolbar                  }
  tbFile.Caption:= getString(rs_m_File);
  tbHelp.Caption:= getString(rs_m_Help);
  LblTimer.Caption:= getString(rs_m_Timer);
  tbTimer.Caption:= getString(rs_m_Timer);
  tbFileOpen.Hint:= getString(rs_m_Open)+' ...';
  tbSave.Hint:= getString(rs_m_Save);
  tbFileSaveAs.Hint:= getString(rs_m_SaveAs)+' ...';
  tbProjectSaveAs.Hint:= getString(rs_m_ProjectSaveAs)+' ...';
  tbProjectOpen.Hint:= getString(rs_m_ProjectOpen)+' ...';
  tbEditor.Hint:= 'Editor';
  tbAssemble.Hint:= getString(rs_m_Assemble);
  tbStart.Hint:= getString(rs_m_Start);
  tbSingleStep.Hint:= getString(rs_m_Singlestep);
  tbStop.Hint:= 'Stop';
  tbResetRAM.Hint:= getString(rs_m_ResetRAM);
  tbResetStack.Hint:= getString(rs_m_ResetStack);
  tbResetRegisterFlags.Hint:= getString(rs_m_ResetRegisterFlags);
  tbResetIPort.Hint:= getString(rs_m_ResetIPort);
  tbResetOPort.Hint:= getString(rs_m_ResetOPort);
  tbResetProcessor.Hint:= getString(rs_m_ReturnFromHLT);
  tbHelp.Hint:= getString(rs_m_Help)+' ...';
end;

procedure TMainForm.RadixChange(Radix: TRadix; View: TView);
begin
  miOctal.Checked:= Radix = rOctal;
  miDecimal.Checked:= Radix = rDecimal;
  miDecimalNeg.Checked:= Radix = rDecimalNeg;
  miHexadecimal.Checked:= Radix = rHexadecimal;
  miBinary.Checked:= Radix = rBinary;
  miSplit.Checked:= View = vShort;
end;

end.
