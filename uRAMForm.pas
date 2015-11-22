unit uRAMForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, uResourceStrings, uView, uProcessor,
  StdCtrls, Menus, Registry, uMisc;

type

  TRAMRefreshRequestEvent = procedure(Listener: IRAM) of object;

  TRAMUpdateRequestEvent = procedure(Address: Word; Value: Byte) of object;

  TRAMForm = class(TForm, ILanguage, IRadixView, IRAM, IRegistry)
    sgRAM: TStringGrid;
    pBottom: TPanel;
    sbPage: TScrollBar;
    LblPage: TLabel;
    LblPageIndex: TLabel;
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miStayOnTop: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure sgRAMDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sbPageChange(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure sgRAMKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgRAMDblClick(Sender: TObject);
    procedure sgRAMSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    _Block: Boolean;
    _Width: Integer;
    _Radix: TRadix;
    _View: TView;
    _ARow: Integer;
    _ACol: Integer;
    _OnRAMRefreshRequest: TRAMRefreshRequestEvent;
    _OnRAMUpdateRequest: TRAMUpdateRequestEvent;
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);
    procedure RAMUpdate(Sender: TObject; Address: Word; Value: Byte);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
  public
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);
    function Show(ATop: Integer): Integer; overload;
    property OnRAMRefreshRequest: TRAMRefreshRequestEvent read _OnRAMRefreshRequest write _OnRAMRefreshRequest;
    property OnRAMUpdateRequest: TRAMUpdateRequestEvent read _OnRAMUpdateRequest write _OnRAMUpdateRequest;
  end;

var
  RAMForm: TRAMForm;

implementation

uses uEditForm;

{$R *.dfm}

procedure TRAMForm.FormCreate(Sender: TObject);
begin
  _Block:= true;
  _Radix:= rOctal;
  _View:= vShort;
  sbPage.Position:= 0;
  sgRAM.RowCount:= 257;
  LblPageIndex.Caption:= IntToStr(sbPage.Position);
  sgRAM.ColCount:= 2;
  { -one- RAM Page }
  sgRAM.ColWidths[0]:= 100;
  sgRAM.ColWidths[1]:= 100;
  ClientWidth:= 220;
  ClientHeight:= sgRAM.RowHeights[0] * 10 + pBottom.Height;
  _Width:= Width;
  _ARow:= -1;
  _ACol:= -1;
  LoadLanguage;
  _Block:= false;
end;

procedure TRAMForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if not _Block then
    NewWidth:= _Width;
end;

procedure TRAMForm.sgRAMDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow = 0) or (ACol = 0) then
    sgRAM.Canvas.Brush.Color:= sgRAM.FixedColor
  else
    sgRAM.Canvas.Brush.Color:= sgRAM.Color;
  sgRAM.Canvas.FillRect(Rect);

  Rect.Top:= Rect.Top + ((sgRAM.RowHeights[ARow] -
                          sgRAM.Canvas.TextHeight(sgRAM.Cells[ACol,ARow]))) div 2;
  if ARow = 0 then
    Rect.Left:= Rect.Left + (sgRAM.ColWidths[ACol] -
                  sgRAM.Canvas.TextWidth(sgRAM.Cells[ACol,ARow])) div 2
  else
    Rect.Left:= Rect.Right - 4 - sgRAM.Canvas.TextWidth(sgRAM.Cells[ACol,ARow]);
                  sgRAM.Canvas.TextOut(Rect.Left,Rect.Top,sgRAM.Cells[ACol,ARow]);
end;

procedure TRAMForm.sbPageChange(Sender: TObject);
begin
  LblPageIndex.Caption:= IntToStr(sbPage.Position);
  if Assigned(OnRAMRefreshRequest) then
    OnRAMRefreshRequest(Self);
end;

procedure TRAMForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TRAMForm.miStayOnTopClick(Sender: TObject);
begin
  if miStayOnTop.Checked then
    FormStyle:= fsNormal
  else
    FormStyle:= fsStayOnTop;
  miStayOnTop.Checked:= not miStayOnTop.Checked;
end;

procedure TRAMForm.sgRAMSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  _ARow:= ARow;
  _ACol:= ACol;
end;

procedure TRAMForm.sgRAMDblClick(Sender: TObject);
var
  C: Boolean;
  P: TPoint;
begin
  if (_ARow > 0) and (_ACol = 1) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= RadixToWord(sgRAM.Cells[_ACol,_ARow],_Radix,vLong,C);
      if (EditForm.ShowModal(_Radix,vLong,8,P) = mrOk) and Assigned(OnRAMUpdateRequest) then
        OnRAMUpdateRequest(sbPage.Position*256+(_ARow-1),EditForm.Value);
    end;
end;

procedure TRAMForm.sgRAMKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sgRAMDblClick(Sender);
end;

procedure TRAMForm.RefreshObject(Sender: TObject);
var
  i, iOffset: Integer;
begin
  if Sender is Ti8008RAM then
    begin
      iOffset:= sbPage.Position shl 8;
      iOffset:= iOffset - 1;
      for i:= 1 to sgRAM.RowCount do
        begin
          if _Radix = rDecimalNeg then  sgRAM.Cells[0,i]:= WordToRadix(i+iOffset,rDecimal,_View,14)
          else sgRAM.Cells[0,i]:= WordToRadix(i+iOffset,_Radix,_View,14);
          sgRAM.Cells[1,i]:= WordToRadix((Sender as Ti8008RAM).RAM[i+iOffset],
                                         _Radix,vLong,8);
        end;
    end;
  sgRAM.Invalidate;
end;

procedure TRAMForm.Reset(Sender: TObject);
begin
  if Assigned(OnRAMRefreshRequest) then
    OnRAMRefreshRequest(Self);
end;

procedure TRAMForm.RAMUpdate(Sender: TObject; Address: Word; Value: Byte);
begin
  // RAM - Page ('High')
  if (Address shr 8) = sbPage.Position then
    begin
      // 'Low'
      Address:= Address and 255;
      sgRAM.Cells[1,Address+1]:= WordToRadix(Value,_Radix,vLong,8);
    end;
end;

procedure TRAMForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false) then
    RegistryList.LoadFormSettings(Self,true)
end;

procedure TRAMForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    RegistryList.SaveFormSettings(Self,true);
end;

procedure TRAMForm.LoadLanguage;
begin
  sgRAM.Cells[0,0]:= getString(rsAddress);
  sgRAM.Cells[1,0]:= getString(rsValue);
  LblPage.Caption:= getString(rsPage);
  miClose.Caption:= getString(rsClose);
  miStayOnTop.Caption:= getString(rsStayOnTop);
end;

procedure TRAMForm.RadixChange(Radix: TRadix; View: TView);
begin
  _Radix:= Radix;
  _View:= View;
end;

function TRAMForm.Show(ATop: Integer): Integer;
begin
  Top:= ATop;
  Left:= 0;
  Show;
  result:= Width;
end;

end.
