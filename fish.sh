#!/usr/bin/env bash

# fish.sh
# This script contains functions for setting up and configuring fish shell

readonly FISH_CONFIG_DIR=~/.config/fish
readonly FISH_DOTFILES_CONFIG_DIR=$DOTFILES_DIR/.config/fish

fish_hidden_functions=(
    '......fish'
    '.....fish'
    '....fish'
    '...fish'
)

function create_config_dirs() {
    printf "${text_style_default}Creating required configuration directories..."
    if mkdir -p $FISH_CONFIG_DIR/functions >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function add_fish_to_shells() {
    printf "${text_style_default}Adding fish shell to /etc/shells..."
    if echo /usr/local/bin/fish | sudo tee -a /etc/shells >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function change_default_shell_to_fish() {
    printf "${text_style_default}Changing the default shell to fish shell..."
    if sudo chsh -s /usr/local/bin/fish $(whoami) >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function change_fish_colors() {
    printf "${text_style_default}Changing the default fish shell colors..."
    if fish fish_colors.fish >/dev/null 2>&1; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function symlink_fish_config() {
    if [ -f $FISH_CONFIG_DIR/config.fish ]; then
        rm -rf $FISH_CONFIG_DIR/config.fish
    fi
    printf "${text_style_default}Symlinking the fish shell configuration file..."
    if ln -nfs $FISH_DOTFILES_CONFIG_DIR/config.fish $FISH_CONFIG_DIR/config.fish; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

function symlink_fish_functions() {
    printf "${text_style_default}Symlinking fish shell functions..."
    for file in $FISH_DOTFILES_CONFIG_DIR/functions/*.fish; do
        if [ -f $FISH_CONFIG_DIR/functions/${file##*/} ]; then
            rm -rf $FISH_CONFIG_DIR/functions/${file##*/}
        fi
        ln -nfs $FISH_DOTFILES_CONFIG_DIR/functions/${file##*/} $FISH_CONFIG_DIR/functions/${file##*/}
    done

    # The above for loop doesn't catch hidden files in functions directory
    # Hence we have to list all hidden files separately and then symllink them
    # TODO: Find a way to symlink all functions using a single loop
    for hidden_function in "${fish_hidden_functions[@]}"; do
        if [ -f $FISH_CONFIG_DIR/functions/$hidden_function ]; then
            rm -rf $FISH_CONFIG_DIR/functions/$hidden_function
        fi
        ln -nfs $FISH_DOTFILES_CONFIG_DIR/functions/$hidden_function $FISH_CONFIG_DIR/functions/$hidden_function
    done
    print_tick
}

function setup_configure_fish_shell() {
    newline
    message_info "Setting up and configuring fish shell..."
    create_config_dirs
    add_fish_to_shells
    change_default_shell_to_fish
    symlink_fish_config
    symlink_fish_functions
    change_fish_colors
    message_success "Successfully set up and configured fish shell!"
}
