# Copyright 2025 ruticejp
# Licensed under the Apache License, Version 2.0

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

# SIG # Begin signature block
# MIIYIAYJKoZIhvcNAQcCoIIYETCCGA0CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCqGQUnrPjORX+U
# ezhPVY4fvyFCgpP13oUl/OLfuWBboqCCBVwwggVYMIIDQKADAgECAhBOqVA7l9RZ
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
# TgkyM/mCMYISGjCCEhYCAQEwWDBEMR0wGwYDVQQLDBRydXRpY2VqcCBTZWxmLVNp
# Z25lZDEjMCEGA1UEAwwaU2Vjb25kc0luV2luZG93czExVGFza3RyYXkCEE6pUDuX
# 1FmlTwrgpvyb4pswDQYJYIZIAWUDBAIBBQCgfDAQBgorBgEEAYI3AgEMMQIwADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg2uLcgdDpOJ3NXx4Hash3kGbIG5sgIyOp
# XEzVzn33lG8wDQYJKoZIhvcNAQEBBQAEggIAOAQAOdwFFx64/z0fIFCxbK+g1eBL
# SO5DQS0WZWwaLC5UrD/Bz7oeui2LI3LrMtTmAzqiLvmMM/fkaE5gxPPLN6qblSjv
# H7Jb4j34Nkk0e6Wx8Dr20aZDhYVHiMSfRaXYLOk5LhITrwZrQcX+Gii1wrCggjrC
# MRlJfJ/4ZFhIRO5U00lIGSrulz7knBSYPuqpRS0mLp4lNpCFQo6kJcYI78rsTjpb
# +XyDzLUoVuIO4FHCM9dO56/MInKamvf141LdXGNehlvx9MaNm49oxPj2dwehIfDG
# tQH21KzK59mo9V65Q5Kf1+gFyAsb3rz6IwNiq6YznuI3mNdn6cbYRfGPXVutITeZ
# 28hf3Im2KM1dyYAxctn6UR/f9H+vGBKn3VKlMhRftRP1qVpwjiN+9A3hfgJBv9i8
# wh8ap837cfnEwHXxcnhRV7uJEbsEixNhbUHOVABPIeoeBmZSgWo6g0tVjiyp4zB+
# 37d2dmFbAPSD5QGGZGOHCeVs8zvQRdBFqqdsiPNweBJfwYUDkOFWmHr4Y54s9ON2
# KxjLQ6WEROZMXeRcJCSeIw9GMbyCigpl7HGOGecvaigSV9YYirB+pvsoz4u2WGde
# vf6mWLzc9+8zNADrIZGK5WAVZFQngDf2fMae3dPQ2P9AXPhN3pbk1z5hZNKjys/e
# vzxpbmDHF/FP3/ahgg8VMIIPEQYKKwYBBAGCNwMDATGCDwEwgg79BgkqhkiG9w0B
# BwKggg7uMIIO6gIBAzENMAsGCWCGSAFlAwQCATB3BgsqhkiG9w0BCRABBKBoBGYw
# ZAIBAQYMKwYBBAGCqTABAwYBMDEwDQYJYIZIAWUDBAIBBQAEIKseg9djc8ijaDvL
# O6PF1Or2tzJxIECQmVfXqxA3vXPiAggSZ7fLj1QQsRgPMjAyNTA3MjUwNDI0MTJa
# MAMCAQGgggwAMIIE/DCCAuSgAwIBAgIQWlqs6Bo1brRiho1XfeA9xzANBgkqhkiG
# 9w0BAQsFADBzMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcM
# B0hvdXN0b24xETAPBgNVBAoMCFNTTCBDb3JwMS8wLQYDVQQDDCZTU0wuY29tIFRp
# bWVzdGFtcGluZyBJc3N1aW5nIFJTQSBDQSBSMTAeFw0yNDAyMTkxNjE4MTlaFw0z
# NDAyMTYxNjE4MThaMG4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4G
# A1UEBwwHSG91c3RvbjERMA8GA1UECgwIU1NMIENvcnAxKjAoBgNVBAMMIVNTTC5j
# b20gVGltZXN0YW1waW5nIFVuaXQgMjAyNCBFMTBZMBMGByqGSM49AgEGCCqGSM49
# AwEHA0IABKdhcvUw6XrEgxSWBULj3Oid25Rt2TJvSmLLaLy3cmVATADvhyMryD2Z
# ELwYfVwABUwivwzYd1mlWCRXUtcEsHyjggFaMIIBVjAfBgNVHSMEGDAWgBQMnRAl
# jpqnG5mHQ88IfuG9gZD0zzBRBggrBgEFBQcBAQRFMEMwQQYIKwYBBQUHMAKGNWh0
# dHA6Ly9jZXJ0LnNzbC5jb20vU1NMLmNvbS10aW1lU3RhbXBpbmctSS1SU0EtUjEu
# Y2VyMFEGA1UdIARKMEgwPAYMKwYBBAGCqTABAwYBMCwwKgYIKwYBBQUHAgEWHmh0
# dHBzOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeTAIBgZngQwBBAIwFgYDVR0lAQH/
# BAwwCgYIKwYBBQUHAwgwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybHMuc3Ns
# LmNvbS9TU0wuY29tLXRpbWVTdGFtcGluZy1JLVJTQS1SMS5jcmwwHQYDVR0OBBYE
# FFBPJKzvtT5jEyMJkibsujqW5F0iMA4GA1UdDwEB/wQEAwIHgDANBgkqhkiG9w0B
# AQsFAAOCAgEAmKCPAwCRvKvEZEF/QiHiv6tsIHnuVO7BWILqcfZ9lJyIyiCmpLOt
# J5VnZ4hvm+GP2tPuOpZdmfTYWdyzhhOsDVDLElbfrKMLiOXn9uwUJpa5fMZe3Zjo
# h+n/8DdnSw1MxZNMGhuZx4zeyqei91f1OhEU/7b2vnJCc9yBFMjY++tVKovFj0TK
# T3/Ry+Izdbb1gGXTzQQ1uVFy7djxGx/NG1VP/aye4OhxHG9FiZ3RM9oyAiPbEgjr
# nVCc+nWGKr3FTQDKi8vNuyLnCVHkiniL+Lz7H4fBgk163Llxi11Ynu5A/phpm1b+
# M2genvqo1+2r8iVLHrERgFGMUHEdKrZ/OFRDmgFrCTY6xnaPTA5/ursCqMK3q3/5
# 9uZaOsBZhZkaP9EuOW2p0U8Gkgqp2GNUjFoaDNWFoT/EcoGDiTgN8VmQFgn0Fa4/
# 3dOb6lpYEPBcjsWDdqUaxugStY9aW/AwCal4lSN4otljbok8u31lZx5NVa4jK6N6
# upvkgyZ6osmbmIWr9DLhg8bI+KiXDnDWT0547gSuZLYUq+TV6O/DhJZH5LVXJaeS
# 1jjjZZqhK3EEIJVZl0xYV4H4Skvy6hA2rUyFK3+whSNS52TJkshsxVCOPtvqA9ec
# PqZLwWBaIICG4zVr+GAD7qjWwlaLMd2ZylgOHI3Oit/0pVETqJHutyYwggb8MIIE
# 5KADAgECAhBtUhhwh+gjTYVgANCAj5NWMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNV
# BAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjEYMBYGA1UE
# CgwPU1NMIENvcnBvcmF0aW9uMTEwLwYDVQQDDChTU0wuY29tIFJvb3QgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkgUlNBMB4XDTE5MTExMzE4NTAwNVoXDTM0MTExMjE4
# NTAwNVowczELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMRAwDgYDVQQHDAdI
# b3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDEvMC0GA1UEAwwmU1NMLmNvbSBUaW1l
# c3RhbXBpbmcgSXNzdWluZyBSU0EgQ0EgUjEwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQCuURAT0vk8IKAghd7JUBxkyeH9xek0/wp/MUjoclrFXqhh/fGH
# 91Fc+7fm0MHCE7A+wmOiqBj9ODrJAYGq3rm33jCnHSsCBNWAQYyoauLq8IjqsS1J
# lXL29qDNMMdwZ8UNzQS7vWZMDJ40JSGNphMGTIA2qn2bohGtgRc4p1395ESypUOa
# GvJ3t0FNL3BuKmb6YctMcQUF2sqooMzd89h0E6ujdvBDo6ZwNnWoxj7YmfWjSXg3
# 3A5GuY9ym4QZM5OEVgo8ebz/B+gyhyCLNNhh4Mb/4xvCTCMVmNYrBviGgdPZYrym
# 8Zb84TQCmSuX0JlLLa6WK1aO6qlwISbb9bVGh866ekKblC/XRP20gAu1CjvcYciU
# gNTrGFg8f8AJgQPOCc1/CCdaJSYwhJpSdheKOnQgESgNmYZPhFOC6IKaMAUXk5U1
# tjTcFCgFvvArXtK4azAWUOO1Y3fdldIBL6LjkzLUCYJNkFXqhsBVcPMuB0nUDWvL
# JfPimstjJ8lF4S6ECxWnlWi7OElVwTnt1GtRqeY9ydvvGLntU+FecK7DbqHDUd36
# 6UreMkSBtzevAc9aqoZPnjVMjvFqV1pYOjzmTiVHZtAc80bAfFe5LLfJzPI6DntN
# yqobpwTevQpHqPDN9qqNO83r3kaw8A9j+HZiSw2AX5cGdQP0kG0vhzfgBwIDAQAB
# o4IBgTCCAX0wEgYDVR0TAQH/BAgwBgEB/wIBADAfBgNVHSMEGDAWgBTdBAkHovV6
# fVJTEpKV7jiAJQ2mWTCBgwYIKwYBBQUHAQEEdzB1MFEGCCsGAQUFBzAChkVodHRw
# Oi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeS9TU0xjb21Sb290Q2VydGlmaWNhdGlv
# bkF1dGhvcml0eVJTQS5jcnQwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3Nwcy5zc2wu
# Y29tMD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwczovL3d3
# dy5zc2wuY29tL3JlcG9zaXRvcnkwEwYDVR0lBAwwCgYIKwYBBQUHAwgwOwYDVR0f
# BDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNvbS9zc2wuY29tLXJzYS1Sb290
# Q0EuY3JsMB0GA1UdDgQWBBQMnRAljpqnG5mHQ88IfuG9gZD0zzAOBgNVHQ8BAf8E
# BAMCAYYwDQYJKoZIhvcNAQELBQADggIBAJIZdQ2mWkLPGQfZ8vyU+sCb8BXpRJZa
# L3Ez3VDlE3uZk3cPxPtybVfLuqaci0W6SB22JTMttCiQMnIVOsXWnIuAbD/aFTcU
# kTLBI3xys+wEajzXaXJYWACDS47BRjDtYlDW14gLJxf8W6DQoH3jHDGGy8kGJFOl
# DKG7/YrK7UGfHtBAEDVe6lyZ+FtCsrk7dD/IiL/+Q3Q6SFASJLQ2XI89ihFugdYL
# 77CiDNXrI2MFspQGswXEAGpHuaQDTHUp/LdR3TyrIsLlnzoLskUGswF/KF8+kpWU
# iKJNC4rPWtNrxlbXYRGgdEdx8SMjUTDClldcrknlFxbqHsVmr9xkT2QtFmG+dEq1
# v5fsIK0vHaHrWjMMmaJ9i+4qGJSD0stYfQ6v0PddT7EpGxGd867Ada6FZyHwbuQS
# adMb0K0P0OC2r7rwqBUe0BaMqTa6LWzWItgBjGcObXeMxmbQqlEz2YtAcErkZvh0
# WABDDE4U8GyV/32FdaAvJgTfe9MiL2nSBioYe/g5mHUSWAay/Ip1RQmQCvmF9sNf
# qlhJwkjy/1U1ibUkTIUBX3HgymyQvqQTZLLys6pL2tCdWcjI9YuLw30rgZm8+K38
# 7L7ycUvqrmQ3ZJlujHl3r1hgV76s3WwMPgKk1bAEFMj+rRXimSC+Ev30hXZdqyMd
# l/il5Ksd0vhGMYICVzCCAlMCAQEwgYcwczELMAkGA1UEBhMCVVMxDjAMBgNVBAgM
# BVRleGFzMRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDEvMC0G
# A1UEAwwmU1NMLmNvbSBUaW1lc3RhbXBpbmcgSXNzdWluZyBSU0EgQ0EgUjECEFpa
# rOgaNW60YoaNV33gPccwCwYJYIZIAWUDBAIBoIIBYTAaBgkqhkiG9w0BCQMxDQYL
# KoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTI1MDcyNTA0MjQxMlowKAYJKoZI
# hvcNAQk0MRswGTALBglghkgBZQMEAgGhCgYIKoZIzj0EAwIwLwYJKoZIhvcNAQkE
# MSIEIEq8Btc+MyjmLw+6Nm9e319ksYIv85mgnlCvFkYXU+z5MIHJBgsqhkiG9w0B
# CRACLzGBuTCBtjCBszCBsAQgnXF/jcI3ZarOXkqw4fV115oX1Bzu2P2v7wP9Pb2J
# R+cwgYswd6R1MHMxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UE
# BwwHSG91c3RvbjERMA8GA1UECgwIU1NMIENvcnAxLzAtBgNVBAMMJlNTTC5jb20g
# VGltZXN0YW1waW5nIElzc3VpbmcgUlNBIENBIFIxAhBaWqzoGjVutGKGjVd94D3H
# MAoGCCqGSM49BAMCBEYwRAIgA4TcIMt3VMvPlmDYn4/xy3uQ2OP3UU06vaHfkz5r
# H0cCIC4aUC8LkvIDpdX+JKpgiBF4Jzca0WwEi18nQGwU8ami
# SIG # End signature block
