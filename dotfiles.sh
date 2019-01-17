#!/usr/bin/env bash

# dotfiles.sh
# This script contains functions for setting up dotfiles

# Constants for the dotfiles directory and the Git repository link
readonly DOTFILES_DIR=~/.dotfiles
readonly DOTFILES_REPO_URL="https://github.com/yashshah7197/dotfiles.git"

# List of dotfiles to be symlinked
dotfiles=(
    '.bash_profile'
    '.gitconfig'
    '.gitignore'
    '.hushlogin'
)

# Clone the main dotfiles Git repository
function clone_repository() {
    if [[ -d "${DOTFILES_DIR}" ]]; then
        rm -rf "${DOTFILES_DIR}"
    fi
    printf "${text_style_default}Cloning the dotfiles repository..."
    if git clone "${DOTFILES_REPO_URL}" "${DOTFILES_DIR}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Create symlinks for all dotfiles in the list of dotfiles
function symlink_dotfiles() {
    printf "${text_style_default}Symlinking dotfiles..."
    for dotfile in "${dotfiles[@]}"; do
        if [[ -f ~/"${dotfile}" ]]; then
            rm -rf ~/"${dotfile}"
        fi
        if ! ln -nfs "${DOTFILES_DIR}"/"${dotfile}" ~/"${dotfile}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_cross
            newline
            print_error_and_exit
        fi
    done
    print_tick
}

# Main function to kick-off setting up dotfiles
function setup_dotfiles() {
    newline
    message_info "Setting up dotfiles..."
    clone_repository
    symlink_dotfiles
    message_success "Successfully set up dotfiles!"
}
