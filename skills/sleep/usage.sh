#!/usr/bin/env bash
# 利用上限の使用率を、枠ごとに1行で表示する。
#
#   usage.sh codex    Codex のセッションログから読む
#   usage.sh claude   claude -p を1回実行し、その出力から読む（モデル呼び出しが1回起きる）
#
# 出力の形式（1行1枠）:
#   <枠の名前> <使用率%> <リセット時刻のUNIX秒> <リセット時刻(ローカル)> <データの取得からの経過秒>
# リセット時刻を過ぎた枠は、使用率を 0 として表示する。
set -euo pipefail

now=$(date +%s)

print_rows() {
  # 標準入力: "<名前> <使用率> <リセットUNIX秒> <取得UNIX秒>" の行
  while read -r name pct reset fetched; do
    [ -z "$name" ] && continue
    if [ "$reset" -le "$now" ]; then pct=0; fi
    printf '%s %s %s %s %s\n' "$name" "$pct" "$reset" "$(date -r "$reset" '+%Y-%m-%dT%H:%M:%S%z')" "$((now - fetched))"
  done
}

case "${1:-}" in
  codex)
    # 最近更新されたセッションログのうち、rate_limits を含む最新の token_count イベントを使う
    file=$(find "${CODEX_HOME:-$HOME/.codex}/sessions" -name '*.jsonl' -mtime -8 -print0 2>/dev/null \
      | xargs -0 ls -t 2>/dev/null | head -20 \
      | while read -r f; do grep -q '"rate_limits"' "$f" && { echo "$f"; break; }; done)
    [ -z "$file" ] && { echo "Codex のセッションログに rate_limits が見つかりません" >&2; exit 1; }
    grep '"rate_limits"' "$file" | tail -1 | jq -r '
      (.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) as $t
      | .payload.rate_limits
      | (.primary, .secondary) | select(. != null and .resets_at != null)
      | "\(.window_minutes)min \(.used_percent) \(.resets_at) \($t)"' | print_rows
    ;;
  claude)
    # 使用量を抑えるため、軽いモデルでセッションを保存せずに1回だけ呼ぶ
    claude -p "ok" --model haiku --no-session-persistence --output-format stream-json --verbose 2>/dev/null \
      | jq -rs --arg t "$now" '
        [.[] | select(.type == "rate_limit_event")] | last
        | .rate_limit_info.unifiedWindows // {} | to_entries[]
        | "\(.key) \(.value.utilization * 100 | round) \(.value.resetsAt) \($t)"' \
      | print_rows
    ;;
  *)
    sed -n '2,9p' "$0" >&2
    exit 1
    ;;
esac
