unit uWatchForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, uResourceStrings, uView, uProcessor,
  StdCtrls, Menus, uMisc, Registry, ImgList;

type

  TRAMRefreshRequestEvent = procedure(Listener: IRAM) of object;

  TRAMUpdateRequestEvent = procedure(Address: Word; Value: Byte) of object;

  TIOPortsRefreshRequestEvent = procedure(Listener: IIOPorts) of object;

  TIOPortsUpdateRequestEvent = procedure(PortNo: Byte; Value: Byte) of object;  

  TWatchForm = class(TForm, ILanguage, IRadixView, IRAM, IIOPorts, IRegistry, IProcessor)
    sgWatch: TStringGrid;
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miStayOnTop: TMenuItem;
    N2: TMenuItem;
    miAddWatchRAM: TMenuItem;
    miDelWatch: TMenuItem;
    miDelAll: TMenuItem;
    miAddWatchIPORT: TMenuItem;
    miAddWatchOPort: TMenuItem;
    iRAM: TImage;
    iIPort: TImage;
    iOPort: TImage;
    ImageList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure sgWatchDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure miCloseClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure sgWatchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgWatchDblClick(Sender: TObject);
    procedure sgWatchSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure miAddWatchRAMClick(Sender: TObject);
    procedure miDelWatchClick(Sender: TObject);
    procedure miDelAllClick(Sender: TObject);
    procedure miAddWatchIPORTClick(Sender: TObject);
    procedure miAddWatchOPortClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    _Block: Boolean;
    _Width: Integer;
    _WatchList: TWatchList;
    _Radix: TRadix;
    _View: TView;
    _ARow: Integer;
    _ACol: Integer;    
    _OnRAMRefreshRequest: TRAMRefreshRequestEvent;
    _OnRAMUpdateRequest: TRAMUpdateRequestEvent;
    _OnIPortsRefreshRequest: TIOPortsRefreshRequestEvent;
    _OnIPortsUpdateRequest: TIOPortsUpdateRequestEvent;
    _OnOPortsRefreshRequest: TIOPortsRefreshRequestEvent;    
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);
    procedure RAMUpdate(Sender: TObject; Address: Word; Value: Byte);
    procedure PortUpdate(Sender: TObject; Index: Byte; Value: Byte);
    procedure PortAction(Sender: TObject; Active: Boolean);
    procedure BeforeCycle(Sender: TObject);
    procedure AfterCycle(Sender: TObject);
    procedure StateChange(Sender: TObject; Halt: Boolean);    
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
  public
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);
    property OnRAMRefreshRequest: TRAMRefreshRequestEvent read _OnRAMRefreshRequest write _OnRAMRefreshRequest;
    property OnRAMUpdateRequest: TRAMUpdateRequestEvent read _OnRAMUpdateRequest write _OnRAMUpdateRequest;
    property OnIPortsRefreshRequest: TIOPortsRefreshRequestEvent read _OnIPortsRefreshRequest write _OnIPortsRefreshRequest;
    property OnIPortsUpdateRequest: TIOPortsUpdateRequestEvent read _OnIPortsUpdateRequest write _OnIPortsUpdateRequest;
    property OnOPortsRefreshRequest: TIOPortsRefreshRequestEvent read _OnOPortsRefreshRequest write _OnOPortsRefreshRequest;
  end;

var
  WatchForm: TWatchForm;

implementation

uses uEditForm;

{$R *.dfm}

procedure TWatchForm.FormCreate(Sender: TObject);
begin
  _Block:= true;
  _WatchList:= TWatchList.Create;
  _Radix:= rOctal;
  _View:= vShort;
  sgWatch.RowCount:= _WatchList.Count+1;
  sgWatch.ColCount:= 4;
  sgWatch.ColWidths[0]:= 100;
  sgWatch.ColWidths[1]:= 100;
  sgWatch.ColWidths[2]:= 24;
  sgWatch.ColWidths[3]:= 0;
  sgWatch.Cells[3,0]:= '';
  sgWatch.Left:= 0;
  sgWatch.Top:= 0;
  ClientWidth:= 244;
  ClientHeight:= sgWatch.RowHeights[0] * 10;
  _Width:= Width;
  sgWatch.Canvas.CopyMode:= cmMergeCopy;
  _ARow:= -1;
  _ACol:= -1;
  LoadLanguage;
  _Block:= false;
