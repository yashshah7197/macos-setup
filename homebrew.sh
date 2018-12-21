#!/usr/bin/env bash

# homebrew.sh
# This script contains functions for checking for and installing Homebrew,
# tapping into Homebrew taps and installing Homebrew formulae and casks

# List of Homebrew taps to be tapped
homebrew_taps=(
    'homebrew/cask-fonts'
    'homebrew/cask-versions'
    'homebrew/services'
)

# List of fonts to be installed
homebrew_fonts=(
    'font-fira-code'
    'font-roboto'
)

# Check if Homebrew is installed
function is_homebrew_installed() {
    newline
    message_info "Checking for an existing installation of Homebrew..."
    if command -v brew >/dev/null 2>&1; then
        message_success "An existing installation of Homebrew was found on the system!"
        return 0
    else
        message_failure "No existing installation of Homebrew was found on the system!"
        return 1
    fi
}

function install_homebrew() {
    if ! is_homebrew_installed; then
        newline
        message_info "Installing Homebrew..."
        local HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
        if /usr/bin/ruby -e "$(curl -fsSL ${HOMEBREW_INSTALL_URL})" </dev/null >/dev/null 2>&1; then
            message_success "Successfully installed Homebrew!"
        else
            message_failure "Failed to install Homebrew!"
        fi
    fi
}

# Tap into Homebrew taps
function tap_homebrew_taps() {
    newline
    message_info "Tapping into Homebrew taps..."
    tap_count_success=0
    tap_count_failure=0
    for tap in "${homebrew_taps[@]}"; do
        printf "${text_style_default}Tapping into $tap..."
        if brew tap $tap >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++tap_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++tap_count_failure))
        fi
    done
    message_success "Successfully tapped into $tap_count_success taps!"
    if [ $tap_count_failure -ne 0 ]; then
        message_failure "Failed to tap into $tap_count_failure taps!"
    fi
}

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
