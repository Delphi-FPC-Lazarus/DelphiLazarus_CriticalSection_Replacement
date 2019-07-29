object frmTest: TfrmTest
  Left = 0
  Top = 0
  ClientHeight = 449
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblinf1: TLabel
    Left = 112
    Top = 8
    Width = 29
    Height = 13
    Caption = '- -      '
  end
  object lblinf2: TLabel
    Left = 112
    Top = 27
    Width = 29
    Height = 13
    Caption = '- -      '
  end
  object lblinf3: TLabel
    Left = 112
    Top = 46
    Width = 29
    Height = 13
    Caption = '- -      '
  end
  object lblinf4: TLabel
    Left = 112
    Top = 65
    Width = 29
    Height = 13
    Caption = '- -      '
  end
  object btnStart: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btnStart'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 8
    Top = 39
    Width = 75
    Height = 25
    Caption = 'btnStop'
    TabOrder = 1
    OnClick = btnStopClick
  end
  object ListBoxLog: TListBox
    Left = 352
    Top = 8
    Width = 305
    Height = 433
    ItemHeight = 13
    TabOrder = 2
  end
  object tmrinf: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrinfTimer
    Left = 16
    Top = 80
  end
end
