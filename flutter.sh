#!/usr/bin/env bash

# flutter.sh
# This script contains functions for setting up the Flutter SDK

# Flutter SDK download url
readonly FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.0.0-stable.zip"

# Constants for the Flutter SDK directories and file names
readonly DIRECTORY_FLUTTER="${HOME}"/Library/Flutter
readonly DIRECTORY_FLUTTER_SDK="${DIRECTORY_FLUTTER}"/sdk
readonly FILENAME_FLUTTER_SDK="flutter.zip"

# List of tools to be downloaded for the iOS toolchain
ios_tools=(
    'usbmuxd --HEAD'
    'libimobiledevice --HEAD'
    'ideviceinstaller'
    'ios-deploy'
    'cocoapods'
)

# Create the Flutter SDK directory
function flutter_create_dir() {
    message_normal "Creating directory for the Flutter SDK..."
    mkdir -p "${DIRECTORY_FLUTTER}"
    print_tick
}

# Download the Flutter SDK
function flutter_download_sdk() {
    message_normal "Downloading the Flutter SDK..."
    if curl "${FLUTTER_SDK_URL}" --output "${DIRECTORY_FLUTTER}"/"${FILENAME_FLUTTER_SDK}" \
        --silent 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Extract the Flutter SDK
function flutter_extract_sdk() {
    message_normal "Extracting the Flutter SDK..."
    if unzip "${DIRECTORY_FLUTTER}"/"${FILENAME_FLUTTER_SDK}" -d "${DIRECTORY_FLUTTER}" >/dev/null \
        && mv "${DIRECTORY_FLUTTER}"/flutter "${DIRECTORY_FLUTTER_SDK}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Configure Xcode for the Flutter SDK
function flutter_configure_xcode() {
    message_normal "Configuring Xcode..."
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    print_tick
}

# Install required iOS toolchain tools for the Flutter SDK
function flutter_install_ios_toolchain_tools() {
    message_normal "Installing iOS toolchain tools..."
    for tool in "${ios_tools[@]}"; do
        if ! brew install ${tool} >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_cross
            newline
            print_error_and_exit
        fi
    done
    print_tick
}

# Set up CocoaPods
function flutter_setup_cocoapods() {
    message_normal "Setting up CocoaPods..."
    if pod setup >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
        print_tick
    else
        print_cross
        newline
        print_error_and_exit
    fi
}

# Main function to kick-off setting up the Flutter SDK
function setup_flutter() {
    authenticate_admin_using_password
    newline
    message_info "Setting up the Flutter SDK..."
    flutter_create_dir
    flutter_download_sdk
    flutter_extract_sdk
    flutter_configure_xcode
    flutter_install_ios_toolchain_tools
    flutter_setup_cocoapods
    message_success "Successfully set up the Flutter SDK!"
}
