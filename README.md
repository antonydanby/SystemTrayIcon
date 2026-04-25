# Delphi System Tray Icon Component (Windows 11)

A robust, non-visual VCL component for Delphi that allows you to easily minimize your application to the Windows System Tray. It features modern Windows 11 compatibility, custom context menu support, and flexible interaction options.

## 📁 Project Structure

/: Contains the component package and installation files.

Source/: Contains the SystemTrayIconComponent.pas unit.

Demo/: A VCL application demonstrating how to minimize, restore, and manage the tray icon.

## 🚀 Features

Windows 11 Compatible: Uses modern Shell API calls for tray integration.

Custom Context Menu: Easily link a standard TPopupMenu to be triggered on right-click.

Internal Message Handling: Uses AllocateHWnd to manage system messages independently of the main form.

Left-Click Restore: Option to restore the application with a single left click (common in modern apps).

Double-Click Support: Always restores the application on double-click.

Auto-Discovery: Automatically detects the owner form to simplify setup.

## 🛠 Installation

Install the Package
Open the provided package file or group.
This was developed in Rad Studio 13, but it should run in any modern version of Delphi or Rad Studio, including the community edition. If this is not the case please contact me on the contact details below.

Right-click on the package in the Project Manager.

Select Build, then Install.

You will now find the component in the Tool Palette under the l53n category.

Library Path
Ensure the folder containing your .dcp and .dcu files is added to your Delphi Library Path (Tools > Options > IDE > Environment Variables).

## 📖 Usage Example

Although you can drop the component onto a form or a DataModule in the VCL, you can in fact use it anywhere by simply creating it on the fly.

To minimize to tray when the user clicks the 'X' button, handle the form's OnCloseQuery event:

```pascal
procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // FAllowClose is a private boolean you set to True only when clicking "Exit"
  if not FAllowClose then
  begin
    CanClose := False; // Prevent the app from closing
    Self.Hide;         // Hide the window
    TrayIcon.ShowIcon; // Show the icon in the tray
  end;
end;
```
The demo shows this idea in practice

## Component Properties

| Property | Description | 
| ----- | ----- | 
| `ApplicationForm` | The form to be restored/managed (defaults to the component owner). | 
| `Icon` | The icon displayed in the system tray. | 
| `Hint` | The tooltip text shown when hovering over the icon. | 
| `PopupMenu` | The `TPopupMenu` to display on a right-click. | 
| `RestoreOnLeftClick` | Boolean (default: True). If true, a single click restores the app. |


## Pros and Cons

Pros

* Self-Contained: Handles its own window messages, so you don't have to subclass your main form.
* Modern UX: Supports the single-click restore behavior common in Windows 11 applications.
* Resource Efficient: Uses minimal system resources and cleans up the tray icon automatically on destruction.

Cons

* VCL Only: Specifically designed for VCL applications; not compatible with FireMonkey (FMX) without modification.
* Icon Dependency: Requires an icon handle; if no icon is provided, it defaults to the application's main icon.

## ⚠️ Important Notes

Unique IDs: The component uses a unique ID within your process. If you create multiple tray icons manually, ensure they have distinct IDs if you modify the source.

Main Form On Taskbar: For the best "minimize to tray" experience, ensure ```Application.MainFormOnTaskBar``` is set appropriately in your project source.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

📩 Contact & Support

If you have questions, find a bug, or want to suggest a feature for the **System Tray Icon Component**, feel free to reach out:

* **Maintainer:** Antony Danby
* **GitHub:** [@AntonyDanby](https://github.com/antonydanby)  
* **Email:** [info@latitude53north.co.uk](mailto:info@latitude53north.co.uk)  
* **Website:** [latitude53north.co.uk](https://latitude53north.co.uk)

> [!TIP]
> If you encounter an issue with window handle detection, please include your Windows version and Delphi edition in the [Issue Tracker](https://github.com/antonydanby/SystemTrayIcon/issues).
>
> 