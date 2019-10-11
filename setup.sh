#!/usr/bin/env bash

# setup.sh
# This is the main script that will perform the macOS provisioning process

# Source all scripts
source apps.sh
source dotfiles.sh
source fish.sh
source fonts.sh
source gpg.sh
source homebrew.sh
source iterm.sh
source macos.sh
source ssh.sh
source utils.sh
source vscode.sh

# Main function to kick-off setting up the entire macOS provisioning process
function main() {
    # Clear the screen
    clear

    # Acquire administrator privileges before doing anything else
    acquire_admin_privileges

    # Prompt for 1Password credentials and save them to sign in later
    prompt_for_1password_credentials

    # Clear the screen
    clear

    newline
    message_info "Setting up and provisioning macOS..."
    message_info "Grab a cup of coffee and relax. This may take a while..."

    # Install Homebrew and tap into Homebrew taps
    homebrew_install_homebrew
    homebrew_tap_taps

    # Install command line tools and utilities and macOS applications via Homebrew and the Mac App Store
    apps_install_homebrew_formulae
    apps_install_homebrew_casks
    apps_install_mas_apps

    # Install additional fonts via Homebrew
    fonts_install_homebrew_fonts

    # Set up dotfiles
    setup_dotfiles

    # Re-source .bash_profile to update environment with the new .bash_profile from dotfiles
    source "${HOME}"/.bash_profile

    # Set up Visual Studio Code
    setup_vscode

    # Set up iTerm2
    setup_iterm

    # Set up fish shell
    setup_fish_shell

    # Sign in to 1Password using previously saved credentials
    signin_to_1password

    # Set up GPG
    setup_gpg

    # Set up SSH
    setup_ssh

    # Set macOS preferences
    set_macos_preferences

    # Clean Homebrew caches
    homebrew_cleanup

    newline
    message_success "Successfully finished setting up and provisioning macOS!"
    message_success "Please reboot macOS for all changes to take effect!"
    message_success "Enjoy!"
}

main "$@"
