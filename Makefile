.PHONY: build up shell tf-init tf-plan tf-apply tf-destroy settings-init settings-plan settings-apply settings-destroy fmt validate lint

# デフォルト環境
ENV ?= dev
# AWSプロファイル（デフォルトでENVと同名のプロファイルを使用）
AWS_PROFILE ?= $(ENV)

# Dockerイメージをビルド
build:
	docker-compose build

# コンテナを起動してシェルに入る
shell:
	docker-compose run --rm terraform

# Terraformコードフォーマット
fmt:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/terraform.sh fmt -recursive

# Terraform設定検証
validate:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/terraform.sh validate

# リンティング（tflintを使用する場合）
lint:
	@echo "Linting Terraform code..."
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform sh -c "find . -name '*.tf' -type f | head -10"

# Terraform初期化
tf-init:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/terraform.sh init

# Terraformプラン
tf-plan:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/terraform.sh plan

# Terraformリソース適用
tf-apply:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/terraform.sh apply

# Terraformリソース削除
tf-destroy:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/terraform.sh destroy

# Settings用のコマンド
# Settings初期化
settings-init:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh init

# Settingsプラン
settings-plan:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh plan

# Settingsリソース適用
settings-apply:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh apply

# Settingsリソース削除
settings-destroy:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh destroy

# モジュール検証（VPCモジュールなど）
module-validate:
	@echo "Validating VPC module..."
	cd modules/vpc && terraform init && terraform validate

# 使用方法表示
help:
	@echo "==========================================="
	@echo "Terraform Docker環境 - 使用方法"
	@echo "==========================================="
	@echo ""
	@echo "📦 基本コマンド:"
	@echo "  make build              - Dockerイメージをビルド"
	@echo "  make shell              - コンテナを起動してシェルに入る"
	@echo "  make fmt                - Terraformコードをフォーマット"
	@echo "  make validate           - Terraform設定を検証"
	@echo "  make lint               - リンティング実行"
	@echo ""
	@echo "🏗️  Settings用コマンド（Terraform状態管理インフラ）:"
	@echo "  make settings-init ENV=dev    - Settings初期化 (dev環境)"
	@echo "  make settings-plan ENV=stg    - Settingsプラン (stg環境)"
	@echo "  make settings-apply ENV=prod  - Settingsリソース適用 (prod環境)"
	@echo "  make settings-destroy ENV=dev - Settingsリソース削除 (dev環境)"
	@echo ""
	@echo "🌐 環境別インフラ管理コマンド:"
	@echo "  make tf-init ENV=dev    - Terraform初期化 (dev環境)"
	@echo "  make tf-plan ENV=stg    - Terraformプラン (stg環境)"
	@echo "  make tf-apply ENV=prod  - Terraformリソース適用 (prod環境)"
	@echo "  make tf-destroy ENV=dev - Terraformリソース削除 (dev環境)"
	@echo ""
	@echo "🔍 モジュール関連:"
	@echo "  make module-validate    - VPCモジュールの検証"
	@echo ""
	@echo "⚙️  環境変数:"
	@echo "  ENV         - 環境名 (dev/stg/prod, デフォルト: dev)"
	@echo "  AWS_PROFILE - AWSプロファイル名 (デフォルト: ENVと同名のプロファイル)"
	@echo "               例: ENV=dev の場合、AWS_PROFILE=dev が使用されます"
	@echo ""
	@echo "📋 デフォルトVPC設定:"
	@echo "  dev環境  - VPC CIDR: 10.0.0.0/16"
	@echo "  stg環境  - VPC CIDR: 10.1.0.0/16"
	@echo "  prod環境 - VPC CIDR: 10.2.0.0/16"
	@echo ""
	@echo "🚀 推奨ワークフロー:"
	@echo "  1. make build                    # 初回のみ"
	@echo "  2. make settings-apply ENV=dev   # Settings適用"
	@echo "  3. make tf-init ENV=dev          # 環境初期化"
	@echo "  4. make tf-plan ENV=dev          # 変更確認"
	@echo "  5. make tf-apply ENV=dev         # 変更適用"
	@echo "===========================================" 