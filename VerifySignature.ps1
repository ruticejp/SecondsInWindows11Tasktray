# Copyright 2025 ruticejp
# Licensed under the Apache License, Version 2.0

# ClockSeconds.ps1の署名検証スクリプト
# Signature verification script for ClockSeconds.ps1

# 言語判定 / Language detection
$isJapanese = (Get-Culture).Name -like "ja*"

if ($isJapanese) {
    Write-Host "=== ClockSeconds.ps1 署名検証 ===" -ForegroundColor Yellow
} else {
    Write-Host "=== ClockSeconds.ps1 Signature Verification ===" -ForegroundColor Yellow
}
Write-Host ""

# 1. Authenticode署名の検証
if ($isJapanese) {
    Write-Host "1. Authenticode署名検証:" -ForegroundColor Cyan
} else {
    Write-Host "1. Authenticode Signature Verification:" -ForegroundColor Cyan
}

$certPath = "$PSScriptRoot\ClockSeconds.cer"
if (Test-Path $certPath) {
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath)
    $sig = Get-AuthenticodeSignature "$PSScriptRoot\ClockSeconds.ps1"
    
    if ($sig.SignerCertificate -and $sig.SignerCertificate.Thumbprint -eq $cert.Thumbprint) {
        if ($isJapanese) {
            Write-Host "   ✅ 署名は一致しています。" -ForegroundColor Green
        } else {
            Write-Host "   ✅ Signature verification successful." -ForegroundColor Green
        }
    } else {
        if ($isJapanese) {
            Write-Host "   ❌ 署名は一致していません。" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Signature verification failed." -ForegroundColor Red
        }
    }
} else {
    if ($isJapanese) {
        Write-Host "   ⚠️  証明書ファイルが見つかりません: $certPath" -ForegroundColor Yellow
    } else {
        Write-Host "   ⚠️  Certificate file not found: $certPath" -ForegroundColor Yellow
    }
}

Write-Host ""

# 2. Ed25519署名の検証（OpenSSLを使用）
if ($isJapanese) {
    Write-Host "2. Ed25519署名検証:" -ForegroundColor Cyan
} else {
    Write-Host "2. Ed25519 Signature Verification:" -ForegroundColor Cyan
}

# OpenSSLの存在確認
$opensslExists = $false
try {
    $null = Get-Command openssl -ErrorAction Stop
    $opensslExists = $true
} catch {
    $opensslExists = $false
}

if ($opensslExists) {
    $pubKeyPath = "$PSScriptRoot\ClockSeconds_ed25519.pub"
    $sigPath = "$PSScriptRoot\ClockSeconds.sig"
    $scriptPath = "$PSScriptRoot\ClockSeconds.ps1"
    
    if ((Test-Path $pubKeyPath) -and (Test-Path $sigPath) -and (Test-Path $scriptPath)) {
        try {
            # OpenSSLコマンドを実行
            $result = & openssl pkeyutl -verify -inkey $pubKeyPath -pubin -sigfile $sigPath -in $scriptPath 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                if ($isJapanese) {
                    Write-Host "   ✅ Ed25519署名の検証に成功しました。" -ForegroundColor Green
                } else {
                    Write-Host "   ✅ Ed25519 signature verification successful." -ForegroundColor Green
                }
            } else {
                if ($isJapanese) {
                    Write-Host "   ❌ Ed25519署名の検証に失敗しました。" -ForegroundColor Red
                    Write-Host "   詳細: $result" -ForegroundColor Gray
                } else {
                    Write-Host "   ❌ Ed25519 signature verification failed." -ForegroundColor Red
                    Write-Host "   Details: $result" -ForegroundColor Gray
                }
            }
        } catch {
            if ($isJapanese) {
                Write-Host "   ❌ OpenSSLコマンドの実行中にエラーが発生しました。" -ForegroundColor Red
                Write-Host "   詳細: $($_.Exception.Message)" -ForegroundColor Gray
            } else {
                Write-Host "   ❌ Error occurred while executing OpenSSL command." -ForegroundColor Red
                Write-Host "   Details: $($_.Exception.Message)" -ForegroundColor Gray
            }
        }
    } else {
        if ($isJapanese) {
            Write-Host "   ⚠️  必要なファイルが見つかりません:" -ForegroundColor Yellow
        } else {
            Write-Host "   ⚠️  Required files not found:" -ForegroundColor Yellow
        }
        if (-not (Test-Path $pubKeyPath)) { Write-Host "      - $pubKeyPath" -ForegroundColor Gray }
        if (-not (Test-Path $sigPath)) { Write-Host "      - $sigPath" -ForegroundColor Gray }
        if (-not (Test-Path $scriptPath)) { Write-Host "      - $scriptPath" -ForegroundColor Gray }
    }
} else {
    if ($isJapanese) {
        Write-Host "   ⚠️  OpenSSLコマンドが見つかりません。Ed25519署名の検証をスキップします。" -ForegroundColor Yellow
        Write-Host "   ヒント: OpenSSLをインストールしてPATHに追加してください。" -ForegroundColor Gray
    } else {
        Write-Host "   ⚠️  OpenSSL command not found. Skipping Ed25519 signature verification." -ForegroundColor Yellow
        Write-Host "   Hint: Install OpenSSL and add it to your PATH." -ForegroundColor Gray
    }
}

