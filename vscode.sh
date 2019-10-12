#!/usr/bin/env bash

# vscode.sh
# This script contains functions for setting up Visual Studio Code

# Constants for the main and the corresponding dotfiles Visual Studio Code settings directories
readonly VSCODE_SETTINGS_DIR="${HOME}"/Library/Application\ Support/Code/User
readonly VSCODE_DOTFILES_SETTINGS_DIR="${DOTFILES_DIR}"/vscode

# List of Visual Studio Code extensions to be installed
vscode_extensions=(
    'Bracket Pair Colorizer 2 -- coenraads.bracket-pair-colorizer-2'
    'Path Intellisense -- christian-kohler.path-intellisense'
    'VS Code Icons -- robertohuertasm.vscode-icons'
)

# List of Python linters to be installed
python_linters=(
    'autopep8'
    'flake8'
)

# Install Visual Studio Code extensions
function vscode_install_extensions() {
    newline
    message_info "Installing Visual Studio Code extensions..."
    for extension in "${vscode_extensions[@]}"; do
        extension_name=$(awk -F-- '{print $1}' <<< "${extension}" | awk '{$1=$1};1')
        extension_identifier=$(awk -F-- '{print $2}' <<< "${extension}" | awk '{$1=$1};1')
        message_normal "Installing ${extension_name}..."
        if code --install-extension "${extension_identifier}" \
            >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed Visual Studio Code extensions!"
}

# Install Python linters
function vscode_install_python_linters() {
    message_normal "Installing Python linters..."
    for linter in "${python_linters[@]}"; do
        if ! pip install "${linter}" >/dev/null 2>&1; then
            print_cross
            newline
            print_error_and_exit
        fi
    done
    print_tick
}

# Create a symlink for the Visual Studio Code settings file
function vscode_symlink_settings() {
    message_normal "Symlinking the Visual Studio Code settings file..."
    ln -f -s "${VSCODE_DOTFILES_SETTINGS_DIR}"/settings.json "${VSCODE_SETTINGS_DIR}"/settings.json
    print_tick
}

# Create a symlink for the Visual Studio Code keybindings file
function vscode_symlink_keybindings() {
    message_normal "Symlinking the Visual Studio Code keybindings file..."
    ln -f -s "${VSCODE_DOTFILES_SETTINGS_DIR}"/keybindings.json \
        "${VSCODE_SETTINGS_DIR}"/keybindings.json
    print_tick
}

# Main function to kick-off setting up Visual Studio Code
function setup_vscode() {
    vscode_install_extensions
    newline
    message_info "Setting up Visual Studio Code..."
    vscode_install_python_linters
    vscode_symlink_settings
    vscode_symlink_keybindings
    message_success "Successfully set up Visual Studio Code!"
}
