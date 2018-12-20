#!/usr/bin/env bash

# setup.sh
# This is the main script that will perform the macOS provisioning process

# Declare different text colors and styles
text_color_blue=$(tput setaf 4)
text_color_green=$(tput setaf 2)
text_color_red=$(tput setaf 1)
text_color_white=$(tput setaf 7)
text_style_bold=$(tput bold)
text_style_default=$(tput sgr0)

function newline() {
    printf "\n"
}

function message_info() {
    printf "${text_style_bold}${text_color_blue}==>${text_color_white} %s" "$1"
    newline
}

function message_failure() {
    printf "${text_style_bold}${text_color_red}✘${text_style_default}  %s" "$1"
    newline
}

function message_success() {
    printf "${text_style_bold}${text_color_green}✔${text_style_default}  %s" "$1"
    newline
}

# Build a simple prompt for the user to enter the administrator password
function prompt_for_admin_password() {
    read -s -p "Password: " password_admin
    newline
}

# (Re)authenticate administrator using the password specified by the user
# This will also extend the sudo timeout for an additional 5 minutes
function authenticate_admin_using_password() {
    sudo --stdin --validate <<< "${password_admin}" >/dev/null 2>&1
}

function acquire_admin_privileges() {
    newline
    message_info "Attempting to acquire administrator privileges..."
    message_info "You may be required to enter your password..."
    # Keep prompting for the administrator password until authentication is successful
    until sudo --non-interactive true >/dev/null 2>&1; do
        prompt_for_admin_password
        authenticate_admin_using_password
    done
    message_success "Successfully acquired administrator privileges!"
}

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
