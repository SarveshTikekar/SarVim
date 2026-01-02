#!/bin/bash

# ================================
# FIXED: Filters Artifacts & Adds Solidity
# ================================

normalize_lang() {
    case "$1" in
        py|pyi|python) echo "py" ;;
        js|jsx|mjs|cjs|javascript) echo "js" ;;
        ts|tsx|typescript) echo "ts" ;;
        sol|solidity) echo "sol" ;;  # Added Solidity
        c|h) echo "c" ;;
        cpp|cc|cxx|hpp|hh|hxx) echo "cpp" ;;
        rs|rust) echo "rs" ;;
        go) echo "go" ;;
        lua) echo "lua" ;;
        java) echo "java" ;;
        rb|erb|ruby) echo "rb" ;;
        php|phtml) echo "php" ;;
        sh|bash|zsh|fish|shell) echo "sh" ;;
        html|htm) echo "html" ;;
        css|scss|sass|less) echo "css" ;;
        vue) echo "vue" ;;
        svelte) echo "svelte" ;;
        # json) echo "json" ;; # Optional: Comment out to hide JSON completely
        md|markdown) echo "md" ;;
        dockerfile) echo "dockerfile" ;;
        makefile) echo "makefile" ;;
        yaml|yml) echo "yaml" ;;
        toml) echo "toml" ;;
        *) return 1 ;;
    esac
}

email=$(git config --global user.email)
if [ -z "$email" ]; then email=$(git config --global user.name); fi
today=$(date +"%F")

# Capture all language outputs into a variable first
output=$(
    find ~ -maxdepth 2 -name ".git" -type d -prune | while read -r gitdir; do
        repo=$(dirname "$gitdir")
        
        # Run inside subshell to handle cd/exit safely
        (
            cd "$repo" || exit
            
            # Skip repos where you have NEVER committed
            git rev-list -n 1 --author="$email" HEAD >/dev/null 2>&1 || exit 0

            # Gather file list
            {
                git log --since="$today 00:00:00" --author="$email" --name-only --pretty=format: 2>/dev/null
                git diff --name-only 2>/dev/null
                git diff --cached --name-only 2>/dev/null
                git ls-files --others --exclude-standard 2>/dev/null
            }
        ) | while read -r file; do
            # 1. Filter empty lines
            [ -z "$file" ] && continue
            
            # 2. <<< NEW: Filter Build Artifacts & Junk >>>
            if [[ "$file" == *"artifacts/"* ]] || \
               [[ "$file" == *"cache/"* ]] || \
               [[ "$file" == *"node_modules/"* ]] || \
               [[ "$file" == *"dist/"* ]] || \
               [[ "$file" == *"build/"* ]] || \
               [[ "$file" == *"package-lock.json"* ]] || \
               [[ "$file" == *"yarn.lock"* ]]; then
                continue
            fi

            # Handle filenames
            ext="${file##*.}"

            # If file has no extension
            if [ "$ext" = "$file" ]; then
                case "$file" in
                    Dockerfile|Containerfile) ext="dockerfile" ;;
                    Makefile|makefile) ext="makefile" ;;
                    *) continue ;;
                esac
            fi
            
            # Print valid languages to stdout
            normalize_lang "$ext"
        done
    done
)

# Check if we found anything
if [ -z "$output" ]; then
    echo "" 
else
    # Sort, Count, and Print Top 3
    echo "$output" | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2}' | tr '\n' ' '
fi
