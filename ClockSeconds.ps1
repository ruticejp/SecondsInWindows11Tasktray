param (
    [ValidateSet("ja", "en")]
    [string]$Language = "",
    [switch]$GetStatus,
    [ValidateSet("Enable", "Disable")]
    [string]$SetStatus
)

# Define messages
$msg = @{
    "ja" = @{
        "Enabled" = "現在、秒の表示は有効です。"
        "Disabled" = "現在、秒の表示は無効です。"
        "SetEnable" = "秒の表示を有効に設定しました。"
        "SetDisable" = "秒の表示を無効に設定しました。"
        "Note" = "反映されない場合はログアウトまたは再起動してください。"
    }
    "en" = @{
        "Enabled" = "Seconds are ENABLED."
        "Disabled" = "Seconds are DISABLED."
        "SetEnable" = "Seconds have been ENABLED."
        "SetDisable" = "Seconds have been DISABLED."
        "Note" = "If the change is not reflected, please log out or restart your PC."
    }
}

# Detect system language if not specified
if (-not $Language) {
    $Language = (Get-Culture).TwoLetterISOLanguageName
}
if (-not $msg.ContainsKey($Language)) {
    $Language = "en"
}

# Registry path and key
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$regName = "ShowSecondsInSystemClock"

# Ensure registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Get current value
$currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regName
if ($null -eq $currentValue) {
    $currentValue = 0
}

function Get-ClockStatus {
    if ($currentValue -eq 1) {
        Write-Output $msg[$Language]["Enabled"]
    } else {
        Write-Output $msg[$Language]["Disabled"]
    }
}

function Set-ClockStatus {
    param([string]$mode)
    $newValue = if ($mode -eq "Enable") { 1 } else { 0 }
    Set-ItemProperty -Path $regPath -Name $regName -Value $newValue -Type DWord
    if ($mode -eq "Enable") {
        Write-Output $msg[$Language]["SetEnable"]
    } else {
        Write-Output $msg[$Language]["SetDisable"]
    }
    Write-Output $msg[$Language]["Note"]
}

# Command-line mode
if ($GetStatus) {
    Get-ClockStatus
    return
}

if ($SetStatus) {
    Set-ClockStatus -mode $SetStatus
    return
}

# GUI mode
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$title = if ($Language -eq "ja") { "秒表示設定" } else { "Clock Seconds Setting" }
$enableButton = if ($Language -eq "ja") { "秒を表示する" } else { "Enable Seconds" }
$disableButton = if ($Language -eq "ja") { "秒を非表示にする" } else { "Disable Seconds" }

$form = New-Object System.Windows.Forms.Form
$form.Text = $title
$form.Size = New-Object System.Drawing.Size(400, 250)
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(20, 20)
$statusLabel.Size = New-Object System.Drawing.Size(360, 20)
$statusLabel.Text = if ($currentValue -eq 1) { $msg[$Language]["Enabled"] } else { $msg[$Language]["Disabled"] }
$form.Controls.Add($statusLabel)

$enableButtonControl = New-Object System.Windows.Forms.Button
$enableButtonControl.Location = New-Object System.Drawing.Point(50, 60)
$enableButtonControl.Size = New-Object System.Drawing.Size(120, 30)
$enableButtonControl.Text = $enableButton
$enableButtonControl.Enabled = ($currentValue -ne 1)
$form.Controls.Add($enableButtonControl)

$disableButtonControl = New-Object System.Windows.Forms.Button
$disableButtonControl.Location = New-Object System.Drawing.Point(220, 60)
$disableButtonControl.Size = New-Object System.Drawing.Size(120, 30)
$disableButtonControl.Text = $disableButton
$disableButtonControl.Enabled = ($currentValue -ne 0)
$form.Controls.Add($disableButtonControl)

$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Location = New-Object System.Drawing.Point(20, 110)
$messageLabel.Size = New-Object System.Drawing.Size(360, 60)
$messageLabel.AutoSize = $false
$messageLabel.MaximumSize = New-Object System.Drawing.Size(360, 0)
$messageLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$messageLabel.ForeColor = [System.Drawing.Color]::Blue
$messageLabel.Text = ""
$form.Controls.Add($messageLabel)

$enableButtonControl.Add_Click({
    Set-ItemProperty -Path $regPath -Name $regName -Value 1 -Type DWord
    $messageLabel.Text = $msg[$Language]["SetEnable"] + "`n" + $msg[$Language]["Note"]
    $enableButtonControl.Enabled = $false
    $disableButtonControl.Enabled = $true
    $statusLabel.Text = $msg[$Language]["Enabled"]
})

$disableButtonControl.Add_Click({
    Set-ItemProperty -Path $regPath -Name $regName -Value 0 -Type DWord
    $messageLabel.Text = $msg[$Language]["SetDisable"] + "`n" + $msg[$Language]["Note"]
    $enableButtonControl.Enabled = $true
    $disableButtonControl.Enabled = $false
    $statusLabel.Text = $msg[$Language]["Disabled"]
})

[void]$form.ShowDialog()
