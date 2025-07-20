#!/bin/bash
set -e

# 環境変数が設定されているか確認
if [ -z "$ENV" ]; then
  echo "環境変数ENVが設定されていません。使用例: ENV=dev"
  exit 1
fi

# 引数を取得
ARGS=$@

# settingsディレクトリに移動
cd /work/settings

# .tfvarsファイルが存在するかチェック
if [ ! -f "${ENV}.tfvars" ]; then
  echo "環境ファイル ${ENV}.tfvars が見つかりません"
  exit 1
fi

# Terraformコマンドを.tfvarsファイル付きで実行
terraform $ARGS -var-file="${ENV}.tfvars" 