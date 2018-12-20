#!/usr/bin/env bash

# setup.sh
# This is the main script that will perform the macOS provisioning process

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
