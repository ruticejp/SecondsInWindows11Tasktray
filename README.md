# SecondsInWindows11Tasktray

Windows11（22H2）以降でタスクトレイに秒表示できない時に使うツール  
組織等でポリシーがかかっている場合のために作成

## ⚠️ 重要事項

**所属する組織（学校、企業等）のポリシー違反にご注意ください**

組織が意図的に秒表示を無効にしている場合、このツールの使用がポリシー違反となる可能性があります。  
**必ず事前に管理者へ確認を取ってからご利用ください。**

## 📋 概要

このツールは、組織のポリシー制限により通常の設定画面から秒表示を有効にできない場合に、レジストリを直接操作してタスクトレイの時計に秒を表示させるためのPowerShellスクリプトです。

## 🚀 使い方

### 🖥️ GUI版（推奨）

**実行方法：**
1. **バッチファイル経由（最も簡単）**  
   📁 `RunToggleClockSecondsGUI.bat` をダブルクリック

2. **PowerShell 5.0（Windows標準）**  
   ```cmd
   powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1
   ```

3. **PowerShell 7系**  
   ```cmd
   pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1
   ```

4. **エクスプローラーから実行**  
   `ClockSeconds.ps1`ファイルを右クリック → 「PowerShellで実行」または「pwshで実行」を選択

**操作手順：**
1. 表示されたウィンドウで「秒を表示する」または「秒を非表示にする」ボタンをクリック
2. 設定が反映されない場合は、ログアウト→サインインまたはPCの再起動を実行

> **💡 注意事項**  
> エクスプローラーからの右クリック実行では、ExecutionPolicyの設定により実行できない場合があります。その際は、コマンドラインから `-ExecutionPolicy Bypass` パラメータ付きで実行するか、バッチファイルをご利用ください。

### ⌨️ コマンドライン版

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

### 🌐 言語設定

#### PowerShell 5.0（Windows標準）
```cmd
# 日本語表示
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language ja

# 英語表示
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language en

# 自動検出（デフォルト）
# 言語パラメータを省略すると、システムの言語設定を自動検出
```

#### PowerShell 7系
```cmd
# 日本語表示
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language ja

# 英語表示
pwsh -ExecutionPolicy Bypass -File ClockSeconds.ps1 -Language en

# 自動検出（デフォルト）
# 言語パラメータを省略すると、システムの言語設定を自動検出
```

## 🔐 セキュリティ情報

### 🔓 管理者権限は不要

このスクリプトは現在のユーザーのレジストリ領域（HKCU）のみを操作するため、**管理者権限は必要ありません**。

### 🗂️ 操作対象レジストリ

| 項目 | 値 |
|------|-----|
| **レジストリパス** | `HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced` |
| **値名** | `ShowSecondsInSystemClock` |
| **データ型** | DWORD値 |

**設定値の意味：**
- `0` : 秒を表示しない（デフォルト）
- `1` : 秒を表示する
- **値が存在しない場合** : `0`と同じ挙動（秒を表示しない）

> **📝 補足情報**  
> 初回実行時や新しいユーザープロファイルでは、レジストリ値が存在しない場合があります。この場合、スクリプトは自動的に「秒を表示しない」状態として認識し、適切に動作します。

## ⚙️ ポリシー制限がない場合の標準設定方法

組織のポリシー制限がない環境では、以下の手順で設定可能です：

1. 🖱️ **スタートボタンを右クリック** → 「設定」を開く
2. 👤 **左メニューから「個人用設定」** を選択
3. 📜 **右側の画面を下にスクロール** して「タスクバー」をクリック
4. ⚙️ **「タスクバーの動作」** を選択
5. ⏰ **「システムトレイの時計に秒を表示する（電力消費が増加します）」** にチェックを入れる

---

## 📁 ファイル構成

| ファイル名 | 説明 |
|------------|------|
| `ClockSeconds.ps1` | メインのPowerShellスクリプト（GUI版・CUI版両対応） |
| `RunToggleClockSecondsGUI.bat` | 実行用バッチファイル（推奨・最も簡単） |
| `README.md` | このドキュメント（日本語版） |
| `README_english.md` | 英語版ドキュメント |

## 🔧 動作環境

| 項目 | 要件 |
|------|------|
| **OS** | Windows 11 (22H2以降) |
| **PowerShell** | PowerShell 5.0以降 または PowerShell 7系 |
| **フレームワーク** | .NET Framework（PowerShell 5.0使用時） |
| **権限** | 標準ユーザー権限（管理者権限不要） |

## 📞 サポート

- **GitHub Issues**: [問題報告・機能要望](https://github.com/ruticejp/SecondsInWindows11Tasktray/issues)
- **動作確認**: Windows 11 22H2、23H2、24H2で動作確認済み

## 📄 ライセンス

このプロジェクトは [Apache License 2.0](LICENSE) の下でライセンスされています。

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

