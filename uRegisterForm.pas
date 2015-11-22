unit uRegisterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uResourceStrings, uView, uProcessor, Menus,
  EnhCtrls, Registry, uMisc;

type

  TProgramCounterUpdateRequestEvent = procedure(Address: Word) of object;

  TRegisterUpdateRequestEvent = procedure(Index: Byte; Value: Byte) of object;

  TFlagUpdateRequestEvent = procedure(Flag: TFlag; Value: Boolean) of object;

  TReturnFromHaltRequestEvent = procedure of object;

  TRegisterForm = class(TForm, ILanguage, IRadixView, IRegister, IFlags, IProgramCounter, IProcessor, IRegistry)
    pRegister: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    pFlags: TPanel;
    Label9: TLabel;
    cbCarry: TCheckBox;
    cbZero: TCheckBox;
    cbParity: TCheckBox;
    cbSign: TCheckBox;
    Label10: TLabel;
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miStayOnTop: TMenuItem;
    eeRegister0: TEnhancedEdit;
    eeRegister1: TEnhancedEdit;
    eeRegister2: TEnhancedEdit;
    eeRegister3: TEnhancedEdit;
    eeRegister4: TEnhancedEdit;
    eeRegister5: TEnhancedEdit;
    eeRegister6: TEnhancedEdit;
    eeRegister7: TEnhancedEdit;
    pProgramcounter: TPanel;
    Label11: TLabel;
    eePC: TEnhancedEdit;
    Panel1: TPanel;
    cbHalt: TCheckBox;
    LblProcessorState: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure RegisterChange(Sender: TObject);
    procedure eRegisterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbCarryClick(Sender: TObject);
    procedure cbParityClick(Sender: TObject);
    procedure cbSignClick(Sender: TObject);
    procedure cbZeroClick(Sender: TObject);
    procedure eePCClick(Sender: TObject);
    procedure eePCKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbHaltClick(Sender: TObject);
  private
    _Block: Boolean;
    _BlockHLT: Boolean;
    _Radix: TRadix;
    _View: TView;
    _RegisterUpdateRequest: TRegisterUpdateRequestEvent;
    _FlagUpdateRequest: TFlagUpdateRequestEvent;
    _ProgramCounterUpdateRequest: TProgramCounterUpdateRequestEvent;
    _ReturnFromHaltRequest: TReturnFromHaltRequestEvent;
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);
    procedure RegisterUpdate(Sender: TObject; Index: Byte; Value: Byte);
    procedure RegisterReset(Sender: TObject; Index: Byte);
    procedure CarryFlagUpdate(Sender: TObject; Value: Boolean);
    procedure SignFlagUpdate(Sender: TObject; Value: Boolean);
    procedure ZeroFlagUpdate(Sender: TObject; Value: Boolean);
    procedure ParityFlagUpdate(Sender: TObject; Value: Boolean);
    procedure PCUpdate(Sender: TObject; Value: Word);
    procedure BeforeCycle(Sender: TObject);
    procedure AfterCycle(Sender: TObject);
    procedure StateChange(Sender: TObject; Halt: Boolean);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
  public
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);
    function Show(ATop: Integer): Integer; overload;
    property OnRegisterUpdateRequest: TRegisterUpdateRequestEvent read _RegisterUpdateRequest write _RegisterUpdateRequest;
    property OnFlagUpdateRequest: TFlagUpdateRequestEvent read _FlagUpdateRequest write _FlagUpdateRequest;
    property OnProgramCounterUpdateRequest: TProgramCounterUpdateRequestEvent read _ProgramCounterUpdateRequest write _ProgramCounterUpdateRequest;
    property OnReturnFromHaltRequest: TReturnFromHaltRequestEvent read _ReturnFromHaltRequest write _ReturnFromHaltRequest;
  end;

var
  RegisterForm: TRegisterForm;

implementation

uses uEditForm;

{$R *.dfm}

procedure TRegisterForm.FormCreate(Sender: TObject);
begin
  _Block:= false;
  _BlockHLT:= false;
  _Radix:= rOctal;
  _View:= vShort;
  AutoSize:= true;
  LoadLanguage;
end;

procedure TRegisterForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TRegisterForm.miStayOnTopClick(Sender: TObject);
begin
  if miStayOnTop.Checked then
    FormStyle:= fsNormal
  else
    FormStyle:= fsStayOnTop;
  miStayOnTop.Checked:= not miStayOnTop.Checked;
end;

procedure TRegisterForm.RegisterChange(Sender: TObject);
var
  result: Integer;
  C: Boolean;
  P: TPoint;
begin
  if (Sender is TEnhancedEdit) then begin
    P.X:= Mouse.CursorPos.X;
    P.Y:= Mouse.CursorPos.Y;
    if (_Radix = rDecimalNeg) and ((Sender as TEnhancedEdit).TabOrder in [5, 6]) then begin
      EditForm.Value:= RadixToWord((Sender as TEnhancedEdit).Text,rDecimal,vLong,C);
      result:= EditForm.ShowModal(rDecimal,vLong,8,P);
    end else begin
      EditForm.Value:= RadixToWord((Sender as TEnhancedEdit).Text,_Radix,vLong,C);
      result:= EditForm.ShowModal(_Radix,vLong,8,P);
    end;
    if (result = mrOk) and Assigned(OnRegisterUpdateRequest) then
      OnRegisterUpdateRequest((Sender as TEnhancedEdit).TabOrder,EditForm.Value);
  end;
