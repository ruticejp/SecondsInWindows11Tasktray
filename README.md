# SecondsInWindows11Tasktray

Windows11（22H2）以降でタスクトレイに秒表示できない時に使うツール  
組織等でポリシーがかかっている場合のために作成

## ⚠️ 重要事項

**所属組織（学校、企業等）の運用ルール・セキュリティポリシー違反にご注意ください**

組織が意図的に秒表示を無効にしている場合、このツールの使用が組織の運用ルールやセキュリティポリシー違反となる可能性があります。  
**必ず事前に管理者へ確認を取ってからご利用ください。**

## 📋 概要

このツールは、組織のグループポリシーやドメインポリシー制限により通常の設定画面から秒表示を有効にできない場合に、レジストリを直接操作してタスクトレイの時計に秒を表示させるためのPowerShellスクリプトです。

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

## ⚙️ 個人PC・家庭PCでの標準設定方法

組織のドメイン・グループポリシー制限がない環境（個人PC、家庭PC、Active DirectoryやAzure ADに参加していないPC等）では、以下の手順で設定可能です：

1. 🖱️ **スタートボタンを右クリック** → 「設定」を開く
2. 👤 **左メニューから「個人用設定」** を選択
3. 📜 **右側の画面を下にスクロール** して「タスクバー」をクリック
4. ⚙️ **「タスクバーの動作」** を選択
5. ⏰ **「システムトレイの時計に秒を表示する（電力消費が増加します）」** にチェックを入れる

> **💡 補足**  
> 上記の設定画面で該当項目がグレーアウトしている場合や設定できない場合は、組織のグループポリシーやローカルポリシーによる制限がかかっている可能性があります。その場合、このツールをご利用ください。

---

## 📁 ファイル構成

### 🎯 実行ファイル
| ファイル名 | 説明 |
|------------|------|
| `ClockSeconds.ps1` | メインのPowerShellスクリプト（GUI版・CUI版両対応） |
| `RunToggleClockSecondsGUI.bat` | 実行用バッチファイル（推奨・最も簡単） |
| `VerifySignature.ps1` | 電子署名検証スクリプト（Authenticode + Ed25519） |

### 📚 ドキュメント
| ファイル名 | 説明 |
|------------|------|
| `README.md` | このドキュメント（日本語版） |
| `README_english.md` | 英語版ドキュメント |
| `LICENSE` | Apache License 2.0 ライセンス文書 |

### 🔐 電子署名ファイル
| ファイル名 | 説明 |
|------------|------|
| `ClockSeconds.cer` | Authenticode証明書（検証用・インポート不要） |
| `ClockSeconds_ed25519.pub` | Ed25519公開鍵（ClockSeconds.ps1用） |
| `ClockSeconds.sig` | Ed25519署名ファイル（ClockSeconds.ps1用） |
| `VerifySignature_ed25519.pub` | Ed25519公開鍵（VerifySignature.ps1用） |
| `VerifySignature.sig` | Ed25519署名ファイル（VerifySignature.ps1用） |

## 🔧 動作環境

| 項目 | 要件 |
|------|------|
| **OS** | Windows 11 (22H2以降) |
| **PowerShell** | PowerShell 5.0以降 または PowerShell 7系 |
| **フレームワーク** | .NET Framework（PowerShell 5.0使用時） |
| **権限** | 標準ユーザー権限（管理者権限不要） |

### 📦 外部ツール（任意）

| ツール | 用途 | 入手先 |
|--------|------|--------|
| **OpenSSL** | Ed25519署名の検証 | [公式サイト](https://www.openssl.org/)<br>[Windows版](https://slproweb.com/products/Win32OpenSSL.html) |

> **💡 補足**  
> OpenSSLは署名検証時のみ使用される任意の依存関係です。メイン機能には不要です。

> **⚠️ OpenSSLバージョンに関する重要事項**  
> 
> **OpenSSL 3.0以降の使用を強く推奨します。**
> 
> - ✅ **推奨**: OpenSSL 3.0以降（Apache License 2.0）
> - ⚠️ **非推奨**: OpenSSL 1.x系（OpenSSL License + SSLeay License）
> - 🚫 **Ed25519未対応**: OpenSSL 1.0.x系
>
> 旧バージョン（1.x系）は本プロジェクトのApache License 2.0と**ライセンス互換性の問題**があり、**セキュリティ脆弱性**も存在する可能性があります。また、OpenSSL 1.0.x系ではEd25519署名がサポートされていません。

## 🔐 スクリプト署名の検証方法

このプロジェクトのPowerShellスクリプトは、セキュリティ確保のために電子署名が施されています。

### 📋 署名方式

| 署名方式 | 対象ファイル | 用途 |
|----------|-------------|------|
| **Authenticode** | `ClockSeconds.ps1`, `VerifySignature.ps1` | PowerShell標準の署名検証 |
| **Ed25519** | `ClockSeconds.ps1`, `VerifySignature.ps1` | OpenSSLによる高セキュリティ署名 |

### ✅ 自動署名検証（利用者操作不要）

PowerShellスクリプトには署名が埋め込まれており、**証明書のインポートなどの事前設定は不要**です。

```powershell
# PowerShellによる自動署名検証
powershell -ExecutionPolicy Bypass -File ClockSeconds.ps1
```

> **⚠️ セキュリティ重要事項**  
> 
> **証明書マネージャ（certmgr.msc）への証明書インポートは不要かつ非推奨です。**
> 
> - 🚫 `.cer`ファイルを「信頼されたルート証明機関」にインポートしない
> - 🚫 自己署名証明書のインポートはセキュリティリスクとなる
> - ✅ スクリプトの署名検証は自動実行される
> - ✅ 追加の証明書設定は不要
>
> 証明書をインポートすると、同じ証明書で署名された悪意のあるスクリプトもシステムが信頼してしまう危険があります。

### 🔍 手動署名検証（上級者向け）

署名の詳細を確認したい場合は、以下の方法で検証できます：

#### Authenticode署名の確認
```powershell
Get-AuthenticodeSignature ClockSeconds.ps1
```

#### Ed25519署名の確認（OpenSSL要）
```bash
openssl pkeyutl -verify -inkey ClockSeconds_ed25519.pub -pubin -sigfile ClockSeconds.sig -in ClockSeconds.ps1
```

#### 包括的な署名検証
```powershell
# 両方の署名を自動検証
.\VerifySignature.ps1
```

## 📞 サポート

- **GitHub Issues**: [問題報告・機能要望](https://github.com/ruticejp/SecondsInWindows11Tasktray/issues)
- **動作確認**: Windows 11 22H2、23H2、24H2で動作確認済み

## 📄 ライセンス

このプロジェクトは [Apache License 2.0](LICENSE) の下でライセンスされています。

### 🔗 外部依存関係

| 依存関係 | ライセンス | 用途 |
|----------|-----------|------|
| **OpenSSL** | [Apache License 2.0](https://www.openssl.org/source/license.html) | Ed25519署名検証（任意） |

> **📝 補足**  
> OpenSSLは任意の外部ツールであり、基本機能には必要ありません。署名検証を行う場合のみ使用されます。

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

