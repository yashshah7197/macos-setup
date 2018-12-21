#!/usr/bin/env bash

# iterm.sh
# This script contains functions for setting up and configuring iTerm2

function change_pref_dir() {
    printf "${text_style_default}Changing preferences directory..."
    if defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES_DIR" >/dev/null 2>&1; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function load_prefs_from_custom_dir() {
    printf "${text_style_default}Telling iTerm to load preferences from the custom directory..."
    if defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true >/dev/null 2>&1; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function setup_configure_iterm() {
    newline
    message_info "Setting up and configuring iTerm2..."
    change_pref_dir
    load_prefs_from_custom_dir
    message_success "Successfully set up and configured iTerm2!"
}
