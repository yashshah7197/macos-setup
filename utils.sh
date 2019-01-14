#!/usr/bin/env bash

# utils.sh
# This script contains some common utility functions which are used by all other scripts

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

function print_tick() {
    printf "${text_style_bold}${text_color_green}✔${text_style_default}"
    newline
}

function print_cross() {
    printf "${text_style_bold}${text_color_red}✘${text_style_default}"
    newline
}

function print_error_and_exit() {
    message_failure "The script failed to run to completion! Please try again!"
    exit 1
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

# Build prompts for user to enter his/her 1Password account credentials
function prompt_for_1password_credentials() {
    read -p "${text_style_default}1Password Sign-In Address: " onepassword_signin_address
    read -p "${text_style_default}1Password Email Address: " onepassword_email_address
    read -s -p "${text_style_default}1Password Secret Key: " onepassword_secret_key
    newline
    read -s -p "${text_style_default}1Password Master Password: " onepassword_master_password
    newline
}

# Sign in to 1Password using the user's 1Password account credentials
function signin_to_1password() {
    newline
    message_info "Attempting to sign in to 1Password..."
    message_info "Please enter the following 1Password credentials for your account..."
    prompt_for_1password_credentials
    onepassword_token=$(echo ${onepassword_master_password} | op signin ${onepassword_signin_address} ${onepassword_email_address} ${onepassword_secret_key} --output=raw 2>/dev/null)
    if [ $? -eq 0 ]; then
        message_success "Successfully signed into 1Password!"
    else
        message_failure "Failed to sign in to 1Password! Please check your credentials and try again!"
        newline
        print_error_and_exit
    fi
}
