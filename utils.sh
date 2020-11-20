# utils.sh
# This script contains some common utility functions which are used by all other scripts

# Filenames for log files
readonly FILENAME_LOG_ERRORS="errors.log"

# Declare different text colors and styles
text_color_blue="\033[38;5;75m"
text_color_green="\033[32;1m"
text_color_red="\033[31;1m"
text_color_white="\033[37m"
text_style_bold="\033[1m"
text_style_default="\033[0m"

# Print a newline
function newline() {
    printf "\n"
}

# Print a normal message
function message_normal {
    printf "${text_style_default}%s" "$1"
}

# Print an information message
function message_info() {
    printf "${text_style_bold}${text_color_blue}==>${text_color_white} %s" "$1"
    newline
}

# Print a failure message
function message_failure() {
    printf "${text_style_bold}${text_color_red}✘${text_style_default}  %s" "$1"
    newline
}

# Print a success message
function message_success() {
    printf "${text_style_bold}${text_color_green}✔${text_style_default}  %s" "$1"
    newline
}

# Print a green tick mark (✔)
function print_tick() {
    printf "${text_style_bold}${text_color_green}%s${text_style_default}" "✔"
    newline
}

# Print a red cross mark (✘)
function print_cross() {
    printf "${text_style_bold}${text_color_red}%s${text_style_default}" "✘"
    newline
}

# Print a failure message and exit the script
function print_error_and_exit() {
    message_failure "The script failed to run to completion! Please try again!"
    exit 1
}

# Build a simple prompt for the user to enter the sudo password
function prompt_for_sudo_password() {
    read -r -s -p "$(echo -e ${text_style_default})Password: " password_sudo
    newline
}

# (Re)validate sudo using the password specified by the user
# This will also extend the sudo timeout for an additional 5 minutes
function validate_sudo_using_password() {
    sudo --stdin --validate <<< "${password_sudo}" >/dev/null 2>"${FILENAME_LOG_ERRORS}"
}

# Acquire sudo privileges for the current user
function acquire_sudo_privileges() {
    newline
    message_info "Attempting to acquire sudo privileges..."
    message_info "You may be required to enter your password..."
    # Keep prompting for the sudo password until authentication is successful
    until sudo --non-interactive true >/dev/null 2>"${FILENAME_LOG_ERRORS}"; do
        prompt_for_sudo_password
        validate_sudo_using_password
    done
    message_success "Successfully acquired sudo privileges!"
}

# Build prompts for the user to enter his/her 1Password account credentials
function prompt_for_1password_credentials() {
    newline
    message_info "Please enter the following credentials for your 1Password account..."
    read -r -p "$(echo -e ${text_style_default})1Password Sign-In Address: " \
        onepassword_signin_address
    read -r -p "$(echo -e ${text_style_default})1Password Email Address: " \
        onepassword_email_address
    read -r -s -p "$(echo -e ${text_style_default})1Password Secret Key: " onepassword_secret_key
    newline
    read -r -s -p "$(echo -e ${text_style_default})1Password Master Password: " \
        onepassword_master_password
    newline
}

# Sign in to 1Password using the user's 1Password account credentials
function signin_to_1password() {
    newline
    message_info "Attempting to sign in to 1Password..."
    if onepassword_token=$(echo "${onepassword_master_password}" | op signin \
        "${onepassword_signin_address}" "${onepassword_email_address}" "${onepassword_secret_key}" \
        --output=raw 2>"${FILENAME_LOG_ERRORS}"); then
        message_success "Successfully signed in to 1Password!"
    else
        message_failure "Failed to sign in to 1Password! Please check your credentials and try again!"
        newline
        print_error_and_exit
    fi
}

# Cleanup
function cleanup() {
    rm -f -r "${FILENAME_PUBLIC_KEYS}"
    rm -f -r "${FILENAME_SECRET_SUBKEYS}"
    rm -f -r "${FILENAME_OWNERTRUST}"
}

# Exit trap to run whenever the script exits
function trap_exit() {
    cleanup
}
trap trap_exit EXIT

# Trap to handle user interruption via CTRL-C cleanly
function trap_ctrl_c() {
    newline
    newline
    message_failure "The script execution was interrupted by the user!"
    print_error_and_exit
}
trap trap_ctrl_c SIGINT
