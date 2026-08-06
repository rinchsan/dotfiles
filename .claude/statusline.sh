#!/bin/bash
# Status line command for Claude Code
# Line 1: 🕐 datetime
# Line 2: 📁 cwd | 🌿 git branch | 🔀 PR
# Line 3: 🔖 claude version | 🤖 model | 💬 context usage | 💰 cost | 📅 daily cost | 📆 monthly cost
# Line 4: ⏱️ 5h rate limit (progress bar) | 7️⃣ 7d rate limit (progress bar)

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ANSI color codes
white=$'\033[0;37m'
orange=$'\033[38;2;255;164;0m'
cyan=$'\033[0;36m'
red=$'\033[0;31m'
yellow=$'\033[0;33m'
green=$'\033[0;32m'
dim=$'\033[2;37m'
reset=$'\033[0m'

sep="${dim} | ${reset}"

# color for a used-percentage value: green <50%, yellow 50-79%, red >=80%
color_for_pct() {
    local pct_int=$1
    if [ "$pct_int" -ge 80 ]; then
        echo "$red"
    elif [ "$pct_int" -ge 50 ]; then
        echo "$yellow"
    else
        echo "$green"
    fi
}

# countdown from now until a unix epoch, formatted with the given units
# usage: countdown_str <resets_at> <unit_seconds> <unit_label> <subunit_seconds> <subunit_label>
countdown_str() {
    local resets_at=$1 unit_secs=$2 unit_label=$3 subunit_secs=$4 subunit_label=$5
    local now diff
    now=$(date +%s)
    diff=$((resets_at - now))
    [ "$diff" -lt 0 ] && diff=0
    printf '%d%s%d%s' "$((diff / unit_secs))" "$unit_label" "$(((diff % unit_secs) / subunit_secs))" "$subunit_label"
}

# eighth-block characters for sub-character bar resolution (index 0 = 1/8 filled ... index 6 = 7/8 filled)
eighths=("▏" "▎" "▍" "▌" "▋" "▊" "▉")

# render an eighths-resolution progress bar for a 0-100 percentage
# usage: make_bar <pct_int> <width>
make_bar() {
    local pct=$1 width=$2
    local total_eighths=$(( (pct * width * 8 + 50) / 100 ))
    [ "$total_eighths" -gt $((width * 8)) ] && total_eighths=$((width * 8))
    local full=$((total_eighths / 8))
    local rem=$((total_eighths % 8))
    local bar="" i
    for ((i = 0; i < full; i++)); do bar+="█"; done
    if [ "$rem" -gt 0 ]; then
        bar+="${eighths[$((rem - 1))]}"
        full=$((full + 1))
    fi
    for ((i = full; i < width; i++)); do bar+=" "; done
    printf '%s' "$bar"
}

# date and time
datetime=$(date '+%Y/%m/%d %T')

# git branch
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch="$branch"
    fi
fi

# PR for current branch
pr_str=""
default_branch=$(git -C "$cwd" remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}')
if [ -n "$git_branch" ] && [ "$git_branch" != "$default_branch" ]; then
    pr_json=$(cd "$cwd" && gh pr list --head "$git_branch" --state all \
        --json number,isDraft,state,url \
        --jq '.[0] | {"text": "#\(.number) (\(if .isDraft then "draft" else .state | ascii_downcase end))", "url": .url}' \
        2>/dev/null)
    if [ -n "$pr_json" ]; then
        pr_text=$(echo "$pr_json" | jq -r '.text')
        pr_url=$(echo "$pr_json" | jq -r '.url')
        pr_link=$(printf '\033]8;;%s\033\\%s\033]8;;\033\\' "${pr_url}" "${cyan}${pr_text}${reset}")
        pr_str="🔀 ${pr_link}"
    fi
fi

# Claude Code version
claude_version=$(claude --version 2>/dev/null | head -1)

# Context usage with color based on level
context_str=""
if [ -n "$used_pct" ]; then
    pct_int=$(printf "%.0f" "$used_pct")
    ctx_color=$(color_for_pct "$pct_int")
    context_str="💬 ${ctx_color}${pct_int}%${reset}"
fi

# Cost display
cost_str=""
if [ -n "$total_cost" ]; then
    cost_str="💰 ${white}$(printf '$%.4f' "$total_cost")${reset}"
fi

