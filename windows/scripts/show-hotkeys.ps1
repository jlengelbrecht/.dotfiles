Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Hotkey Cheatsheet'
$form.Size = New-Object System.Drawing.Size(900,750)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 46)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$textBox = New-Object System.Windows.Forms.RichTextBox
$textBox.Location = New-Object System.Drawing.Point(20,20)
$textBox.Size = New-Object System.Drawing.Size(850,680)
$textBox.Font = New-Object System.Drawing.Font("JetBrainsMono Nerd Font",11,[System.Drawing.FontStyle]::Regular)
$textBox.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 46)
$textBox.ForeColor = [System.Drawing.Color]::FromArgb(205, 214, 244)
$textBox.ReadOnly = $true
$textBox.BorderStyle = 'None'

$hotkeys = @"
================================================================
                    HOTKEY CHEATSHEET
================================================================

SYSTEM / CONFIGURATION
----------------------------------------------------------------
Win + O              Reload whkd
Win + Shift + O      Reload komorebi configuration
Win + Shift + A      Restart AutoHotkey
Win + Esc            Exit AutoHotkey (for gaming)
Win + Enter          Open Terminal
Win + Alt + D        Toggle Desktop Icons
Win + /              Show this cheatsheet

WINDOW MANAGEMENT
----------------------------------------------------------------
Win + Q              Close window
Win + Space          Minimize window
Win + W              Toggle floating
Win + P              Pause/Resume tiling
Win + Shift + R      Retile all windows

FOCUS WINDOWS
----------------------------------------------------------------
Win + Alt + Left     Focus window to the left
Win + Alt + Down     Focus window below
Win + Alt + Up       Focus window above
Win + Alt + Right    Focus window to the right

MOVE WINDOWS
----------------------------------------------------------------
Win + Shift + Left   Move window left
Win + Shift + Down   Move window down
Win + Shift + Up     Move window up
Win + Shift + Right  Move window right
Win + Shift + Enter  Promote window to main

STACK WINDOWS
----------------------------------------------------------------
Win + Left           Stack left
Win + Down           Stack down
Win + Up             Stack up
Win + Right          Stack right
Win + Shift + Space  Unstack window
Win + Tab            Cycle to next in stack
Win + Shift + Tab    Cycle to previous in stack

RESIZE WINDOWS
----------------------------------------------------------------
Win + Ctrl + Right   Increase horizontal size
Win + Ctrl + Left    Decrease horizontal size
Win + Ctrl + Up      Increase vertical size
Win + Ctrl + Down    Decrease vertical size

WORKSPACES
----------------------------------------------------------------
Win + 1-6            Switch to workspace 1-6
Win + Shift + 1-6    Move window to workspace 1-6

================================================================
                 Press ESC or click X to close
================================================================
"@

$textBox.Text = $hotkeys
$form.Controls.Add($textBox)

$form.KeyPreview = $true
$form.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') { $form.Close() }
})

[void]$form.ShowDialog()