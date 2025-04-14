#!/bin/bash

# Find all VSCode workspaceStorage workspace.json files
JSON_FILES=$(find ~/.config/Code/User/workspaceStorage -type f -name "workspace.json")

# Create an associative array to map project names to full paths
declare -A PROJECTS

# Extract folder paths and map to clean names
while read -r file; do
    folder_uri=$(jq -r '.folder' "$file")
    folder_path=${folder_uri#file://}
    folder_name=$(basename "$folder_path")
    PROJECTS["$folder_name"]="$folder_path"
done <<< "$JSON_FILES"

# Present folder names in rofi
CHOICE=$(printf "%s\n" "${!PROJECTS[@]}" | sort | rofi -dmenu -i -p "VSCode Session")

# Open the selected folder in VSCode
if [[ -n "$CHOICE" ]]; then
    code "${PROJECTS[$CHOICE]}"
fi
