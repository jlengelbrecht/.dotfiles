# Save as: C:\Users\DudeI\repos\.dotfiles\windows\scripts\restart-ahk.ps1

$ahk = @(
  "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe",
  "$env:ProgramFiles\AutoHotkey\AutoHotkey.exe",
  "$env:LOCALAPPDATA\Programs\AutoHotkey\AutoHotkey.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

# Point to your actual script in the repo
$script = "C:\Users\DudeI\repos\.dotfiles\windows\configs\ahk\elrond.ahk"

if ($ahk -and (Test-Path $script)) {
  # Kill existing AHK processes first
  Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue | Stop-Process -Force
  Start-Sleep -Milliseconds 500
  
  Start-Process $ahk -ArgumentList "`"$script`"" -WindowStyle Hidden
  Write-Host "AutoHotkey restarted"
} else {
  Write-Host "AHK not found: ahk=$ahk script=$script"
}