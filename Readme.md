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

### Option 1: Manual Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/edaneshi/MacStageFlow.git
   ```

2. Open the Shortcuts app on your Mac
3. Click the '+' button to create a new shortcut
4. Add a "Run Shell Script" action (you can search for it in the actions panel)
5. Configure the shell script action:
   - Set Shell to `/bin/zsh`
   - Leave "Pass Input" as "to stdin"
6. Copy and paste the entire script from `resize_window.sh` into the script text area

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
