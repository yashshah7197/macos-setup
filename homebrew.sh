#!/usr/bin/env bash

# homebrew.sh
# This script contains functions for checking for and installing Homebrew,
# tapping into Homebrew taps and installing Homebrew formulae and casks

# Constant for installation url for Homebrew
readonly HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"

# List of Homebrew taps to be tapped
homebrew_taps=(
    'homebrew/cask-fonts'
    'homebrew/cask-versions'
    'homebrew/services'
)

# Check if Homebrew is installed
function homebrew_is_homebrew_installed() {
    newline
    message_info "Checking for an existing installation of Homebrew..."
    if command -v brew >/dev/null; then
        message_success "An existing installation of Homebrew was found on the system!"
        return 0
    else
        message_failure "No existing installation of Homebrew was found on the system!"
        return 1
    fi
}

# Install Homebrew
function homebrew_install_homebrew() {
    if ! homebrew_is_homebrew_installed; then
        newline
        message_info "Installing Homebrew..."
        if /usr/bin/ruby -e "$(curl -fsSL ${HOMEBREW_INSTALL_URL})" \
            </dev/null >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            message_success "Successfully installed Homebrew!"
        else
            message_failure "Failed to install Homebrew!"
            newline
            print_error_and_exit
        fi
    fi
}

# Tap into Homebrew taps
function homebrew_tap_taps() {
    newline
    message_info "Tapping into Homebrew taps..."
    for tap in "${homebrew_taps[@]}"; do
        message_normal "Tapping into ${tap}..."
        if brew tap "${tap}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully tapped into Homebrew taps!"
}
