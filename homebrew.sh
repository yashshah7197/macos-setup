#!/usr/bin/env bash

# homebrew.sh
# This script contains functions for checking for and installing Homebrew,
# tapping into Homebrew taps and installing Homebrew formulae and casks

# List of Homebrew taps to be tapped
homebrew_taps=(
    'homebrew/cask-fonts'
    'homebrew/cask-versions'
    'homebrew/services'
)

# List of Homebrew formulae to be installed
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

# List of Homebrew casks to be installed
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

# List of fonts to be installed
homebrew_fonts=(
    'font-fira-code'
    'font-roboto'
)

# Check if Homebrew is installed
function is_homebrew_installed() {
    newline
    message_info "Checking for an existing installation of Homebrew..."
    if command -v brew >/dev/null 2>&1; then
        message_success "An existing installation of Homebrew was found on the system!"
        return 0
    else
        message_failure "No existing installation of Homebrew was found on the system!"
        return 1
    fi
}

function install_homebrew() {
    if ! is_homebrew_installed; then
        newline
        message_info "Installing Homebrew..."
        local HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
        if /usr/bin/ruby -e "$(curl -fsSL ${HOMEBREW_INSTALL_URL})" </dev/null >/dev/null 2>&1; then
            message_success "Successfully installed Homebrew!"
        else
            message_failure "Failed to install Homebrew!"
        fi
    fi
}

# Tap into Homebrew taps
function tap_homebrew_taps() {
    newline
    message_info "Tapping into Homebrew taps..."
    tap_count_success=0
    tap_count_failure=0
    for tap in "${homebrew_taps[@]}"; do
        printf "${text_style_default}Tapping into $tap..."
        if brew tap $tap >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++tap_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++tap_count_failure))
        fi
    done
    message_success "Successfully tapped into $tap_count_success taps!"
    if [ $tap_count_failure -ne 0 ]; then
        message_failure "Failed to tap into $tap_count_failure taps!"
    fi
}

# Install Homebrew formulae
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

# Install Homebrew casks
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

# Install fonts via Homebrew cask
function install_homebrew_fonts() {
    newline
    message_info "Installing fonts via Homebrew cask..."
    font_count_success=0
    font_count_failure=0
    for font in "${homebrew_fonts[@]}"; do
        printf "${text_style_default}Installing $font..."
        if brew cask install $font >/dev/null 2>&1; then
            printf "${text_style_bold}${text_color_green}✔${text_style_default}\n"
            ((++font_count_success))
        else
            printf "${text_style_bold}${text_color_red}✘${text_style_default}\n"
            ((++font_count_failure))
        fi
    done
    message_success "Successfully installed $font_count_success fonts via Homebrew cask!"
    if [ $font_count_failure -ne 0 ]; then
        message_failure "Failed to install $font_count_failure fonts via Homebrew cask!"
    fi
}
