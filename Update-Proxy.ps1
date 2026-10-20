<#
.SYNOPSIS
    Automatically enables or disables the Windows system proxy based on the active Wi-Fi SSID.
#>

# --- CONFIGURATION ---
$ProxyAddress   = "192.168.16.2:3128"
$ProxyBypass    = "<local>"
$CampusNetworks = @(
    "SUSL_Student_Wi-Fi"
)
# ---------------------

# Wait briefly for the network interface to settle
Start-Sleep -Seconds 3

# Fetch active Wi-Fi SSID
$currentSSID = (netsh wlan show interfaces | Select-String '^\s*SSID\s*:' | Select-Object -First 1 | ForEach-Object { ($_ -split ':', 2)[1].Trim() })

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

if ($CampusNetworks -contains $currentSSID) {
    Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1
    Set-ItemProperty -Path $regPath -Name ProxyServer -Value $ProxyAddress
    Set-ItemProperty -Path $regPath -Name ProxyOverride -Value $ProxyBypass
    Write-Output "[+] Campus network detected ($currentSSID). Proxy ENABLED ($ProxyAddress)."
} else {
    Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 0
    Write-Output "[-] Non-campus network detected ($currentSSID). Proxy DISABLED."
}

# Notify Windows WinInet API so browsers apply the change immediately
$signature = @'
[DllImport("wininet.dll", SetLastError = true, CharSet=CharSet.Auto)]
public static extern bool InternetSetOption(IntPtr hInternet, int dwOption, IntPtr lpBuffer, int dwBufferLength);
'@
$wininet = Add-Type -MemberDefinition $signature -Name WinInet -Namespace PinVoke -PassThru
$wininet::InternetSetOption([IntPtr]::Zero, 39, [IntPtr]::Zero, 0) | Out-Null
$wininet::InternetSetOption([IntPtr]::Zero, 37, [IntPtr]::Zero, 0) | Out-Null