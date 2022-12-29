object SaveLoc: TSaveLoc
  Left = 227
  Top = 425
  Width = 681
  Height = 267
  Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1083#1086#1082#1072#1083#1080#1079#1072#1094#1080#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = 334
    Top = 116
    Width = 144
    Height = 48
    Shape = bsFrame
    Style = bsRaised
  end
  object SaveButton: TSpeedButton
    Left = 128
    Top = 184
    Width = 225
    Height = 33
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1083#1086#1082#1072#1083#1080#1079#1072#1094#1080#1080
    Glyph.Data = {
      EE000000424DEE0000000000000076000000280000000F0000000F0000000100
      0400000000007800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D70000000000
      0000D033000000770300D033000000770300D033000000770300D03300000000
      0300D033333333333300D033000000003300D030777777770300D03077777777
      0300D030777777770300D030777777770300D030777777770000D03077777777
      0700D000000000000000DDDDDDDDDDDDDDD0}
    OnClick = SaveButtonClick
  end
  object Label1: TLabel
    Left = 16
    Top = 5
    Width = 37
    Height = 13
    Caption = 'ID-'#1080#1084#1103':'
  end
  object Label2: TLabel
    Left = 16
    Top = 53
    Width = 57
    Height = 13
    Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082':'
  end
  object Label3: TLabel
    Left = 335
    Top = 5
    Width = 56
    Height = 13
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
  end
  object Label4: TLabel
    Left = 16
    Top = 101
    Width = 22
    Height = 13
    Caption = #1058#1080#1087':'
  end
  object CloseButton: TSpeedButton
    Left = 360
    Top = 184
    Width = 177
    Height = 33
    Caption = #1054#1090#1084#1077#1085#1072
    OnClick = CloseButtonClick
  end
  object Label5: TLabel
    Left = 335
    Top = 53
    Width = 87
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1076#1072#1090#1091#1084':'
  end
  object Label6: TLabel
    Left = 335
    Top = 101
    Width = 122
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1072#1103' '#1057#1050'/'#1087#1088#1086#1077#1082#1094#1080#1103':'
  end
  object Label7: TLabel
    Left = 339
    Top = 119
    Width = 136
    Height = 42
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    Layout = tlCenter
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 334
    Top = 68
    Width = 144
    Height = 29
    Shape = bsFrame
    Style = bsRaised
  end
  object Label8: TLabel
    Left = 339
    Top = 70
    Width = 136
    Height = 26
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    Layout = tlCenter
    WordWrap = True
  end
  object ValueList: TValueListEditor
    Left = 490
    Top = 55
    Width = 163
    Height = 111
    DefaultColWidth = 60
    FixedCols = 1
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
    Strings.Strings = (
      'Scale=1'
      'Beta=0'
      'dX=0'
      'dY=0'
      'dH=0')
    TabOrder = 0
    TitleCaptions.Strings = (
      #1055#1072#1088#1072#1084#1077#1090#1088
      #1047#1085#1072#1095#1077#1085#1080#1077
      '')
    ColWidths = (
      60
      97)
    RowHeights = (
      18
      18
      17
      18
      18
      18)
  end
  object Edit1: TEdit
    Left = 16
    Top = 117
    Width = 302
    Height = 21
    Enabled = False
    TabOrder = 1
    Text = #1055#1083#1072#1085'-'#1089#1093#1077#1084#1072' ('#1083#1086#1082#1072#1083#1100#1085#1072#1103' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1072#1103' '#1057#1050')'
  end
  object PlanKind: TComboBox
    Left = 16
    Top = 141
    Width = 302
    Height = 22
    Style = csOwnerDrawFixed
    Enabled = False
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 2
    Text = #1051#1077#1074#1072#1103' '#1086#1088#1080#1077#1085#1090#1072#1094#1080#1103' '#1086#1089#1077#1081
    Items.Strings = (
      #1055#1088#1072#1074#1072#1103' '#1086#1088#1080#1077#1085#1090#1072#1094#1080#1103' '#1086#1089#1077#1081
      #1051#1077#1074#1072#1103' '#1086#1088#1080#1077#1085#1090#1072#1094#1080#1103' '#1086#1089#1077#1081)
  end
  object Edit2: TEdit
    Left = 16
    Top = 21
    Width = 302
    Height = 21
    TabOrder = 3
    Text = 'Local01'
  end
  object Edit4: TEdit
    Left = 16
    Top = 69
    Width = 302
    Height = 21
    TabOrder = 4
    Text = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1072#1103' '#1083#1086#1082#1072#1083#1100#1085#1072#1103' '#1089#1080#1089#1090#1077#1084#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  end
  object ComboBox1: TComboBox
    Left = 335
    Top = 21
    Width = 318
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 5
    Text = #1051#1086#1082#1072#1083#1080#1079#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  end
end
