# Copyright 2025 ruticejp
# Licensed under the Apache License, Version 2.0

<#
.SYNOPSIS
    Windows 11タスクトレイの時計に秒表示を切り替えるツール

.DESCRIPTION
    Windows 11のタスクトレイ時計に秒を表示/非表示にするためのツールです。
    GUIモードまたはコマンドラインモードで使用できます。

.PARAMETER Language
    表示言語を指定します。ja (日本語) または en (英語)

.PARAMETER Status
    現在の秒表示設定を確認します

.PARAMETER Enable
    秒表示を有効にします

.PARAMETER Disable
    秒表示を無効にします

.EXAMPLE
    .\ClockSeconds.ps1
    GUIモードで起動

.EXAMPLE
    .\ClockSeconds.ps1 -Status
    現在の設定を表示

.EXAMPLE
    .\ClockSeconds.ps1 -Enable
    秒表示を有効にする

.EXAMPLE
    .\ClockSeconds.ps1 -Disable
    秒表示を無効にする

.EXAMPLE
    .\ClockSeconds.ps1 -Enable -Language en
    英語で秒表示を有効にする
#>

param (
    [ValidateSet("ja", "en")]
    [string]$Language = "",
    [switch]$Status,
    [switch]$Enable,
    [switch]$Disable
)

# Define messages
$msg = @{
    "ja" = @{
        "Enabled" = "現在、秒の表示は有効です。"
        "Disabled" = "現在、秒の表示は無効です。"
        "SetEnable" = "秒の表示を有効に設定しました。"
        "SetDisable" = "秒の表示を無効に設定しました。"
        "Note" = "反映されない場合はログアウトまたは再起動してください。"
        "UnsupportedOS" = "このツールはWindows 11 (22H2以降)でのみ動作します。`n現在のOS: {0}`n現在のバージョン: {1}"
        "OSCheckFailed" = "OS情報の取得に失敗しました。"
    }
    "en" = @{
        "Enabled" = "Seconds are ENABLED."
        "Disabled" = "Seconds are DISABLED."
        "SetEnable" = "Seconds have been ENABLED."
        "SetDisable" = "Seconds have been DISABLED."
        "Note" = "If the change is not reflected, please log out or restart your PC."
        "UnsupportedOS" = "This tool only works on Windows 11 (22H2 or later).`nCurrent OS: {0}`nCurrent Version: {1}"
        "OSCheckFailed" = "Failed to retrieve OS information."
    }
}

# Detect system language if not specified
if (-not $Language) {
    $Language = (Get-Culture).TwoLetterISOLanguageName
}
if (-not $msg.ContainsKey($Language)) {
    $Language = "en"
}

# OS compatibility check function
function Test-OSCompatibility {
    try {
        # Check if running on Windows
        if (-not ($PSVersionTable.PSVersion.Major -ge 5 -and [System.Environment]::OSVersion.Platform -eq "Win32NT")) {
            return $false, "Non-Windows OS", "Unknown"
        }

        # Get OS information
        $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
        $osName = $osInfo.Caption
        $buildNumber = [int]$osInfo.BuildNumber

        # Check for Windows 11
        if ($osName -notmatch "Windows 11") {
            return $false, $osName, $buildNumber
        }

        # Check for 22H2 or later (Build 22621+)
        if ($buildNumber -lt 22621) {
            return $false, $osName, $buildNumber
        }

        return $true, $osName, $buildNumber
    }
    catch {
        return $false, "Unknown", "Unknown"
    }
}

# Perform OS compatibility check
$isCompatible, $osName, $osVersion = Test-OSCompatibility

if (-not $isCompatible) {
    $errorMessage = $msg[$Language]["UnsupportedOS"] -f $osName, $osVersion
    
    # Display error message
    if ($Status -or $Enable -or $Disable) {
        # Command-line mode - output to console
        Write-Host $errorMessage -ForegroundColor Red
        exit 1
    } else {
        # GUI mode - show message box
        Add-Type -AssemblyName System.Windows.Forms
        $title = if ($Language -eq "ja") { "エラー" } else { "Error" }
        [System.Windows.Forms.MessageBox]::Show($errorMessage, $title, "OK", "Error")
        exit 1
    }
}

