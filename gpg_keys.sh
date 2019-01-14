#!/usr/bin/env bash

# ssh_keys.sh
# This script contains functions for setting up GPG keys

# GPG key file names
readonly GPG_PUBLIC_KEYS_FILENAME="public-keys.gpg"
readonly GPG_SECRET_SUBKEYS_FILENAME="secret-subkeys.gpg"
readonly GPG_OWNERTRUST_FILENAME="ownertrust.gpg"

# GPG key 1Password UUIDs
readonly GPG_PASSWORD_UID="nw25bj5screinla2s2d4y62sn4"
readonly GPG_PUBLIC_KEYS_UUID="zxcunfbomvfmrjt3nruv5huliu"
readonly GPG_SECRET_SUBKEYS_UUID="kifsewuybnbdrks2dwrjdjjpxa"
readonly GPG_OWNERTRUST_UUID="gnclrdvfnran5j2frjokdkzyhq"

function fetch_gpg_public_keys_from_1password() {
    printf "${text_style_default}Fetching the public keys from the 1Password vault..."
    if op get document $GPG_PUBLIC_KEYS_UUID --session=$onepassword_token > $GPG_PUBLIC_KEYS_FILENAME; then
        print_tick
    else
        print_cross
    fi
}

function fetch_gpg_secret_subkeys_from_1password() {
    printf "${text_style_default}Fetching the secret subkeys from the 1Password vault..."
    if op get document $GPG_SECRET_SUBKEYS_UUID --session=$onepassword_token > $GPG_SECRET_SUBKEYS_FILENAME; then
        print_tick
    else
        print_cross
    fi
}

function fetch_ownertrust_from_1password() {
    printf "${text_style_default}Fetching the ownertrust file from the 1Password vault..."
    if op get document $GPG_OWNERTRUST_UUID --session=$onepassword_token > $GPG_OWNERTRUST_FILENAME; then
        print_tick
    else
        print_cross
    fi
}

function import_publics_keys() {
    printf "${text_style_default}Importing public keys into keyring..."
    if gpg --import $GPG_PUBLIC_KEYS_FILENAME >/dev/null 2>&1; then
        print_tick
    else
        print_cross
    fi
}

function import_secret_subkeys() {
    printf "${text_style_default}Importing secret subkeys into keyring..."
    if gpg --pinentry-mode loopback --passphrase=$gpg_passphrase --import $GPG_SECRET_SUBKEYS_FILENAME >/dev/null 2>&1; then
        print_tick
    else
        print_cross
    fi
}

function import_ownertrust() {
    printf "${text_style_default}Importing ownertrust..."
    if gpg --import-ownertrust $GPG_OWNERTRUST_FILENAME >/dev/null 2>&1; then
        print_tick
    else
        print_cross
    fi
}

function fetch_gpg_passphrase() {
    printf "${text_style_default}Fetching GPG passphrase from 1Password..."
    gpg_passphrase=$(op get item $GPG_PASSWORD_UID --session=$onepassword_token | jq -r '.details.password')
    if [ $? -eq 0 ]; then
        print_tick
    else
        print_cross
    fi
}

function setup_configure_gpg() {
    signin_to_1password
    newline
    message_info "Setting up and configuring GPG..."
    fetch_gpg_public_keys_from_1password
    fetch_gpg_secret_subkeys_from_1password
    fetch_ownertrust_from_1password
    fetch_gpg_passphrase
    import_publics_keys
    import_secret_subkeys
    import_ownertrust
    message_success "Successfully set up and configured GPG!"
}
