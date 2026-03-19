#!/bin/bash
# Status line command for Claude Code
# Line 1: 🕐 datetime | 📁 cwd
# Line 2: 🌿 git branch | 🤖 model | 💬 context usage

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ANSI color codes
white='\033[0;37m'
orange='\033[38;2;255;164;0m'
cyan='\033[0;36m'
red='\033[0;31m'
yellow='\033[0;33m'
green='\033[0;32m'
dim='\033[2;37m'
reset='\033[0m'

sep="${dim} | ${reset}"

# Date/time
datetime=$(date '+%Y/%m/%d %T')

# Git branch (skip optional locks)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch="$branch"
    fi
fi

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

# Line 1: datetime | cwd
line1="🕐 ${white}${datetime}${reset}${sep}📁 ${orange}${cwd}${reset}"

# Line 2: git branch | model | context
if [ -n "$git_branch" ]; then
    line2="🌿 ${green}${git_branch}${reset}${sep}🤖 ${cyan}${model}${reset}"
else
    line2="🤖 ${cyan}${model}${reset}"
fi
if [ -n "$context_str" ]; then
    line2="${line2}${sep}${context_str}"
fi

printf "%b\n" "$line1"
printf "%b\n" "$line2"
