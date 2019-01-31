#!/usr/bin/env bash

# fish.sh
# This script contains functions for setting up fish shell

# Constants for the main and corresponding dotfiles fish shell configuration directories
readonly FISH_CONFIG_DIR="${HOME}"/.config/fish
readonly FISH_DOTFILES_CONFIG_DIR="${DOTFILES_DIR}"/.config/fish

# List of hidden fish shell functions to be symlinked
fish_hidden_functions=(
    '......fish'
    '.....fish'
    '....fish'
    '...fish'
)

# Create the required fish shell configuration directories
function fish_create_config_dirs() {
    message_normal "Creating the required fish shell configuration directories..."
    mkdir -p "${FISH_CONFIG_DIR}"/functions
    print_tick
}

# Add fish shell to the list of valid login shells
function fish_add_to_login_shells() {
    message_normal "Adding fish shell to the list of valid login shells..."
    if echo /usr/local/bin/fish | sudo tee -a /etc/shells \
        >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Change the default and login shell of the user to fish shell
function fish_make_default_login_shell() {
    message_normal "Changing the default and login shell to fish shell..."
    if sudo chsh -s /usr/local/bin/fish "$(whoami)" 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Create a symlink for the fish shell configuration file
function fish_symlink_config() {
    message_normal "Symlinking the fish shell configuration file..."
    ln -f -s "${FISH_DOTFILES_CONFIG_DIR}"/config.fish "${FISH_CONFIG_DIR}"/config.fish
    print_tick
}

# Create symlinks for all fish shell functions
function fish_symlink_functions() {
    message_normal "Symlinking fish shell functions..."
    for file in "${FISH_DOTFILES_CONFIG_DIR}"/functions/*.fish; do
        ln -f -s "${FISH_DOTFILES_CONFIG_DIR}"/functions/"${file##*/}" \
            "${FISH_CONFIG_DIR}"/functions/"${file##*/}"
    done

    # The above for loop doesn't catch hidden files in functions directory
    # Hence we have to list all hidden files separately and then symlink them
    # TODO: Find a way to symlink all functions using a single loop
    for hidden_function in "${fish_hidden_functions[@]}"; do
        ln -f -s "${FISH_DOTFILES_CONFIG_DIR}"/functions/"${hidden_function}" \
            "${FISH_CONFIG_DIR}"/functions/"${hidden_function}"
    done
    print_tick
}

# Change the default colors of fish shell
function fish_change_default_colors() {
    message_normal "Changing the default fish shell colors..."
    fish fish_colors.fish
    print_tick
}

# Main function to kick-off setting up fish shell
function setup_fish_shell() {
    newline
    message_info "Setting up fish shell..."
    fish_create_config_dirs
    fish_add_to_login_shells
    fish_make_default_login_shell
    fish_symlink_config
    fish_symlink_functions
    fish_change_default_colors
    message_success "Successfully set up fish shell!"
}
