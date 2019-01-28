#!/usr/bin/env bash

# gpg.sh
# This script contains functions for setting up GPG

# Constants for GPG key and ownertrust file names
readonly FILENAME_PUBLIC_KEYS="public-keys.gpg"
readonly FILENAME_SECRET_SUBKEYS="secret-subkeys.gpg"
readonly FILENAME_OWNERTRUST="ownertrust.gpg"

# 1Password UUIDs for the GPG passphrase, keys and ownertrust
readonly UUID_PASSPHRASE="nw25bj5screinla2s2d4y62sn4"
readonly UUID_PUBLIC_KEYS="zxcunfbomvfmrjt3nruv5huliu"
readonly UUID_SECRET_SUBKEYS="kifsewuybnbdrks2dwrjdjjpxa"
readonly UUID_OWNERTRUST="gnclrdvfnran5j2frjokdkzyhq"

# Fetch the passphrase from 1Password
function gpg_fetch_passphrase_from_1password() {
    message_normal "Fetching the passphrase from 1Password..."
    if passphrase=$(op get item "${UUID_PASSPHRASE}" --session="${onepassword_token}" \
        2>"${FILENAME_LOG_ERRORS}" | jq -e -r '.details.password') && [[ -n "${passphrase}" ]]; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Fetch the public keys from 1Password
function gpg_fetch_public_keys_from_1password() {
    message_normal "Fetching the public keys from 1Password..."
    if op get document "${UUID_PUBLIC_KEYS}" --session="${onepassword_token}" \
        >"${FILENAME_PUBLIC_KEYS}" 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Fetch the secret subkeys from 1Password
function gpg_fetch_secret_subkeys_from_1password() {
    message_normal "Fetching the secret subkeys from 1Password..."
    if op get document "${UUID_SECRET_SUBKEYS}" --session="${onepassword_token}" \
        >"${FILENAME_SECRET_SUBKEYS}" 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Fetch the ownertrust file from 1Password
function gpg_fetch_ownertrust_from_1password() {
    message_normal "Fetching the ownertrust file from 1Password..."
    if op get document "${UUID_OWNERTRUST}" --session="${onepassword_token}" \
        >"${FILENAME_OWNERTRUST}" 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Import the public keys into the keyring
function gpg_import_public_keys() {
    message_normal "Importing the public keys into the keyring..."
    if gpg --import "${FILENAME_PUBLIC_KEYS}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Import the secret subkeys into the keyring
function gpg_import_secret_subkeys() {
    message_normal "Importing the secret subkeys into the keyring..."
    if gpg --pinentry-mode loopback --passphrase="${passphrase}" \
        --import "${FILENAME_SECRET_SUBKEYS}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Import ownertrust
function gpg_import_ownertrust() {
    message_normal "Importing ownertrust..."
    if gpg --import-ownertrust "${FILENAME_OWNERTRUST}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Main function to kick-off setting up GPG
function setup_gpg() {
    newline
    message_info "Setting up GPG..."
    gpg_fetch_passphrase_from_1password
    gpg_fetch_public_keys_from_1password
    gpg_fetch_secret_subkeys_from_1password
    gpg_fetch_ownertrust_from_1password
    gpg_import_public_keys
    gpg_import_secret_subkeys
    gpg_import_ownertrust
    message_success "Successfully set up GPG!"
}
