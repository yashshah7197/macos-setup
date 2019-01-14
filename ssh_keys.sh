#!/usr/bin/env bash

# ssh_keys.sh
# This script contains functions for setting up and configuring SSH

# SSH configuration directory
readonly SSH_CONFIG_DIR=~/.ssh
readonly SSH_DOTFILES_CONFIG_DIR=$DOTFILES_DIR/ssh

# SSH key and config file names
readonly KEY_PRIVATE_FILENAME="id_rsa"
readonly KEY_PUBLIC_FILENAME="id_rsa.pub"
readonly SSH_CONFIG_FILENAME="config"

# SSH key 1Password UUIDs
readonly KEY_PRIVATE_UUID="c2oai664kfdtlbr5xa7yjii5dq"
readonly KEY_PUBLIC_UUID="lgr3rt63gvh6lncrpdhghmksou"

function create_ssh_config_dirs() {
    printf "${text_style_default}Creating the SSH configuration directory..."
    if mkdir -p $SSH_CONFIG_DIR >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function fetch_private_key_from_1password() {
    if [ -f $SSH_CONFIG_DIR/$KEY_PRIVATE_FILENAME ]; then
        rm -rf $SSH_CONFIG_DIR/$KEY_PRIVATE_FILENAME
    fi
    printf "${text_style_default}Fetching the private key from the 1Password vault..."
    if op get document $KEY_PRIVATE_UUID --session=$onepassword_token > $SSH_CONFIG_DIR/$KEY_PRIVATE_FILENAME; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function fetch_public_key_from_1password() {
    if [ -f $SSH_CONFIG_DIR/$KEY_PUBLIC_FILENAME ]; then
        rm -rf $SSH_CONFIG_DIR/$KEY_PUBLIC_FILENAME
    fi
    printf "${text_style_default}Fetching the public key from the 1Password vault..."
    if op get document $KEY_PUBLIC_UUID --session=$onepassword_token > $SSH_CONFIG_DIR/$KEY_PUBLIC_FILENAME; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function set_ssh_dir_permissions() {
    printf "${text_style_default}Setting the SSH directory permissions..."
    if chmod 700 $SSH_CONFIG_DIR >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function set_private_key_permissions() {
    printf "${text_style_default}Setting the private key permissions..."
    if chmod 400 $SSH_CONFIG_DIR/$KEY_PRIVATE_FILENAME >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function set_public_key_permissions() {
    printf "${text_style_default}Setting the public key permissions..."
    if chmod 644 $SSH_CONFIG_DIR/$KEY_PUBLIC_FILENAME >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function symlink_ssh_config() {
    if [ -f $SSH_CONFIG_DIR/$SSH_CONFIG_FILENAME ]; then
        rm -rf $SSH_CONFIG_DIR/$SSH_CONFIG_FILENAME
    fi
    printf "${text_style_default}Symlinking the SSH config file..."
    if ln -nfs $SSH_DOTFILES_CONFIG_DIR/$SSH_CONFIG_FILENAME $SSH_CONFIG_DIR/$SSH_CONFIG_FILENAME >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function setup_configure_ssh() {
    newline
    message_info "Setting up and configuring SSH ..."
    create_ssh_config_dirs
    fetch_private_key_from_1password
    fetch_public_key_from_1password
    set_ssh_dir_permissions
    set_private_key_permissions
    set_public_key_permissions
    symlink_ssh_config
    message_success "Successfully set up and configured the SSH keys!"
}
