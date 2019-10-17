#!/usr/bin/env bash

# ssh.sh
# This script contains functions for setting up SSH

# Constants for the main and the corresponding dotfiles SSH configuration directories
readonly SSH_CONFIG_DIR="${HOME}"/.ssh
readonly SSH_DOTFILES_CONFIG_DIR="${DOTFILES_DIR}"/ssh

# Constants for SSH key and config file names
readonly FILENAME_KEY_PRIVATE="id_rsa"
readonly FILENAME_KEY_PUBLIC="id_rsa.pub"
readonly FILENAME_CONFIG="config"

# 1Password UUIDs for SSH keys
readonly UUID_KEY_PRIVATE="wweqnrz4z5efzlwy3ayonutjyi"
readonly UUID_KEY_PUBLIC="rsu5ptsr6vcc7id5hes5tzvrie"

# Create the SSH configuration directory
function ssh_create_config_dir() {
    message_normal "Creating the SSH configuration directory..."
    mkdir -p "${SSH_CONFIG_DIR}"
    print_tick
}

# Fetch the private key from 1Password
function ssh_fetch_private_key_from_1password() {
    rm -f -r "${SSH_CONFIG_DIR:?}"/"${FILENAME_KEY_PRIVATE:?}"
    message_normal "Fetching the private key from 1Password..."
    if op get document "${UUID_KEY_PRIVATE}" --session="${onepassword_token}" \
        >"${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PRIVATE}" 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Fetch the public key from 1Password
function ssh_fetch_public_key_from_1password() {
    rm -f -r "${SSH_CONFIG_DIR:?}"/"${FILENAME_KEY_PUBLIC:?}"
    message_normal "Fetching the public key from 1Password..."
    if op get document "${UUID_KEY_PUBLIC}" --session="${onepassword_token}" \
        >"${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PUBLIC}" 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Set the permissions for the SSH configuration directory
function ssh_set_config_dir_permissions() {
    message_normal "Setting permissions for the configuration directory..."
    chmod 700 "${SSH_CONFIG_DIR}"
    print_tick
}

# Set the permissions for the private key
function ssh_set_private_key_permissions() {
    message_normal "Setting permissions for the private key file..."
    chmod 400 "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PRIVATE}"
    print_tick
}

# Set the permissions for the public key
function ssh_set_public_key_permissions() {
    message_normal "Setting permissions for the public key file..."
    chmod 644 "${SSH_CONFIG_DIR}"/"${FILENAME_KEY_PUBLIC}"
    print_tick
}

# Create a symlink for the SSH configuration file
function ssh_symlink_config() {
    message_normal "Symlinking the SSH config file..."
    ln -f -s "${SSH_DOTFILES_CONFIG_DIR}"/"${FILENAME_CONFIG}" \
        "${SSH_CONFIG_DIR}"/"${FILENAME_CONFIG}"
    print_tick
}

# Main function to kick-off setting up SSH
function setup_ssh() {
    newline
    message_info "Setting up SSH..."
    ssh_create_config_dir
    ssh_fetch_private_key_from_1password
    ssh_fetch_public_key_from_1password
    ssh_set_config_dir_permissions
    ssh_set_private_key_permissions
    ssh_set_public_key_permissions
    ssh_symlink_config
    message_success "Successfully set up SSH!"
}
