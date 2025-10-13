# Save as: C:\Users\DudeI\repos\.dotfiles\windows\scripts\restart-ahk.ps1

$ahk = @(
  "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe",
  "$env:ProgramFiles\AutoHotkey\AutoHotkey.exe",
  "$env:LOCALAPPDATA\Programs\AutoHotkey\AutoHotkey.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$script = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'AutoHotkey.ahk'

if ($ahk -and (Test-Path $script)) {
  Start-Process $ahk -ArgumentList "`"$script`"" -WindowStyle Hidden
  Write-Host "AutoHotkey restarted"
} else {
  Write-Host "AHK not found"
}