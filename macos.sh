#!/usr/bin/env bash

# macos.sh
# This script contains functions for setting some macOS preferences

# Set the timezone
function macos_set_timezone() {
    message_normal "Setting timezone..."

    # Set the timezone
    sudo systemsetup -settimezone "Asia/Calcutta" >/dev/null

    print_tick
}

# Set keyboard preferences
function macos_set_keyboard_preferences() {
    message_normal "Setting keyboard preferences..."

    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Set a fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 25

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable automatic capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable automatic period substitution
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    # Disable smart dashes
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable smart quotes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

    # Use scroll gesture with the Ctrl (^) modifier key to zoom
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

    # Follow the keyboard focus while zoomed in
    defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

    print_tick
}

# Set trackpad preferences
function macos_set_trackpad_preferences() {
    message_normal "Setting trackpad preferences..."

    # Enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Set the trackpad scaling speed
    defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1

    # Enable natural scrolling
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    print_tick
}

# Set Finder preferences
function macos_set_finder_preferences() {
    message_normal "Setting Finder preferences..."

    # Allow quitting via ⌘ + Q
    defaults write com.apple.finder QuitMenuItem -bool true

    # Set the user's home directory as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Use list view in all Finder windows by default
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Show the path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Enable spring loading for directories
    defaults write NSGlobalDomain com.apple.springing.enabled -bool true

    # Remove the spring loading delay for directories
    defaults write NSGlobalDomain com.apple.springing.delay -float 0

    # Disable disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Enable snap-to-grid for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c \
        "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c \
        "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c \
        "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist

    # Change grid spacing for icons on the desktop and in other icon views to 48 pixels
    /usr/libexec/PlistBuddy -c \
        "Set :DesktopViewSettings:IconViewSettings:gridSpacing 48" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c \
        "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 48" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c \
        "Set :StandardViewSettings:IconViewSettings:gridSpacing 48" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist

    # Change the size of icons on the desktop and in other icon views to 60x60 pixels
    /usr/libexec/PlistBuddy -c \
        "Set :DesktopViewSettings:IconViewSettings:iconSize 60" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c \
        "Set :FK_StandardViewSettings:IconViewSettings:iconSize 60" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c \
        "Set :StandardViewSettings:IconViewSettings:iconSize 60" \
        "${HOME}"/Library/Preferences/com.apple.finder.plist

    # Expand the following File Info panes:
    # “General”, “Open with”, and “Sharing & Permissions”
    defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        OpenWith -bool true \
        Privileges -bool true

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

    # Hide the Desktop, Documents, Downloads, Movies, Music, Pictures and Public directories in the
    # user's home directory
    chflags hidden "${HOME}/Desktop"
    chflags hidden "${HOME}/Documents"
    chflags hidden "${HOME}/Downloads"
    chflags hidden "${HOME}/Movies"
    chflags hidden "${HOME}/Music"
    chflags hidden "${HOME}/Pictures"
    chflags hidden "${HOME}/Public"

    print_tick
}

# Set Dock preferences
function macos_set_dock_preferences() {
    message_normal "Setting Dock preferences..."

    # Set the icon size of Dock items to 36x36 pixels
    defaults write com.apple.dock tilesize -int 36

    # Enable magnification
    defaults write com.apple.dock magnification -bool true

    # Set the magnification size of Dock items to 54x54 pixels
    defaults write com.apple.dock largesize -int 54

    # Minimize windows into their application’s icon
    defaults write com.apple.dock minimize-to-application -bool true

    # Don’t animate opening applications from the Dock
    defaults write com.apple.dock launchanim -bool false

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true

    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0

    # Don’t show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false

    # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true

    # Enable highlight hover effect for the grid view of a stack (Dock)
    defaults write com.apple.dock mouse-over-hilite-stack -bool true

    print_tick
}

# Set Mission Control preferences
function macos_set_mission_control_preferences() {
    message_normal "Setting Mission Control preferences..."

    # Group windows by application
    defaults write com.apple.dock expose-group-by-app -bool true

    # Don’t automatically rearrange Spaces based on most recent use
    defaults write com.apple.dock mru-spaces -bool false

    print_tick
}

# Set screenshot preferences
function macos_set_screenshot_preferences() {
    message_normal "Setting screenshot preferences..."

    # Create the screenshots directory
    mkdir -p "${HOME}/Pictures/Screenshots"

    # Set directory where screenshots are saved
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

    # Save screenshots in PNG format
    defaults write com.apple.screencapture type -string "png"

    print_tick
}

# Set Activity Monitor preferences
function macos_set_activity_monitor_preferences() {
    message_normal "Setting Activity Monitor preferences..."

    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0

    print_tick
}

# Set Disk Utility preferences
function macos_set_disk_utility_preferences() {
    message_normal "Setting Disk Utility preferences..."

    # Enable the advanced image options in Disk Utility
    defaults write com.apple.DiskUtility advanced-image-options -bool true

    print_tick
}

# Set Time Machine preferences
function macos_set_time_machine_preferences() {
    message_normal "Setting Time Machine preferences..."

    # Prevent Time Machine from prompting to use new hard drives as backup volume
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    print_tick
}

# Set the system accent and highlight colors
function macos_set_accent_highlight_colors() {
    message_normal "Setting accent and highlight colors..."

    # Change accent color to red
    defaults write NSGlobalDomain AppleAccentColor -int 0

    # Change highlight color to red
    defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569 Red"

    print_tick
}

# Set the login window message
function macos_set_login_window_message() {
    message_normal "Setting login window message..."

    # Set login window message
    sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
    "'Hello! I belong to Yash Shah.\nIf you find me lost somewhere, please contact Yash at either \
    of the following :-\nPhone Number: (+91) 750-760-7711\nEmail: yash.shah7197@live.com'"

    print_tick
}

# Main function to kick-off setting preferences for macOS
function set_macos_preferences() {
    newline
    message_info "Setting preferences for macOS..."
    macos_set_timezone
    macos_set_keyboard_preferences
    macos_set_trackpad_preferences
    macos_set_finder_preferences
    macos_set_dock_preferences
    macos_set_mission_control_preferences
    macos_set_screenshot_preferences
    macos_set_activity_monitor_preferences
    macos_set_disk_utility_preferences
    macos_set_time_machine_preferences
    macos_set_accent_highlight_colors
    macos_set_login_window_message
    message_success "Successfully set preferences for macOS!"
}
