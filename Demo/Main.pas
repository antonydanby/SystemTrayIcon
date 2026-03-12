unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  SystemTrayIcon; // Ensure this unit is in your project or search path

type
  TFormMain = class(TForm)
    TrayIcon: TSystemTrayIcon;
    TrayMenu: TPopupMenu;
    MenuRestore: TMenuItem;
    MenuLine1: TMenuItem;
    MenuExit: TMenuItem;
    lblStatus: TLabel;
    btnHide: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MenuRestoreClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAllowClose: Boolean;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // Initialize the flag to prevent accidental closure
  FAllowClose := False;

  // Link the tray icon to this form and the popup menu
  TrayIcon.ApplicationForm := Self;
  TrayIcon.PopupMenu := TrayMenu;
  TrayIcon.Hint := 'Delphi Tray Demo - Windows 11';
  TrayIcon.RestoreOnLeftClick := True;

  lblStatus.Caption := 'Application is running. Close the window to minimize to tray.';
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // If FAllowClose is false, we intercept the close command (X button or Alt+F4)
  if not FAllowClose then
  begin
    CanClose := False; // Prevent form destruction
    Self.Hide;         // Hide the main window
    TrayIcon.ShowIcon; // Show the icon in the Windows System Tray
  end;
end;

procedure TFormMain.btnHideClick(Sender: TObject);
begin
  // Trigger the close logic which will hide the form to the tray
  Self.Close;
end;

procedure TFormMain.MenuRestoreClick(Sender: TObject);
begin
  // Restore the application window and hide the tray icon
  TrayIcon.RestoreApplication;
end;

procedure TFormMain.MenuExitClick(Sender: TObject);
begin
  // Set the flag to allow the application to truly terminate
  FAllowClose := True;
  Application.Terminate;
end;

end.