end;

procedure TWatchForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if not _Block then
    NewWidth:= _Width;
end;

procedure TWatchForm.FormDestroy(Sender: TObject);
begin
  _WatchList.Free;
end;

procedure TWatchForm.sgWatchDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Item: TWatchItem;
begin
  if (ARow = 0) or (ACol = 0) then
    sgWatch.Canvas.Brush.Color:= sgWatch.FixedColor
  else
    sgWatch.Canvas.Brush.Color:= sgWatch.Color;
  sgWatch.Canvas.FillRect(Rect);

  if (ACol = 1) and (sgWatch.Cells[3,ARow] <> '') then
    sgWatch.Canvas.Font.Color:= clRed
  else
    sgWatch.Canvas.Font.Color:= clWindowText;

  if ACol < 2 then
    begin
      Rect.Top:= Rect.Top + ((sgWatch.RowHeights[ARow] -
                              sgWatch.Canvas.TextHeight(sgWatch.Cells[ACol,ARow]))) div 2;
      if ARow = 0 then
        Rect.Left:= Rect.Left + (sgWatch.ColWidths[ACol] -
                      sgWatch.Canvas.TextWidth(sgWatch.Cells[ACol,ARow])) div 2
      else
        Rect.Left:= Rect.Right - 4 - sgWatch.Canvas.TextWidth(sgWatch.Cells[ACol,ARow]);
                      sgWatch.Canvas.TextOut(Rect.Left,Rect.Top,sgWatch.Cells[ACol,ARow]);
    end
  else
    if (ARow > 0) and (ACol = 2) then
      begin
        Item:= _WatchList.Item[ARow-1];
        if Assigned(Item) then
          case Item.WatchType of
            wtRAM   : sgWatch.Canvas.CopyRect(Rect,iRAM.Canvas,Bounds(0,0,24,24));
            wtIPort : sgWatch.Canvas.CopyRect(Rect,iIPort.Canvas,Bounds(0,0,24,24));
            wtOPort : sgWatch.Canvas.CopyRect(Rect,iOPort.Canvas,Bounds(0,0,24,24));
          end;
      end;
end;

procedure TWatchForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TWatchForm.miStayOnTopClick(Sender: TObject);
begin
  if miStayOnTop.Checked then
    FormStyle:= fsNormal
  else
    FormStyle:= fsStayOnTop;
  miStayOnTop.Checked:= not miStayOnTop.Checked;
end;

procedure TWatchForm.miAddWatchRAMClick(Sender: TObject);
var
  P: TPoint;
  result: Integer;
begin
  if Assigned(OnRAMRefreshRequest) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= 0;
      if _Radix = rDecimalNeg then result:= EditForm.ShowModal(rDecimal,_View,14,P)
      else result:= EditForm.ShowModal(_Radix,_View,14,P);
      if (result = mrOk) then
        begin
          if _WatchList.AddressExists(EditForm.Value,wtRAM) then
            MessageDlg(getString(rsExistingAddress),mtInformation,[mbOk],0)
          else
            begin
              _WatchList.Add(EditForm.Value,wtRAM);
              sgWatch.RowCount:= _WatchList.Count+1;
              sgWatch.Cells[3,sgWatch.RowCount-1];
              sgWatch.FixedRows:= 1;
              OnRAMRefreshRequest(Self);
            end;
        end;
    end;
end;

procedure TWatchForm.miAddWatchIPORTClick(Sender: TObject);
var
  P: TPoint;
  result: Integer;
