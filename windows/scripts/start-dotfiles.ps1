#requires -version 5
$ErrorActionPreference = 'SilentlyContinue'
$log = "$env:LOCALAPPDATA\dotfiles\startup.log"

function Log($m){ (Get-Date -Format 'HH:mm:ss') + ' ' + $m | Out-File -FilePath $log -Append -Encoding utf8 }

Remove-Item $log -ErrorAction SilentlyContinue

# Wait for Explorer (appbar registration, etc.)
for ($i=0; $i -lt 60 -and -not (Get-Process explorer -ErrorAction SilentlyContinue); $i++){ Start-Sleep -Milliseconds 500 }
Log "Explorer ready after $i checks"

# Resolve binaries
$komorebic = (Get-Command komorebic -ErrorAction SilentlyContinue).Source
$whkdExe   = (Get-Command whkd      -ErrorAction SilentlyContinue).Source
if (-not $whkdExe) { $whkdExe = "C:\Program Files\whkd\bin\whkd.exe" }

$yasbExe   = (Get-Command yasb -ErrorAction SilentlyContinue).Source
if (-not $yasbExe) {
  foreach ($p in @('C:\Program Files\YASB\yasb.exe','C:\Program Files\yasb\yasb.exe','C:\Program Files (x86)\YASB\yasb.exe')) {
    if (Test-Path $p) { $yasbExe = $p; break }
  }
}

$ahk = @(
  "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe",
  "$env:ProgramFiles\AutoHotkey\AutoHotkey.exe",
  "$env:LOCALAPPDATA\Programs\AutoHotkey\AutoHotkey.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
$DefaultAhk = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'AutoHotkey.ahk'

function Start-IfMissing($name,$exe,$args="",$hidden=$true){
  if (Get-Process -Name $name -ErrorAction SilentlyContinue) { Log "Skip: $name already running"; return }
  if (-not $exe -or -not (Test-Path $exe)) { Log "Skip: $name missing exe ($exe)"; return }
  Log "Start: $name -> $exe $args"
  if ($hidden) { Start-Process -FilePath $exe -ArgumentList $args -WindowStyle Hidden -WorkingDirectory (Split-Path $exe) }
  else { Start-Process -FilePath $exe -ArgumentList $args -WorkingDirectory (Split-Path $exe) }
}

# Start komorebi
if ($komorebic) {
  try { Log "komorebic start"; & $komorebic start | Out-Null } catch { Log "komorebic start error: $_" }
  Start-Sleep -Seconds 1
} else { Log "komorebic not found" }

# Start whkd
Start-IfMissing 'whkd' $whkdExe

# Start YASB with retry
if ($yasbExe) {
  Log "YASB start attempt 1"
  Start-Process -FilePath $yasbExe -WindowStyle Hidden -WorkingDirectory (Split-Path $yasbExe) -PassThru | Out-Null
  Start-Sleep -Seconds 2
  if (-not (Get-Process -Name 'yasb' -ErrorAction SilentlyContinue)) {
    Log "YASB not detected; retrying with cmd /c start"
    Start-Process cmd -ArgumentList "/c start `"`" `"`"$yasbExe`"`"" -WorkingDirectory (Split-Path $yasbExe) -WindowStyle Hidden
  } else { Log "YASB running" }
} else {
  Log "YASB exe not found"
}

# Start AutoHotkey with your wrapper (AutoHotkey.ahk includes repo script)
if ($ahk -and (Test-Path $DefaultAhk)) {
  if (-not (Get-Process -Name 'AutoHotkey64','AutoHotkey' -ErrorAction SilentlyContinue)) {
    Log "Start AHK: $ahk -> $DefaultAhk"
    Start-Process $ahk -ArgumentList "`"$DefaultAhk`"" -WindowStyle Hidden
  } else { Log 'AHK already running' }
} else {
  Log 'AHK not configured or default script missing'
}

Log 'Done.'
