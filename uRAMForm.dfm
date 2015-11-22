object RAMForm: TRAMForm
  Left = 515
  Top = 254
  Width = 210
  Height = 237
  BorderStyle = bsSizeToolWin
  Caption = 'i8008 RAM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  ScreenSnap = True
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object sgRAM: TStringGrid
    Left = 0
    Top = 0
    Width = 202
    Height = 169
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = True
    GridLineWidth = 0
    ParentCtl3D = False
    PopupMenu = PopupMenu
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = sgRAMDblClick
    OnDrawCell = sgRAMDrawCell
    OnKeyUp = sgRAMKeyUp
    OnSelectCell = sgRAMSelectCell
  end
  object pBottom: TPanel
    Left = 0
    Top = 169
    Width = 202
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    PopupMenu = PopupMenu
    TabOrder = 1
    object LblPage: TLabel
      Left = 4
      Top = 4
      Width = 38
      Height = 14
      Caption = 'LblPage'
    end
    object LblPageIndex: TLabel
      Left = 48
      Top = 4
      Width = 64
      Height = 14
      Caption = 'LblPageIndex'
    end
    object sbPage: TScrollBar
      Left = 0
      Top = 24
      Width = 202
      Height = 17
      Align = alBottom
      Max = 63
      PageSize = 0
      TabOrder = 0
      OnChange = sbPageChange
    end
  end
  object PopupMenu: TPopupMenu
    MenuAnimation = [maLeftToRight]
    Left = 16
    Top = 8
    object miClose: TMenuItem
      Caption = 'Beenden'
      OnClick = miCloseClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miStayOnTop: TMenuItem
      Caption = 'immer im Vordergrund'
      OnClick = miStayOnTopClick
    end
  end
end
