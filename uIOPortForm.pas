unit uIOPortForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, uResourceStrings, uView, uProcessor,
  StdCtrls, Menus, uMisc, Registry;

type

  TIOPortsRefreshRequestEvent = procedure(Listener: IIOPorts) of object;

  TIOPortsUpdateRequestEvent = procedure(PortNo: Byte; Value: Byte) of object;

  TIOPortsActiveRequestEvent = procedure(Active: Boolean) of object;

  TIOPortsFileRequestEvent = procedure(Filename: TFilename) of object;

  TIOPortsFileResetRequestEvent = procedure of object;

  TIOPortForm = class(TForm, ILanguage, IRadixView, IIOPorts, IRegistry, IProcessor)
    sgIOPort: TStringGrid;
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miStayOnTop: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    gbPortFile: TGroupBox;
    cbPortActive: TCheckBox;
    sbFile: TSpeedButton;
    sbClose: TSpeedButton;
    iIN: TImage;
    iOUT: TImage;
    iOUTClose: TImage;
    iINClose: TImage;
    sbResetFile: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sgIOPortDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure miCloseClick(Sender: TObject);
    procedure miStayOnTopClick(Sender: TObject);
    procedure sgIOPortKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgIOPortDblClick(Sender: TObject);
    procedure sgIOPortSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure cbPortActiveClick(Sender: TObject);
    procedure sbFileClick(Sender: TObject);
    procedure sbCloseClick(Sender: TObject);
    procedure sbResetFileClick(Sender: TObject);
  private
    _Block: Boolean;
    _BlockActive: Boolean;
    _Width: Integer;
    _PortType: TPortType;
    _CanEdit: Boolean;
    _Radix: TRadix;
    _ARow: Integer;
    _ACol: Integer;
    _OnIPortsRefreshRequest: TIOPortsRefreshRequestEvent;
    _OnIPortsUpdateRequest: TIOPortsUpdateRequestEvent;
    _OnOPortsRefreshRequest: TIOPortsRefreshRequestEvent;
    _OnPortsActiveRequest: TIOPortsActiveRequestEvent;
    _OnPortsFileRequest: TIOPortsFileRequestEvent;
    _OnPortFileResetRequest: TIOPortsFileResetRequestEvent;
    procedure setPortType(Value: TPortType);
    procedure setCanEdit(Value: Boolean);
    procedure RefreshObject(Sender: TObject);
    procedure Reset(Sender: TObject);
    procedure PortUpdate(Sender: TObject; Index: Byte; Value: Byte);
    procedure PortAction(Sender: TObject; Active: Boolean);
    procedure BeforeCycle(Sender: TObject);
    procedure AfterCycle(Sender: TObject);
    procedure StateChange(Sender: TObject; Halt: Boolean);
    procedure LoadData(RegistryList: TRegistryList);
    procedure SaveData(RegistryList: TRegistryList);
    property CanEdit: Boolean read _CanEdit write setCanEdit;
  public
    procedure LoadLanguage;
    procedure RadixChange(Radix: TRadix; View: TView);
    property PortType: TPortType read _PortType write setPortType;
    property OnIPortsRefreshRequest: TIOPortsRefreshRequestEvent read _OnIPortsRefreshRequest write _OnIPortsRefreshRequest;
    property OnIPortsUpdateRequest: TIOPortsUpdateRequestEvent read _OnIPortsUpdateRequest write _OnIPortsUpdateRequest;
    property OnOPortsRefreshRequest: TIOPortsRefreshRequestEvent read _OnOPortsRefreshRequest write _OnOPortsRefreshRequest;
    property OnPortsActiveRequest: TIOPortsActiveRequestEvent read _OnPortsActiveRequest write _OnPortsActiveRequest;
    property OnPortsFileRequest: TIOPortsFileRequestEvent read _OnPortsFileRequest write _OnPortsFileRequest;
    property OnPortFileResetRequest: TIOPortsFileResetRequestEvent read _OnPortFileResetRequest write _OnPortFileResetRequest;
  end;

var
  IPortForm: TIOPortForm;
  OPortForm: TIOPortForm;

implementation

uses uEditForm;

{$R *.dfm}

