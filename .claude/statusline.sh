#!/bin/bash
# Status line command for Claude Code
# Line 1: 🕐 datetime
# Line 2: 📁 cwd | 🌿 git branch
# Line 3: 🔖 claude version | 🤖 model | 💬 context usage | 💰 cost

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

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
    if [ "$pct_int" -ge 80 ]; then
        ctx_color="$red"
    elif [ "$pct_int" -ge 50 ]; then
        ctx_color="$yellow"
    else
        ctx_color="$green"
    fi
    context_str="💬 ${ctx_color}${pct_int}%${reset}"
fi

# Cost display
cost_str=""
if [ -n "$total_cost" ]; then
    cost_str="💰 ${white}$(printf '$%.4f' "$total_cost")${reset}"
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

printf "%b\n" "$line1"
printf "%b\n" "$line2"
printf "%b\n" "$line3"
