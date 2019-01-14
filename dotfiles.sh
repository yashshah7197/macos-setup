#!/usr/bin/env bash

# dotfiles.sh
# This script contains functions for cloning the dotfiles repository and symlinking dotfiles

readonly DOTFILES_DIR=~/.dotfiles
readonly DOTFILES_REPO_URL="https://github.com/yashshah7197/dotfiles.git"

dotfiles=(
    '.bash_profile'
    '.gitconfig'
    '.gitignore'
    '.hushlogin'
)

function clone_dotfiles_repo() {
    newline
    message_info "Cloning the dotfiles repository..."
    if git clone $DOTFILES_REPO_URL $DOTFILES_DIR >/dev/null 2>&1; then
        message_success "Successfully cloned the dotfiles repository!"
    else
        message_failure "Failed to clone the dotfiles repository!"
    fi
}

function symlink_home_dotfiles() {
    newline
    message_info "Setting up symbolic links for dotfiles..."
    for dotfile in "${dotfiles[@]}"; do
        if [ -f ~/$dotfile ]; then
            rm -rf ~/$dotfile
        fi
        printf "${text_style_default}Symlinking $dotfile..."
        if ln -nfs $DOTFILES_DIR/$dotfile ~/$dotfile; then
            print_tick
        else
            print_cross
        fi
    done
}
