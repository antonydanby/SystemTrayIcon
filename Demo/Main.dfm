object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Delphi System Tray Demo'
  ClientHeight = 200
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object lblStatus: TLabel
    Left = 24
    Top = 40
    Width = 353
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'Status Label'
  end
  object btnHide: TButton
    Left = 144
    Top = 88
    Width = 113
    Height = 33
    Caption = 'Minimize to Tray'
    TabOrder = 0
    OnClick = btnHideClick
  end
  object TrayIcon: TSystemTrayIcon
    ApplicationForm = Owner
    Hint = 'Tray Demo'
    PopupMenu = TrayMenu
    Left = 40
    Top = 136
  end
  object TrayMenu: TPopupMenu
    Left = 112
    Top = 136
    object MenuRestore: TMenuItem
      Caption = '&Restore Application'
      Default = True
      OnClick = MenuRestoreClick
    end
    object MenuLine1: TMenuItem
      Caption = '-'
    end
    object MenuExit: TMenuItem
      Caption = 'E&xit'
      OnClick = MenuExitClick
    end
  end
end
