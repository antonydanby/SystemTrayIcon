unit SystemTrayIcon;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Menus, Winapi.Messages, Winapi.Windows, Winapi.ShellAPI, Vcl.Graphics,
  Vcl.Controls, System.SysUtils;

const
  WM_TRAYICON = WM_USER + 1000;
  TRAY_ID = 1;

type
  TSystemTrayIcon = class(TComponent)
  private
    FApplicationForm: TForm;
    FPopupMenu: TPopupMenu;
    FIcon: TIcon;
    FHint: string;
    FIsIconVisible: Boolean;
    FWindowHandle: HWND; // Internal handle to receive messages
    FRestoreOnLeftClick: Boolean;
    procedure SetIcon(const Value: TIcon);
    procedure SetHint(const Value: string);
    procedure SetPopupMenu(const Value: TPopupMenu);
    // The internal window procedure
    procedure WndProc(var Msg: TMessage);
    procedure UpdateTrayIcon(Operation: UINT);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowIcon;
    procedure HideIcon;
    procedure RestoreApplication;
  published
    property ApplicationForm: TForm read FApplicationForm write FApplicationForm;
    property Icon: TIcon read FIcon write SetIcon;
    property Hint: string read FHint write SetHint;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property RestoreOnLeftClick: Boolean read FRestoreOnLeftClick write FRestoreOnLeftClick default True;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('l53n', [TSystemTrayIcon]);
end;

{ TSystemTrayIcon }

constructor TSystemTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIcon := TIcon.Create;
  FIsIconVisible := False;
  FRestoreOnLeftClick := True; // Default to standard behavior
  // Create a hidden window to receive tray messages
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TSystemTrayIcon.Destroy;
begin
  HideIcon;
  if FWindowHandle <> 0 then
    DeallocateHWnd(FWindowHandle);
  FIcon.Free;
  inherited Destroy;
end;

procedure TSystemTrayIcon.WndProc(var Msg: TMessage);
var
  P: TPoint;
begin
  if Msg.Msg = WM_TRAYICON then
  begin
    case Msg.LParam of
      WM_LBUTTONUP: // Single left click
        begin
          if FRestoreOnLeftClick then
            RestoreApplication;
        end;

      WM_LBUTTONDBLCLK: // Double left click
        begin
          // If not already restored by single click, restore now
          if not FRestoreOnLeftClick then
            RestoreApplication;
        end;

      WM_RBUTTONUP: // Right click
        begin
          if Assigned(FPopupMenu) then
          begin
            GetCursorPos(P);
            // Required so the menu disappears when clicking away
            SetForegroundWindow(FWindowHandle);
            FPopupMenu.Popup(P.X, P.Y);
            PostMessage(FWindowHandle, WM_NULL, 0, 0);
          end;
        end;
    end;
  end
  else
    Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TSystemTrayIcon.Loaded;
begin
  inherited Loaded;
  if (FApplicationForm = nil) and (Owner is TForm) then
    FApplicationForm := TForm(Owner);
end;

procedure TSystemTrayIcon.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FPopupMenu then
      FPopupMenu := nil;
    if AComponent = FApplicationForm then
      FApplicationForm := nil;
  end;
end;

procedure TSystemTrayIcon.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);
  if FIsIconVisible then UpdateTrayIcon(NIM_MODIFY);
end;

procedure TSystemTrayIcon.SetHint(const Value: string);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    if FIsIconVisible then UpdateTrayIcon(NIM_MODIFY);
  end;
end;

procedure TSystemTrayIcon.SetPopupMenu(const Value: TPopupMenu);
begin
  if FPopupMenu <> Value then
  begin
    if FPopupMenu <> nil then FPopupMenu.RemoveFreeNotification(Self);
    FPopupMenu := Value;
    if FPopupMenu <> nil then FPopupMenu.FreeNotification(Self);
  end;
end;

procedure TSystemTrayIcon.UpdateTrayIcon(Operation: UINT);
var
  NID: TNotifyIconData;
begin
  ZeroMemory(@NID, SizeOf(NID));
  NID.cbSize := SizeOf(NID);
  // Route messages to our internal hidden window, not the Form
  NID.Wnd := FWindowHandle;
  NID.uID := TRAY_ID;
  NID.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  NID.uCallbackMessage := WM_TRAYICON;

  if FIcon.HandleAllocated then
    NID.hIcon := FIcon.Handle
  else
    NID.hIcon := Application.Icon.Handle;

  StrPLCopy(NID.szTip, FHint, Length(NID.szTip) - 1);

  Shell_NotifyIcon(Operation, @NID);
end;

procedure TSystemTrayIcon.ShowIcon;
begin
  if not FIsIconVisible then
  begin
    UpdateTrayIcon(NIM_ADD);
    FIsIconVisible := True;
  end;
end;

procedure TSystemTrayIcon.HideIcon;
begin
  if FIsIconVisible then
  begin
    UpdateTrayIcon(NIM_DELETE);
    FIsIconVisible := False;
  end;
end;

procedure TSystemTrayIcon.RestoreApplication;
begin
  if Assigned(FApplicationForm) then
  begin
    FApplicationForm.Show;
    FApplicationForm.WindowState := wsNormal;
    FApplicationForm.BringToFront;
    HideIcon;
  end;
end;

end.
