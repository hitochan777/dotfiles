#!/bin/bash
input=$(cat)
# 各種情報を取得
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // "0"')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // "0"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // "0"')
duration_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // "0"')
# レイテンシを秒に変換（小数点1桁）
latency=$(echo "scale=1; $duration_ms / 1000" | bc)

# カレントディレクトリを取得してgitブランチを調べる
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // "."')
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
if [ -n "$branch" ]; then
  git_info=" | 🌿 ${branch}"
else
  git_info=""
fi

# ステータスライン表示
echo "${model} | ${input_tokens}/${output_tokens} tokens | Context: ${used}% used | ${latency}s${git_info}"
