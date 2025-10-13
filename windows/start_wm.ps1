#requires -version 5
\Continue = 'SilentlyContinue'

function Log(\){ \03:17:05 + ' ' + \ | Out-File -FilePath 'C:\Users\DudeI\AppData\Local\dotfiles-startup.log' -Append -Encoding utf8 }

function Start-IfMissing(\, \, \ = '', \ = \True) {
  if (Get-Process -Name \ -ErrorAction SilentlyContinue) { Log "Skip: \ already running"; return }
  if (-not \ -or -not (Test-Path \)) { Log "Skip: \ missing exe (\)"; return }
  Log "Start: \ -> \ \"
  if (\) { Start-Process -FilePath \ -ArgumentList \ -WindowStyle Hidden -WorkingDirectory (Split-Path \) }
  else         { Start-Process -FilePath \ -ArgumentList \ -WorkingDirectory (Split-Path \) }
}

# clean log each boot
Remove-Item 'C:\Users\DudeI\AppData\Local\dotfiles-startup.log' -ErrorAction SilentlyContinue

# wait for Explorer (registers appbar areas etc.)
\ = 0
while (-not (Get-Process explorer -ErrorAction SilentlyContinue) -and \ -lt 60) { Start-Sleep -Milliseconds 500; \++ }
Log "Explorer ready after \ checks"

# resolve binaries
\ = (Get-Command komorebic -ErrorAction SilentlyContinue).Source
\   = (Get-Command whkd      -ErrorAction SilentlyContinue).Source
\   = (Get-Command yasb      -ErrorAction SilentlyContinue).Source
if (-not \) {
  foreach (\ in @('C:\Program Files\YASB\yasb.exe','C:\Program Files\yasb\yasb.exe','C:\Program Files (x86)\YASB\yasb.exe')) {
    if (Test-Path \) { \ = \; break }
  }
}
\ = @(
  "\C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe",
  "\C:\Program Files\AutoHotkey\AutoHotkey.exe",
  "\C:\Users\DudeI\AppData\Local\Programs\AutoHotkey\AutoHotkey.exe"
) | Where-Object { Test-Path \ } | Select-Object -First 1
\ = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'AutoHotkey.ahk'

# start in order
if (\) { Log "komorebic start"; & \ start | Out-Null; Start-Sleep -Seconds 1 }

Start-IfMissing -name 'whkd' -exe \

# YASB: explicit working dir + retry if not up
if (\) {
  Log "YASB start attempt 1"
  Start-Process -FilePath \ -WindowStyle Hidden -WorkingDirectory (Split-Path \) -PassThru | Out-Null
  Start-Sleep -Seconds 2
  if (-not (Get-Process -Name 'yasb' -ErrorAction SilentlyContinue)) {
    Log 'YASB not detected; retrying with cmd /c start'
    Start-Process cmd -ArgumentList "/c start "" "\"" -WorkingDirectory (Split-Path \) -WindowStyle Hidden
  } else { Log 'YASB running' }
} else {
  Log 'YASB exe not found'
}

if (\ -and (Test-Path \)) {
  if (-not (Get-Process -Name 'AutoHotkey64','AutoHotkey' -ErrorAction SilentlyContinue)) {
    Log "Start AHK: \ -> \"
    Start-Process \ -ArgumentList ""\"" -WindowStyle Hidden
  } else { Log 'AHK already running' }
} else { Log 'AHK not configured or default script missing' }

Log 'Done.'
