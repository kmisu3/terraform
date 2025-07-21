# Terraform Docker 環境

このリポジトリは、Docker環境でTerraformを実行するための設定を提供します。PC環境に直接Terraformをインストールする必要がなく、複数の環境（dev、stg、prod）の管理が容易になります。

## ディレクトリ構成

```
.
├── .aws/                  # AWS認証情報ディレクトリ
├── .docker/               # Docker関連ファイル
├── modules/               # 再利用可能なモジュール（NEW!）
│   └── vpc/               # VPCモジュール
├── settings/              # Terraform状態管理用インフラの設定（最適化済み！）
│   ├── dev/               # 開発環境用settings
│   ├── stg/               # ステージング環境用settings
│   ├── prod/              # 本番環境用settings
│   └── modules/           # 共有モジュール
├── environments/          # 環境別Terraform設定
│   ├── dev/               # 開発環境設定
│   ├── stg/               # ステージング環境設定
│   └── prod/              # 本番環境設定
├── docker-compose.yml     # Docker Compose設定
├── Makefile               # タスク自動化スクリプト
└── README.md              # このファイル
```

## 環境セットアップ

1. `.aws/credentials` ファイルにAWSの認証情報を設定します
2. Dockerイメージをビルドします
   ```bash
   make build
   ```

## 使用方法

### 環境変数

* `ENV` - 環境名 (dev/stg/prod、デフォルト: dev)
* `AWS_PROFILE` - AWSプロファイル名 (デフォルト: ENVと同名のプロファイル)


### 推奨ワークフロー

```bash
# 1. Dockerイメージのビルド（初回のみ）
make build

# 2. Settings（Terraform状態管理インフラ）の適用
make settings-init ENV=dev
make settings-plan ENV=dev
make settings-apply ENV=dev

# 3. バックエンド設定の更新（後述）

# 4. 環境別インフラの管理
make tf-init ENV=dev
make tf-plan ENV=dev
make tf-apply ENV=dev
```

### 各環境の使用例

```bash
# 開発環境
make tf-plan ENV=dev     # AWS_PROFILE=dev が使用される
make tf-apply ENV=dev

# ステージング環境
make tf-plan ENV=stg     # AWS_PROFILE=stg が使用される
make tf-apply ENV=stg

# 本番環境
make tf-plan ENV=prod    # AWS_PROFILE=prod が使用される
make tf-apply ENV=prod

# 明示的にプロファイルを指定
make tf-plan ENV=dev AWS_PROFILE=dev-admin
```

## Terraform初期セットアップ

### 1. Settingsの実行

**重要**: Settingsを実行する前に、各環境の`settings/{ENV}/locals.tf`ファイル内のプロジェクトプレフィックス（デフォルト: my-project）を、ご自身の環境に合わせて変更してください。この値はユニークである必要があります。

```hcl
# 例：settings/dev/locals.tf
locals {
  project_prefix = "your-unique-project-name"  # ここを変更
  environment    = "dev"
  # ...
}
```

```bash
# 開発環境のSettingsを実行
make settings-init ENV=dev
make settings-plan ENV=dev
make settings-apply ENV=dev

# 他の環境も同様に実行
make settings-apply ENV=stg
make settings-apply ENV=prod
```

### 2. バックエンド設定の更新

Settingsで作成したS3バケットの情報を、各環境のbackend.tfファイルに設定します。

```hcl
# 例：environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "<Settingsで出力されたバケット名>"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
}
```

### 3. 環境別のTerraform実行

```bash
# 開発環境
make tf-init ENV=dev
make tf-plan ENV=dev
make tf-apply ENV=dev
```

## プロファイルと環境の対応

システムは環境名（ENV）に基づいて自動的に対応するAWSプロファイルを使用します：

* ENV=dev → AWS_PROFILE=dev（AWS_PROFILEを明示的に指定しない場合）
* ENV=stg → AWS_PROFILE=stg（AWS_PROFILEを明示的に指定しない場合）
* ENV=prod → AWS_PROFILE=prod（AWS_PROFILEを明示的に指定しない場合）

## 環境の柔軟な管理

このリポジトリの構成は、必要な環境だけを使用できるように設計されています：

- ステージング環境（stg）が不要な場合、単に `environments/stg` ディレクトリを使用せず、dev環境とprod環境のみを利用することができます
- 不要な環境を完全に削除する場合は、以下のコマンドを実行します
  ```bash
  rm -rf environments/stg  # ステージング環境を削除する例
  rm -rf settings/stg      # settings側も削除
  ```
- 新しい環境を追加する場合は、既存の環境ディレクトリをコピーして新しい環境名に変更するだけです
  ```bash
  cp -r environments/dev environments/uat  # UAT環境を追加する例
  cp -r settings/dev settings/uat          # settings側も追加
  ```

## 🎯 主な改善点

このプロジェクトでは以下のベストプラクティスを実装しています：

1. **モジュール化**: 再利用可能なVPCモジュールを作成
2. **環境分離**: 独立したCIDRブロックと状態ファイル
3. **バージョン管理**: 明示的なTerraformとプロバイダーバージョン指定
4. **命名規則**: 一貫性のあるリソース命名
5. **ドキュメント化**: 各モジュールに詳細なREADMEを提供
6. **Settings最適化**: 環境別ディレクトリ構造でDRY原則を実現

## リソースの削除

```bash
# 環境内のリソースを削除
make tf-destroy ENV=dev

# Settings（状態管理インフラ）の削除
make settings-destroy ENV=dev
```

## 🆘 ヘルプとトラブルシューティング

```bash
# 使用方法の確認
make help

# Terraformコードの検証
make validate

# モジュールの検証
make module-validate
```
