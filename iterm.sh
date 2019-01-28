#!/usr/bin/env bash

# iterm.sh
# This script contains functions for setting up iTerm2

# Change the directory from which iTerm2 loads preferences
function iterm_change_prefs_dir() {
    message_normal "Changing the iTerm2 preferences directory..."
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${DOTFILES_DIR}"
    print_tick
}

# Load iTerm2 preferences from a custom directory instead of the default one
function iterm_load_prefs_from_custom_dir() {
    message_normal "Telling iTerm to load preferences from the custom directory..."
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
    print_tick
}

# Main function to kick-off setting up iTerm2
function setup_iterm() {
    newline
    message_info "Setting up iTerm2..."
    iterm_change_prefs_dir
    iterm_load_prefs_from_custom_dir
    message_success "Successfully set up iTerm2!"
}
