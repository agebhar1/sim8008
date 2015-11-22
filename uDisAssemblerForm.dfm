object DisAssemblerForm: TDisAssemblerForm
  Left = 218
  Top = 421
  BorderStyle = bsToolWindow
  Caption = 'i8008 Disassembler'
  ClientHeight = 191
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ScreenSnap = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object pDisAssemble: TPanel
    Left = 0
    Top = 0
    Width = 195
    Height = 185
    PopupMenu = PopupMenu
    TabOrder = 0
    object LblSourcecode: TLabel
      Left = 8
      Top = 8
      Width = 83
      Height = 14
      Caption = 'LblSourcecode'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 14
      Top = 33
      Width = 15
      Height = 14
      Caption = 'PC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object iArrow: TImage
      Left = 30
      Top = 28
      Width = 24
      Height = 24
      AutoSize = True
      Picture.Data = {
        07544269746D617096010000424D960100000000000076000000280000001800
        0000180000000100040000000000200100000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF44888FFFFFFFFFFFFFFFFFFF444448888FFFFFFF88888888
        4444444488FFFFF4444444444444444444FFFFF4444444444444444444FFFFFF
        FFFFFFFF44444444FFFFFFFFFFFFFFFF44444FFFFFFFFFFFFFFFFFFF44FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      Transparent = True
    end
    object bDivider: TBevel
      Left = 14
      Top = 129
      Width = 171
      Height = 2
    end
    object Label2: TLabel
      Left = 8
      Top = 136
      Width = 91
      Height = 14
      Caption = 'Programcounter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object pCode0: TPanel
      Left = 59
      Top = 32
      Width = 126
      Height = 15
      BevelOuter = bvLowered
      Caption = 'pCode0'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object pCode1: TPanel
      Left = 59
      Top = 47
      Width = 126
      Height = 15
      BevelOuter = bvLowered
      Caption = 'pCode1'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object pCode2: TPanel
      Left = 59
      Top = 62
      Width = 126
      Height = 15
      BevelOuter = bvLowered
      Caption = 'pCode2'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object pCode3: TPanel
      Left = 59
      Top = 77
      Width = 126
      Height = 15
      BevelOuter = bvLowered
      Caption = 'pCode3'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object pCode4: TPanel
      Left = 59
      Top = 92
      Width = 126
      Height = 15
      BevelOuter = bvLowered
      Caption = 'pCode4'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object pCode5: TPanel
      Left = 59
      Top = 107
      Width = 126
      Height = 15
      BevelOuter = bvLowered
      Caption = 'pCode5'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object eePC: TEnhancedEdit
      Left = 85
      Top = 158
      Width = 100
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 6
      Text = 'eePC'
      OnClick = ePCClick
      OnKeyUp = ePCKeyUp
    end
  end
  object PopupMenu: TPopupMenu
    Left = 8
    Top = 64
    object miClose: TMenuItem
      Caption = 'Schlie'#223'en'
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
