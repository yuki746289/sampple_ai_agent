# sampple_ai_agent README

このディレクトリは、AI エージェントに対して「設計から実装確認までを段階的に進めさせるためのルールセット」をまとめたものです。  
`_rules_v1` は初期版、`_rules_v2_current` は現在運用中の改訂版です。

## 概要

このルールセットは、開発を以下の 6 段階に分けて進める前提で構成されています。

1. 基本設計書作成
2. 基本設計書確認
3. 詳細設計書作成
4. 詳細設計書確認
5. コード実装
6. コード確認

各工程には専用の `rules_dev_*.md` があり、ファイル名規約、タグ付け、確認観点、出力物の形式が定義されています。

## ディレクトリ構成

```text
_rules_v1/
  rules_dev.md
  rules_dev_1_base.md
  rules_dev_2_base_confirm.md
  rules_dev_3_detail.md
  rules_dev_4_detail_confirm.md
  rules_dev_5_code.md
  rules_dev_6_code_confirm.md

_rules_v2_current/
  rules_dev.md
  rules_dev_1_base.md
  rules_dev_2_base_confirm.md
  rules_dev_3_detail.md
  rules_dev_4_detail_confirm.md
  rules_dev_5_code.md
  rules_dev_6_code_confirm.md
```

## 使い方

基本的な使い方は v1 / v2 とも共通です。

1. 利用するルールセットを決めます。通常は `v2_current` を使います。
2. 最初に共通ルール `rules_dev.md` を読みます。
3. 工程ごとに対応するルールファイルを参照して成果物を作成します。
4. 各工程の完了時に確認ファイルを作り、次工程へ進みます。
5. 実装時は、設計書と確認用 JSON の内容をコードへトレースできる状態にします。

推奨の参照順は以下です。

```text
rules_dev.md
  -> rules_dev_1_base.md
  -> rules_dev_2_base_confirm.md
  -> rules_dev_3_detail.md
  -> rules_dev_4_detail_confirm.md
  -> rules_dev_5_code.md
  -> rules_dev_6_code_confirm.md
```

### サンプルの指示文

AI エージェントへ依頼する際は、「どのルールを使うか」「対象ファイル名」「バージョン」「今回やりたい変更」を明示すると進めやすくなります。

#### 開始時の指示例

```text
_rules_v2_current を使って進めてください。
最初に rules_dev.md を確認し、その後 rules_dev_1_base.md に従って
sample_indicator_v2.0 の基本設計書を作成してください。

今回やりたい変更:
- アラート条件を追加
- ログ出力の ON/OFF 設定を追加
- 既存の移動平均ロジックは維持
```

#### 基本設計書以降の作成を依頼する例

```text
手順に沿って進めて下さい。
```

### 指示文を作るときのポイント

- 使用するルールセットを明記する
- 対象ファイル名とバージョンを明記する
- 変更点と維持したい仕様を分けて書く
- `v2_current` を使う場合は、L / F / V / S の対応を明示する
- 実装依頼時は、参照元の `_4_detail.json` を必ず指定する

## v1 と v2 の違い

主な違いは、`v2_current` で詳細設計と実装トレーサビリティが強化されている点です。

### 1. 詳細設計の表現力

- `v1`
  - 詳細設計では主に `[Lxxx]` ベースで処理フローを管理します。
- `v2`
  - `[Lxxx]` に加えて、関数用の `[Fxxx]`、主要変数用の `[Vxxx]` を導入しています。
  - 各 `[Lxxx]` に対応する基本設計の `(Sxxx)` を必須化しています。

### 2. JSON 出力の強化

- `v1`
  - `_4_detail.json` は主に機能一覧 (`features`) を中心に扱います。
- `v2`
  - `_3_detail.json` を「L/F/V の辞書」として扱います。
  - `_4_detail.json` でも `functions`、`variables`、`sourceStepId` などを持ち、実装前の仕様確定がより厳密です。

### 3. コードとの対応付け

- `v1`
  - コードコメントは主に `// [Lxxx]` を付ける前提です。
- `v2`
  - `// [Lxxx]` に加え、関数定義に `// [Fxxx]`、主要変数の宣言に `// [Vxxx]` を必須化しています。
  - 実装対象は `_4_detail.json` を基準に確認する運用へ整理されています。

### 4. 共通ルールの追加事項

- `v1`
  - 詳細設計の成果物は主に Markdown 前提です。
- `v2`
  - 詳細設計の成果物に Markdown に加えて JSON を明示しています。
  - 処理中に矛盾が見つかった場合は、処理を終了して報告するルールが追加されています。

## どちらを使うべきか

- 既存の古い運用に合わせる場合は `v1`
- 新規作成や、設計とコードの対応を厳密に管理したい場合は `v2_current`

特に、関数単位・変数単位まで追跡したい場合は `v2_current` が向いています。
