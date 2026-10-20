# Windows Wi-Fi Auto Proxy Switcher

A lightweight PowerShell utility that automatically enables or disables the Windows system proxy based on the currently connected Wi-Fi network (SSID).

Pre-configured for **Sabaragamuwa University of Sri Lanka (SUSL)** campus network (`SUSL_Student_Wi-Fi`), and easily customizable for any university or corporate network.

## Features
- **Zero Dependencies:** Written in native Windows PowerShell.
- **Instant Browser Refresh:** Calls the Windows `wininet.dll` API so Chrome, Edge, and system applications adopt the proxy change immediately without restarting.
- **Automatic Fallback:** Automatically disables the proxy when connecting to home Wi-Fi or a mobile hotspot.
- **Desktop Shortcuts Included:** Installer creates one-click Desktop shortcuts for automatic detection or manual override.

## Quick Start

### Option 1: Direct PowerShell Setup
Open **Windows PowerShell** on your PC and run the following commands to install and execute the script directly:

```powershell
New-Item -ItemType Directory -Path "C:\Scripts" -Force | Out-Null
Invoke-WebRequest -Uri "[https://raw.githubusercontent.com/NadunML/Windows-Auto-Proxy-Switcher/main/Update-Proxy.ps1](https://raw.githubusercontent.com/NadunML/Windows-Auto-Proxy-Switcher/main/Update-Proxy.ps1)" -OutFile "C:\Scripts\Update-Proxy.ps1"
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\Update-Proxy.ps1"
```

### Option 2: Clone and Run Installer
1. Clone this repository or download and extract the ZIP archive:
   ```bash
   git clone [https://github.com/NadunML/Windows-Auto-Proxy-Switcher.git](https://github.com/NadunML/Windows-Auto-Proxy-Switcher.git)
   ```
2. Open PowerShell inside the project folder and run:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File .\Install.ps1
   ```
3. This copies the script to `C:\Scripts\Update-Proxy.ps1` and creates three shortcuts on your Desktop:
   - **Auto Switch Proxy**
   - **Enable Campus Proxy**
   - **Disable Proxy**

## Customization for Other Networks
Open `Update-Proxy.ps1` in a text editor and modify the configuration variables at the top of the file:

```powershell
$ProxyAddress   = "192.168.16.2:3128"
$CampusNetworks = @(
    "SUSL_Student_Wi-Fi"
)
```

## Automate with Windows Task Scheduler (Optional)
To make the script run automatically every time you switch Wi-Fi networks:
1. Press `Win + R`, type `taskschd.msc`, and press **Enter**.
2. Click **Create Task...** in the right sidebar.
3. **General Tab:** Name it `Auto Switch Proxy` and select **Run only when user is logged on**.
4. **Triggers Tab:** Click **New...** and select **On an event**
   - **Log:** `Microsoft-Windows-NetworkProfile/Operational`
   - **Source:** `NetworkProfile`
   - **Event ID:** `10000`
5. **Actions Tab:** Click **New...** and select **Start a program**
   - **Program/script:** `powershell.exe`
   - **Add arguments:** `-ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Scripts\Update-Proxy.ps1"`
6. **Conditions Tab:** Uncheck **Start the task only if the computer is on AC power**.
7. Click **OK** to save.

## License
This project is open-source and available under the MIT License.
