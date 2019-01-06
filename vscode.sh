#!/usr/bin/env bash

# vscode.sh
# This script contains functions for setting up and configurign VS Code

readonly VSCODE_SETTINGS_DIR=~/Library/Application\ Support/Code/User
readonly VSCODE_DOTFILES_SETTINGS_DIR=$DOTFILES_DIR/vscode

# List of VS Code extensions to be installed
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

function install_vscode_extensions() {
    message_info "Installing Visual Studio Code extensions..."
    extension_count_success=0
    extension_count_failure=0
    for extension in "${vscode_extensions[@]}"; do
        extension_name=$(awk -F-- '{print $1}' <<< $extension | awk '{$1=$1};1')
        extension_identifier=$(awk -F-- '{print $2}' <<< $extension | awk '{$1=$1};1')
        printf "${text_style_default}Installing $extension_name..."
        if code --install-extension $extension_identifier >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++extension_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++extension_count_failure))
        fi
    done
    message_success "Successfully installed $extension_count_success Visual Studio Code extensions!"
    if [ $extension_count_failure -ne 0 ]; then
        message_failure "Failed to install $extension_count_failure Visual Studio Code extensions!"
    fi
}

function symlink_vscode_settings() {
    if [ -f "$VSCODE_SETTINGS_DIR"/settings.json ]; then
        rm -rf "$VSCODE_SETTINGS_DIR"/settings.json
    fi
    newline
    message_info "Symlinking the Visual Studio Code settings file..."
    printf "${text_style_default}Symlinking settings.json..."
    if ln -nfs $VSCODE_DOTFILES_SETTINGS_DIR/settings.json "$VSCODE_SETTINGS_DIR"/settings.json; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function symlink_vscode_keybindings() {
    if [ -f "$VSCODE_SETTINGS_DIR"/keybindings.json ]; then
        rm -rf "$VSCODE_SETTINGS_DIR"/keybindings.json
    fi
    newline
    message_info "Symlinking the Visual Studio Code keybindings file..."
    printf "${text_style_default}Symlinking keybindings.json..."
    if ln -nfs $VSCODE_DOTFILES_SETTINGS_DIR/keybindings.json "$VSCODE_SETTINGS_DIR"/keybindings.json; then
        printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
    else
        printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
    fi
}

function setup_configure_vscode() {
    newline
    message_info "Setting up and configuring Visual Studio Code..."
    install_vscode_extensions
    symlink_vscode_settings
    symlink_vscode_keybindings
    newline
    message_success "Successfully set up and configured Visual Studio Code!"
}
