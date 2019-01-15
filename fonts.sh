#!/usr/bin/env bash

# fonts.sh
# This script contains a function to install additional fonts via Homebrew cask

# List of fonts to be installed via Homebrew cask
homebrew_fonts=(
    'Fira Code -- font-fira-code'
    'Roboto -- font-roboto'
)

# Install fonts via Homebrew cask
function install_homebrew_fonts() {
    newline
    message_info "Installing fonts via Homebrew cask..."
    for font in "${homebrew_fonts[@]}"; do
        font_name=$(awk -F-- '{print $1}' <<< "${font}" | awk '{$1=$1};1')
        font_id=$(awk -F-- '{print $2}' <<< "${font}" | awk '{$1=$1};1')
        printf "${text_style_default}Installing ${font_name}..."
        if brew cask install "${font_id}" >/dev/null 2>&1; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed fonts via Homebrew cask!"
}
