#!/usr/bin/env bash

# android_sdk.sh
# This script contains functions for setting up the Android SDK

# List of Android SDK packages to be installed
sdk_packages=(
    'Android SDK Tools -- 26.1.1 -- tools'
    'Android SDK Platform-Tools -- 28.0.1 -- platform-tools'
    'Android SDK Platform 28 -- 6 -- platforms;android-28'
    'Sources for Android 28 -- 1 -- sources;android-28'
    'Android 28 Google Play Intel x86 Atom System Image -- 8 -- system-images;android-28;google_apis_playstore;x86'
    'Android SDK Platform 27 -- 3 -- platforms;android-27'
    'Sources for Android 27 -- 1 -- sources;android-27'
    'Android SDK Build-Tools -- 28.0.3 -- build-tools;28.0.3'
    'GPU Debugging tools -- 3.1.0 -- extras;android;gapid;3'
    'Android Emulator -- 28.0.23 -- emulator'
    'Documentation for Android SDK -- 1 -- docs'
    'Google Play APK Expansion library -- 1 -- extras;google;market_apk_expansion'
    'Google Play Instant Development SDK -- 1.6.0 -- extras;google;instantapps'
    'Google Play Licensing Library -- 1 -- extras;google;market_licensing'
    'Google Play services -- 49 -- extras;google;google_play_services'
    'Google Web Driver -- 2 -- extras;google;webdriver'
    'Intel x86 Emulator Accelerator (HAXM installer) -- 7.3.2 -- extras;intel;Hardware_Accelerated_Execution_Manager'
    'ConstraintLayout for Android 1.0.2 -- 1 -- extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2'
    'Solver for ConstraintLayout 1.0.2 -- 1 -- extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2'
    'Android Support Repository -- 47.0.0 -- extras;android;m2repository'
    'Google Repository -- 58 -- extras;google;m2repository'
    'SDK Patch Applier v4 -- 1 -- patcher;v4'
)

# Accept all Android SDK licenses
function android_sdk_accept_licenses() {
    message_normal "Accepting licenses..."
    yes | "${ANDROID_SDK_ROOT}"/tools/bin/sdkmanager --licenses \
        >/dev/null 2>"${FILENAME_LOG_ERRORS}"
    print_tick
}

# Install Android SDK packages
function android_sdk_install_packages() {
    for package in "${sdk_packages[@]}"; do
        package_name=$(awk -F-- '{print $1}' <<< "${package}" | awk '{$1=$1};1')
        package_version=$(awk -F-- '{print $2}' <<< "${package}" | awk '{$1=$1};1')
        package_id=$(awk -F-- '{print $3}' <<< "${package}" | awk '{$1=$1};1')
        message_normal "Installing ${package_name} (v${package_version})..."
        if "${ANDROID_SDK_ROOT}"/tools/bin/sdkmanager --install "${package_id}" \
            >/dev/null 2>"${FILENAME_LOG_ERRORS}"; then
            print_tick
        else
            print_cross
            newline
            print_error_and_exit
        fi
    done
}

# Main function to kick-off setting up the Android SDK
function setup_android_sdk() {
    newline
    message_info "Setting up the Android SDK..."
    android_sdk_accept_licenses
    android_sdk_install_packages
    message_success "Successfully set up the Android SDK!"
}
