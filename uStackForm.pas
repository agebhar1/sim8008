unit uStackForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, Menus, uResourceStrings, uProcessor, uView,
  Buttons, StdCtrls, uEditForm, Registry, uMisc;

type

  TStackPointerUpdateRequestEvent = procedure(Value: Byte) of object;

  TStackUpdateRequestEvent = procedure(Index: Byte; Value: Word) of object;

  TStackForm = class(TForm, IStack, ILanguage, IRadixView, IRegistry)
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miStayOnTop: TMenuItem;
    iStackPointer: TImage;
    sgStack: TStringGrid;
    procedure miCloseClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgStackDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgStackDblClick(Sender: TObject);
    procedure sgStackSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgStackKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    _StackPointer: Integer;
    _ARow: Integer;
    _ACol: Integer;
    _Radix: TRadix;
    _View: TView;
    _OnSPUpdateRequest: TStackPointerUpdateRequestEvent;
    _OnStackUpdateRequest: TStackUpdateRequestEvent;
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);        
    procedure SPChanged(Sender: TObject; SP: Byte);
    procedure Change(Sender: TObject; Index: Byte; Value: Word);
    procedure Push(Sender: TObject; Index: Byte; Value: Word);
    procedure Pop(Sender: TObject; Index: Byte; Value: Word);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
  public
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);    
    property OnStackPointerUpdateRequest: TStackPointerUpdateRequestEvent read _OnSPUpdateRequest write _OnSPUpdateRequest;
    property OnStackUpdateRequest: TStackUpdateRequestEvent read _OnStackUpdateRequest write _OnStackUpdateRequest;
  end;

var
  StackForm: TStackForm;

implementation

{$R *.dfm}

procedure TStackForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  _ARow:= 0;
  _ACol:= 0;
  _StackPointer:= -1;
  _Radix:= rOctal;
  _View:= vShort;
  sgStack.ColCount:= 3;
  sgStack.RowCount:= Ti8008Stack.Size+1;
  for i:= 1 to sgStack.RowCount do
    sgStack.Cells[0,i]:= IntToStr(i-1);
  sgStack.ColWidths[0]:= 50;
  sgStack.ColWidths[1]:= 100;
  sgStack.ColWidths[2]:= 24;
  sgStack.Width:= 174;
  sgStack.Height:= sgStack.RowHeights[0] * (sgStack.RowCount + 1);
  sgStack.Canvas.CopyMode:= cmMergeCopy;
  AutoSize:= true;
  LoadLanguage;
end;

procedure TStackForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TStackForm.miStayOnTopClick(Sender: TObject);
begin
  if miStayOnTop.Checked then
    FormStyle:= fsNormal
  else
    FormStyle:= fsStayOnTop;
  miStayOnTop.Checked:= not miStayOnTop.Checked;
end;

procedure TStackForm.sgStackDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow = 0) or (ACol = 0) then
    sgStack.Canvas.Brush.Color:= sgStack.FixedColor
  else
    sgStack.Canvas.Brush.Color:= sgStack.Color;
  sgStack.Canvas.FillRect(Rect);
  if ACol < 2 then
    begin
      Rect.Top:= Rect.Top + ((sgStack.RowHeights[ARow] -
                              sgStack.Canvas.TextHeight(sgStack.Cells[ACol,ARow]))) div 2;
      if ARow = 0 then
        Rect.Left:= Rect.Left + (sgStack.ColWidths[ACol] -
                                 sgStack.Canvas.TextWidth(sgStack.Cells[ACol,ARow])) div 2
      else
        Rect.Left:= Rect.Right - 4 - sgStack.Canvas.TextWidth(sgStack.Cells[ACol,ARow]);
      sgStack.Canvas.TextOut(Rect.Left,Rect.Top,sgStack.Cells[ACol,ARow]);
    end
  else
    if (ARow-1) = _StackPointer then
      sgStack.Canvas.CopyRect(Rect,iStackPointer.Canvas,Bounds(0,0,24,24));
end;

procedure TStackForm.sgStackSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  _ARow:= ARow;
  _ACol:= ACol;
end;

procedure TStackForm.sgStackDblClick(Sender: TObject);
var
  C: Boolean;
  P: TPoint;
begin
  if _ARow > 0 then
    case _ACol of
      1: begin
           P.X:= Mouse.CursorPos.X;
           P.Y:= Mouse.CursorPos.Y;
           EditForm.Value:= RadixToWord(sgStack.Cells[_ACol,_ARow],_Radix,_View,C);
           if (EditForm.ShowModal(_Radix,_View,14,P) = mrOk) and Assigned(OnStackUpdateRequest) then
             OnStackUpdateRequest(_ARow-1,EditForm.Value);
         end;
      2: if Assigned(OnStackPointerUpdateRequest) then
           OnStackPointerUpdateRequest(_ARow-1);
    end;
end;

procedure TStackForm.sgStackKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sgStackDblClick(Sender);
end;

procedure TStackForm.RefreshObject(Sender: TObject);
var
  i: Integer;
begin
  if Sender is Ti8008Stack then
    begin
      _StackPointer:= (Sender as Ti8008Stack).StackPointer;
      for i:= 1 to sgStack.RowCount do
        sgStack.Cells[1,i]:= WordToRadix((Sender as Ti8008Stack).Items[i-1],_Radix,_View,14);
    end;
end;

procedure TStackForm.Reset(Sender: TObject);
var
  i: Integer;
begin
  if Sender is Ti8008Stack then
    begin
      _StackPointer:= (Sender as Ti8008Stack).StackPointer;
      for i:= 1 to sgStack.RowCount do
        sgStack.Cells[1,i]:= WordToRadix((Sender as Ti8008Stack).Items[i-1],_Radix,_View,14);
    end;
end;

procedure TStackForm.SPChanged(Sender: TObject; SP: Byte);
begin
  _StackPointer:= SP;
  sgStack.Invalidate;
end;

procedure TStackForm.Change(Sender: TObject; Index: Byte; Value: Word);
begin
  sgStack.Cells[1,Index+1]:= WordToRadix(Value,_Radix,_View,14);
end;

procedure TStackForm.Push(Sender: TObject; Index: Byte; Value: Word);
begin
  sgStack.Cells[1,Index+1]:= WordToRadix(Value,_Radix,_View,14);
end;

procedure TStackForm.Pop(Sender: TObject; Index: Byte; Value: Word);
begin
  sgStack.Cells[1,Index+1]:= WordToRadix(Value,_Radix,_View,14);
end;

procedure TStackForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false) then
    RegistryList.LoadFormSettings(Self,false);
end;

procedure TStackForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    RegistryList.SaveFormSettings(Self,false);
end;

procedure TStackForm.LoadLanguage;
begin
  sgStack.Cells[0,0]:= getString(rsAddress);
  sgStack.Cells[1,0]:= getString(rsValue);
  miClose.Caption:= getString(rsClose);
  miStayOnTop.Caption:= getString(rsStayOnTop);
end;

procedure TStackForm.RadixChange(Radix: TRadix; View: TView);
begin
  if Radix = rDecimalNeg then Radix:= rDecimal;
  _Radix:= Radix;
  _View:= View;
end;

end.
