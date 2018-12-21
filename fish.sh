#!/usr/bin/env bash

# fish.sh
# This script contains functions for setting up and configuring fish shell

function create_config_dirs() {
    printf "${text_style_default}Creating required configuration directories..."
    if mkdir -p ~/.config/fish/functions >/dev/null 2>&1; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function add_fish_to_shells() {
    printf "${text_style_default}Adding fish shell to /etc/shells..."
    if echo /usr/local/bin/fish | sudo tee -a /etc/shells >/dev/null 2>&1; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function change_default_shell_to_fish() {
    printf "${text_style_default}Changing the default shell to fish shell..."
    if sudo chsh -s /usr/local/bin/fish $(whoami) >/dev/null 2>&1; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function change_fish_colors() {
    printf "${text_style_default}Changing the default fish shell colors..."
    if fish fish_colors.fish >/dev/null 2>&1; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function setup_configure_fish_shell() {
    newline
    message_info "Setting up and configuring fish shell..."
    create_config_dirs
    add_fish_to_shells
    change_default_shell_to_fish
    change_fish_colors
    message_success "Successfully set up and configured fish shell!"
}