end;

procedure TRegisterForm.eRegisterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    RegisterChange(Sender);
end;

procedure TRegisterForm.cbCarryClick(Sender: TObject);
begin
  _Block:= true;
  if Assigned(OnFlagUpdateRequest) then
    OnFlagUpdateRequest(fCarry,cbCarry.Checked);
  _Block:= false;
end;

procedure TRegisterForm.cbParityClick(Sender: TObject);
begin
  _Block:= true;
  if Assigned(OnFlagUpdateRequest) then
    OnFlagUpdateRequest(fParity,cbParity.Checked);
  _Block:= false;
end;

procedure TRegisterForm.cbSignClick(Sender: TObject);
begin
  _Block:= true;
  if Assigned(OnFlagUpdateRequest) then
    OnFlagUpdateRequest(fSign,cbSign.Checked);
  _Block:= false;
end;

procedure TRegisterForm.cbZeroClick(Sender: TObject);
begin
  _Block:= true;
  if Assigned(OnFlagUpdateRequest) then
    OnFlagUpdateRequest(fZero,cbZero.Checked);
  _Block:= false;
end;

procedure TRegisterForm.eePCClick(Sender: TObject);
var
  C: Boolean;
  P: TPoint;
begin
  if (Sender is TEnhancedEdit) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      if _Radix = rDecimalNeg then begin
        EditForm.Value:= RadixToWord((Sender as TEnhancedEdit).Text,rDecimal,_View,C);
        if (EditForm.ShowModal(rDecimal,_View,14,P) = mrOk) and Assigned(OnProgramCounterUpdateRequest) then
          OnProgramCounterUpdateRequest(EditForm.Value);
      end else begin
        EditForm.Value:= RadixToWord((Sender as TEnhancedEdit).Text,_Radix,_View,C);
        if (EditForm.ShowModal(_Radix,_View,14,P) = mrOk) and Assigned(OnProgramCounterUpdateRequest) then
          OnProgramCounterUpdateRequest(EditForm.Value);
      end;
    end;
end;

procedure TRegisterForm.eePCKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    eePCClick(Sender);
end;

procedure TRegisterForm.cbHaltClick(Sender: TObject);
begin
  if not _BlockHLT and Assigned(OnReturnFromHaltRequest) then
    OnReturnFromHaltRequest;
end;

procedure TRegisterForm.RefreshObject(Sender: TObject);
var
  i: Byte;
begin
  if Sender is Ti8008Register then
    begin
      for i:= 0 to (Sender as Ti8008Register).Count-1 do begin
        if (i in [5, 6]) and (_Radix = rDecimalNeg) then
             (FindComponent('eeRegister'+IntToStr(i)) as TEnhancedEdit).Text:= WordToRadix(
                                                                               (Sender as Ti8008Register).Value[i],
                                                                               rDecimal,
                                                                               vLong,
                                                                               8)
        else (FindComponent('eeRegister'+IntToStr(i)) as TEnhancedEdit).Text:= WordToRadix(
                                                                               (Sender as Ti8008Register).Value[i],
                                                                               _Radix,
                                                                               vLong,
                                                                               8);
      end;
    end
  else
    if (Sender is Ti8008Flags) and not _Block then
      begin
       cbCarry.Checked:= (Sender as Ti8008Flags).Carry;
       cbSign.Checked:= (Sender as Ti8008Flags).Sign;
       cbZero.Checked:= (Sender as Ti8008Flags).Zero;
       cbParity.Checked:= (Sender as Ti8008Flags).Parity;
      end
    else
      if Sender is Ti8008Stack then begin
        if _Radix = rDecimalNeg then  eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,rDecimal,_View,14)
        else eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,_Radix,_View,14);
      end;
end;

procedure TRegisterForm.Reset(Sender: TObject);
var
  i: Byte;
  Edit: TEnhancedEdit;
begin
  if Sender is Ti8008Register then
    begin
      for i:= 0 to (Sender as Ti8008Register).Count-1 do begin
        Edit:= FindComponent('eeRegister'+IntToStr(i)) as TEnhancedEdit;
        if (i in [5, 6]) and (_Radix = rDecimalNeg) then Edit.Text:= WordToRadix((Sender as Ti8008Register).Value[i],rDecimal,vLong,8)
        else Edit.Text:= WordToRadix((Sender as Ti8008Register).Value[i], _Radix,vLong,8);
        Edit.Font.Color:= clWindowText;
      end;
    end
  else
    if (Sender is Ti8008Flags) and not _Block then
      begin
        cbCarry.Checked:= (Sender as Ti8008Flags).Carry;
        cbCarry.Font.Color:= clWindowText;
        cbSign.Checked:= (Sender as Ti8008Flags).Sign;
        cbSign.Font.Color:= clWindowText;
        cbZero.Checked:= (Sender as Ti8008Flags).Zero;
        cbZero.Font.Color:= clWindowText;
        cbParity.Checked:= (Sender as Ti8008Flags).Parity;
        cbParity.Font.Color:= clWindowText;
      end;