procedure TIOPortForm.FormCreate(Sender: TObject);
begin
  _BlockActive:= false;
  _Block:= false;
  _Radix:= rOctal;
  sgIOPort.ColCount:= 3;
  sgIOPort.ColWidths[0]:= 70;
  sgIOPort.ColWidths[1]:= 70;
  sgIOPort.ColWidths[2]:= 0;
  sgIOPort.Cells[2,0]:= '';
  ClientHeight:= sgIOPort.RowHeights[0] * 9 + gbPortFile.Height;
  _ARow:= -1;
  _ACol:= -1;
  LoadLanguage;
  PortType:= ptUnknown;
end;

procedure TIOPortForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if not _Block then
    NewWidth:= _Width;
end;

procedure TIOPortForm.sgIOPortDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow = 0) or (ACol = 0) then
    sgIOPort.Canvas.Brush.Color:= sgIOPort.FixedColor
  else
    sgIOPort.Canvas.Brush.Color:= sgIOPort.Color;
  sgIOPort.Canvas.FillRect(Rect);

  if (ACol = 1) and (sgIOPort.Cells[2,ARow] <> '') then
    sgIOPort.Canvas.Font.Color:= clRed
  else
    if (ACol = 1) and (ARow = 0) and not CanEdit then
      sgIOPort.Canvas.Font.Color:= clGrayText
    else
      sgIOPort.Canvas.Font.Color:= clWindowText;

  Rect.Top:= Rect.Top + ((sgIOPort.RowHeights[ARow] -
                          sgIOPort.Canvas.TextHeight(sgIOPort.Cells[ACol,ARow]))) div 2;
  if ARow = 0 then
    Rect.Left:= Rect.Left + (sgIOPort.ColWidths[ACol] -
                  sgIOPort.Canvas.TextWidth(sgIOPort.Cells[ACol,ARow])) div 2
  else
    Rect.Left:= Rect.Right - 4 - sgIOPort.Canvas.TextWidth(sgIOPort.Cells[ACol,ARow]);
                  sgIOPort.Canvas.TextOut(Rect.Left,Rect.Top,sgIOPort.Cells[ACol,ARow]);
end;

procedure TIOPortForm.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TIOPortForm.miStayOnTopClick(Sender: TObject);
begin
  if miStayOnTop.Checked then
    FormStyle:= fsNormal
  else
    FormStyle:= fsStayOnTop;
  miStayOnTop.Checked:= not miStayOnTop.Checked;
end;

procedure TIOPortForm.sgIOPortSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect:= ACol < 2;
  if CanSelect then
    begin
      _ARow:= ARow;
      _ACol:= ACol;
    end;
end;

procedure TIOPortForm.sgIOPortDblClick(Sender: TObject);
var
  C: Boolean;
  P: TPoint;
begin
  if (_ARow > 0) and (_ACol = 1) and (PortType = ptIN) and CanEdit then
    begin
      P.X:= Mouse.CursorPos.X;
      P.Y:= Mouse.CursorPos.Y;
      EditForm.Value:= RadixToWord(sgIOPort.Cells[_ACol,_ARow],_Radix,vLong,C);
      if (EditForm.ShowModal(_Radix,vLong,8,P) = mrOk) and Assigned(OnIPortsUpdateRequest) then
        OnIPortsUpdateRequest(_ARow-1+Ti8008IPorts.FirstPortNo,EditForm.Value);
    end;
end;

procedure TIOPortForm.sgIOPortKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sgIOPortDblClick(Sender);
end;

procedure TIOPortForm.cbPortActiveClick(Sender: TObject);
begin
  if not _BlockActive and Assigned(OnPortsActiveRequest) then
    OnPortsActiveRequest(cbPortActive.Checked);
end;

procedure TIOPortForm.sbResetFileClick(Sender: TObject);
begin
  if Assigned(OnPortFileResetRequest) then
    OnPortFileResetRequest;
end;

procedure TIOPortForm.sbFileClick(Sender: TObject);
var
  Filename: TFilename;
