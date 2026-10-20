<#
.SYNOPSIS
    Copies Update-Proxy.ps1 to C:\Scripts and creates Desktop shortcuts.
#>

$InstallDir = "C:\Scripts"
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

# Copy the main script to C:\Scripts
Copy-Item -Path "$PSScriptRoot\Update-Proxy.ps1" -Destination "$InstallDir\Update-Proxy.ps1" -Force

$WshShell = New-Object -ComObject WScript.Shell

# 1. Auto Switch Shortcut
$AutoShortcut = $WshShell.CreateShortcut("$Home\Desktop\Auto Switch Proxy.lnk")
$AutoShortcut.TargetPath = "powershell.exe"
$AutoShortcut.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$InstallDir\Update-Proxy.ps1`""
$AutoShortcut.IconLocation = "shell32.dll,18"
$AutoShortcut.Save()

# 2. Enable Proxy Shortcut
$EnableShortcut = $WshShell.CreateShortcut("$Home\Desktop\Enable Campus Proxy.lnk")
$EnableShortcut.TargetPath = "cmd.exe"
$EnableShortcut.Arguments = "/c reg add `"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings`" /v ProxyEnable /t REG_DWORD /d 1 /f & reg add `"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings`" /v ProxyServer /t REG_SZ /d `"192.168.16.2:3128`" /f"
$EnableShortcut.IconLocation = "shell32.dll,135"
$EnableShortcut.Save()

# 3. Disable Proxy Shortcut
$DisableShortcut = $WshShell.CreateShortcut("$Home\Desktop\Disable Proxy.lnk")
$DisableShortcut.TargetPath = "cmd.exe"
$DisableShortcut.Arguments = "/c reg add `"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings`" /v ProxyEnable /t REG_DWORD /d 0 /f"
$DisableShortcut.IconLocation = "shell32.dll,131"
$DisableShortcut.Save()

Write-Host "Installation complete. Script installed to $InstallDir and shortcuts added to Desktop." -ForegroundColor Green