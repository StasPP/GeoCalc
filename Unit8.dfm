object Form8: TForm8
  Left = 666
  Top = 364
  BorderStyle = bsDialog
  Caption = #1060#1086#1088#1084#1072#1090' '#1074#1099#1074#1086#1076#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
  ClientHeight = 259
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 145
    Height = 72
    Caption = #1044#1077#1089#1103#1090#1080#1095#1085#1099#1077' '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1080
    TabOrder = 0
    object RS1: TRadioButton
      Left = 17
      Top = 44
      Width = 113
      Height = 17
      Caption = ','
      TabOrder = 0
    end
    object RS2: TRadioButton
      Left = 17
      Top = 22
      Width = 113
      Height = 17
      Caption = '.'
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 86
    Width = 146
    Height = 123
    Caption = #1064#1080#1088#1086#1090#1072' '#1080' '#1076#1086#1083#1075#1086#1090#1072
    TabOrder = 1
    object Label1: TLabel
      Left = 17
      Top = 71
      Width = 116
      Height = 13
      Caption = #1047#1085#1072#1082#1086#1074' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1103#1090#1086#1081':'
    end
    object ShowLitera: TCheckBox
      Left = 17
      Top = 20
      Width = 80
      Height = 17
      Caption = 'N/S/E/W'
      TabOrder = 0
    end
    object ComboBox3: TComboBox
      Left = 17
      Top = 43
      Width = 100
      Height = 22
      Style = csOwnerDrawFixed
      Color = clInfoBk
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ItemIndex = 0
      ParentFont = False
      TabOrder = 1
      Text = 'D,ddd'
      Items.Strings = (
        'D,ddd'
        'D,ddd'#176' '
        'D M,mmm'
        'D'#176' M,mmm'#39
        'D M S,sss'
        'D'#176' M'#39' S,sss"')
    end
    object ComboBox4: TComboBox
      Left = 17
      Top = 87
      Width = 100
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 2
      Text = 'Default'
      Items.Strings = (
        'Default'
        '%'
        '%.1'
        '%.2'
        '%.3'
        '%.4'
        '%.5'
        '%.6'
        '%.7'
        '%.8'
        '%.9'
        '%.10'
        '%.11'
        '%.12'
        '%.13'
        '%.14'
        '%.15'
        '%.16')
    end
  end
  object GroupBox3: TGroupBox
    Left = 168
    Top = 7
    Width = 145
    Height = 73
    Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1074' '#1084#1077#1090#1088#1072#1093
    TabOrder = 2
    object Label2: TLabel
      Left = 14
      Top = 21
      Width = 116
      Height = 13
      Caption = #1047#1085#1072#1082#1086#1074' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1103#1090#1086#1081':'
    end
    object ComboBox5: TComboBox
      Left = 14
      Top = 38
      Width = 100
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 0
      Text = 'Default'
      Items.Strings = (
        'Default'
        '%'
        '%.1'
        '%.2'
        '%.3'
        '%.4'
        '%.5'
        '%.6'
        '%.7'
        '%.8'
        '%.9'
        '%.10'
        '%.11'
        '%.12'
        '%.13'
        '%.14'
        '%.15'
        '%.16')
    end
  end
  object Button1: TButton
    Left = 35
    Top = 223
    Width = 129
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 170
    Top = 223
    Width = 123
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = Button2Click
  end
  object GroupBox4: TGroupBox
    Left = 168
    Top = 86
    Width = 145
    Height = 123
    Caption = #1042#1099#1089#1086#1090#1099
    TabOrder = 5
    object Label3: TLabel
      Left = 15
      Top = 28
      Width = 116
      Height = 13
      Caption = #1047#1085#1072#1082#1086#1074' '#1087#1086#1089#1083#1077' '#1079#1072#1087#1103#1090#1086#1081':'
    end
    object ComboBox6: TComboBox
      Left = 15
      Top = 47
      Width = 100
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 0
      Text = 'Default'
      Items.Strings = (
        'Default'
        '%'
        '%.1'
        '%.2'
        '%.3'
        '%.4'
        '%.5'
        '%.6'
        '%.7'
        '%.8'
        '%.9'
        '%.10'
        '%.11'
        '%.12'
        '%.13'
        '%.14'
        '%.15'
        '%.16')
    end
    object CheckBox4: TCheckBox
      Left = 15
      Top = 84
      Width = 101
      Height = 28
      Caption = #1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074#1099#1089#1086#1090#1099
      TabOrder = 1
      WordWrap = True
    end
  end
end
