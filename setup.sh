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