end;

procedure TRegisterForm.RegisterUpdate(Sender: TObject; Index: Byte; Value: Byte);
var
  Edit: TEnhancedEdit;
  Text: String;
begin
  Edit:= FindComponent('eeRegister'+IntToStr(Index)) as TEnhancedEdit;
  if (_Radix = rDecimalNeg) and (Index in [5, 6]) then Text:= WordToRadix(Value,rDecimal,vLong,8)
  else Text:= WordToRadix(Value,_Radix,vLong,8);
  if Text <> Edit.Text then Edit.Font.Color:= clRed;
  Edit.Text:= Text;
end;

procedure TRegisterForm.RegisterReset(Sender: TObject; Index: Byte);
var
  Edit: TEnhancedEdit;
begin
  if (Sender is Ti8008Register) and (Index in [0..7]) then begin
    Edit:= FindComponent('eeRegister'+IntToStr(Index)) as TEnhancedEdit;
    if Assigned(Edit) then begin
      if (Index in [5, 6]) and (_Radix = rDecimalNeg) then Edit.Text:= WordToRadix((Sender as Ti8008Register).Value[Index],rDecimal,vLong,8)
      else WordToRadix((Sender as Ti8008Register).Value[Index],_Radix,vLong,8);
      Edit.Font.Color:= clWindowText;
    end;
  end;
end;

procedure TRegisterForm.CarryFlagUpdate(Sender: TObject; Value: Boolean);
begin
  if not _Block then begin
    if cbCarry.Checked <> Value then cbCarry.Font.Color:= clRed;
    cbCarry.Checked:= Value;
  end
end;

procedure TRegisterForm.SignFlagUpdate(Sender: TObject; Value: Boolean);
begin
  if not _Block then begin
    if cbSign.Checked <> Value then cbSign.Font.Color:= clRed;
    cbSign.Checked:= Value;
  end;
end;

procedure TRegisterForm.ZeroFlagUpdate(Sender: TObject; Value: Boolean);
begin
  if not _Block then begin
    if cbZero.Checked <> Value then cbZero.Font.Color:= clRed;
    cbZero.Checked:= Value;
  end;
end;

procedure TRegisterForm.ParityFlagUpdate(Sender: TObject; Value: Boolean);
begin
  if not _Block then begin
  if cbParity.Checked <> Value then cbParity.Font.Color:= clRed;
  cbParity.Checked:= Value;
  end
end;

procedure TRegisterForm.PCUpdate(Sender: TObject; Value: Word);
begin
  if Sender is Ti8008Stack then begin
    if _Radix = rDecimalNeg then eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,rDecimal,_View,14)
    else eePC.Text:= WordToRadix((Sender as Ti8008Stack).ProgramCounter,_Radix,_View,14);
  end;
end;

procedure TRegisterForm.BeforeCycle(Sender: TObject);
begin
  eeRegister0.Font.Color:= clWindowText;
  eeRegister1.Font.Color:= clWindowText;
  eeRegister2.Font.Color:= clWindowText;
  eeRegister3.Font.Color:= clWindowText;
  eeRegister4.Font.Color:= clWindowText;
  eeRegister5.Font.Color:= clWindowText;
  eeRegister6.Font.Color:= clWindowText;
  eeRegister7.Font.Color:= clWindowText;
  cbCarry.Font.Color:= clWindowText;
  cbParity.Font.Color:= clWindowText;
  cbSign.Font.Color:= clWindowText;
  cbZero.Font.Color:= clWindowText;
end;

procedure TRegisterForm.AfterCycle(Sender: TObject);
begin
end;

procedure TRegisterForm.StateChange(Sender: TObject; Halt: Boolean);
begin
  _BlockHLT:= true;
  cbHalt.Checked:= Halt;
  _BlockHLT:= false;
  if Halt then
    cbHalt.Font.Color:= clRed
  else
    cbHalt.Font.Color:= clWindowText;
  cbHalt.Enabled:= Halt and Assigned(OnReturnFromHaltRequest);
end;

procedure TRegisterForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false) then
    RegistryList.LoadFormSettings(Self,false);
end;

procedure TRegisterForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    RegistryList.SaveFormSettings(Self,false);
end;

procedure TRegisterForm.LoadLanguage;
begin
  miClose.Caption:= getString(rsClose);
  miStayOnTop.Caption:= getString(rsStayOnTop);
  LblProcessorState.Caption:= getString(rsProcessorState);
end;

procedure TRegisterForm.RadixChange(Radix: TRadix; View: TView);
begin
  _Radix:= Radix;
  _View:= View;
end;

function TRegisterForm.Show(ATop: Integer): Integer;
begin
  Top:= ATop;
  Left:= Screen.Width-Width;
  Show;
  result:= Width;
end;

end.
