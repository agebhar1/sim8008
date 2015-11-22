unit uDisAssemblerForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uResourceStrings, uView, uDisAssembler, uProcessor, StdCtrls,
  ExtCtrls, Menus, EnhCtrls, uMisc, Registry;

type
  TProgramCounterUpdateRequestEvent = procedure(Address: Word) of object;

  TDisAssemblerForm = class(TForm, ILanguage, IRadixView, IProgramCounter, IProcessor, IRAM, IRegistry)
    pDisAssemble: TPanel;
    pCode0: TPanel;
    pCode1: TPanel;
    pCode2: TPanel;
    pCode3: TPanel;
    pCode4: TPanel;
    pCode5: TPanel;
    LblSourcecode: TLabel;
    Label1: TLabel;
    iArrow: TImage;
    bDivider: TBevel;
    Label2: TLabel;
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miStayOnTop: TMenuItem;
    eePC: TEnhancedEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure ePCKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ePCClick(Sender: TObject);
  private
    _pCodes: array [0..6] of TPanel;
    _DisAssembler: Ti8008DisAssembler;
    _SourceCode: TStringList;
    _Radix: TRadix;
    _View: TView;
    _ProgramCounterUpdateRequest: TProgramCounterUpdateRequestEvent;
    procedure ShowSourceCode;
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);
    procedure PCUpdate(Sender: TObject; Value: Word);
    procedure BeforeCycle(Sender: TObject);
    procedure AfterCycle(Sender: TObject);
    procedure StateChange(Sender: TObject; Halt: Boolean);
    procedure RAMUpdate(Sender: TObject; Address: Word; Value: Byte);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
    procedure setProcessor(Value: Ti8008Processor);
    function getProcessor: Ti8008Processor;
  public
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);
    property Processor: Ti8008Processor read getProcessor write setProcessor;
    property OnProgramCounterUpdateRequest: TProgramCounterUpdateRequestEvent read _ProgramCounterUpdateRequest write _ProgramCounterUpdateRequest;
  end;

var
  DisAssemblerForm: TDisAssemblerForm;

implementation

uses uEditForm;

{$R *.dfm}

procedure TDisAssemblerForm.FormCreate(Sender: TObject);
begin
  _Radix:= rOctal;
  _View:= vShort;
  _DisAssembler:= Ti8008DisAssembler.Create;
  _SourceCode:= TStringList.Create;
  _pCodes[0]:= pCode0;
  _pCodes[1]:= pCode1;
  _pCodes[2]:= pCode2;
  _pCodes[3]:= pCode3;
  _pCodes[4]:= pCode4;
  _pCodes[5]:= pCode5;
  AutoSize:= true;
  LoadLanguage;
end;

procedure TDisAssemblerForm.FormDestroy(Sender: TObject);
begin
  _SourceCode.Free;
  _DisAssembler.Free;
end;

procedure TDisAssemblerForm.ePCClick(Sender: TObject);
var
  C: Boolean;
  P: TPoint;
begin
  if (Sender is TEnhancedEdit) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= RadixToWord((Sender as TEnhancedEdit).Text,_Radix,_View,C);
      if (EditForm.ShowModal(_Radix,_View,14,P) = mrOk) and Assigned(OnProgramCounterUpdateRequest) then
        OnProgramCounterUpdateRequest(EditForm.Value);
    end;
end;

procedure TDisAssemblerForm.ePCKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ePCClick(Sender);
end;

procedure TDisAssemblerForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDisAssemblerForm.miStayOnTopClick(Sender: TObject);
begin
  if miStayOnTop.Checked then
    FormStyle:= fsNormal
  else
    FormStyle:= fsStayOnTop;
  miStayOnTop.Checked:= not miStayOnTop.Checked;
end;

procedure TDisAssemblerForm.ShowSourceCode;
var
  i: Byte;
begin
  _DisAssembler.Disassemble(_SourceCode);
  for i:= 0 to High(_pCodes)-1 do
    _pCodes[i].Caption:= _SourceCode.Strings[i];
end;

procedure TDisAssemblerForm.RefreshObject(Sender: TObject);
begin
  if Sender is Ti8008Stack then
    eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,_Radix,_View,14);
  ShowSourceCode;
end;

procedure TDisAssemblerForm.Reset(Sender: TObject);
begin
  if Sender is Ti8008Stack then
    eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,_Radix,_View,14);
  ShowSourceCode;
end;

procedure TDisAssemblerForm.PCUpdate(Sender: TObject; Value: Word);
begin
  if Sender is Ti8008Stack then
    eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,_Radix,_View,14);
  ShowSourceCode;
end;

procedure TDisAssemblerForm.BeforeCycle(Sender: TObject);
begin
  ShowSourceCode;
end;

procedure TDisAssemblerForm.AfterCycle(Sender: TObject);
begin
end;

procedure TDisAssemblerForm.StateChange(Sender: TObject; Halt: Boolean);
begin
end;

procedure TDisAssemblerForm.RAMUpdate(Sender: TObject; Address: Word; Value: Byte);
begin
  ShowSourceCode;
end;

procedure TDisAssemblerForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false) then
    RegistryList.LoadFormSettings(Self,false);
end;

procedure TDisAssemblerForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    RegistryList.SaveFormSettings(Self,false);
end;

procedure TDisAssemblerForm.setProcessor(Value: Ti8008Processor);
begin
  _DisAssembler.Processor:= Value;
end;

function TDisAssemblerForm.getProcessor: Ti8008Processor;
begin
  result:= _DisAssembler.Processor;
end;

procedure TDisAssemblerForm.LoadLanguage;
begin
  LblSourcecode.Caption:= getString(rsSourcecode);
end;

procedure TDisAssemblerForm.RadixChange(Radix: TRadix; View: TView);
begin
  if Radix = rDecimalNeg then Radix:= rDecimal;
  _Radix:= Radix;
  _View:= View;
  _DisAssembler.Radix:= Radix;
  _DisAssembler.View:= View;
end;

end.
