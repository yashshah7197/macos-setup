#!/usr/bin/env bash

# vscode.sh
# This script contains functions for setting up Visual Studio Code

# Constants for the main and the corresponding dotfiles Visual Studio Code settings directories
readonly VSCODE_SETTINGS_DIR=~/Library/Application\ Support/Code/User
readonly VSCODE_DOTFILES_SETTINGS_DIR="${DOTFILES_DIR}"/vscode

# List of Visual Studio Code extensions to be installed
vscode_extensions=(
    'Auto Close Tag -- formulahendry.auto-close-tag'
    'Auto Rename Tag -- formulahendry.auto-rename-tag'
    'autoDocstring -- njpwerner.autodocstring'
    'Bracket Pair Colorizer 2 -- coenraads.bracket-pair-colorizer-2'
    'Code Runner -- formulahendry.code-runner'
    'Fish VS Code -- skyapps.fish-vscode'
    'Flutter -- dart-code.flutter'
    'GitLens -- eamodio.gitlens'
    'Markdown All In One -- yzhang.markdown-all-in-one'
    'Partial Diff -- ryu1kn.partial-diff'
    'Paste and Indent -- rubymaniac.vscode-paste-and-indent'
    'Path Intellisense -- christian-kohler.path-intellisense'
    'Project Manager -- alefragnani.project-manager'
    'Python -- ms-python.python'
    'REST Client -- humao.rest-client'
    'Sort Lines -- tyriar.sort-lines'
    'TODO Highlight -- wayou.vscode-todo-highlight'
    'Visual Studio IntelliCode -- visualstudioexptteam.vscodeintellicode'
    'VS Code Icons -- robertohuertasm.vscode-icons'
)

# Install Visual Studio Code extensions
function install_extensions() {
    newline
    message_info "Installing Visual Studio Code extensions..."
    for extension in "${vscode_extensions[@]}"; do
        extension_name=$(awk -F-- '{print $1}' <<< "${extension}" | awk '{$1=$1};1')
        extension_identifier=$(awk -F-- '{print $2}' <<< "${extension}" | awk '{$1=$1};1')
        message_normal "Installing ${extension_name}..."
        if code --install-extension "${extension_identifier}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed Visual Studio Code extensions!"
}

# Create a symlink for the Visual Studio Code settings file
function symlink_settings() {
    message_normal "Symlinking the Visual Studio Code settings file..."
    ln -nfs "${VSCODE_DOTFILES_SETTINGS_DIR}"/settings.json "${VSCODE_SETTINGS_DIR}"/settings.json
    print_tick
}

# Create a symlink for the Visual Studio Code keybindings file
function symlink_keybindings() {
    message_normal "Symlinking the Visual Studio Code keybindings file..."
    ln -nfs "${VSCODE_DOTFILES_SETTINGS_DIR}"/keybindings.json "${VSCODE_SETTINGS_DIR}"/keybindings.json
    print_tick
}

# Main function to kick-off setting up Visual Studio Code
function setup_vscode() {
    newline
    message_info "Setting up Visual Studio Code..."
    symlink_settings
    symlink_keybindings
    message_success "Successfully set up Visual Studio Code!"
    install_extensions
}
