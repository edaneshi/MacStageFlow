# Window Resizer for Stage Manager

This script intelligently resizes the active window to accommodate Stage Manager thumbnails while preserving UI visibility.

## Features

- Automatically resizes active window to work with Stage Manager
- Preserves UI visibility by using intelligent resizing
- Maintains window aspect ratio when possible
- Includes safety margins to prevent UI clipping
- Works with all applications

## Setup Instructions

1. Save the script to a permanent location (e.g., `~/Documents/Scripts/`)
2. Open Apple Shortcuts app
3. Create a new shortcut
4. Add a "Run Shell Script" action
5. Enter the following command (adjust path as needed):
   ```
   osascript -l JavaScript /path/to/resizeWindow.js
   ```
6. Save the shortcut
7. Optionally, assign a keyboard shortcut in System Settings > Keyboard > Keyboard Shortcuts

## How It Works

The script:

1. Gets the active window dimensions
2. Calculates optimal size accounting for Stage Manager
3. Applies intelligent resizing with safety margins
4. Validates and adjusts position if needed

## Technical Details

- Uses JavaScript for Automation (JXA)
- Maintains minimum window width of 800px
- Includes 90px allowance for Stage Manager
- Adds 10px safety margin to prevent UI clipping

## Troubleshooting

If the window doesn't resize properly:

1. Ensure the script has execute permissions (`chmod +x resizeWindow.js`)
2. Check that the application window is active
3. Verify the script path in Shortcuts is correct
4. Make sure Stage Manager is enabled

## Known Limitations

- Works best with standard window layouts
- Some applications may have unique UI requirements
- Minimum window width of 800px is enforced to maintain usability
