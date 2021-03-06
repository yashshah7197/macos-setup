# apps.sh
# This script contains functions for installing command line tools and utilities and macOS
# applications via Homebrew and the Mac App Store

# List of command line tools and utilities to be installed via Homebrew
homebrew_formulae=(
    'bash'
    'curl'
    'diff-so-fancy'
    'dockutil'
    'exa'
    'fish'
    'git'
    'gnupg'
    'go'
    'httpie'
    'mas'
    'neofetch'
    'openssh'
    'python'
    'vim'
    'zsh'
)

# List of macOS applications to be installed via Homebrew Cask
homebrew_casks=(
    '1password-cli'
    'corretto8'
    'docker'
    'goland'
    'google-chrome'
    'iterm2'
    'miniconda'
    'visual-studio-code'
    'vlc'
)

# List of macOS applications to be installed via the Mac App Store
mas_apps=(
    '1Password - 1333542190'
    'Todoist - 585829637'
    'Wipr - 1320666476'
)

# Install command line tools and utilities via Homebrew
function apps_install_homebrew_formulae() {
    newline
    message_info "Installing command line tools and utilities via Homebrew..."
    for formula in "${homebrew_formulae[@]}"; do
        message_normal "Installing ${formula}..."
        if brew install "${formula}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed command line tools and utilities via Homebrew!"
}

# Install macOS applications via Homebrew Cask
function apps_install_homebrew_casks() {
    newline
    message_info "Installing applications via Homebrew Cask..."
    for cask in "${homebrew_casks[@]}"; do
        validate_sudo_using_password
        message_normal "Installing ${cask}..."
        if brew cask install "${cask}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed applications via Homebrew Cask!"
}

# Install macOS applications via the Mac App Store
function apps_install_mas_apps() {
    newline
    message_info "Installing applications via the Mac App Store..."
    for app in "${mas_apps[@]}"; do
        app_name=$(awk -F- '{print $1}' <<< "${app}" | awk '{$1=$1};1')
        app_id=$(awk -F- '{print $2}' <<< "${app}" | awk '{$1=$1};1')
        message_normal "Installing ${app_name}..."
        if mas install "${app_id}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
    message_success "Successfully installed applications via the Mac App Store!"
}
