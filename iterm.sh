#!/usr/bin/env bash

# iterm.sh
# This script contains functions for setting up iTerm2

# Change the directory from which iTerm2 loads preferences
function change_prefs_dir() {
    printf "${text_style_default}Changing the iTerm2 preferences directory..."
    if defaults write com.googlecode.iterm2.plist PrefsCustomFolder \
        -string "${DOTFILES_DIR}" >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Load iTerm2 preferences from a custom directory instead of the default one
function load_prefs_from_custom_dir() {
    printf "${text_style_default}Telling iTerm to load preferences from the custom directory..."
    if defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder \
        -bool true >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Main function to kick-off setting up iTerm2
function setup_iterm() {
    newline
    message_info "Setting up iTerm2..."
    change_prefs_dir
    load_prefs_from_custom_dir
    message_success "Successfully set up iTerm2!"
}
