#!/usr/bin/env bash

# iterm.sh
# This script contains functions for setting up iTerm2

# Base url for downloading iTerm2 shell integration scripts
readonly ITERM_SHELL_INTEGRATION_URL="https://iterm2.com/shell_integration"

# List of shells for which to download shell integration scripts
shell_integrations=(
    'bash'
    'fish'
    'zsh'
)

# Download iTerm2 shell integration scripts
function iterm_download_shell_integration_scripts() {
    message_normal "Downloading shell integration scripts..."
    for shell_integration in "${shell_integrations[@]}"; do
        if ! curl -L "${ITERM_SHELL_INTEGRATION_URL}"/"${shell_integration}" \
            --output "${HOME}"/.iterm2_shell_integration."${shell_integration}" --silent \
            2>"${FILENAME_LOG_ERRORS}"; then
            print_cross
            newline
            print_error_and_exit
        fi
    done
    print_tick
}

# Change the directory from which iTerm2 loads preferences
function iterm_change_prefs_dir() {
    message_normal "Changing the iTerm2 preferences directory..."
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${DOTFILES_DIR}"
    print_tick
}

# Load iTerm2 preferences from a custom directory instead of the default one
function iterm_load_prefs_from_custom_dir() {
    message_normal "Telling iTerm2 to load preferences from the custom directory..."
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
    print_tick
}

# Main function to kick-off setting up iTerm2
function setup_iterm() {
    newline
    message_info "Setting up iTerm2..."
    iterm_download_shell_integration_scripts
    iterm_change_prefs_dir
    iterm_load_prefs_from_custom_dir
    message_success "Successfully set up iTerm2!"
}
