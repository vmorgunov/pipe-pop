#!/bin/bash

SERVICE_NAME="pop"
CHECK_INTERVAL=60  # Time in seconds between log checks

# Function to check for updates in logs and extract the URL
check_for_update() {
    local log_output
    log_output=$(journalctl -u "$SERVICE_NAME" -o cat --no-pager -n 100 | grep -E "UPDATE AVAILABLE!")

    if [[ -n "$log_output" ]]; then
        # Extract the download URL dynamically
        local new_version_url
        new_version_url=$(journalctl -u "$SERVICE_NAME" -o cat --no-pager -n 100 | grep -Eo "https://dl\.pipecdn\.app/v[0-9]+\.[0-9]+\.[0-9]+/pop")

        if [[ -n "$new_version_url" ]]; then
            echo "New update detected: $new_version_url"
            update_pop "$new_version_url"
        fi
    fi
}

# Function to update the 'pop' binary
update_pop() {
    local url="$1"
    local target_path="$HOME/opt/dcdn/pop"

    echo "Stopping pop service..."
    sudo systemctl stop pop

    echo "Downloading new version: $url"
    sudo wget -O "$target_path" "$url"

    echo "Applying executable permissions..."
    chmod +x "$target_path"
    sudo ln -sf "$target_path" /usr/local/bin/pop

    echo "Refreshing and restarting pop service..."
    "$target_path" --refresh
    sudo systemctl start pop

    echo "Update complete!"
}

# Monitor logs and trigger update when necessary
while true; do
    check_for_update
    sleep $CHECK_INTERVAL
done