begin
  if Assigned(OnIPortsRefreshRequest) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= Ti8008IPorts.FirstPortNo;
      if _Radix = rDecimalNeg then result:= EditForm.ShowModal(rDecimal,vLong,3,P)
      else result:= EditForm.ShowModal(_Radix,vLong,3,P);
      if (result = mrOk) then
        begin
          if (EditForm.Value >= Ti8008IPorts.FirstPortNo) and
             (EditForm.Value < Ti8008IPorts.FirstPortNo+Ti8008IPorts.Count) then
            begin
              if _WatchList.AddressExists(EditForm.Value,wtIPort) then
                MessageDlg(getString(rsExistingAddress),mtInformation,[mbOk],0)
              else begin
                _WatchList.Add(EditForm.Value,wtIPort);
                sgWatch.RowCount:= _WatchList.Count+1;
                sgWatch.Cells[3,sgWatch.RowCount-1];
                sgWatch.FixedRows:= 1;
                OnIPortsRefreshRequest(Self);
              end;
            end
          else
            MessageDlg(getString(rsInvalidPortAddress),mtError,[mbOk],0)
        end;
    end;
end;

procedure TWatchForm.miAddWatchOPortClick(Sender: TObject);
var
  P: TPoint;
  result: Integer;
begin
  if Assigned(OnIPortsRefreshRequest) then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= Ti8008OPorts.FirstPortNo;
      if _Radix = rDecimalNeg then result:= EditForm.ShowModal(rDecimal,vLong,5,P)
      else result:= EditForm.ShowModal(_Radix,vLong,5,P);
      if (result = mrOk) then
        begin
          if (EditForm.Value >= Ti8008OPorts.FirstPortNo) and
             (EditForm.Value < Ti8008OPorts.FirstPortNo+Ti8008OPorts.Count) then
            begin
              if _WatchList.AddressExists(EditForm.Value,wtOPort) then
                MessageDlg(getString(rsExistingAddress),mtInformation,[mbOk],0)
              else
                begin
                  _WatchList.Add(EditForm.Value,wtOPort);
                  sgWatch.RowCount:= _WatchList.Count+1;
                  sgWatch.Cells[3,sgWatch.RowCount-1];                  
                  sgWatch.FixedRows:= 1;
                  OnIPortsRefreshRequest(Self);
                end;
            end
          else
            MessageDlg(getString(rsInvalidPortAddress),mtError,[mbOk],0)
        end;
    end;
end;

procedure TWatchForm.miDelWatchClick(Sender: TObject);
begin
  if Assigned(OnRAMRefreshRequest) then
    begin
      _WatchList.Delete(_ARow-1);
      sgWatch.RowCount:= _WatchList.Count+1;
      OnRAMRefreshRequest(Self);
      OnIPortsRefreshRequest(Self);
      OnOPortsRefreshRequest(Self);
    end;
end;

procedure TWatchForm.miDelAllClick(Sender: TObject);
begin
  if Assigned(OnRAMRefreshRequest) and
     Assigned(OnIPortsRefreshRequest) and
     Assigned(OnOPortsRefreshRequest) then
    begin
      _WatchList.Clear;
      sgWatch.RowCount:= _WatchList.Count+1;
      OnRAMRefreshRequest(Self);
      OnIPortsRefreshRequest(Self);
      OnOPortsRefreshRequest(Self);
    end;
end;

procedure TWatchForm.sgWatchSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect:= ACol < 3;
  if CanSelect then begin
    _ARow:= ARow;
    _ACol:= ACol;
  end;
end;

procedure TWatchForm.sgWatchDblClick(Sender: TObject);
var
  C: Boolean;
  P: TPoint;
  Item: TWatchItem;
  result: Integer;
