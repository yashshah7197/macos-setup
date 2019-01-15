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

# List of macOS applications to be installed via the Mac App Store
mas_apps=(
    '1Password - 1333542190'
    'Agenda - 1287445660'
    'Blackmagic Disk Speed Test - 425264550'
    'Keynote - 409183694'
    'Slack - 803453959'
    'Spark - 1176895641'
    'WhatsApp - 1147396723'
    'Wipr - 1320666476'
    'Xcode - 497799835'
)

# Install command line tools and utilities via Homebrew
function install_homebrew_formulae() {
    newline
    message_info "Installing command line tools and utilities via Homebrew..."
    for formula in "${homebrew_formulae[@]}"; do
        printf "${text_style_default}Installing ${formula}..."
        if brew install ${formula} >/dev/null 2>&1; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed command line tools and utilities via Homebrew!"
}

# Install macOS applications via Homebrew cask
function install_homebrew_casks() {
    newline
    message_info "Installing applications via Homebrew cask..."
    for cask in "${homebrew_casks[@]}"; do
        authenticate_admin_using_password
        printf "${text_style_default}Installing ${cask}..."
        if brew cask install "${cask}" >/dev/null 2>&1; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed applications via Homebrew cask!"
}

# Install macOS applications via the Mac App Store
function install_mas_apps() {
    newline
    message_info "Installing applications via the Mac App Store..."
    for app in "${mas_apps[@]}"; do
        app_name=$(awk -F- '{print $1}' <<< "${app}" | awk '{$1=$1};1')
        app_id=$(awk -F- '{print $2}' <<< "${app}" | awk '{$1=$1};1')
        printf "${text_style_default}Installing ${app_name}..."
        if mas install "${app_id}" >/dev/null 2>&1; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed applications via the Mac App Store!"
}
