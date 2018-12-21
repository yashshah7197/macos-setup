#!/usr/bin/env bash

# fonts.sh
# This script contains a function to install additional fonts via Homebrew cask

# List of fonts to be installed via Homebrew cask
homebrew_fonts=(
    'font-fira-code'
    'font-roboto'
)

# Install fonts via Homebrew cask
function install_homebrew_fonts() {
    newline
    message_info "Installing fonts via Homebrew cask..."
    font_count_success=0
    font_count_failure=0
    for font in "${homebrew_fonts[@]}"; do
        printf "${text_style_default}Installing $font..."
        if brew cask install $font >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++font_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++font_count_failure))
        fi
    done
    message_success "Successfully installed $font_count_success fonts via Homebrew cask!"
    if [ $font_count_failure -ne 0 ]; then
        message_failure "Failed to install $font_count_failure fonts via Homebrew cask!"
    fi
}
