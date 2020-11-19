# fish.sh
# This script contains functions for setting up fish shell

# Constants for the main and corresponding dotfiles fish shell configuration directories
readonly FISH_CONFIG_DIR="${HOME}"/.config/fish
readonly FISH_DOTFILES_CONFIG_DIR="${DOTFILES_DIR}"/fish/.config/fish

# Hidden fish shell function to be symlinked
fish_hidden_function="...fish"

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

    ln -f -s "${FISH_DOTFILES_CONFIG_DIR}"/functions/"${fish_hidden_function}" \
        "${FISH_CONFIG_DIR}"/functions/"${fish_hidden_function}"

    print_tick
}

# Set up custom color palette for fish shell
function fish_setup_color_palette() {
    message_normal "Setting up custom color palette for fish shell..."
    if ! fish fish_colors.fish >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_cross
        newline
        print_error_and_exit
    fi
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
    fish_setup_color_palette
    message_success "Successfully set up fish shell!"
}
