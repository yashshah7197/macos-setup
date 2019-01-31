#!/usr/bin/env bash

# dotfiles.sh
# This script contains functions for setting up dotfiles

# Constants for the dotfiles directory and the Git repository link
readonly DOTFILES_DIR="${HOME}"/.dotfiles
readonly DOTFILES_REPO_URL="https://github.com/yashshah7197/dotfiles.git"

# List of dotfiles to be symlinked
dotfiles=(
    '.bash_profile'
    '.gitconfig'
    '.gitignore'
    '.hushlogin'
)

# Clone the main dotfiles Git repository
function dotfiles_clone_repository() {
    rm -f -r "${DOTFILES_DIR}"
    message_normal "Cloning the dotfiles repository..."
    if git clone "${DOTFILES_REPO_URL}" "${DOTFILES_DIR}" \
        >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Create symlinks for all dotfiles in the list of dotfiles
function dotfiles_symlink_dotfiles() {
    message_normal "Symlinking dotfiles..."
    for dotfile in "${dotfiles[@]}"; do
        ln -f -s "${DOTFILES_DIR}"/"${dotfile}" "${HOME}"/"${dotfile}"
    done
    print_tick
}

# Main function to kick-off setting up dotfiles
function setup_dotfiles() {
    newline
    message_info "Setting up dotfiles..."
    dotfiles_clone_repository
    dotfiles_symlink_dotfiles
    message_success "Successfully set up dotfiles!"
}
