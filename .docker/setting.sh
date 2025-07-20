#!/bin/bash
set -e

# 環境変数が設定されているか確認
if [ -z "$ENV" ]; then
  echo "環境変数ENVが設定されていません。使用例: ENV=dev"
  exit 1
fi

# 引数を取得
ARGS=$@

# settingディレクトリに移動
cd /work/setting/$ENV

# Terraformコマンドを実行
terraform $ARGS 