#!/bin/zsh

# Get logical screen dimensions from Finder (handles HiDPI scaling)
logical_bounds=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')
logical_width=$(echo $logical_bounds | cut -d, -f3 | tr -d ' ')
logical_height=$(echo $logical_bounds | cut -d, -f4 | tr -d ' ')

# Configuration
right_margin=30    # Buffer to prevent overflow on the right
bottom_margin=0    # No bottom margin

# Fixed position for top-left corner
app_x=300  
app_y=250  

# Calculate window size
available_width=$((logical_width - app_x - right_margin))  # Space from app_x to right edge
app_width=$((available_width * 90 / 100))  # 80% of available width
app_height=$(( (logical_height - app_y - bottom_margin) * 90 / 100 ))  # 80% of available height from app_y downward

# Cap dimensions to avoid overflow
max_width=$((logical_width - app_x - right_margin))
if (( app_width > max_width )); then
    app_width=$max_width
fi
max_height=$((logical_height - app_y - bottom_margin))
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
                -- Get current position and size
                set currentPosition to position
                set currentX to item 1 of currentPosition
                set currentY to item 2 of currentPosition
                set currentSize to size
                set currentWidth to item 1 of currentSize
                set currentHeight to item 2 of currentSize
                
                -- Debug: log current position and size
                set posString to "Current position: " & (currentX as string) & "," & (currentY as string) & " Size: " & (currentWidth as string) & "x" & (currentHeight as string)
                do shell script "echo " & quoted form of posString
                
                -- Resize first
                if exists attribute "AXSize" then
                    set size to {$app_width, $app_height}
                else
                    display dialog "This window cannot be resized." buttons {"OK"} default button "OK"
                end if
                
                -- Get actual size after resize
                set actualSize to size
                set actualWidth to item 1 of actualSize
                set actualHeight to item 2 of actualSize
                
                -- Debug: log actual size
                set sizeString to "Actual size after resize: " & (actualWidth as string) & "x" & (actualHeight as string)
                do shell script "echo " & quoted form of sizeString
                
                -- Only move if the top-left corner deviates significantly (e.g., > 5 pixels)
                if (currentX - $app_x > 5 or $app_x - currentX > 5 or currentY - $app_y > 5 or $app_y - currentY > 5) then
                    set position to {$app_x, $app_y}
                    set moveString to "Moved window to: " & ($app_x as string) & "," & ($app_y as string)
                    do shell script "echo " & quoted form of moveString
                else
                    set noMoveString to "Position unchanged: " & (currentX as string) & "," & (currentY as string)
                    do shell script "echo " & quoted form of noMoveString
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