
  - Apps Script のデプロイ規約
    - デプロイ前は、必ず `appScript/auto_deploy/deploy_flow.md`、`appScript/auto_deploy/code/deploy_projects.psd1`、`appScript/auto_deploy/log/task_checklist_log.md` を確認すること。
    - デプロイ手順は `appScript/auto_deploy/deploy_flow.md` を正本とし、プロジェクト固有の設定値は `appScript/auto_deploy/code/deploy_projects.psd1` を正本として参照すること。
    - デプロイ時は、原則として `appScript/auto_deploy/code/deploy_appscript.ps1` を入口として使用すること。
    - デプロイ後は `appScript/auto_deploy/log/task_checklist_log.md` と `appScript/auto_deploy/log/deploy_log.md` を確認すること。
    - 新規 Apps Script プロジェクトを追加する場合は、必ず `appScript/auto_deploy/project_initialize.md` を確認し、その手順に沿って初期化すること。
    - Apps Script deployment時は、Web URLをそのまま使い続けるか、新しいWeb URLへ切り替えるかを、必ず事前にユーザへ確認すること。既存URLを維持する場合は redeploy を前提にし、新しいURLが必要な場合は新規 deployment を作成すること。
  - Pine 追加ルール
    - Pine を作成または修正する前は、必ず `pine/_rules/pine_checklist.md` を確認し、`:=`、分岐内タプル代入、`request.*()` 件数、`external elements` を事前チェックすること。
    - Pine を作成または修正する前は、`pine/_rules/pine_checklist_log.md` にチェック結果を毎回記録すること。
    