#!/bin/bash
# Rofi menu for KooL Hyprland Quick Settings (SUPER SHIFT E)

# Define preferred text editor and terminal
edit=${EDITOR:-nvim}
tty=foot

# variables
configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"
rofi_theme="$HOME/.config/rofi/config-edit.rasi"
msg=' ⁉️ Choose what to do ⁉️'
iDIR="$HOME/.config/swaync/images"
scriptsDir="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"

# Function to display the menu options without numbers
menu() {
    cat <<EOF
ENV variables
Window Rules
User Keybinds
User Settings
Startup Apps
Decorations
Animations
Laptop Keybinds
Default Keybinds
Configure Monitors (nwg-displays)
Configure Workspace Rules (nwg-displays)
Choose Hyprland Animations
Choose Monitor Profiles
Choose Rofi Themes
Search for Keybinds
EOF
}

# Main function to handle menu selection
main() {
    choice=$(menu | rofi -i -dmenu -config $rofi_theme -mesg "$msg")
    
    # Map choices to corresponding files
    case "$choice" in
        "ENV variables") file="$UserConfigs/ENVariables.conf" ;;
        "Window Rules") file="$UserConfigs/WindowRules.conf" ;;
        "User Keybinds") file="$UserConfigs/UserKeybinds.conf" ;;
        "User Settings") file="$UserConfigs/UserSettings.conf" ;;
        "Startup Apps") file="$UserConfigs/Startup_Apps.conf" ;;
        "Decorations") file="$UserConfigs/UserDecorations.conf" ;;
        "Animations") file="$UserConfigs/UserAnimations.conf" ;;
        "Laptop Keybinds") file="$UserConfigs/Laptops.conf" ;;
        "Default Keybinds") file="$configs/Keybinds.conf" ;;
        "Configure Monitors (nwg-displays)") 
            if ! command -v nwg-displays &>/dev/null; then
                notify-send -i "$iDIR/ja.png" "E-R-R-O-R" "Install nwg-displays first"
                exit 1
            fi
            nwg-displays ;;
        "Configure Workspace Rules (nwg-displays)") 
            if ! command -v nwg-displays &>/dev/null; then
                notify-send -i "$iDIR/ja.png" "E-R-R-O-R" "Install nwg-displays first"
                exit 1
            fi
            nwg-displays ;;
        "Choose Hyprland Animations") $scriptsDir/Animations.sh ;;
        "Choose Monitor Profiles") $scriptsDir/MonitorProfiles.sh ;;
        "Choose Rofi Themes") $scriptsDir/RofiThemeSelector.sh ;;
        "Search for Keybinds") $scriptsDir/KeyBinds.sh ;;
        *) return ;;  # Do nothing for invalid choices
    esac

    # Open the selected file in the terminal with the text editor
    if [ -n "$file" ]; then
        $tty -e $edit "$file"
    fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

main
