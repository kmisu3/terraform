# Terraform Docker 環境

このリポジトリは、Docker環境でTerraformを実行するための設定を提供します。PC環境に直接Terraformをインストールする必要がなく、複数の環境（dev、stg、prod）の管理が容易になります。

## 環境セットアップ

1. `.aws/credentials` ファイルにAWSの認証情報を設定します
2. Dockerイメージをビルドします
   ```
   make build
   ```

## 使用方法


### 環境変数

* `ENV` - 環境名 (dev/stg/prod、デフォルト: dev)
* `AWS_PROFILE` - AWSプロファイル名 (デフォルト: ENVと同名のプロファイル)

例
```bash
# 各環境の使用例（AWS_PROFILEは自動的に環境名と同じになる）
make tf-plan ENV=dev     # AWS_PROFILE=dev が使用される
make tf-plan ENV=stg     # AWS_PROFILE=stg が使用される
make tf-apply ENV=prod   # AWS_PROFILE=prod が使用される

# 任意の環境で明示的にプロファイルを指定することも可能
make tf-plan ENV=dev AWS_PROFILE=dev-admin
make tf-plan ENV=stg AWS_PROFILE=stg-admin
make tf-apply ENV=prod AWS_PROFILE=prod-admin
```

### プロファイルと環境の対応

システムは環境名（ENV）に基づいて自動的に対応するAWSプロファイルを使用します

* ENV=dev → AWS_PROFILE=dev（AWS_PROFILEを明示的に指定しない場合）
* ENV=stg → AWS_PROFILE=stg（AWS_PROFILEを明示的に指定しない場合）
* ENV=prod → AWS_PROFILE=prod（AWS_PROFILEを明示的に指定しない場合）

**注意**: AWS_PROFILEの指定はすべての環境で任意です。指定しない場合は環境名と同じプロファイルが自動的に使用されます。別のプロファイルを使用したい場合のみ、明示的に指定してください。

### 環境の柔軟な管理

このリポジトリの構成は、必要な環境だけを使用できるように設計されています。

- ステージング環境（stg）が不要な場合、単に `environments/stg` ディレクトリを使用せず、dev環境とprod環境のみを利用することができます
- 不要な環境を完全に削除する場合は、以下のコマンドを実行します
  ```bash
  rm -rf environments/stg  # ステージング環境を削除する例
  ```
- 新しい環境を追加する場合は、既存の環境ディレクトリをコピーして新しい環境名に変更するだけです
  ```bash
  cp -r environments/dev environments/uat  # UAT環境を追加する例
  ```
  
これにより、プロジェクトの要件に合わせて環境を柔軟に追加・削除することができます。

## ディレクトリ構成

```
.
├── .aws/                  # AWS認証情報ディレクトリ
├── .docker/               # Docker関連ファイル
│   ├── Dockerfile         # Terraformを含むDockerイメージ定義
│   └── terraform.sh       # Terraform実行スクリプト
├── settings/             # Terraform状態管理用インフラの設定
│   ├── dev/               # 開発環境用の状態管理バケット設定
│   ├── stg/               # ステージング環境用の状態管理バケット設定
│   └── prod/              # 本番環境用の状態管理バケット設定
├── docker-compose.yml     # Docker Compose設定
├── Makefile               # タスク自動化スクリプト
├── environments/          # 環境別Terraform設定
│   ├── dev/               # 開発環境設定
│   │   ├── main.tf        # メインの設定ファイル
│   │   ├── locals.tf      # ローカル変数定義
│   │   ├── backend.tf     # バックエンド設定
│   │   ├── provider.tf    # プロバイダー設定
│   │   ├── variables.tf   # 変数定義
│   │   └── outputs.tf     # 出力定義
│   ├── stg/               # ステージング環境設定
│   │   └── ...            # 開発環境と同様のファイル
│   └── prod/              # 本番環境設定
│       └── ...            # 開発環境と同様のファイル
└── modules/               # 再利用可能なモジュール
    ├── s3/                # S3バケットモジュール
    ├── alb/               # ALBモジュール
    ├── api-gateway/       # APIゲートウェイモジュール
    └── waf/               # WAFモジュール
```

## Terraform初期セットアップ

### 1. Settingsの実行

**重要**: Settingsを実行する前に、ファイル内のバケット名に含まれるAWSアカウントID（例: 123456000000）とプロジェクトプレフィックス（例: my-project）を、ご自身の環境に合わせて変更してください。これらの値はユニークである必要があります。

まず、Terraformの状態管理に必要なインフラ（S3バケット）を作成します。settingsディレクトリには、各環境（開発、ステージング、本番）のTerraform状態を保存するためのS3バケットを作成するための設定が含まれています。

各環境は独立したディレクトリに分かれており、必要な環境のみデプロイすることができます。

```bash
# 開発環境のSettingsを実行する場合
make settings-init ENV=dev
make settings-plan ENV=dev
make settings-apply ENV=dev

# ステージング環境のSettingsを実行する場合
make settings-init ENV=stg
make settings-plan ENV=stg
make settings-apply ENV=stg

# 本番環境のSettingsを実行する場合
make settings-init ENV=prod
make settings-plan ENV=prod
make settings-apply ENV=prod
```

### 2. バックエンド設定の更新

Settingsで作成したS3バケットの情報を、各環境のbackend.tfファイルに設定します。

**重要**: バケット名には必ずご自身のAWSアカウントIDとプロジェクトプレフィックスが含まれるようにしてください。Settingsの出力に表示されたバケット名を使用してください。

```
# 例：environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "<出力されたバケット名>"  # settings実行後に出力された値に更新
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
}
```

### 3. 環境別のTerraform実行

バックエンド設定を更新したら、各環境のTerraformを実行できます。

```bash
# 開発環境の初期化
make tf-init ENV=dev

# 開発環境のプラン確認
make tf-plan ENV=dev

# 開発環境のリソース適用
make tf-apply ENV=dev
```

### 4. リソースの削除

環境内のリソースを削除する必要がある場合は、以下のコマンドを使用します。

```bash
# 開発環境のリソースを削除
make tf-destroy ENV=dev

# ステージング環境のリソースを削除
make tf-destroy ENV=stg

# 本番環境のリソースを削除
make tf-destroy ENV=prod
```

### 環境変数

* `ENV` - 環境名 (dev/stg/prod、デフォルト: dev)
* `AWS_PROFILE` - AWSプロファイル名 (デフォルト: ENVと同名のプロファイル)

例