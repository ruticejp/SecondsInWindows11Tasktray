@echo off
rem Windows11 タスクトレイ秒表示設定GUI実行バッチ
rem PowerShellの実行ポリシーを一時的にバイパスしてClockSeconds.ps1を実行

chcp 65001 >nul 2>&1

echo Windows11 タスクトレイ秒表示設定を開始しています...
echo.

rem ClockSeconds.ps1が存在するかチェック
if not exist "%~dp0ClockSeconds.ps1" (
    echo エラー: ClockSeconds.ps1が見つかりません。
    echo このバッチファイルとClockSeconds.ps1を同じフォルダに配置してください。
    echo.
    pause
    exit /b 1
)

rem PowerShell 5.0で実行を試行
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0ClockSeconds.ps1"

rem エラーレベルをチェック
if %errorlevel% neq 0 (
    echo.
    echo PowerShell 5.0での実行に失敗しました。
    echo PowerShell 7がインストールされている場合は、pwshでの実行を試行します...
    echo.
    
    rem PowerShell 7で実行を試行
    pwsh -ExecutionPolicy Bypass -NoProfile -File "%~dp0ClockSeconds.ps1" 2>nul
    
    if %errorlevel% neq 0 (
        echo.
        echo PowerShell 7での実行も失敗しました。
        echo 手動でPowerShellから以下のコマンドを実行してください：
        echo powershell -ExecutionPolicy Bypass -File "%~dp0ClockSeconds.ps1"
        echo.
        pause
        exit /b 1
    )
)

echo.
echo 処理が完了しました。
pause
