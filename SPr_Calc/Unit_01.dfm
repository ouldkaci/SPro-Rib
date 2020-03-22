object Frm_01: TFrm_01
  Left = 0
  Top = 0
  Caption = 'Frm_01'
  ClientHeight = 441
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 344
    Height = 441
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 30
      Top = 26
      Width = 54
      Height = 17
      Caption = 'Banque :'
    end
    object Label2: TLabel
      Left = 30
      Top = 60
      Width = 53
      Height = 17
      Caption = 'Agence :'
    end
    object Label3: TLabel
      Left = 30
      Top = 90
      Width = 56
      Height = 17
      Caption = 'Compte :'
    end
    object Label4: TLabel
      Left = 255
      Top = 90
      Width = 19
      Height = 17
      Caption = 'Cl'#233
    end
    object Label5: TLabel
      Left = 30
      Top = 120
      Width = 77
      Height = 17
      Caption = 'Idx Banque :'
    end
    object Label6: TLabel
      Left = 255
      Top = 260
      Width = 19
      Height = 17
      Caption = 'Cl'#233
    end
    object SpBClear: TSpeedButton
      Left = 30
      Top = 290
      Width = 50
      Height = 50
      Caption = '.'
      Flat = True
      OnClick = SpBClearClick
    end
    object Ednomanque: TLabel
      Left = 120
      Top = 121
      Width = 209
      Height = 40
      AutoSize = False
      Caption = '___'#13#10'___'
      WordWrap = True
    end
    object pnlToolbar: TPanel
      Left = 0
      Top = 0
      Width = 344
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      Caption = '*'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object Edbanque: TEdit
      Left = 120
      Top = 30
      Width = 41
      Height = 25
      MaxLength = 3
      NumbersOnly = True
      TabOrder = 0
      Text = '000'
      OnChange = EdbanqueChange
      OnEnter = EdbanqueEnter
      OnKeyDown = EKeyDown
    end
    object Edcompte: TEdit
      Left = 120
      Top = 90
      Width = 81
      Height = 25
      MaxLength = 10
      NumbersOnly = True
      TabOrder = 2
      Text = '0000000000'
      OnKeyDown = EKeyDown
    end
    object Edagence: TEdit
      Left = 120
      Top = 60
      Width = 49
      Height = 25
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 1
      Text = '00000'
      OnKeyDown = EKeyDown
    end
    object Edclerib: TEdit
      Left = 120
      Top = 170
      Width = 153
      Height = 25
      TabStop = False
      MaxLength = 20
      ReadOnly = True
      TabOrder = 9
      Text = '12345678901234567890'
      OnKeyDown = EKeyDown
    end
    object Edcontrol: TEdit
      Left = 120
      Top = 210
      Width = 153
      Height = 25
      MaxLength = 20
      NumbersOnly = True
      TabOrder = 5
      OnKeyDown = EKeyDown
    end
    object BtnCalcRib: TBitBtn
      Left = 30
      Top = 170
      Width = 70
      Height = 25
      Caption = 'Calc Rib'
      TabOrder = 4
      OnClick = BtnCalcRibClick
    end
    object BtnEpre: TBitBtn
      Left = 30
      Top = 210
      Width = 70
      Height = 25
      Caption = #201'preuve'
      TabOrder = 6
      OnClick = BtnEpreClick
    end
    object StatusBar1: TStatusBar
      Left = 0
      Top = 422
      Width = 344
      Height = 19
      Panels = <
        item
          Alignment = taCenter
          Width = 320
        end
        item
          Width = 50
        end>
    end
    object BtnNss: TBitBtn
      Left = 30
      Top = 260
      Width = 70
      Height = 25
      Caption = #201'p N SS'
      TabOrder = 8
      OnClick = BtnNssClick
    end
    object MaskEdNss: TMaskEdit
      Left = 120
      Top = 260
      Width = 104
      Height = 25
      EditMask = '!99\ 9999\ 9999\ 99;0;_'
      MaxLength = 15
      TabOrder = 7
      Text = '123456789022'
      OnKeyDown = EKeyDown
    end
    object EdNss: TEdit
      Left = 224
      Top = 260
      Width = 25
      Height = 25
      TabStop = False
      Alignment = taCenter
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      Text = '00'
    end
    object Edcle: TEdit
      Left = 224
      Top = 89
      Width = 25
      Height = 25
      TabStop = False
      Alignment = taCenter
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 12
      Text = '00'
    end
  end
end
