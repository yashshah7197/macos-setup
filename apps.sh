#!/usr/bin/env bash

# apps.sh
# This script contains functions to install command line tools and utilities
# and macOS applications via Homebrew and the Mac App Store

# List of command line tools and utilities to be installed via Homebrew
homebrew_formulae=(
    'awscli'
    'bash'
    'calc'
    'cmatrix'
    'cowsay'
    'curl --with-libssh2 --with-nghttp2'
    'diff-so-fancy'
    'dockutil'
    'exa'
    'figlet'
    'fish'
    'fortune'
    'gcc'
    'git'
    'gnupg'
    'go'
    'htop'
    'imagemagick --with-libheif'
    'shyiko/ktlint/ktlint'
    'links'
    'mas'
    'mysql'
    'neofetch'
    'nmap'
    'node'
    'openssh'
    'openssl'
    'php'
    'pv'
    'python'
    'python@2'
    'rsync'
    'ruby'
    'sl'
    'speedtest-cli'
    'sqlite'
    'ssh-copy-id'
    'telnet'
    'tmux'
    'trash'
    'tree'
    'unrar'
    'vim'
    'wget'
    'yarn'
    'zopfli'
)

# List of macOS applications to be installed via Homebrew cask
homebrew_casks=(
    'java'
    'android-studio'
    'epubquicklook'
    'google-cloud-sdk'
    'iterm2'
    'miniconda'
    'qlcolorcode'
    'qlmarkdown'
    'qlstephen'
    'qlvideo'
    'quicklook-csv'
    'quicklook-json'
    'visual-studio-code'
    'vlc'
    'webpquicklook'
)

# Install command line tools and utilities via Homebrew
function install_homebrew_formulae() {
    newline
    message_info "Installing command line tools and utilities via Homebrew..."
    formula_count_success=0
    formula_count_failure=0
    for formula in "${homebrew_formulae[@]}"; do
        printf "${text_style_default}Installing $formula..."
        if brew install $formula >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++formula_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++formula_count_failure))
        fi
    done
    message_success "Successfully installed $formula_count_success command line tools and utilities via Homebrew!"
    if [ $formula_count_failure -ne 0 ]; then
        message_failure "Failed to install $formula_count_failure command line tools and utilities via Homebrew!"
    fi
}

# Install macOS applications via Homebrew cask
function install_homebrew_casks() {
    newline
    message_info "Installing applications via Homebrew cask..."
    cask_count_success=0
    cask_count_failure=0
    for cask in "${homebrew_casks[@]}"; do
        authenticate_admin_using_password
        printf "${text_style_default}Installing $cask..."
        if brew cask install $cask >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++cask_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++cask_count_failure))
        fi
    done
    message_success "Successfully installed $cask_count_success applications via Homebrew cask!"
    if [ $cask_count_failure -ne 0 ]; then
        message_failure "Failed to install $cask_count_failure applications via Homebrew cask!"
    fi
}