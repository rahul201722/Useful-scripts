#!/bin/bash

# LazyVim Auto-Update Helper Script
# This script checks if 15 days have passed since last update and runs the update script

SCRIPT_DIR="$HOME/Useful-scripts"
UPDATE_SCRIPT="$SCRIPT_DIR/update_lazyvim.sh"
LAST_UPDATE_FILE="$HOME/.lazyvim_last_update"
DAYS_BETWEEN_UPDATES=15

# Function to get current timestamp
get_timestamp() {
    date +%s
}

# Function to check if update is needed
should_update() {
    if [ ! -f "$LAST_UPDATE_FILE" ]; then
        return 0  # First time, should update
    fi
    
    local last_update=$(cat "$LAST_UPDATE_FILE" 2>/dev/null || echo "0")
    local current_time=$(get_timestamp)
    local seconds_in_day=86400
    local seconds_between_updates=$((DAYS_BETWEEN_UPDATES * seconds_in_day))
    local time_diff=$((current_time - last_update))
    
    if [ $time_diff -ge $seconds_between_updates ]; then
        return 0  # Should update
    else
        return 1  # Too soon
    fi
}

# Function to update timestamp
update_timestamp() {
    get_timestamp > "$LAST_UPDATE_FILE"
}

# Function to run the update with user confirmation
run_auto_update() {
    if [ ! -f "$UPDATE_SCRIPT" ]; then
        echo "⚠️  LazyVim update script not found at: $UPDATE_SCRIPT"
        echo "   Make sure you've cloned the Useful-scripts repository to your home directory."
        return 1
    fi
    
    if should_update; then
        local days_since_last=0
        if [ -f "$LAST_UPDATE_FILE" ]; then
            local last_update=$(cat "$LAST_UPDATE_FILE" 2>/dev/null || echo "0")
            local current_time=$(get_timestamp)
            days_since_last=$(( (current_time - last_update) / 86400 ))
        fi
        
        echo ""
        echo "🔄 LazyVim Auto-Update Notice"
        echo "=============================="
        if [ $days_since_last -eq 0 ]; then
            echo "This is your first time running the auto-updater."
        else
            echo "It's been $days_since_last days since your last LazyVim update."
        fi
        echo ""
        echo "Would you like to update LazyVim dependencies now? (y/N)"
        read -r response
        
        case "$response" in
            [yY][eE][sS]|[yY]) 
                echo "🚀 Running LazyVim update..."
                if "$UPDATE_SCRIPT"; then
                    update_timestamp
                    echo "✅ Update completed and timestamp recorded."
                else
                    echo "❌ Update failed. Timestamp not updated."
                    return 1
                fi
                ;;
            *) 
                echo "⏭️  Update skipped. Will ask again in $DAYS_BETWEEN_UPDATES days."
                update_timestamp  # Update timestamp to avoid asking again soon
                ;;
        esac
    fi
}

# Function to force an update (can be called manually)
force_update() {
    if [ ! -f "$UPDATE_SCRIPT" ]; then
        echo "⚠️  LazyVim update script not found at: $UPDATE_SCRIPT"
        return 1
    fi
    
    echo "🚀 Force running LazyVim update..."
    if "$UPDATE_SCRIPT"; then
        update_timestamp
        echo "✅ Update completed and timestamp recorded."
    else
        echo "❌ Update failed."
        return 1
    fi
}

# Main execution based on argument
case "${1:-auto}" in
    "force")
        force_update
        ;;
    "auto"|*)
        run_auto_update
        ;;
esac
