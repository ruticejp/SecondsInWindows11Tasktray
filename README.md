# SecondsInWindows11Tasktray

Windows11（22H2）以降でタスクトレイに秒表示できない時に使うツール  
組織等でポリシーがかかっている場合のために作成

## 📋 概要

このツールは、組織のポリシー制限により通常の設定画面から秒表示を有効にできない場合に、レジストリを直接操作してタスクトレイの時計に秒を表示させるためのPowerShellスクリプトです。

## 🚀 使い方

### GUI版（推奨）

1. **`ClockSeconds.ps1` を実行**
   - **PowerShell 5.0（Windows標準）**  
     ```cmd
     powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1
     ```
   - **PowerShell 7系**  
     ```cmd
     pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1
     ```
   - **エクスプローラーから実行**  
     `ClockSeconds.ps1`ファイルを右クリック → 「PowerShellで実行」または「pwshで実行」を選択
   - **バッチファイル経由（最も簡単）**  
     `RunToggleClockSecondsGUI.bat` をダブルクリック

2. **操作**  
   表示されたウィンドウで「秒を表示する」または「秒を非表示にする」ボタンをクリック

3. **設定反映**  
   設定が反映されない場合は、ログアウト→サインインまたはPCの再起動を行う

> **💡 注意事項**  
> エクスプローラーからの右クリック実行では、ExecutionPolicyの設定によっては実行できない場合があります。その場合は、コマンドラインから `-ExecutionPolicy Bypass` パラメータ付きで実行するか、バッチファイルをご利用ください。

### コマンドライン版

#### PowerShell 5.0（Windows標準）
```cmd
# 秒表示を有効にする
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Enable

# 秒表示を無効にする
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Disable

# 現在の状態を確認
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Status
```

#### PowerShell 7系
```cmd
# 秒表示を有効にする
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Enable

# 秒表示を無効にする
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Disable

# 現在の状態を確認
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Status
```

### 言語設定

#### PowerShell 5.0（Windows標準）
```cmd
# 日本語
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language ja

# 英語
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language en

# 自動検出（デフォルト）
# 言語パラメータを省略
```

#### PowerShell 7系
```cmd
# 日本語
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language ja

# 英語
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language en

# 自動検出（デフォルト）
# 言語パラメータを省略
```

## 🔐 セキュリティ情報

### 管理者権限は不要

このスクリプトは、現在のユーザーのレジストリ領域のみを操作するため、管理者権限は必要ありません。

### 操作対象レジストリ

**レジストリパス：**
```
HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
```

**値名：** `ShowSecondsInSystemClock`  
**データ型：** DWORD値  

**設定値：**
- `0` : 秒を表示しない
- `1` : 秒を表示する
- **値が存在しない場合** : `0`と同じ挙動（秒を表示しない）

> **📝 補足**  
> 初回実行時や新しいユーザープロファイルでは、レジストリ値が存在しない場合があります。この場合、スクリプトは自動的に「秒を表示しない」状態として認識し、適切に動作します。

## ⚙️ ポリシー制限がない場合の標準設定方法

組織のポリシー制限がない環境では、以下の手順で設定可能です：

1. **スタートボタンを右クリック** → 「設定」を開く
2. **左メニューから「個人用設定」** を選択
3. **右側の画面を下にスクロール** して「タスクバー」をクリック
4. **「タスクバーの動作」** を選択
5. **「システムトレイの時計に秒を表示する（電力消費が増加します）」** にチェックを入れる

---

## 📁 ファイル構成

- `ClockSeconds.ps1` - メインのPowerShellスクリプト（GUI版・CUI版両対応）
- `RunToggleClockSecondsGUI.bat` - 実行用バッチファイル（推奨）
- `README.md` - このファイル

## 🔧 動作環境

- Windows 11 (22H2以降)
- PowerShell 5.0以降 または PowerShell 7系
- .NET Framework（PowerShell 5.0使用時）

