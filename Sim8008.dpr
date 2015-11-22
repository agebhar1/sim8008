program Sim8008;

uses
  Forms,
  Windows,
  SysUtils,
  DdeMan,
  uMainForm in 'uMainForm.pas' {MainForm},
  uASMProgress in '..\shared\uASMProgress.pas' {ASMProgressForm},
  uAssembler in '..\shared\uAssembler.pas',
  uDisAssembler in '..\shared\uDisAssembler.pas',
  uDisAssemblerForm in 'uDisAssemblerForm.pas' {DisAssemblerForm},
  uEditForm in '..\shared\uEditForm.pas' {EditForm},
  uEditorForm in 'uEditorForm.pas' {EditorForm},
  uIOPortForm in 'uIOPortForm.pas' {IOPortForm},
  uMisc in '..\shared\uMisc.pas',
  uProcessor in '..\shared\uProcessor.pas',
  uRAMForm in 'uRAMForm.pas' {RAMForm},
  uRegisterForm in 'uRegisterForm.pas' {RegisterForm},
  uResourceStrings in '..\shared\uResourceStrings.pas',
  uStackForm in 'uStackForm.pas' {StackForm},
  uTimer in '..\shared\uTimer.pas',
  uView in '..\shared\uView.pas',
  uWatchForm in 'uWatchForm.pas' {WatchForm},
  uInfoForm in 'uInfoForm.pas' {InfoForm},
  uFileVersion in '..\shared\uFileVersion.pas',
  uSynHighlighteri8008ASM in 'uSynHighlighteri8008ASM.pas';

{$R *.res}

var
  Splash: TInfoForm;
  Mutex: THandle;
  DdeClientConv: TDdeClientConv;
  DdeClientItem: TDdeClientItem;

begin
  Mutex:= CreateMutex(nil,true,'Sim8008-V2');
  if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      DdeClientConv:= TDdeClientConv.Create(nil);
      DdeClientConv.ConnectMode:= ddeManual;
      DdeClientItem:= TDdeClientItem.Create(nil);
      DdeClientItem.DdeConv:= DdeClientConv;
      // Send Data
      if DdeClientConv.SetLink('Sim8008',MAIN_TITLE) then
        begin
          DdeClientItem.DdeItem:= 'Sim8008DdeServerItem';
          DdeClientConv.OpenLink;
          if ParamCount > 0 then
            DdeClientConv.PokeData(DdeClientItem.DdeItem,PChar('open:'+ParamStr(1)))
          else
            DdeClientConv.PokeData(DdeClientItem.DdeItem,'open:');
        end;
      DdeClientItem.DdeConv:= nil;
      DdeClientItem.Free;
      DdeClientConv.Free;
    end
  else
    begin
      Application.Initialize;
      Application.Title := 'Sim 8008';
      Application.CreateForm(TMainForm, MainForm);
      Application.CreateForm(TEditForm, EditForm);
      Splash:= TInfoForm.Create(nil);
      Splash.ShowSplash;
      Splash.Free;
      MainForm.LoadRegistry;
      if ParamCount > 0 then
        MainForm.Open(ParamStr(1));
      Application.Run;
      ReleaseMutex(Mutex);
    end;
end.
