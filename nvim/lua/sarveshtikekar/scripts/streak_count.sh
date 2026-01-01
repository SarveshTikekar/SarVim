#!/bin/bash

user=$(git config --global user.name)
streak=0
day=0

# Safety: empty user = no commits
[ -z "$user" ] && echo "0" && exit 0

while true; do
    found_commit=false
    date_str=$(date -d "$day day ago" +"%Y-%m-%d")

    since="$date_str 00:00:00"
    until="$date_str 23:59:59"

    while read gitdir; do
        repo=$(dirname "$gitdir")

        count=$(cd "$repo" && \
            git rev-list --count \
            --author="$user" \
            --since="$since" \
            --until="$until" \
            --all 2>/dev/null)

        if [ "$count" -gt 0 ]; then
            found_commit=true
            break
        fi
    done < <(find ~ -maxdepth 2 -name ".git" -type d -prune)

    if [ "$found_commit" = true ]; then
        streak=$((streak + 1))
        day=$((day + 1))
    else
        break
    fi
done

echo "$streak"

