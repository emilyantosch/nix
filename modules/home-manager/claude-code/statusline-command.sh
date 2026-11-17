#!/usr/bin/env bash
# Claude Code status line: model | dir | branch | effort | context | limits
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
ctx_size_fmt=""
if [ -n "$ctx_size" ]; then
  if [ "$ctx_size" -ge 1000000 ]; then
    ctx_size_fmt="$(awk "BEGIN{printf \"%g\", $ctx_size/1000000}")M"
  else
    ctx_size_fmt="$((ctx_size / 1000))k"
  fi
fi
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
spend=$(echo "$input" | jq -r '.rate_limits.spend_limit.used_percentage // empty')

branch=""
if [ -n "$dir" ] && [ -d "$dir" ]; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" symbolic-ref --short HEAD 2>/dev/null \
    || GIT_OPTIONAL_LOCKS=0 git -C "$dir" rev-parse --short HEAD 2>/dev/null)
fi

parts=()
[ -n "$model" ]  && parts+=("$(printf '\033[36m%s\033[0m' "$model")")
[ -n "$dir" ]    && parts+=("$(printf '\033[34m%s\033[0m' "${dir/#$HOME/~}")")
[ -n "$branch" ] && parts+=("$(printf '\033[35m%s\033[0m' "$branch")")
[ -n "$effort" ] && parts+=("effort:$effort")
if [ -n "$ctx" ] && [ -n "$ctx_size_fmt" ]; then
  parts+=("ctx:$(printf '%.0f' "$ctx")%/$ctx_size_fmt")
elif [ -n "$ctx" ]; then
  parts+=("ctx:$(printf '%.0f' "$ctx")%")
elif [ -n "$ctx_size_fmt" ]; then
  parts+=("ctx:$ctx_size_fmt")
fi
[ -n "$five" ]   && parts+=("5h:$(printf '%.0f' "$five")%")
[ -n "$week" ]   && parts+=("7d:$(printf '%.0f' "$week")%")
[ -n "$spend" ]  && parts+=("spend:$(printf '%.0f' "$spend")%")

out=""
for p in "${parts[@]}"; do
  [ -n "$out" ] && out="$out | "
  out="$out$p"
done
printf '%s\n' "$out"
