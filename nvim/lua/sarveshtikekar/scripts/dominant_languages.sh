#!/bin/bash

# ================================
# FIXED: Removed Subshell Trap
# ================================

normalize_lang() {
    case "$1" in
        py|pyi) echo "python" ;;
        js|jsx|mjs|cjs) echo "javascript" ;;
        ts|tsx) echo "typescript" ;;
        c|h) echo "c" ;;
        cpp|cc|cxx|hpp|hh|hxx) echo "cpp" ;;
        rs) echo "rust" ;;
        go) echo "go" ;;
        lua) echo "lua" ;;
        java) echo "java" ;;
        rb|erb) echo "ruby" ;;
        php|phtml) echo "php" ;;
        sh|bash|zsh|fish) echo "shell" ;;
        html|htm) echo "html" ;;
        css|scss|sass|less) echo "css" ;;
        vue) echo "vue" ;;
        svelte) echo "svelte" ;;
        *) return 1 ;;
    esac
}

email=$(git config --global user.email)
if [ -z "$email" ]; then email=$(git config --global user.name); fi
today="2025-12-31"

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
            # Filter empty lines and paths
            [ -z "$file" ] && continue
            [[ "$file" == .* ]] && continue

            # Handle filenames
            ext="${file##*.}"
            if [ "$ext" = "$file" ]; then
                case "$file" in
                    Dockerfile|Containerfile) ext="docker" ;;
                    Makefile|makefile) ext="make" ;;
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
    echo "-"
else
    # Sort, Count, and Print Top 3
    echo "$output" | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2}' | tr '\n' ' '
fi
