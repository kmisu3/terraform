# Terraform Docker 環境

このリポジトリは、Docker環境でTerraformを実行するための設定を提供します。PC環境に直接Terraformをインストールする必要がなく、複数の環境（dev、stg、prod）の管理が容易になります。

## セットアップ

1. `.aws/credentials` ファイルにAWSの認証情報を設定します
2. Dockerイメージをビルドします
   ```
   make build
   ```

## 使用方法

### 基本コマンド

```bash
# ヘルプを表示
make help

# Dockerコンテナでシェルを起動
make shell

# 開発環境でTerraform初期化
make tf-init ENV=dev

# ステージング環境でプラン確認
make tf-plan ENV=stg

# 本番環境でリソース適用
make tf-apply ENV=prod

# 開発環境でリソース削除
make tf-destroy ENV=dev
```

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

- ステージング環境（stg）が不要な場合、単に `terraform/stg` ディレクトリを使用せず、dev環境とprod環境のみを利用することができます
- 不要な環境を完全に削除する場合は、以下のコマンドを実行します
  ```bash
  rm -rf terraform/stg  # ステージング環境を削除する例
  ```
- 新しい環境を追加する場合は、既存の環境ディレクトリをコピーして新しい環境名に変更するだけです
  ```bash
  cp -r terraform/dev terraform/uat  # UAT環境を追加する例
  ```
  
これにより、プロジェクトの要件に合わせて環境を柔軟に追加・削除することができます。

## ディレクトリ構成

```
.
├── .aws/                  # AWS認証情報ディレクトリ
├── .docker/               # Docker関連ファイル
│   ├── Dockerfile         # Terraformを含むDockerイメージ定義
│   └── terraform.sh       # Terraform実行スクリプト
├── docker-compose.yml     # Docker Compose設定
├── Makefile               # タスク自動化スクリプト
└── terraform/             # Terraform設定ファイル
    ├── dev/               # 開発環境設定
    ├── stg/               # ステージング環境設定（オプション）
    └── prod/              # 本番環境設定
```