# Registry path and key
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$regName = "ShowSecondsInSystemClock"

# Ensure registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Command-line mode check (before creating functions)
if ($Status -or $Enable -or $Disable) {
    # Get current value
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regName
    if ($null -eq $currentValue) {
        $currentValue = 0
    }

    if ($Status) {
        if ($currentValue -eq 1) {
            Write-Output $msg[$Language]["Enabled"]
        } else {
            Write-Output $msg[$Language]["Disabled"]
        }
        exit 0
    }

    if ($Enable) {
        Set-ItemProperty -Path $regPath -Name $regName -Value 1 -Type DWord
        Write-Output $msg[$Language]["SetEnable"]
        Write-Output $msg[$Language]["Note"]
        exit 0
    }

    if ($Disable) {
        Set-ItemProperty -Path $regPath -Name $regName -Value 0 -Type DWord
        Write-Output $msg[$Language]["SetDisable"]
        Write-Output $msg[$Language]["Note"]
        exit 0
    }
}

# GUI mode - Get current value
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

# SIG # Begin signature block
# MIIJEAYJKoZIhvcNAQcCoIIJATCCCP0CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC3FUzGCA/53VUU
# qHt+OAdP6XRqyyp2S7hpNaUG7l2hMaCCBVwwggVYMIIDQKADAgECAhBOqVA7l9RZ
# pU8K4Kb8m+KbMA0GCSqGSIb3DQEBCwUAMEQxHTAbBgNVBAsMFHJ1dGljZWpwIFNl
# bGYtU2lnbmVkMSMwIQYDVQQDDBpTZWNvbmRzSW5XaW5kb3dzMTFUYXNrdHJheTAe
# Fw0yNTA3MjUwMzI5MzBaFw0yNjA3MjUwMzQ5MzBaMEQxHTAbBgNVBAsMFHJ1dGlj
# ZWpwIFNlbGYtU2lnbmVkMSMwIQYDVQQDDBpTZWNvbmRzSW5XaW5kb3dzMTFUYXNr
# dHJheTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANHQzvVNdu0QlBZJ
# WhZC86scAkxXOhnbkwaWHqDg9ntzEwiyqmvWhIORqQkyUGfpZSmGRRc9zuT2YCeN
# wNtwzKOBBO1H23Os9O+bEKipEovGrJrNB+PG4T1Ma+btt5NV/h7B93D8dPDP11m1
# qQ1D56NhtDc2QG5l6ek5xNcFQUeLPpylnUN57b0g3YHopDGFAzxlCMAQqzSpVtj8
# 5QJNRf0ACbBjkUx463IRsxmddAR4K5H5wG4uBJgvS8k7kPKpWDtzpLmQpsnzBK5z
# MEwTUlv1H+VJquVPkVkV8aOrlWsULC8e/UurxZhG1bNFlCq0gOapTbVr2GYQaclz
# IDzyi+9dURyGAv7qsPpqA5nYGBilEJ1tTmQEjadcvO3KOei4FUjNT5q37PlF+cfA
# vhKmxSbqBWWKk+yHyLdhiTvJMTo8LUsbODbZfue5MYH/JKN/LU70J7RODn26uXV5
# /9xPrNecUJfnYSUOST5r8QpnIWGTI6pP9JQrKXa1hJqr4TOx1lu6nw+zqztuPzxf
# OhSSTxBOn0cc+68MYQOqPtuaLZ+hdo/tPuDhzAYxhyk27ORCih7V1YK24CMD58+H
# nT7sLEAJD5CF+rI3OfLNWOTI/Hg4B75/nt00k+sFYyd+j/FEii9USF1WRsVdBKY3
# RC6Ze+m4heY7yxja1FBfa0un9u9xAgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUgLhWoyv2dPu+kICR5hzxsqTG
# 484wDQYJKoZIhvcNAQELBQADggIBAKmay56Gthk+XRa2xTjzbBsgn099tr/3OxEM
# De25Zx/X+9Znw3/9dyJsKG5jy8AAV4li+HNZnWdPInqpU3cQtytx0qEYcCpoi9QA
# Bd0Ofggz6Qzy6UlA34zHAMvgGnMeQABuYiqD7+XigKuEw87VtKi+oIlib2s3dVL+
# EjTe+dHJAuGoOnqb35k8l81+AoPTn35qaJMpYhFjOMIgETG7sFYVWhxgr3TCSV1G
# i2GrQvNHMonEjf6Y3VuJps/kSc3ltqpCaMTKDksQ4pblSSBiITvO0a6y4LwZZAMy
# piN7JO1SOn/PlsZdLLRBca4XbsOArEXxj7wnQOW7uEGDFt5rkvk/eQmTQz1k7nIC
# jOoz+bK1Y7qqXpytlNMIauEtTE9ilzKfZzKrzpIjpk/AiZkpjk+FFFlMzUUZr0GC
# 2gZg/m6/1uiIOE95kQ7KSzoXWk8It/yiqjLw1GTGmlu7h8Nwb+4ednnVwUT4x98G
# CigwJMuliXSmfSxaH9jgJr/xFI73RZfhpa15VXaj4+IJy+LnQPQ3VV5qvJhCwZ3M
# bLzvuI4bD3gcWT7O17xXC0I3HOoWXP10vhd9cJtbglCDmbT63KhxteAvOMYZoqr2
# U82uvWBD8tnLWkheF7PpQH0NiVraXKBf+LMJ6uZTUcKjf0/XjTai3BRXH6z6Ejii
# TgkyM/mCMYIDCjCCAwYCAQEwWDBEMR0wGwYDVQQLDBRydXRpY2VqcCBTZWxmLVNp
# Z25lZDEjMCEGA1UEAwwaU2Vjb25kc0luV2luZG93czExVGFza3RyYXkCEE6pUDuX
# 1FmlTwrgpvyb4pswDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgvfPQ8KE9erzmyIVUl1/7
# F+BtiPn4jgpZSS399P6VZp4wDQYJKoZIhvcNAQEBBQAEggIAes5vVk0gL4LRp33q
# xcc6zxO8LHA+d9jcNHfaMdAoSBypIDuIMUw4UV/7bMMe46899cHJM56PiTzSoYXY
# TfFAm9ibDj4D1OMatdxziZ53DtXzPROtNL9QmUQhYhvc6D60jDFNJlAI/LB+WOLc
# 3gc0vEns5sZ+ZZdj+NUHydq29HKktWCPOI8UWAWO7jFxbZPh5aLw4uvNyAq3fdB3
# NKzkuYbyTNSRClFoFS9ZrGcthxPV0HvF6mecry0PaoAPbY7/iMwdlTM0V7geswgF
# Mt//jF9ywcP5OQrujrk0xE4FH5RXkUeoSYh8AnROZK0izMi3qs+Zj9843WzpOCCR
# ZIhENzeOWrrnGDHjZIa1D/dHsbYRQkJDG5ulC8W5zRwPLCn6gvEQejc+6nlqJ9FY
# gnDyvU5qvJ05LZ6435Dlvn3FRaRzdR1kL1nORkfuD48wXKnwVzSWgtJfnWEtl0TM
# CtGBCKBPSlXthuy+JEt1QQDRVm17ymUNuu/VGPiTDF9YE8Z215JXaO0hFE80jvsR
# JRq1IdFeQQoOzeTfg9vK6QgKbJxJfL02e1US9k8j4vFE2rkEMK1cZHtgdieIPTdE
# wBlXDynYR1mnKdRHg+0GrhfPPbOnfe1Ik9Yjas4LBTfuFFFULbfSLyZA2i0PJHQ9
# GSAAOXyy0MliLgedboSAJRgj87U=
# SIG # End signature block
