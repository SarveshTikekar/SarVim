#!/bin/bash

total_commits_today=0
user=$(git config --global user.name)

while read gitdir; do
    
    repo=$(dirname "$gitdir")
    count=$(cd "$repo" && git rev-list --count --author="$user" --since="midnight" --all)

    if [ "$count" -gt 0 ]; then  
        total_commits_today=$((total_commits_today + count))
    fi

done < <(find ~ -maxdepth 2 -name ".git" -type d -prune)
echo "$total_commits_today"
