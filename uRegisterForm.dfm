object RegisterForm: TRegisterForm
  Left = 620
  Top = 274
  BorderStyle = bsToolWindow
  Caption = 'i8008 Register - Flags'
  ClientHeight = 354
  ClientWidth = 199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poDefault
  ScreenSnap = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object pRegister: TPanel
    Left = 0
    Top = 0
    Width = 195
    Height = 155
    PopupMenu = PopupMenu
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 32
      Width = 8
      Height = 14
      Caption = 'A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 32
      Top = 48
      Width = 7
      Height = 14
      Caption = 'B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 32
      Top = 64
      Width = 7
      Height = 14
      Caption = 'C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 32
      Top = 80
      Width = 7
      Height = 14
      Caption = 'D'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 32
      Top = 96
      Width = 6
      Height = 14
      Caption = 'E'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 32
      Top = 112
      Width = 7
      Height = 14
      Caption = 'H'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 110
      Top = 112
      Width = 6
      Height = 14
      Caption = 'L'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 11
      Top = 128
      Width = 29
      Height = 14
      Caption = 'M(HL)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 8
      Top = 8
      Width = 47
      Height = 14
      Caption = 'Register'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arail'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object eeRegister0: TEnhancedEdit
      Left = 44
      Top = 32
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister1: TEnhancedEdit
      Left = 44
      Top = 48
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister2: TEnhancedEdit
      Left = 44
      Top = 64
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister3: TEnhancedEdit
      Left = 44
      Top = 80
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister4: TEnhancedEdit
      Left = 44
      Top = 96
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister5: TEnhancedEdit
      Left = 44
      Top = 112
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister6: TEnhancedEdit
      Left = 124
      Top = 112
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
    object eeRegister7: TEnhancedEdit
      Left = 44
      Top = 128
      Width = 62
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      OnClick = RegisterChange
      OnKeyUp = eRegisterKeyUp
    end
  end
  object pFlags: TPanel
    Left = 0
    Top = 155
    Width = 195
    Height = 78
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu
    TabOrder = 1
    object Label10: TLabel
      Left = 8
      Top = 8
      Width = 29
      Height = 14
      Caption = 'Flags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arail'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object cbCarry: TCheckBox
      Left = 40
      Top = 32
      Width = 57
      Height = 17
      Cursor = crHandPoint
      Caption = 'Carry'
      TabOrder = 0
      OnClick = cbCarryClick
    end
    object cbZero: TCheckBox
      Left = 112
      Top = 54
      Width = 57
      Height = 17
      Cursor = crHandPoint
      Caption = 'Zero'
      TabOrder = 3
      OnClick = cbZeroClick
    end
    object cbParity: TCheckBox
      Left = 112
      Top = 32
      Width = 57
      Height = 17
      Cursor = crHandPoint
      Caption = 'Parity'
      TabOrder = 1
      OnClick = cbParityClick
    end
    object cbSign: TCheckBox
      Left = 40
      Top = 54
      Width = 57
      Height = 17
      Cursor = crHandPoint
      Caption = 'Sign'
      TabOrder = 2
      OnClick = cbSignClick
    end
  end
  object pProgramcounter: TPanel
    Left = 0
    Top = 233
    Width = 195
    Height = 64
    PopupMenu = PopupMenu
    TabOrder = 2
    object Label11: TLabel
      Left = 8
      Top = 10
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
    object eePC: TEnhancedEdit
      Left = 85
      Top = 34
      Width = 100
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = 'eePC'
      OnClick = eePCClick
      OnKeyUp = eePCKeyUp
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 297
    Width = 195
    Height = 56
    TabOrder = 3
    object LblProcessorState: TLabel
      Left = 8
      Top = 10
      Width = 93
      Height = 14
      Caption = 'Prozessorstatus'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object cbHalt: TCheckBox
      Left = 88
      Top = 32
      Width = 97
      Height = 17
      Caption = 'Halt'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = cbHaltClick
    end
  end
  object PopupMenu: TPopupMenu
    Left = 160
    Top = 8
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