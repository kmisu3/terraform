.PHONY: build up shell tf-init tf-plan tf-apply tf-destroy setting-init setting-plan setting-apply setting-destroy

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

# Setting用のコマンド
# Setting初期化
setting-init:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh init

# Settingプラン
setting-plan:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh plan

# Settingリソース適用
setting-apply:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh apply

# Settingリソース削除
setting-destroy:
	ENV=$(ENV) AWS_PROFILE=$(AWS_PROFILE) docker-compose run --rm terraform .docker/setting.sh destroy

# 使用方法表示
help:
	@echo "使用方法:"
	@echo "  make build              - Dockerイメージをビルド"
	@echo "  make shell              - コンテナを起動してシェルに入る"
	@echo ""
	@echo "Setting用コマンド:"
	@echo "  make setting-init ENV=dev    - Setting初期化 (dev環境)"
	@echo "  make setting-plan ENV=stg    - Settingプラン (stg環境)"
	@echo "  make setting-apply ENV=prod  - Settingリソース適用 (prod環境)"
	@echo "  make setting-destroy ENV=dev - Settingリソース削除 (dev環境)"
	@echo ""
	@echo "環境用コマンド:"
	@echo "  make tf-init ENV=dev    - Terraform初期化 (dev環境)"
	@echo "  make tf-plan ENV=stg    - Terraformプラン (stg環境)"
	@echo "  make tf-apply ENV=prod  - Terraformリソース適用 (prod環境)"
	@echo "  make tf-destroy ENV=dev - Terraformリソース削除 (dev環境)"
	@echo ""
	@echo "環境変数:"
	@echo "  ENV         - 環境名 (dev/stg/prod, デフォルト: dev)"
	@echo "  AWS_PROFILE - AWSプロファイル名 (デフォルト: ENVと同名のプロファイル)"
	@echo "               例: ENV=dev の場合、AWS_PROFILE=dev が使用されます" 