begin
  case PortType of
    ptIN  : if Assigned(OnPortsFileRequest) and OpenDialog.Execute then
              begin
                Filename:= ChangeFileExt(OpenDialog.FileName,'.pin');
                OnPortsFileRequest(Filename);
                sbFile.Enabled:= false;
                sbResetFile.Enabled:= true;
                sbClose.Enabled:= true;
                cbPortActive.Enabled:= true;
              end;
    ptOUT : if Assigned(OnPortsFileRequest) and SaveDialog.Execute then
              begin
                Filename:= ChangeFileExt(SaveDialog.FileName,'.pout');
                OnPortsFileRequest(FileName);
                sbFile.Enabled:= false;
                sbClose.Enabled:= true;
                cbPortActive.Enabled:= true;                
              end;
  end
end;

procedure TIOPortForm.sbCloseClick(Sender: TObject);
begin
  if Assigned(OnPortsFileRequest) then
    begin
      OnPortsFileRequest('');
      sbFile.Enabled:= true;
      sbResetFile.Enabled:= false;
      sbClose.Enabled:= false;
      cbPortActive.Enabled:= false;      
    end;
end;

procedure TIOPortForm.setPortType(Value: TPortType);
begin
  _Block:= true;
  _PortType:= Value;
  case PortType of
    ptIN  : begin
              Caption:= 'i8008 IN - Ports';
              sgIOPort.RowCount:= Ti8008IPorts.Count + 1;
              sgIOPort.FixedRows:= 1;
              ClientWidth:= 160;
              _Width:= Width;
              iIN.Visible:= false;
              iINClose.Visible:= false;
              iOUT.Visible:= false;
              iOUTClose.Visible:= false;
              sbFile.Glyph:= iIN.Picture.Bitmap;
              sbClose.Glyph:= iINClose.Picture.Bitmap;
              sbFile.Enabled:= true;
              sbClose.Enabled:= false;
              sbResetFile.Visible:= true;
              sbResetFile.Enabled:= false;
              cbPortActive.Enabled:= false;
              CanEdit:= true;
            end;
    ptOUT : begin
              Caption:= 'i8008 OUT - Ports';
              sgIOPort.RowCount:= Ti8008OPorts.Count + 1;
              sgIOPort.FixedRows:= 1;
              ClientWidth:= 160;
              _Width:= Width;
              iIN.Visible:= false;
              iINClose.Visible:= false;
              iOUT.Visible:= false;
              iOUTClose.Visible:= false;
              sbFile.Glyph:= iOUT.Picture.Bitmap;
              sbClose.Glyph:= iOUTClose.Picture.Bitmap;
              sbFile.Enabled:= true;
              sbClose.Enabled:= false;
              sbResetFile.Visible:= false;
              cbPortActive.Enabled:= false;              
              CanEdit:= false;
            end;
    else    begin
              Caption:= 'i8008 Ports';
              sgIOPort.RowCount:= 1;
              ClientWidth:= 160;
              _Width:= Width;
              iIN.Visible:= false;
              iINClose.Visible:= false;
              iOUT.Visible:= false;
              iOUTClose.Visible:= false;
              sbFile.Enabled:= false;
              sbClose.Enabled:= false;
              CanEdit:= false;
            end;
  end;
  if (PortType = ptIN) and Assigned(OnIPortsRefreshRequest) then
    OnIPortsRefreshRequest(Self);
  if (PortType = ptOUT) and Assigned(OnOPortsRefreshRequest) then
    OnOPortsRefreshRequest(Self);
  _Block:= false;
end;

procedure TIOPortForm.setCanEdit(Value: Boolean);
begin
  _CanEdit:= (Porttype = ptIn) and Value;
  sgIOPort.Invalidate;
end;

procedure TIOPortForm.RefreshObject(Sender: TObject);
var
  i, iFirstPortNo: Integer;
  Bits: Byte;
begin
  if (Sender is TIOPorts) and
    ((Sender as TIOPorts).PortType = PortType) and not (PortType = ptUnknown) then
    begin
      case (Sender as TIOPorts).PortType of
        ptIN  : Bits:= 3;
        ptOUT : Bits:= 5;
        else    Bits:= 16;
      end;
      iFirstPortNo:= (Sender as TIOPorts).FirstPortNo;
      for i:= 0 to (Sender as TIOPorts).Count-1 do
        begin
          sgIOPort.Cells[0,i+1]:= WordToRadix(i+iFirstPortNo,_Radix,vLong,Bits);
          sgIOPort.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[i+iFirstPortNo],
                                              _Radix,vLong,8);
        end;
    end;
  sgIOPort.Invalidate;