begin
  if (_ARow > 0) and (_ACol = 1) then begin
    Item:= _WatchList.Item[_ARow-1];
    if Assigned(Item) and not (Item.WatchType = wtOPort) then begin
        P.X:= Mouse.CursorPos.X;
        P.Y:= Mouse.CursorPos.Y;
        if Item.WatchType = wtRAM then begin
          EditForm.Value:= RadixToWord(sgWatch.Cells[_ACol,_ARow],_Radix,vLong,C);
          if (EditForm.ShowModal(_Radix,vLong,8,P) = mrOk) and Assigned(OnRAMUpdateRequest) then
            OnRAMUpdateRequest(Item.Address,EditForm.Value);
        end else if Item.WatchType = wtIPort then begin
          if _Radix = rDecimalNeg then begin
            EditForm.Value:= RadixToWord(sgWatch.Cells[_ACol,_ARow],rDecimal,vLong,C);
            result:= EditForm.ShowModal(rDecimal,vLong,8,P)
          end else begin
            EditForm.Value:= RadixToWord(sgWatch.Cells[_ACol,_ARow],_Radix,vLong,C);
            result:= EditForm.ShowModal(_Radix,vLong,8,P);
          end;
          if (result = mrOk) and Assigned(OnIPortsUpdateRequest) then
            OnIPortsUpdateRequest(Item.Address,EditForm.Value);
        end;
    end;
  end;
end;

procedure TWatchForm.sgWatchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then sgWatchDblClick(Sender);
  if Key = VK_DELETE then miDelWatchClick(Sender);
end;

procedure TWatchForm.RefreshObject(Sender: TObject);
var
  i: Integer;
  Bits: Byte;
  Item: TWatchItem;
  Address: Word;
begin
  if Sender is Ti8008RAM then begin
    for i:= 0 to _WatchList.Count-1 do begin
      Item:= _WatchList.Item[i];
      if Assigned(Item) and (Item.WatchType = wtRAM) then begin
        Address:= Item.Address;
        sgWatch.Cells[0,i+1]:= WordToRadix(Address,_Radix,_View,14);
        sgWatch.Cells[1,i+1]:= WordToRadix((Sender as Ti8008RAM).RAM[Address],
                                         _Radix,vLong,8);
      end;
   end;
  end else if (Sender is TIOPorts) then begin
    for i:= 0 to _WatchList.Count-1 do begin
      Item:= _WatchList.Item[i];
      if Assigned(Item) and (Item.WatchType in [wtIPort, wtOPort]) then begin
        Address:= Item.Address;
        case (Sender as TIOPorts).PortType of
          ptIN  : Bits:= 3;
          ptOUT : Bits:= 5;
          else    Bits:= 16;
        end;
        if _Radix = rDecimalNeg then begin
          sgWatch.Cells[0,i+1]:= WordToRadix(Address,rDecimal,vLong,Bits);
          sgWatch.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[Address],
                                           rDecimal,vLong,8);
        end else begin
          sgWatch.Cells[0,i+1]:= WordToRadix(Address,_Radix,vLong,Bits);
          sgWatch.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[Address],
                                           _Radix,vLong,8);
        end;
      end;
    end;
  end;
  sgWatch.Invalidate;
end;

procedure TWatchForm.Reset(Sender: TObject);
var
  i: Integer;
  Bits: Byte;
  Item: TWatchItem;
  Address: Word;
begin
  if Sender is Ti8008RAM then begin
    for i:= 0 to _WatchList.Count-1 do begin
      Item:= _WatchList.Item[i];
      if Assigned(Item) and (Item.WatchType = wtRAM) then begin
        Address:= Item.Address;
        sgWatch.Cells[3,i+1]:= '';
        sgWatch.Cells[0,i+1]:= WordToRadix(Address,_Radix,_View,14);
        sgWatch.Cells[1,i+1]:= WordToRadix((Sender as Ti8008RAM).RAM[Address],
                                         _Radix,vLong,8);
      end;
    end;
  end else if (Sender is TIOPorts) then begin
    for i:= 0 to _WatchList.Count-1 do begin
      Item:= _WatchList.Item[i];
      if Assigned(Item) and (Item.WatchType = wtIPort) and ((Sender as TIOPorts).PortType = ptIN) then begin
        Address:= Item.Address;
        Bits:= 3;
        sgWatch.Cells[3,i+1]:= '';
        if _Radix = rDecimalNeg then begin
          sgWatch.Cells[0,i+1]:= WordToRadix(Address,rDecimal,vLong,Bits);
          sgWatch.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[Address],
                                             rDecimal,vLong,8);
        end else begin
          sgWatch.Cells[0,i+1]:= WordToRadix(Address,_Radix,vLong,Bits);
          sgWatch.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[Address],
                                             _Radix,vLong,8);
        end;
      end else if Assigned(Item) and (Item.WatchType = wtOPort) and ((Sender as TIOPorts).PortType = ptOUT) then  begin
        Address:= Item.Address;
        Bits:= 5;
        sgWatch.Cells[3,i+1]:= '';
        if _Radix = rDecimalNeg then begin
          sgWatch.Cells[0,i+1]:= WordToRadix(Address,rDecimal,vLong,Bits);
          sgWatch.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[Address],
                                             rDecimal,vLong,8);
        end else begin
          sgWatch.Cells[0,i+1]:= WordToRadix(Address,_Radix,vLong,Bits);
          sgWatch.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[Address],
                                             _Radix,vLong,8);
        end;
      end
    end;
  end;
