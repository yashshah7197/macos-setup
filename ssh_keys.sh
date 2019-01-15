#!/usr/bin/env bash

# ssh_keys.sh
# This script contains functions for setting up SSH

# Constants for the main and the corresponding dotfiles SSH configuration directories
readonly SSH_CONFIG_DIR=~/.ssh
readonly SSH_DOTFILES_CONFIG_DIR="${DOTFILES_DIR}"/ssh

# Constants for SSH key and config file names
readonly FILENAME_KEY_PRIVATE="id_rsa"
readonly FILENAME_KEY_PUBLIC="id_rsa.pub"
readonly FILENAME_CONFIG="config"

# 1Password UUIDs for SSH keys
readonly UUID_KEY_PRIVATE="c2oai664kfdtlbr5xa7yjii5dq"
readonly UUID_KEY_PUBLIC="lgr3rt63gvh6lncrpdhghmksou"

# Create the SSH configuration directory
function create_config_dir() {
    printf "${text_style_default}Creating the SSH configuration directory..."
    if mkdir -p "${SSH_CONFIG_DIR}" >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Fetch the private key from 1Password
function fetch_private_key_from_1password() {
    if [[ -f "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PRIVATE}" ]]; then
        rm -rf "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PRIVATE}"
    fi
    printf "${text_style_default}Fetching the private key from 1Password..."
    if op get document "${UUID_KEY_PRIVATE}" --session="${onepassword_token}" \
        > "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PRIVATE}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Fetch the public key from 1Password
function fetch_public_key_from_1password() {
    if [[ -f "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PUBLIC}" ]]; then
        rm -rf "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PUBLIC}"
    fi
    printf "${text_style_default}Fetching the public key from 1Password..."
    if op get document "${UUID_KEY_PUBLIC}" --session="${onepassword_token}" \
        > "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PUBLIC}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Set the permissions for the SSH configuration directory
function set_config_dir_permissions() {
    printf "${text_style_default}Setting permissions for the configuration directory..."
    if chmod 700 "${SSH_CONFIG_DIR}" >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Set the permissions for the private key
function set_private_key_permissions() {
    printf "${text_style_default}Setting permissions for the private key file..."
    if chmod 400 "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PRIVATE}" >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Set the permissions for the public key
function set_public_key_permissions() {
    printf "${text_style_default}Setting permissions for the public key file..."
    if chmod 644 "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PUBLIC}" >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Create a symlink for the SSH configuration file
function symlink_ssh_config() {
    if [[ -f "${SSH_CONFIG_DIR}"/"${FILENAME_CONFIG}" ]]; then
        rm -rf "${SSH_CONFIG_DIR}"/"${FILENAME_CONFIG}"
    fi
    printf "${text_style_default}Symlinking the SSH config file..."
    if ln -nfs "${SSH_DOTFILES_CONFIG_DIR}"/"${FILENAME_CONFIG}" \
        "${SSH_CONFIG_DIR}"/"${FILENAME_CONFIG}" >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Main function to kick-off setting up SSH
function setup_ssh() {
    newline
    message_info "Setting up SSH..."
    create_config_dir
    fetch_private_key_from_1password
    fetch_public_key_from_1password
    set_config_dir_permissions
    set_private_key_permissions
    set_public_key_permissions
    symlink_ssh_config
    message_success "Successfully set up SSH!"
}
