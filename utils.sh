#!/usr/bin/env bash

# utils.sh
# This script contains some common utility functions which are used by all other scripts

# Filenames for log files
readonly FILENAME_LOG_ERRORS="errors.log"

# Declare different text colors and styles
text_color_blue=$(tput setaf 4)
text_color_green=$(tput setaf 2)
text_color_red=$(tput setaf 1)
text_color_white=$(tput setaf 7)
text_style_bold=$(tput bold)
text_style_default=$(tput sgr0)

# Print a newline
function newline() {
    printf "\n"
}

# Print a normal message
function message_normal {
    printf "${text_style_default}%s" "$1"
}

# Print an information message
function message_info() {
    printf "${text_style_bold}${text_color_blue}==>${text_color_white} %s" "$1"
    newline
}

# Print a failure message
function message_failure() {
    printf "${text_style_bold}${text_color_red}✘${text_style_default}  %s" "$1"
    newline
}

# Print a success message
function message_success() {
    printf "${text_style_bold}${text_color_green}✔${text_style_default}  %s" "$1"
    newline
}

# Print a green tick mark (✔)
function print_tick() {
    printf "${text_style_bold}${text_color_green}%s${text_style_default}" "✔"
    newline
}

# Print a red cross mark (✘)
function print_cross() {
    printf "${text_style_bold}${text_color_red}%s${text_style_default}" "✘"
    newline
}

# Print a failure message and exit the script
function print_error_and_exit() {
    message_failure "The script failed to run to completion! Please try again!"
    exit 1
}

# Build a simple prompt for the user to enter the administrator password
function prompt_for_admin_password() {
    read -s -r -p "Password: " password_admin
    newline
}

# (Re)authenticate administrator using the password specified by the user
# This will also extend the sudo timeout for an additional 5 minutes
function authenticate_admin_using_password() {
    sudo --stdin --validate <<< "${password_admin}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"
}

# Acquire administrator privileges for the current user
function acquire_admin_privileges() {
    newline
    message_info "Attempting to acquire administrator privileges..."
    message_info "You may be required to enter your password..."
    # Keep prompting for the administrator password until authentication is successful
    until sudo --non-interactive true >/dev/null 2>"${FILENAME_LOG_ERRORS}"; do
        prompt_for_admin_password
        authenticate_admin_using_password
    done
    message_success "Successfully acquired administrator privileges!"
}

# Build prompts for user to enter his/her 1Password account credentials
function prompt_for_1password_credentials() {
    read -r -p "${text_style_default}1Password Sign-In Address: " onepassword_signin_address
    read -r -p "${text_style_default}1Password Email Address: " onepassword_email_address
    read -s -r -p "${text_style_default}1Password Secret Key: " onepassword_secret_key
    newline
    read -s -r -p "${text_style_default}1Password Master Password: " onepassword_master_password
    newline
}

# Sign in to 1Password using the user's 1Password account credentials
function signin_to_1password() {
    newline
    message_info "Attempting to sign in to 1Password..."
    message_info "Please enter the following 1Password credentials for your account..."
    prompt_for_1password_credentials
    if onepassword_token=$(echo "${onepassword_master_password}" | op signin \
        "${onepassword_signin_address}" "${onepassword_email_address}" "${onepassword_secret_key}" \
        --output=raw 2>"${FILENAME_LOG_ERRORS}"); then
        message_success "Successfully signed into 1Password!"
    else
        message_failure "Failed to sign in to 1Password! Please check your credentials and try again!"
        newline
        print_error_and_exit
    fi
}

# Cleanup
function cleanup() {
    if [[ -f "${FILENAME_PUBLIC_KEYS}" ]]; then
        rm -rf "${FILENAME_PUBLIC_KEYS}"
    fi
    if [[ -f "${FILENAME_SECRET_SUBKEYS}" ]]; then
        rm -rf "${FILENAME_SECRET_SUBKEYS}"
    fi
    if [[ -f "${FILENAME_OWNERTRUST}" ]]; then
        rm -rf "${FILENAME_OWNERTRUST}"
    fi
}

# Exit trap to run whenever the script exits
function trap_exit() {
    cleanup
}
trap trap_exit EXIT

# Trap to handle user interruption via CTRL-C cleanly
function trap_ctrl_c() {
    newline
    newline
    message_failure "The script execution was interrupted by the user!"
    print_error_and_exit
}
trap trap_ctrl_c SIGINT
