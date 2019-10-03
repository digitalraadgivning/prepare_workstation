Write-Verbose "==== updating Windows theme"

# Write-Verbose "setting standard theme"
# Start-Process -FilePath .\ThemeSwitcher.exe -ArgumentList "$($env:windir)\Resources\Themes\aero.theme"

Write-Verbose "adding 'This PC' to Desktop"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "==== updating file explorer" 
Write-Verbose "visible file extensions"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "hiding hidden files and folders"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -PropertyType DWORD -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "deactivating checkboxes"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "defaults to 'This PC' when file explorer is opened"

New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -PropertyType DWORD -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "deactivating automatic app installation and ads"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null

# $subscribedContent = @($i | Get-Member | ? {$_.Name -like 'SubscribedContent*'} | Select-Object -ExpandProperty Name)
# foreach ($sub in $subscribedContent) {
#     New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name $sub -PropertyType DWORD -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
# }

Write-Verbose "==== changing power settings"
Start-Process -FilePath powercfg -ArgumentList "-x -standby-timeout-ac 0"
Start-Process -FilePath powercfg -ArgumentList "-x -standby-timeout-dc 120"
Start-Process -FilePath powercfg -ArgumentList "-x -hibernate-timeout-ac 0"
Start-Process -FilePath powercfg -ArgumentList "-x -hibernate-timeout-dc 30"
Start-Process -FilePath powercfg -ArgumentList "-setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3"    # when power button is pressed, dc. 3 = shut down.
Start-Process -FilePath powercfg -ArgumentList "-setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3"    # when power button is pressed, ac.
Start-Process -FilePath powercfg -ArgumentList "-setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1"    # when lid is closed, dc. 1 = sleep.
Start-Process -FilePath powercfg -ArgumentList "-setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1"    # when lid is closed, ac.

