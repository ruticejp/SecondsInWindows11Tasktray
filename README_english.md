# SecondsInWindows11Tasktray

A tool for displaying seconds in the Windows 11 (22H2 or later) taskbar when unable to do so through normal settings  
Created for situations where organizational policies are in place

> **📝 Translation Note**  
> This document is an English translation of the original Japanese README.md  
> Original document created: July 24, 2025  
> Translation date: July 24, 2025

## ⚠️ Important Notice

**Please be aware of potential policy violations within your organization (school, company, etc.)**

If your organization has intentionally disabled seconds display, using this tool may constitute a policy violation.  
**Please ensure you obtain confirmation from your administrator before use.**

## 📋 Overview

This tool is a PowerShell script that directly manipulates the registry to display seconds in the taskbar clock when organizational policy restrictions prevent enabling seconds display through the normal settings interface.

## 🚀 Usage

### 🖥️ GUI Version (Recommended)

**Execution Methods:**
1. **Via Batch File (Easiest)**  
   📁 Double-click `RunToggleClockSecondsGUI.bat`

2. **PowerShell 5.0 (Windows Default)**  
   ```cmd
   powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1
   ```

3. **PowerShell 7 Series**  
   ```cmd
   pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1
   ```

4. **Execute from Explorer**  
   Right-click `ClockSeconds.ps1` file → Select "Run with PowerShell" or "Run with pwsh"

**Operation Steps:**
1. Click "Enable Seconds" or "Disable Seconds" button in the displayed window
2. If settings are not reflected, log out → sign in again or restart your PC

> **💡 Important Notes**  
> Right-click execution from Explorer may not work depending on ExecutionPolicy settings. In such cases, execute from command line with `-ExecutionPolicy Bypass` parameter or use the batch file.

### ⌨️ Command Line Version

#### PowerShell 5.0 (Windows Default)
```cmd
# Enable seconds display
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Enable

# Disable seconds display
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Disable

# Check current status
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Status
```

#### PowerShell 7 Series
```cmd
# Enable seconds display
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Enable

# Disable seconds display
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Disable

# Check current status
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Status
```

### 🌐 Language Settings

#### PowerShell 5.0 (Windows Default)
```cmd
# Japanese display
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language ja

# English display
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language en

# Auto-detection (Default)
# Automatically detects system language settings when language parameter is omitted
```

#### PowerShell 7 Series
```cmd
# Japanese display
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language ja

# English display
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language en

# Auto-detection (Default)
# Automatically detects system language settings when language parameter is omitted
```

## 🔐 Security Information

### 🔓 Administrator Rights Not Required

This script operates only on the current user's registry area (HKCU), so **administrator privileges are not required**.

### 🗂️ Target Registry Operations

| Item | Value |
|------|-------|
| **Registry Path** | `HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced` |
| **Value Name** | `ShowSecondsInSystemClock` |
| **Data Type** | DWORD value |

**Setting Value Meanings:**
- `0` : Do not display seconds (Default)
- `1` : Display seconds
- **When value does not exist** : Same behavior as `0` (do not display seconds)

> **📝 Supplementary Information**  
> During initial execution or with new user profiles, the registry value may not exist. In such cases, the script automatically recognizes the state as "do not display seconds" and operates appropriately.

## ⚙️ Standard Setting Method When No Policy Restrictions

In environments without organizational policy restrictions, you can configure settings through the following steps:

1. 🖱️ **Right-click Start button** → Open "Settings"
2. 👤 **Select "Personalization"** from the left menu
3. 📜 **Scroll down on the right side** and click "Taskbar"
4. ⚙️ **Select "Taskbar behaviors"**
5. ⏰ **Check "Show seconds in system tray clock (increases power consumption)"**

---

## 📁 File Structure

| File Name | Description |
|-----------|-------------|
| `ClockSeconds.ps1` | Main PowerShell script (supports both GUI and CUI versions) |
| `RunToggleClockSecondsGUI.bat` | Execution batch file (recommended, easiest) |
| `README.md` | This document (Japanese version) |
| `README_english.md` | English version document |

## 🔧 System Requirements

| Item | Requirements |
|------|-------------|
| **OS** | Windows 11 (22H2 or later) |
| **PowerShell** | PowerShell 5.0 or later, or PowerShell 7 series |
| **Framework** | .NET Framework (when using PowerShell 5.0) |
| **Permissions** | Standard user permissions (administrator rights not required) |

## 📞 Support

- **GitHub Issues**: [Bug Reports & Feature Requests](https://github.com/ruticejp/SecondsInWindows11Tasktray/issues)
- **Compatibility Verified**: Tested on Windows 11 22H2, 23H2, 24H2

---

## 📄 License

This project is licensed under the [Apache License 2.0](LICENSE).

```
Copyright 2025 ruticejp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## 📄 Document Information

- **Original Language**: Japanese (README.md)
- **Original Creation Date**: July 24, 2025
- **Translation Language**: English
- **Translation Date**: July 24, 2025
- **Repository**: [SecondsInWindows11Tasktray](https://github.com/ruticejp/SecondsInWindows11Tasktray)
