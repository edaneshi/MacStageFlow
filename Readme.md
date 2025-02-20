# MacStageFlow

MacStageFlow is a simple utility that automatically resizes your active window to perfectly complement macOS Stage Manager. It ensures your windows are positioned and sized optimally, maintaining visibility of the Stage Manager sidebar while maximizing usable space.

## Features

- Automatically resizes the active window to fit perfectly with Stage Manager
- Maintains visibility of Stage Manager sidebar
- Considers screen resolution dynamically
- Works with any application window
- Can be triggered via Shortcuts app or Alfred

## Requirements

- macOS with Stage Manager support (macOS Ventura or later)
- Apple's Shortcuts app

## Installation

1. Open the Shortcuts app on your Mac
2. Click the '+' button to create a new shortcut
3. Add a "Run Shell Script" action (you can search for it in the actions panel)
4. Configure the shell script action:

   - Set Shell to `/bin/zsh`
   - Leave "Pass Input" as "to stdin"

5. Copy and paste the entire script below into the script text area:

#!/bin/zsh

# Get screen dimensions

screen_width=$(system_profiler SPDisplaysDataType | awk '/Resolution:/ {print $2}')
screen_height=$(system_profiler SPDisplaysDataType | awk '/Resolution:/ {print $4}')

# Configuration

sidebar_width=200 # Stage Manager sidebar
right_margin=220 # Reduced from 300 to 220 for app UI panels
top_margin=20
bottom_margin=40

# Calculate dimensions

app_x=$sidebar_width
app_y=$top_margin

# Calculate width using 85% of available space

available_width=$((screen_width - sidebar_width - right_margin))
app_width=$available_width # Use all available width instead of percentage

# Height calculation

app_height=$((screen_height - top_margin - bottom_margin))

osascript <<EOF
try
tell application "System Events"
set frontApp to first application process whose frontmost is true

        tell frontApp
            if (count of windows) is 0 then
                error "No windows available"
            end if

            tell window 1
                -- Set position first
                set position to {$app_x, $app_y}
                delay 0.1

                -- Set size using full available width
                set size to {$app_width, $app_height}
            end tell
        end tell
    end tell

on error errMsg
log "Notice: " & errMsg
end try
EOF

echo "Resize operation completed - Window size: ${app_width}x${app_height} at position ${app_x},${app_y}"
