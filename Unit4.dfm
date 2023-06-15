object Form4: TForm4
  Left = 348
  Top = 58
  BorderStyle = bsDialog
  Caption = '?????????????? ???????'
  ClientHeight = 535
  ClientWidth = 727
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
  object Label2: TLabel
    Left = 368
    Top = 8
    Width = 84
    Height = 13
    Caption = '?????????? ???:'
  end
  object Label1: TLabel
    Left = 368
    Top = 48
    Width = 51
    Height = 13
    Caption = '????????:'
  end
  object Label6: TLabel
    Left = 368
    Top = 88
    Width = 54
    Height = 13
    Caption = '??? ?????:'
  end
  object Label3: TLabel
    Left = 368
    Top = 128
    Width = 54
    Height = 13
    Caption = '?????????'
  end
  object Label4: TLabel
    Left = 368
    Top = 248
    Width = 138
    Height = 13
    Caption = '????? ? ??????? ????????:'
  end
  object Label5: TLabel
    Left = 368
    Top = 329
    Width = 138
    Height = 13
    Caption = '????????? ?????????????:'
  end
  object Label7: TLabel
    Left = 536
    Top = 248
    Width = 165
    Height = 13
    Caption = '??????, ????????? ? ?????????:'
  end
  object Edit1: TEdit
    Left = 368
    Top = 24
    Width = 345
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 368
    Top = 64
    Width = 345
    Height = 21
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 368
    Top = 104
    Width = 345
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object ComboBox1: TComboBox
    Left = 368
    Top = 144
    Width = 257
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 3
  end
  object Button1: TButton
    Left = 632
    Top = 144
    Width = 81
    Height = 22
    Caption = '...'
    TabOrder = 4
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 368
    Top = 176
    Width = 345
    Height = 65
    Caption = #208#229#230#232#236' "'#206#242' '#228#224#242#243#236#224' '#234' '#228#224#242#243#236#243'":'
    TabOrder = 5
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 305
      Height = 17
      Caption = '????????? ???????? ? ???????? ??????-???????'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 40
      Width = 305
      Height = 17
      Caption = '????????? ???????? ? UTM'
      TabOrder = 1
    end
  end
  object Button2: TButton
    Left = 640
    Top = 344
    Width = 73
    Height = 25
    Caption = '????????'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 368
    Top = 500
    Width = 65
    Height = 25
    Caption = '???????'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 440
    Top = 500
    Width = 129
    Height = 25
    Caption = '????????? ?????????'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 576
    Top = 500
    Width = 65
    Height = 25
    Caption = '???????'
    TabOrder = 9
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 648
    Top = 500
    Width = 67
    Height = 25
    Caption = '?????'
    TabOrder = 10
    OnClick = Button6Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 345
    Height = 513
    ItemHeight = 13
    TabOrder = 11
    OnClick = ListBox1Click
  end
  object ListBox2: TListBox
    Left = 368
    Top = 264
    Width = 161
    Height = 57
    ItemHeight = 13
    TabOrder = 12
    OnClick = ListBox2Click
  end
  object Button7: TButton
    Left = 640
    Top = 440
    Width = 73
    Height = 25
    Caption = '???????'
    TabOrder = 13
    OnClick = Button7Click
  end
  object ValueList: TStringGrid
    Left = 368
    Top = 344
    Width = 265
    Height = 145
    ColCount = 2
    DefaultColWidth = 125
    DefaultRowHeight = 16
    RowCount = 8
    FixedRows = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
    ParentFont = False
    TabOrder = 14
    OnKeyPress = ValueListKeyPress
    RowHeights = (
      16
      16
      16
      16
      16
      16
      16
      16)
  end
  object Button8: TButton
    Left = 640
    Top = 376
    Width = 73
    Height = 25
    Caption = '?????????'
    TabOrder = 15
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 640
    Top = 408
    Width = 73
    Height = 25
    Caption = '?????'
    TabOrder = 16
    OnClick = Button9Click
  end
  object ListBox3: TListBox
    Left = 536
    Top = 264
    Width = 177
    Height = 57
    Color = clBtnFace
    ItemHeight = 13
    TabOrder = 17
    OnClick = ListBox3Click
  end
end
