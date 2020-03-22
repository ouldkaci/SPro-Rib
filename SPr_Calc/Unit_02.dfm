object Frm_02: TFrm_02
  Left = 0
  Top = 0
  Caption = 'Frm_02'
  ClientHeight = 441
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 344
    Height = 441
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = Panel1Resize
    object pnlToolbar: TPanel
      Left = 0
      Top = 0
      Width = 344
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      Caption = '**'
      TabOrder = 0
    end
    object Memo1: TMemo
      Left = 15
      Top = 26
      Width = 265
      Height = 130
      Lines.Strings = (
        '00799999000000000012')
      ScrollBars = ssVertical
      TabOrder = 1
      OnClick = Memo1Click
    end
    object ListBox1: TListBox
      Left = 15
      Top = 164
      Width = 265
      Height = 130
      ItemHeight = 17
      TabOrder = 2
    end
    object BitBtn1: TBitBtn
      Left = 15
      Top = 300
      Width = 75
      Height = 27
      Caption = 'Calc '#201'pv'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 205
      Top = 300
      Width = 75
      Height = 27
      Caption = 'Nettoyer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = BitBtn2Click
    end
    object BitBtn3: TBitBtn
      Left = 108
      Top = 300
      Width = 75
      Height = 27
      Caption = 'Reset'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = BitBtn3Click
    end
  end
end