end;

procedure TWatchForm.RAMUpdate(Sender: TObject; Address: Word; Value: Byte);
var
  Index: Integer;
  sValue: String;
begin
  Index:= _WatchList.FindAddress(Address,wtRAM);
  if Index >= 0 then begin
    sValue:= WordToRadix(Value,_Radix,vLong,8);
    if sValue <> sgWatch.Cells[1,Index+1] then sgWatch.Cells[3,Index+1]:= '*';
    sgWatch.Cells[1,Index+1]:= sValue;
  end;
end;

procedure TWatchForm.PortUpdate(Sender: TObject; Index: Byte; Value: Byte);
var
  lIndex: Integer;
  sValue: String;
begin
  if (Sender is TIOPorts) then begin
    case (Sender as TIOPorts).PortType of
      ptIN  : lIndex:= _WatchList.FindAddress(Index,wtIPort);
      ptOUT : lIndex:= _WatchList.FindAddress(Index,wtOPort);
      else    lIndex:= -1;
    end;
    if lIndex >= 0 then begin
      if _Radix = rDecimalNeg then sValue:= WordToRadix(Value,rDecimal,vLong,8)
      else sValue:= WordToRadix(Value,_Radix,vLong,8);
      if sValue <> sgWatch.Cells[1,lIndex+1] then sgWatch.Cells[3,lIndex+1]:= '*';
      sgWatch.Cells[1,lIndex+1]:= sValue;
    end;
  end
end;

procedure TWatchForm.PortAction(Sender: TObject; Active: Boolean);
begin
end;

procedure TWatchForm.BeforeCycle(Sender: TObject);
var
  i: Integer;
begin
  for i:= 1 to sgWatch.RowCount-1 do
    begin
      sgWatch.Cells[3,i]:= '';
      sgWatch.Cells[1,i]:= sgWatch.Cells[1,i];
    end;
end;

procedure TWatchForm.AfterCycle(Sender: TObject);
begin
end;

procedure TWatchForm.StateChange(Sender: TObject; Halt: Boolean);
begin
end;

procedure TWatchForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false) then
    RegistryList.LoadFormSettings(Self,true);
end;

procedure TWatchForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    RegistryList.SaveFormSettings(Self,true);
end;

procedure TWatchForm.LoadLanguage;
begin
  Caption:= 'i8008 '+getString(rsWatch);
  sgWatch.Cells[0,0]:= getString(rsAddress);
  sgWatch.Cells[1,0]:= getString(rsValue);
  miAddWatchRAM.Caption:= getString(rsAddWatchRAM);
  miAddWatchIPort.Caption:= getString(rsAddWatchIPort);
  miAddWatchOPort.Caption:= getString(rsAddWatchOPort);
  miDelWatch.Caption:= getString(rsDelWatch);
  miDelAll.Caption:= getString(rsDelAll);
  miClose.Caption:= getString(rsClose);
  miStayOnTop.Caption:= getString(rsStayOnTop);
end;

procedure TWatchForm.RadixChange(Radix: TRadix; View: TView);
begin
  _Radix:= Radix;
  _View:= View;
end;

end.
