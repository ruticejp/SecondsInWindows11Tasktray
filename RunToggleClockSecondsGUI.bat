@echo off
rem Windows11 Taskbar Clock Seconds Setting GUI Execution Batch
rem Temporarily bypass PowerShell execution policy to run ClockSeconds.ps1
rem Multi-language support: Japanese/English

setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

rem Detect system language
for /f "tokens=3" %%i in ('reg query "HKCU\Control Panel\International" /v LocaleName 2^>nul') do set LOCALE=%%i
if "!LOCALE:~0,2!"=="ja" (
    set LANG=ja
    echo Windows11 タスクトレイ秒表示設定を開始しています...
) else (
    set LANG=en
    echo Starting Windows11 Taskbar Clock Seconds Configuration...
)
echo.

rem Check if ClockSeconds.ps1 exists
if not exist "%~dp0ClockSeconds.ps1" (
    if "!LANG!"=="ja" (
        echo エラー: ClockSeconds.ps1が見つかりません。
        echo このバッチファイルとClockSeconds.ps1を同じフォルダに配置してください。
    ) else (
        echo Error: ClockSeconds.ps1 not found.
        echo Please place this batch file and ClockSeconds.ps1 in the same folder.
    )
    echo.
    pause
    exit /b 1
)

rem Try PowerShell 5.0 execution
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0ClockSeconds.ps1"

rem Check error level and store it
set EXEC_RESULT=%errorlevel%
if !EXEC_RESULT! neq 0 (
    echo.
    if "!LANG!"=="ja" (
        echo PowerShell 5.0での実行に失敗しました。
        echo PowerShell 7がインストールされている場合は、pwshでの実行を試行します...
    ) else (
        echo PowerShell 5.0 execution failed.
        echo If PowerShell 7 is installed, trying to execute with pwsh...
    )
    echo.
    
    rem Try PowerShell 7 execution
    pwsh -ExecutionPolicy Bypass -NoProfile -File "%~dp0ClockSeconds.ps1" 2>nul
    
    rem Check PowerShell 7 result
    set EXEC_RESULT2=!errorlevel!
    if !EXEC_RESULT2! neq 0 (
        echo.
        if "!LANG!"=="ja" (
            echo PowerShell 7での実行も失敗しました。
            echo 手動でPowerShellから以下のコマンドを実行してください：
        ) else (
            echo PowerShell 7 execution also failed.
            echo Please manually execute the following command from PowerShell:
        )
        echo powershell -ExecutionPolicy Bypass -File "%~dp0ClockSeconds.ps1"
        echo.
        pause
        exit /b 1
    )
)

echo.
if "!LANG!"=="ja" (
    echo 処理が完了しました。
) else (
    echo Process completed.
)
pause
exit /b 0
rem End of script
