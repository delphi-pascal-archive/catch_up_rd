object FAnim: TFAnim
  Left = 234
  Top = 127
  Width = 564
  Height = 501
  Caption = 'Catch up the red dot!'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CCC0
    000CCCC0000000000CCCC7777CCCCCCC0000CCCC00000000CCCC7777CCCCCCCC
    C0000CCCCCCCCCCCCCC7777CCCCC0CCCCC0000CCCCCCCCCCCC7777CCCCC700CC
    C00CCCC0000000000CCCC77CCC77000C0000CCCC00000000CCCC7777C7770000
    00000CCCC000000CCCC777777777C000C00000CCCC0000CCCC77777C777CCC00
    CC00000CCCCCCCCCC77777CC77CCCCC0CCC000CCCCC00CCCCC777CCC7CCCCCCC
    CCCC0CCCCCCCCCCCCCC7CCCCCCCCCCCC0CCCCCCCCCCCCCCCCCCCCCC7CCC70CCC
    00CCCCCCCC0CC0CCCCCCCC77CC7700CC000CCCCCC000000CCCCCC777CC7700CC
    0000CCCC00000000CCCC7777CC7700CC0000C0CCC000000CCC7C7777CC7700CC
    0000C0CCC000000CCC7C7777CC7700CC0000CCCC00000000CCCC7777CC7700CC
    000CCCCCC000000CCCCCC777CC7700CC00CCCCCCCC0CC0CCCCCCCC77CC770CCC
    0CCCCCCCCCCCCCCCCCCCCCC7CCC7CCCCCCCC0CCCCCCCCCCCCCC7CCCCCCCCCCC0
    CCC000CCCCC00CCCCC777CCC7CCCCC00CC00000CCCCCCCCCC77777CC77CCC000
    C00000CCCC0000CCCC77777C777C000000000CCCC000000CCCC777777777000C
    0000CCCC00000000CCCC7777C77700CCC00CCCC0000000000CCCC77CCC770CCC
    CC0000CCCCCCCCCCCC7777CCCCC7CCCCC0000CCCCCCCCCCCCCC7777CCCCCCCCC
    0000CCCC00000000CCCC7777CCCCCCC0000CCCC0000000000CCCC7777CCC0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  OnCreate = FormCreate
  DesignSize = (
    556
    473)
  PixelsPerInch = 120
  TextHeight = 16
  object PBFrame: TPaintBox
    Left = 0
    Top = 0
    Width = 556
    Height = 473
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = PopupMenu1
    OnPaint = PBFramePaint
  end
  object Panel1: TPanel
    Left = 336
    Top = 8
    Width = 209
    Height = 33
    Anchors = [akTop, akRight]
    TabOrder = 0
    object CBxFollowCursor: TCheckBox
      Left = 13
      Top = 7
      Width = 116
      Height = 21
      Caption = 'Follow to cursor'
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Verdana'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnClick = CBxFollowCursorClick
    end
    object CBxFreeze: TCheckBox
      Left = 132
      Top = 7
      Width = 69
      Height = 21
      Caption = 'Freeze!'
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'Verdana'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnClick = CBxFreezeClick
    end
  end
  object Timer1: TTimer
    Interval = 40
    OnTimer = Timer1Timer
    Left = 8
    Top = 13
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 13
    object ShowCupInfos: TMenuItem
      AutoCheck = True
      Caption = 'Voir les infos des points'
      Checked = True
    end
    object ShowMCPInfos: TMenuItem
      AutoCheck = True
      Caption = 'Voir la position MCP'
      Checked = True
    end
    object ShowGTCInfos: TMenuItem
      AutoCheck = True
      Caption = 'Voir les infos de performances'
      Checked = True
    end
  end
end