Write-Host ""
if ($isJapanese) {
    Write-Host "=== 検証完了 ===" -ForegroundColor Yellow
} else {
    Write-Host "=== Verification Complete ===" -ForegroundColor Yellow
}

# SIG # Begin signature block
# MIIfdAYJKoZIhvcNAQcCoIIfZTCCH2ECAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA76Drzl8cMmJ+9
# z7dahUVUpsqVUjTx7JWDGoak8V0Ga6CCGJYwggVYMIIDQKADAgECAhBOqVA7l9RZ
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
# TgkyM/mCMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0B
# AQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz
# 7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS
# 5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7
# bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfI
# SKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jH
# trHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14
# Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2
# h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt
# 6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPR
# iQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ER
# ElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4K
# Jpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAd
# BgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SS
# y4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAC
# hjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
# b290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRV
# HSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyh
# hyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO
# 0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo
# 8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9HdaXFSMb++h
# UD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5x
# aiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIGtDCCBJyg
# AwIBAgIQDcesVwX/IZkuQEMiDDpJhjANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwHhcNMjUw
# NTA3MDAwMDAwWhcNMzgwMTE0MjM1OTU5WjBpMQswCQYDVQQGEwJVUzEXMBUGA1UE
# ChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQg
# VGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAtHgx0wqYQXK+PEbAHKx126NGaHS0URedTa2N
# DZS1mZaDLFTtQ2oRjzUXMmxCqvkbsDpz4aH+qbxeLho8I6jY3xL1IusLopuW2qft
# JYJaDNs1+JH7Z+QdSKWM06qchUP+AbdJgMQB3h2DZ0Mal5kYp77jYMVQXSZH++0t
# rj6Ao+xh/AS7sQRuQL37QXbDhAktVJMQbzIBHYJBYgzWIjk8eDrYhXDEpKk7RdoX
# 0M980EpLtlrNyHw0Xm+nt5pnYJU3Gmq6bNMI1I7Gb5IBZK4ivbVCiZv7PNBYqHEp
# NVWC2ZQ8BbfnFRQVESYOszFI2Wv82wnJRfN20VRS3hpLgIR4hjzL0hpoYGk81coW
# J+KdPvMvaB0WkE/2qHxJ0ucS638ZxqU14lDnki7CcoKCz6eum5A19WZQHkqUJfdk
# DjHkccpL6uoG8pbF0LJAQQZxst7VvwDDjAmSFTUms+wV/FbWBqi7fTJnjq3hj0Xb
# Qcd8hjj/q8d6ylgxCZSKi17yVp2NL+cnT6Toy+rN+nM8M7LnLqCrO2JP3oW//1sf
# uZDKiDEb1AQ8es9Xr/u6bDTnYCTKIsDq1BtmXUqEG1NqzJKS4kOmxkYp2WyODi7v
# QTCBZtVFJfVZ3j7OgWmnhFr4yUozZtqgPrHRVHhGNKlYzyjlroPxul+bgIspzOwb
# tmsgY1MCAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYE
# FO9vU0rp5AZ8esrikFb2L9RJ7MtOMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/n
# upiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3Bggr
# BgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQAX
# zvsWgBz+Bz0RdnEwvb4LyLU0pn/N0IfFiBowf0/Dm1wGc/Do7oVMY2mhXZXjDNJQ
# a8j00DNqhCT3t+s8G0iP5kvN2n7Jd2E4/iEIUBO41P5F448rSYJ59Ib61eoalhnd
# 6ywFLerycvZTAz40y8S4F3/a+Z1jEMK/DMm/axFSgoR8n6c3nuZB9BfBwAQYK9FH
# aoq2e26MHvVY9gCDA/JYsq7pGdogP8HRtrYfctSLANEBfHU16r3J05qX3kId+ZOc
# zgj5kjatVB+NdADVZKON/gnZruMvNYY2o1f4MXRJDMdTSlOLh0HCn2cQLwQCqjFb
# qrXuvTPSegOOzr4EWj7PtspIHBldNE2K9i697cvaiIo2p61Ed2p8xMJb82Yosn0z
# 4y25xUbI7GIN/TpVfHIqQ6Ku/qjTY6hc3hsXMrS+U0yy+GWqAXam4ToWd2UQ1KYT
# 70kZjE4YtL8Pbzg0c1ugMZyZZd/BdHLiRu7hAWE6bTEm4XYRkA6Tl4KSFLFk43es
# aUeqGkH/wyW4N7OigizwJWeukcyIPbAvjSabnf7+Pu0VrFgoiovRDiyx3zEdmcif
# /sYQsfch28bZeUz2rtY/9TCA6TD8dC3JE3rYkrhLULy7Dc90G6e8BlqmyIjlgp2+
# VqsS9/wQD7yFylIz0scmbKvFoW2jNrbM1pD2T7m3XDCCBu0wggTVoAMCAQICEAqA
# 7xhLjfEFgtHEdqeVdGgwDQYJKoZIhvcNAQELBQAwaTELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVk
# IEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1IENBMTAeFw0yNTA2
# MDQwMDAwMDBaFw0zNjA5MDMyMzU5NTlaMGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQK
# Ew5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgU0hBMjU2IFJTQTQw
# OTYgVGltZXN0YW1wIFJlc3BvbmRlciAyMDI1IDEwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQDQRqwtEsae0OquYFazK1e6b1H/hnAKAd/KN8wZQjBjMqiZ
# 3xTWcfsLwOvRxUwXcGx8AUjni6bz52fGTfr6PHRNv6T7zsf1Y/E3IU8kgNkeECqV
# Q+3bzWYesFtkepErvUSbf+EIYLkrLKd6qJnuzK8Vcn0DvbDMemQFoxQ2Dsw4vEjo
# T1FpS54dNApZfKY61HAldytxNM89PZXUP/5wWWURK+IfxiOg8W9lKMqzdIo7VA1R
# 0V3Zp3DjjANwqAf4lEkTlCDQ0/fKJLKLkzGBTpx6EYevvOi7XOc4zyh1uSqgr6Un
# bksIcFJqLbkIXIPbcNmA98Oskkkrvt6lPAw/p4oDSRZreiwB7x9ykrjS6GS3NR39
# iTTFS+ENTqW8m6THuOmHHjQNC3zbJ6nJ6SXiLSvw4Smz8U07hqF+8CTXaETkVWz0
# dVVZw7knh1WZXOLHgDvundrAtuvz0D3T+dYaNcwafsVCGZKUhQPL1naFKBy1p6ll
# N3QgshRta6Eq4B40h5avMcpi54wm0i2ePZD5pPIssoszQyF4//3DoK2O65Uck5Wg
# gn8O2klETsJ7u8xEehGifgJYi+6I03UuT1j7FnrqVrOzaQoVJOeeStPeldYRNMmS
# F3voIgMFtNGh86w3ISHNm0IaadCKCkUe2LnwJKa8TIlwCUNVwppwn4D3/Pt5pwID
# AQABo4IBlTCCAZEwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQU5Dv88jHt/f3X85Fx
# YxlQQ89hjOgwHwYDVR0jBBgwFoAU729TSunkBnx6yuKQVvYv1Ensy04wDgYDVR0P
# AQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMIGVBggrBgEFBQcBAQSB
# iDCBhTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMF0GCCsG
# AQUFBzAChlFodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVz
# dGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcnQwXwYDVR0f
# BFgwVjBUoFKgUIZOaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1
# c3RlZEc0VGltZVN0YW1waW5nUlNBNDA5NlNIQTI1NjIwMjVDQTEuY3JsMCAGA1Ud
# IAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAgEA
# ZSqt8RwnBLmuYEHs0QhEnmNAciH45PYiT9s1i6UKtW+FERp8FgXRGQ/YAavXzWjZ
# hY+hIfP2JkQ38U+wtJPBVBajYfrbIYG+Dui4I4PCvHpQuPqFgqp1PzC/ZRX4pvP/
# ciZmUnthfAEP1HShTrY+2DE5qjzvZs7JIIgt0GCFD9ktx0LxxtRQ7vllKluHWiKk
# 6FxRPyUPxAAYH2Vy1lNM4kzekd8oEARzFAWgeW3az2xejEWLNN4eKGxDJ8WDl/FQ
# USntbjZ80FU3i54tpx5F/0Kr15zW/mJAxZMVBrTE2oi0fcI8VMbtoRAmaaslNXdC
# G1+lqvP4FbrQ6IwSBXkZagHLhFU9HCrG/syTRLLhAezu/3Lr00GrJzPQFnCEH1Y5
# 8678IgmfORBPC1JKkYaEt2OdDh4GmO0/5cHelAK2/gTlQJINqDr6JfwyYHXSd+V0
# 8X1JUPvB4ILfJdmL+66Gp3CSBXG6IwXMZUXBhtCyIaehr0XkBoDIGMUG1dUtwq1q
# mcwbdUfcSYCn+OwncVUXf53VJUNOaMWMts0VlRYxe5nK+At+DI96HAlXHAL5SlfY
# xJ7La54i71McVWRP66bW+yERNpbJCjyCYG2j+bdpxo/1Cy4uPcU3AWVPGrbn5PhD
# Bf3Froguzzhk++ami+r3Qrx5bIbY3TVzgiFI7Gq3zWcxggY0MIIGMAIBATBYMEQx
# HTAbBgNVBAsMFHJ1dGljZWpwIFNlbGYtU2lnbmVkMSMwIQYDVQQDDBpTZWNvbmRz
# SW5XaW5kb3dzMTFUYXNrdHJheQIQTqlQO5fUWaVPCuCm/JvimzANBglghkgBZQME
# AgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqG
# SIb3DQEJBDEiBCDBadWrsbbaC5Q8NluwytC2iycg6BarLVTc2i/kymfsQDANBgkq
# hkiG9w0BAQEFAASCAgAPu6RmoFXZJYt5I70mQaTfyGKDfgKhgflkF0zNce/Obkvk
# V4sAPpx77IMFIRu8DIDzX82SnKNCtRyaI+LezB0maW/4sRA6Y+D9XqtbjlOP1547
# SiprxYwYIqZpQ7FyJN3GCgcYHKqX/zOo5m2Um5le0Dynjaqsj1En03bfk8TT8ZZ3
# rQxYSlOnO2vKvgSU6LwNPwB0qHGV6lBwhYAykJ/T1AOLKqlD4Rq6d3FEgPWO1Rif
# JCqIGcXNY3raFDvPzC/7caxL8iWw3QwjOFOlTygIno7VnHwBUuxBY4zg2jiG0EeK
# dsypdLoT+raDziV/Pi3NwuyrZScVSDCnBEv8tWPRFcqhGHGvs76eNzk3GEvajNJx
# +rzKguZt0ohHMFiW4bkvsHYL1zbcy6dCIXzE9uaKi2T3an6I1b6wEuTaaNTqOhS9
# FQHrK2SBCgDmMgDBacLiSg6bRf168hCfsFMolTAp0RPdPYqxL+q2CFxKokoxdCVy
# 2SZjaseizaYV+SbGnBZ/9w95eh32vJsf5LsFac40XK5l+jDAenz65dmIS+HjYvff
# XcnxGsHe6t1Gr59osF/yj9JvYqAbzpN0jZvmUxdVwe/q5XDxADivZgGcFa5QdHUB
# cLTfTwcVBuTAEDWk0NNzkOsQEl45HqCcXQI3JzGSceBg5vBP129HNUpqjgW6MKGC
# AyYwggMiBgkqhkiG9w0BCQYxggMTMIIDDwIBATB9MGkxCzAJBgNVBAYTAlVTMRcw
# FQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3Rl
# ZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYgMjAyNSBDQTECEAqA7xhL
# jfEFgtHEdqeVdGgwDQYJYIZIAWUDBAIBBQCgaTAYBgkqhkiG9w0BCQMxCwYJKoZI
# hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNTA3MjUwNTM3NTZaMC8GCSqGSIb3DQEJ
# BDEiBCCfqErHYwj6yOQ4E+v4Vd+8IMsu/1UUAMD/qR0vVoZICTANBgkqhkiG9w0B
# AQEFAASCAgAWi/bBqCcHNjocHcvXypowtwe+V1rTTMUwEBXHt9dY+kvQlMmF0qRy
# yReVqgiXJIXw3yua2ffUy2s8ggQecNKPmKrtYDH28xVPYwdrqxsv2Imvg1Rk8Cpf
# ldH6z1qv0HHqsyXEMXKlgW0qZiWYlQCaUhq5o3y0ytu8QvF0y9rQ/Q+frc7eWjI0
# WxEqGkaGK7/m5PwxnbAsThG/GE03VJElDGgx8rsVSXy4XN+GPiRqV+eH/mVCSx6I
# r3rqV0fR/vbCq1ZLupKv3JVEi3CAhmjK18a67UoMSNkAITm4kotbKUL192bVdPZA
# jZqc9OXnz0JLi+2xrjF3H2JGT6K6e9EWoNcj0qznPK3n30DJHLUuKYHGhe2ds5yQ
# GtT1GuRPVIPi6ZG6cvW58O10YUcUqxeSqR8NJG8+hJ0eOYX8l3N1K1EyVU++NhAa
# E+UDkpOwSQ0Fl4zFb0wspyhonoSOEzLeNMRNCrrbkAA9FtFtFhuMXHjXgqsB2UrD
# oSkaAsM+Hdet8YJ+YeY+Pzx5Osp20Uzhdlxw0FM96w2aANjXxU+PXxNyix8yzC0l
# SOEtdp2lbmpoxHB8u3q5Q5TEI13uJU2Rli1N/PiVbGstms9hZb/rJ6gZoaLVPUy0
# VWKuuR4JEHl23i93VrE3K76/S0xEeejSWunV4I6M9dAr1EUXap7teQ==
# SIG # End signature block