end;

procedure TIOPortForm.Reset(Sender: TObject);
var
  i, iFirstPortNo: Integer;
  Bits: Byte;
begin
  if (Sender is TIOPorts) and
    ((Sender as TIOPorts).PortType = PortType) and not (PortType = ptUnknown) then
    begin
      case (Sender as TIOPorts).PortType of
        ptIN  : Bits:= 3;
        ptOUT : Bits:= 5;
        else    Bits:= 16;
      end;
      iFirstPortNo:= (Sender as TIOPorts).FirstPortNo;
      for i:= 0 to (Sender as TIOPorts).Count-1 do
        begin
          sgIOPort.Cells[2,i+1]:= '';
          sgIOPort.Cells[0,i+1]:= WordToRadix(i+iFirstPortNo,_Radix,vLong,Bits);
          sgIOPort.Cells[1,i+1]:= WordToRadix((Sender as TIOPorts).Value[i+iFirstPortNo],
                                              _Radix,vLong,8);
        end;
    end;
end;

procedure TIOPortForm.PortUpdate(Sender: TObject; Index: Byte; Value: Byte);
var
  sValue: String;
begin
  if (Sender is TIOPorts) and
    ((Sender as TIOPorts).PortType = PortType) and not (PortType = ptUnknown) then
    begin
      Index:= Index - (Sender as TIOPorts).FirstPortNo;
      sValue:= WordToRadix(Value,_Radix,vLong,8);
      if sValue <> sgIOPort.Cells[1,Index+1] then
        sgIOPort.Cells[2,Index+1]:= '*';
      sgIOPort.Cells[1,Index+1]:= sValue;
    end
end;

procedure TIOPortForm.PortAction(Sender: TObject; Active: Boolean);
begin
  _BlockActive:= true;
  cbPortActive.Checked:= Active;
  CanEdit:= not Active;
  _BlockActive:= false;
end;

procedure TIOPortForm.BeforeCycle(Sender: TObject);
var
  i: Integer;
begin
  for i:= 1 to sgIOPort.RowCount-1 do
    begin
      sgIOPort.Cells[2,i]:= '';
      sgIOPort.Cells[1,i]:= sgIOPort.Cells[1,i];
    end;
end;

procedure TIOPortForm.AfterCycle(Sender: TObject);
begin
end;

procedure TIOPortForm.StateChange(Sender: TObject; Halt: Boolean);
begin
end;

procedure TIOPortForm.LoadData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,false) then
    RegistryList.LoadFormSettings(Self,true);
end;

procedure TIOPortForm.SaveData(RegistryList: TRegistryList);
begin
  if RegistryList.Registry.OpenKey(APPLICATION_MAIN_KEY,true) then
    RegistryList.SaveFormSettings(Self,true);
end;

procedure TIOPortForm.LoadLanguage;
begin
  sgIOPort.Cells[0,0]:= getString(rsPortAddress);
  sgIOPort.Cells[1,0]:= getString(rsValue);
  miClose.Caption:= getString(rsClose);
  miStayOnTop.Caption:= getString(rsStayOnTop);
  gbPortFile.Caption:= ' '+getString(rs_p_File)+' ';
  cbPortActive.Caption:= getString(rs_p_Active);
  sbResetFile.Hint:= getString(rs_p_ResetFile);
  case PortType of
    ptIN  : sbFile.Caption:= getString(rs_p_Open);
    ptOUT : sbFile.Caption:= getString(rs_p_Save);
    else    sbFile.Caption:= '';
  end;
  sbClose.Caption:= getString(rs_p_Close);
  OpenDialog.Title:= getString(rs_p_OpenDialog);
  SaveDialog.Title:= getString(rs_p_SaveDialog);
  OpenDialog.Filter:= getString(rs_p_OpenFilter);
  SaveDialog.Filter:= getString(rs_p_SaveFilter);
end;

procedure TIOPortForm.RadixChange(Radix: TRadix; View: TView);
begin
  if Radix = rDecimalNeg then Radix:= rDecimal;
  _Radix:= Radix;
end;

end.
