Write-Verbose "==== Oppdaterer Windows-tema"

Write-Verbose "Setter standard tema"
#Start-Process -FilePath .\ThemeSwitcher.exe -ArgumentList "$($env:windir)\Resources\Themes\aero.theme"

Write-Verbose "Legger til Datamaskin på skrivebord"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "==== Oppdaterer Filutforsker" 
Write-Verbose "Aktiverer visning av filetternavn"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Deaktiverer visning av skjulte filer"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -PropertyType DWORD -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Deaktiverer avmerkingsbokser for elementer"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Setter Åpne filutforsker til å åpne Denne PC-en som standard"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -PropertyType DWORD -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Deaktiverer automatisk installasjon av apper og app-reklame"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

$subscribedContent = @($i | Get-Member | ? {$_.Name -like 'SubscribedContent*'} | Select-Object -ExpandProperty Name)
foreach ($sub in $subscribedContent) {
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name $sub -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
}

Write-Verbose "==== Endrer strøminnstillinger"
Start-Process -FilePath powercfg -ArgumentList "-x -standby-timeout-ac 0"
Start-Process -FilePath powercfg -ArgumentList "-x -standby-timeout-dc 120"
Start-Process -FilePath powercfg -ArgumentList "-x -hibernate-timeout-ac 0"
Start-Process -FilePath powercfg -ArgumentList "-x -hibernate-timeout-dc 30"

Write-Verbose "==== Decrapifying"
& '.\Windows 10 Decrapifier, 1803_1809.ps1' -LeaveTasks -LeaveServices -OneDrive -Cortana -Xbox -ClearStart

Start-Process -FilePath .\systemupdate5.07.0078.exe -ArgumentList "/VERYSILENT /NORESTART"

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco upgrade chocolatey -y

choco install googlechrome -y
choco install adobereader -y
choco install teamviewer -y
choco install vlc -y
choco install 7zip -y
choco install lenovo-thinkvantage-system-update -y