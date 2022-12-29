object OpenTabFm: TOpenTabFm
  Left = 679
  Top = 502
  BorderStyle = bsDialog
  Caption = 'OpenTabFm'
  ClientHeight = 278
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 98
    Width = 92
    Height = 13
    Caption = #1053#1072#1095#1072#1090#1100' '#1089#1086' '#1089#1090#1088#1086#1082#1080':'
  end
  object Label2: TLabel
    Left = 8
    Top = 128
    Width = 148
    Height = 13
    Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088':'
  end
  object Button1: TButton
    Left = 104
    Top = 245
    Width = 153
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 264
    Top = 245
    Width = 153
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 149
    Width = 505
    Height = 89
    ColCount = 4
    DefaultColWidth = 120
    DefaultRowHeight = 16
    FixedCols = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowMoving, goColMoving, goThumbTracking]
    ParentFont = False
    TabOrder = 2
    OnDrawCell = StringGrid1DrawCell
  end
  object SepG: TRadioGroup
    Left = 8
    Top = 8
    Width = 265
    Height = 81
    Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1080
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      #1055#1088#1086#1073#1077#1083#1099
      #1058#1072#1073#1091#1083#1103#1094#1080#1103
      #1044#1088#1091#1075#1080#1077
      #1058#1086#1095#1082#1080' '#1089' '#1079#1072#1087#1103#1090#1086#1081
      #1047#1072#1087#1103#1090#1099#1077)
    TabOrder = 3
    OnClick = SepGClick
  end
  object Edit1: TEdit
    Left = 88
    Top = 63
    Width = 49
    Height = 21
    TabOrder = 4
    Text = #39
    OnChange = Edit1Change
    OnKeyUp = ValueListKeyUp
  end
  object ValueList: TValueListEditor
    Left = 280
    Top = 8
    Width = 233
    Height = 105
    DefaultColWidth = 120
    FixedCols = 1
    GridLineWidth = 0
    KeyOptions = [keyEdit, keyAdd, keyUnique]
    Strings.Strings = (
      #1048#1084#1103'=1'
      'X=2'
      'Y=3'
      'Z=4')
    TabOrder = 5
    TitleCaptions.Strings = (
      #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
      #1050#1086#1083#1086#1085#1082#1072)
    OnKeyUp = ValueListKeyUp
    ColWidths = (
      120
      107)
    RowHeights = (
      18
      18
      18
      18
      18)
  end
  object SpinEdit1: TSpinEdit
    Left = 110
    Top = 94
    Width = 65
    Height = 22
    MaxValue = 100000
    MinValue = 1
    TabOrder = 6
    Value = 1
    OnChange = SpinEdit1Change
    OnKeyUp = ValueListKeyUp
  end
end
