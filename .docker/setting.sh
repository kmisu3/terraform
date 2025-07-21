#!/bin/bash
set -e

# 環境変数が設定されているか確認
if [ -z "$ENV" ]; then
  echo "環境変数ENVが設定されていません。使用例: ENV=dev"
  exit 1
fi

# 引数を取得
ARGS=$@

# settings/{ENV}ディレクトリに移動
TARGET_DIR="/work/settings/${ENV}"

# ディレクトリが存在するかチェック
if [ ! -d "${TARGET_DIR}" ]; then
  echo "環境ディレクトリ ${TARGET_DIR} が見つかりません"
  echo "利用可能な環境: dev, stg, prod"
  exit 1
fi

cd "${TARGET_DIR}"

# Terraformコマンドを実行
terraform $ARGS 