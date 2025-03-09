#!/bin/zsh

# Get logical screen dimensions from Finder (handles HiDPI scaling)
logical_bounds=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')
logical_width=$(echo $logical_bounds | cut -d, -f3 | tr -d ' ')
logical_height=$(echo $logical_bounds | cut -d, -f4 | tr -d ' ')

# Configuration
sidebar_width=200  # Width for Stage Manager sidebar
right_margin=50    # Buffer to prevent overflow
top_margin=100     # Space for menu bar or UI elements
bottom_margin=0    # No bottom margin

# Calculate window position and size
app_x=$sidebar_width
app_y=$top_margin
available_width=$((logical_width - sidebar_width - right_margin))
app_width=$((available_width * 4 / 5))  # 80% of available width
app_height=$(( (logical_height - top_margin - bottom_margin) * 4 / 5 ))  # 80% of available height

# Cap dimensions to avoid overflow
max_width=$((logical_width - sidebar_width - right_margin))
if (( app_width > max_width )); then
    app_width=$max_width
fi
max_height=$((logical_height - top_margin - bottom_margin))
if (( app_height > max_height )); then
    app_height=$max_height
fi

# Debug output to track values
echo "Logical screen: ${logical_width}x${logical_height}"
echo "Target position: ${app_x},${app_y}, Size: ${app_width}x${app_height}"

# Execute AppleScript to resize and position the frontmost window
osascript <<EOF
tell application "System Events"
    try
        set frontApp to first application process whose frontmost is true
        tell frontApp
            -- Find the frontmost window using AXMain
            set frontWindow to missing value
            repeat with win in windows
                if value of attribute "AXMain" of win is true then
                    set frontWindow to win
                    exit repeat
                end if
            end repeat
            
            if frontWindow is missing value then
                error "Could not find the frontmost window"
            end if
            
            tell frontWindow
                -- Get current position
                set currentPosition to position
                set currentX to item 1 of currentPosition
                set currentY to item 2 of currentPosition
                
                -- Build the debug string in AppleScript
                set posString to "Current position: " & (currentX as string) & "," & (currentY as string)
                do shell script "echo " & quoted form of posString
                
                -- Only adjust position if it's off-screen
                if currentX >= $logical_width or currentX < 0 or currentY < 0 or currentY >= $logical_height then
                    set position to {$app_x, $app_y}
                    set moveString to "Moved window to: " & ($app_x as string) & "," & ($app_y as string)
                    do shell script "echo " & quoted form of moveString
                else
                    set noMoveString to "Position unchanged: " & (currentX as string) & "," & (currentY as string)
                    do shell script "echo " & quoted form of noMoveString
                end if
                
                -- Resize if possible
                if exists attribute "AXSize" then
                    set size to {$app_width, $app_height}
                else
                    display dialog "This window cannot be resized." buttons {"OK"} default button "OK"
                end if
            end tell
        end tell
    on error errMsg
        display dialog "Error: " & errMsg buttons {"OK"} default button "OK"
    end try
end tell
EOF

# Confirm success
if [ $? -eq 0 ]; then
    echo "Resize operation completed - Window size: ${app_width}x${app_height} at position ${app_x},${app_y}"
else
    echo "Resize operation failed."
fi