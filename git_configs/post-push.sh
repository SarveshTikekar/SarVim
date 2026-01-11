#!/bin/bash

LOG_FILE="$HOME/.config/nvim/lua/sarveshtikekar/scripts/stats/stat-log.txt"
SCRIPT_DIR="$HOME/.config/nvim/lua/sarveshtikekar/scripts"

printf "" > "$LOG_FILE"

# Execute your 4 scripts and append the results
"$SCRIPT_DIR/commits_till_date.sh" >> "$LOG_FILE"
"$SCRIPT_DIR/commits_today.sh" >> "$LOG_FILE"
"$SCRIPT_DIR/streak_count.sh" >> "$LOG_FILE"
"$SCRIPT_DIR/dominant_languages.sh" >> "$LOG_FILE"
printf "\n" >> "$LOG_FILE"
