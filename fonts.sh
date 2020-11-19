#!/usr/bin/env bash

# fonts.sh
# This script contains a function for installing additional fonts via Homebrew Cask

# List of fonts to be installed via Homebrew Cask
homebrew_fonts=(
    'Fira Code -- font-fira-code'
)

# Install fonts via Homebrew cask
function fonts_install_homebrew_fonts() {
    newline
    message_info "Installing fonts via Homebrew Cask..."
    for font in "${homebrew_fonts[@]}"; do
        font_name=$(awk -F-- '{print $1}' <<< "${font}" | awk '{$1=$1};1')
        font_id=$(awk -F-- '{print $2}' <<< "${font}" | awk '{$1=$1};1')
        message_normal "Installing ${font_name}..."
        if brew cask install "${font_id}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed fonts via Homebrew Cask!"
}
