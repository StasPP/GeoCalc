object Form3: TForm3
  Left = 465
  Top = 251
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1080#1089#1090#1077#1084' '#1082#1086#1086#1088#1076#1080#1085#1080#1072#1090
  ClientHeight = 455
  ClientWidth = 726
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 368
    Top = 48
    Width = 53
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label2: TLabel
    Left = 368
    Top = 8
    Width = 88
    Height = 13
    Caption = #1059#1085#1080#1082#1072#1083#1100#1085#1086#1077' '#1080#1084#1103':'
  end
  object Label3: TLabel
    Left = 368
    Top = 168
    Width = 33
    Height = 13
    Caption = #1044#1072#1090#1091#1084
  end
  object Label4: TLabel
    Left = 368
    Top = 208
    Width = 73
    Height = 13
    Caption = #1058#1080#1087' '#1087#1088#1086#1077#1082#1094#1080#1080':'
  end
  object Label5: TLabel
    Left = 368
    Top = 248
    Width = 62
    Height = 13
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099':'
  end
  object Label6: TLabel
    Left = 368
    Top = 88
    Width = 60
    Height = 13
    Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072':'
  end
  object Label7: TLabel
    Left = 368
    Top = 128
    Width = 56
    Height = 13
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
  end
  object ComboBox1: TComboBox
    Left = 368
    Top = 184
    Width = 249
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 345
    Height = 409
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = ListBox1Click
    OnMouseMove = ListBox1MouseMove
  end
  object Edit1: TEdit
    Left = 368
    Top = 24
    Width = 345
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 368
    Top = 64
    Width = 345
    Height = 21
    TabOrder = 3
  end
  object Button1: TButton
    Left = 624
    Top = 184
    Width = 89
    Height = 22
    Caption = '...'
    TabOrder = 4
    OnClick = Button1Click
  end
  object ComboBox2: TComboBox
    Left = 368
    Top = 224
    Width = 249
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 5
    OnChange = ComboBox2Change
    Items.Strings = (
      #1053#1077#1090' ('#1064#1080#1088#1086#1090#1072'/'#1044#1086#1083#1075#1086#1090#1072')'
      #1053#1077#1090' ('#1043#1077#1086#1094#1077#1085#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099')'
      #1055#1088#1086#1077#1082#1094#1080#1103' '#1043#1072#1091#1089#1089#1072'-'#1050#1088#1102#1075#1077#1088#1072
      #1055#1088#1086#1077#1082#1094#1080#1103' UTM, '#1057#1077#1074#1077#1088#1085#1086#1077' '#1087#1086#1083#1091#1096#1072#1088#1080#1077
      #1055#1088#1086#1077#1082#1094#1080#1103' UTM, '#1070#1078#1085#1086#1077' '#1087#1086#1083#1091#1096#1072#1088#1080#1077)
  end
  object Button2: TButton
    Left = 368
    Top = 416
    Width = 65
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 440
    Top = 416
    Width = 129
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 648
    Top = 416
    Width = 67
    Height = 25
    Caption = #1057#1073#1088#1086#1089
    TabOrder = 8
    OnClick = Button4Click
  end
  object ComboBox3: TComboBox
    Left = 8
    Top = 8
    Width = 345
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 9
    OnChange = ComboBox3Change
  end
  object ValueList: TStringGrid
    Left = 368
    Top = 264
    Width = 345
    Height = 137
    ColCount = 2
    DefaultColWidth = 148
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
    ParentFont = False
    TabOrder = 10
  end
  object Edit3: TEdit
    Left = 368
    Top = 104
    Width = 345
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 11
  end
  object Edit4: TComboBox
    Left = 368
    Top = 144
    Width = 345
    Height = 21
    ItemHeight = 13
    TabOrder = 12
  end
  object Button5: TButton
    Left = 576
    Top = 416
    Width = 65
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 13
    OnClick = Button5Click
  end
  object isLocal: TCheckBox
    Left = 624
    Top = 227
    Width = 91
    Height = 17
    Caption = #1051#1086#1082#1072#1083#1080#1079#1072#1094#1080#1103
    Enabled = False
    TabOrder = 14
  end
end
