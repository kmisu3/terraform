# Settings - Terraform状態管理用リソース

このディレクトリはTerraformの状態管理用S3バケットを作成するためのリソースです。

## 構造

```
settings/
├── main.tf           # 主要なリソース定義
├── variables.tf      # 変数定義
├── outputs.tf        # 出力定義
├── dev.tfvars       # 開発環境用変数
├── stg.tfvars       # ステージング環境用変数
├── prod.tfvars      # 本番環境用変数
└── modules/         # モジュール
    └── terraform-state-bucket/
```

## 使用方法

各環境に対してTerraformを実行する際は、対応する`.tfvars`ファイルを指定してください：

### 開発環境
```bash
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

### ステージング環境
```bash
terraform plan -var-file="stg.tfvars"
terraform apply -var-file="stg.tfvars"
```

### 本番環境
```bash
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## 最適化のポイント

- 環境別ディレクトリを削除し、共通のTerraformファイルを使用
- 環境固有の値は`.tfvars`ファイルで管理
- コードの重複を排除し、保守性を向上
- 新しい環境の追加が容易 