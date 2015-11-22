unit uInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, ShellAPI, uFileVersion;

type
  TInfoForm = class(TForm)
    sBackground: TShape;
    sbOk: TSpeedButton;
    iLogo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LbleMail: TLabel;
    LblWeb: TLabel;
    LblVersion: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Label5: TLabel;
    Label6: TLabel;
    Timer: TTimer;
    pInfo: TPanel;
    reLicense: TRichEdit;
    reHistory: TRichEdit;
    procedure sbOkClick(Sender: TObject);
    procedure LbleMailMouseEnter(Sender: TObject);
    procedure LbleMailMouseLeave(Sender: TObject);
    procedure LblWebMouseEnter(Sender: TObject);
    procedure LblWebMouseLeave(Sender: TObject);
    procedure LblWebClick(Sender: TObject);
    procedure LbleMailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    _CanClose: Boolean;
  public
    procedure ShowInfo;
    procedure ShowSplash;
  end;

implementation

{$R *.dfm}

procedure TInfoForm.sbOkClick(Sender: TObject);
begin
  Close;
end;

procedure TInfoForm.LbleMailMouseEnter(Sender: TObject);
begin
  LbleMail.Font.Color:= clBlue;
  LbleMail.Font.Style:= [fsUnderline];
end;

procedure TInfoForm.LbleMailMouseLeave(Sender: TObject);
begin
  LbleMail.Font.Color:= clBlack;
  LbleMail.Font.Style:= [];
end;

procedure TInfoForm.LblWebMouseEnter(Sender: TObject);
begin
  LblWeb.Font.Color:= clBlue;
  LblWeb.Font.Style:= [fsUnderline];
end;

procedure TInfoForm.LblWebMouseLeave(Sender: TObject);
begin
  LblWeb.Font.Color:= clBlack;
  LblWeb.Font.Style:= [];
end;

procedure TInfoForm.LblWebClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','https://github.com/agebhar1/sim8008','','',SW_MAXIMIZE);
end;

procedure TInfoForm.LbleMailClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','mailto:agebhar1@googlemail.com?subject=SIM8008 Version 2','','',SW_NORMAL);
end;

procedure TInfoForm.FormCreate(Sender: TObject);
var
  Major, Minor: Word;
  Release, Build: Word;
begin
  Timer.Enabled:= false;
  GetFileVersion(PChar(Application.ExeName),Major,Minor,Release,Build);
  LblVersion.Caption:= 'Version '+IntToStr(Major)+'.'+IntToStr(Minor)+'.'+
                                  IntToStr(Release)+'.'+IntToStr(Build);
end;

procedure TInfoForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= _CanClose;
end;

procedure TInfoForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:= false;
  _CanClose:= true;
  Close;
end;

procedure TInfoForm.ShowInfo;
begin
  AutoSize:= false;
  pInfo.Visible:= true;
  AutoSize:= true;
  Top:= (Screen.DesktopHeight - Height) div 2;
  Left:= (Screen.DesktopWidth - Width) div 2;
  _CanClose:= true;
  ShowModal;
end;

procedure TInfoForm.ShowSplash;
begin
  AutoSize:= false;
  pInfo.Visible:= false;
  AutoSize:= true;
  Top:= (Screen.DesktopHeight - Height) div 2;
  Left:= (Screen.DesktopWidth - Width) div 2;
  _CanClose:= false;
  Timer.Enabled:= true;
  ShowModal;
end;

end.