# Daily cumulative cost
daily_str=""
if [ -n "$total_cost" ] && [ -n "$session_id" ]; then
    usage_dir="$HOME/.claude/usage"
    usage_file="$usage_dir/$(date +%Y-%m-%d).json"
    mkdir -p "$usage_dir"
    [ -f "$usage_file" ] || echo '{"sessions":{}}' > "$usage_file"
    if jq --arg sid "$session_id" --argjson cost "$total_cost" \
        '.sessions[$sid] = $cost' "$usage_file" > "$usage_file.tmp" 2>/dev/null; then
        mv "$usage_file.tmp" "$usage_file"
    else
        rm -f "$usage_file.tmp"
    fi
    daily_total=$(jq '[.sessions[]] | add // 0' "$usage_file" 2>/dev/null)
    if [ -n "$daily_total" ]; then
        daily_str="📅 ${white}$(printf '$%.4f' "$daily_total")${reset}"
    fi
fi

# Monthly cumulative cost
monthly_str=""
if [ -n "$total_cost" ]; then
    usage_dir="$HOME/.claude/usage"
    monthly_files=("$usage_dir"/$(date +%Y-%m)-*.json)
    if [ -e "${monthly_files[0]}" ]; then
        monthly_total=$(jq -s '[.[].sessions[]] | add // 0' "${monthly_files[@]}" 2>/dev/null)
        if [ -n "$monthly_total" ]; then
            monthly_str="📆 ${white}$(printf '$%.4f' "$monthly_total")${reset}"
        fi
    fi
fi

# 5-hour rate limit
five_hour_str=""
if [ -n "$five_hour_pct" ]; then
    pct_int=$(printf "%.0f" "$five_hour_pct")
    rl_color=$(color_for_pct "$pct_int")
    bar=$(make_bar "$pct_int" 10)
    five_hour_str="⏱️ [${rl_color}${bar}${reset}] ${rl_color}${pct_int}%${reset}"
    if [ -n "$five_hour_resets_at" ]; then
        remaining=$(countdown_str "$five_hour_resets_at" 3600 h 60 m)
        five_hour_str="${five_hour_str} ${dim}(${remaining} left)${reset}"
    fi
fi

# 7-day (weekly) rate limit
seven_day_str=""
if [ -n "$seven_day_pct" ]; then
    pct_int=$(printf "%.0f" "$seven_day_pct")
    rl_color=$(color_for_pct "$pct_int")
    bar=$(make_bar "$pct_int" 10)
    seven_day_str="7️⃣ [${rl_color}${bar}${reset}] ${rl_color}${pct_int}%${reset}"
    if [ -n "$seven_day_resets_at" ]; then
        remaining=$(countdown_str "$seven_day_resets_at" 86400 d 3600 h)
        seven_day_str="${seven_day_str} ${dim}(${remaining} left)${reset}"
    fi
fi

# Line 1: date and time
line1="🕐 ${white}${datetime}${reset}"

# Line 2: cwd | git branch
line2="📁 ${orange}${cwd}${reset}"
if [ -n "$git_branch" ]; then
    line2="${line2}${sep}🌿 ${green}${git_branch}${reset}"
fi
if [ -n "$pr_str" ]; then
    line2="${line2}${sep}${pr_str}"
fi

# Line 3: claude version | model | context | cost
line3=""
if [ -n "$claude_version" ]; then
    line3="🔖 ${white}${claude_version}${reset}${sep}🤖 ${cyan}${model}${reset}"
else
    line3="🤖 ${cyan}${model}${reset}"
fi
if [ -n "$context_str" ]; then
    line3="${line3}${sep}${context_str}"
fi
if [ -n "$cost_str" ]; then
    line3="${line3}${sep}${cost_str}"
fi
if [ -n "$daily_str" ]; then
    line3="${line3}${sep}${daily_str}"
fi
if [ -n "$monthly_str" ]; then
    line3="${line3}${sep}${monthly_str}"
fi

# Line 4: 5h rate limit | 7d rate limit
line4=""
if [ -n "$five_hour_str" ]; then
    line4="$five_hour_str"
fi
if [ -n "$seven_day_str" ]; then
    if [ -n "$line4" ]; then
        line4="${line4}${sep}${seven_day_str}"
    else
        line4="$seven_day_str"
    fi
fi

printf "%b\n" "$line1"
printf "%b\n" "$line2"
printf "%b\n" "$line3"
if [ -n "$line4" ]; then
    printf "%b\n" "$line4"
fi
