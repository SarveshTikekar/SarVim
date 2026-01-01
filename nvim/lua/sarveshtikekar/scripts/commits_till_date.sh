#!/bin/bash

total_commits_till_date=0
user=$(git config --global user.name)
git_rel_date="2005-04-07"

while read gitdir; do
    
    repo=$(dirname "$gitdir")
    count=$(cd "$repo" && git rev-list --count --author="$user" --since="$git_rel_date" --all)

    if [ "$count" -gt 0 ]; then  
        total_commits_till_date=$((total_commits_till_date + count))
    fi

done < <(find ~ -maxdepth 2 -name ".git" -type d -prune)
echo "$total_commits_till_date"

