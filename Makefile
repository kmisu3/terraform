.PHONY: build up shell tf-init tf-plan tf-apply tf-destroy

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
	ENV=$(ENV) docker-compose run --rm terraform .docker/terraform.sh init

# Terraformプラン
tf-plan:
	ENV=$(ENV) docker-compose run --rm terraform .docker/terraform.sh plan

# Terraformリソース適用
tf-apply:
	ENV=$(ENV) docker-compose run --rm terraform .docker/terraform.sh apply

# Terraformリソース削除
tf-destroy:
	ENV=$(ENV) docker-compose run --rm terraform .docker/terraform.sh destroy

# 使用方法表示
help:
	@echo "使用方法:"
	@echo "  make build              - Dockerイメージをビルド"
	@echo "  make shell              - コンテナを起動してシェルに入る"
	@echo "  make tf-init ENV=dev    - Terraform初期化 (dev環境)"
	@echo "  make tf-plan ENV=stg    - Terraformプラン (stg環境)"
	@echo "  make tf-apply ENV=prod  - Terraformリソース適用 (prod環境)"
	@echo "  make tf-destroy ENV=dev - Terraformリソース削除 (dev環境)"
	@echo ""
	@echo "環境変数:"
	@echo "  ENV         - 環境名 (dev/stg/prod, デフォルト: dev)"
	@echo "  AWS_PROFILE - AWSプロファイル名 (デフォルト: ENVと同名のプロファイル)"
	@echo "               例: ENV=dev の場合、AWS_PROFILE=dev が使用されます" 