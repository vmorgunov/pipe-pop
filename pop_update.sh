#!/bin/bash

SERVICE_NAME="pop"
LOG_LINES=100
TARGET_PATH="$HOME/opt/dcdn/pop"

# Function to check for updates in logs
check_for_update() {
    local log_output
    log_output=$(journalctl -u "$SERVICE_NAME" -o cat --no-pager -n $LOG_LINES | grep -E "UPDATE AVAILABLE!")

    if [[ -n "$log_output" ]]; then
        # Extract the download URL dynamically
        local new_version_url
        new_version_url=$(journalctl -u "$SERVICE_NAME" -o cat --no-pager -n $LOG_LINES | grep -Eo "https://dl\.pipecdn\.app/v[0-9]+\.[0-9]+\.[0-9]+/pop")

        if [[ -n "$new_version_url" ]]; then
            echo "New update detected: $new_version_url"
            update_pop "$new_version_url"
        fi
    fi
}

# Function to update the 'pop' binary
update_pop() {
    local url="$1"

    echo "Stopping pop service..."
    sudo systemctl stop pop

    echo "Downloading new version: $url"
    sudo wget -O "$TARGET_PATH" "$url"

    echo "Applying executable permissions..."
    chmod +x "$TARGET_PATH"
    sudo ln -sf "$TARGET_PATH" /usr/local/bin/pop

    echo "Refreshing and restarting pop service..."
    "$TARGET_PATH" --refresh
    sudo systemctl start pop

    echo "Update complete!"
}

# Run the update check
check_for_update