#!/usr/bin/env bash

# vscode.sh
# This script contains functions for setting up Visual Studio Code

# Constants for the main and the corresponding dotfiles Visual Studio Code settings directories
readonly VSCODE_SETTINGS_DIR="${HOME}"/Library/Application\ Support/Code/User
readonly VSCODE_DOTFILES_SETTINGS_DIR="${DOTFILES_DIR}"/vscode

# List of Visual Studio Code extensions to be installed
vscode_extensions=(
    'coenraads.bracket-pair-colorizer-2'
    'vscode-icons-team.vscode-icons'
    'skyapps.fish-vscode'
)

# Install Visual Studio Code extensions
function vscode_install_extensions() {
    message_normal "Installing extensions..."
    for extension in "${vscode_extensions[@]}"; do
        if ! code --install-extension "${extension}" \
            >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_cross
            newline
            print_error_and_exit
        fi
    done
    print_tick
}

# Create a symlink for the Visual Studio Code settings file
function vscode_symlink_settings() {
    message_normal "Symlinking settings.json..."
    ln -f -s "${VSCODE_DOTFILES_SETTINGS_DIR}"/settings.json "${VSCODE_SETTINGS_DIR}"/settings.json
    print_tick
}

# Main function to kick-off setting up Visual Studio Code
function setup_vscode() {
    newline
    message_info "Setting up Visual Studio Code..."
    vscode_install_extensions
    vscode_symlink_settings
    message_success "Successfully set up Visual Studio Code!"
}
