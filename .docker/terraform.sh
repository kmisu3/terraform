#!/bin/bash
set -e

# 環境変数が設定されているか確認
if [ -z "$ENV" ]; then
  echo "環境変数ENVが設定されていません。使用例: ENV=dev"
  exit 1
fi

# 引数を取得
ARGS=$@

# 環境ディレクトリに移動
cd /work/terraform/$ENV

# Terraformコマンドを実行
terraform $ARGS 