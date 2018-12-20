#!/usr/bin/env bash

# setup.sh
# This is the main script that will perform the macOS provisioning process

# Declare different text colors and styles
text_color_blue=$(tput setaf 4)
text_color_green=$(tput setaf 2)
text_color_red=$(tput setaf 1)
text_color_white=$(tput setaf 7)
text_style_bold=$(tput bold)
text_style_default=$(tput sgr0)

function newline() {
    printf "\n"
}

function message_info() {
    printf "${text_style_bold}${text_color_blue}==>${text_color_white} %s" "$1"
    newline
}

function message_failure() {
    printf "${text_style_bold}${text_color_red}✘${text_style_default}  %s" "$1"
    newline
}

function message_success() {
    printf "${text_style_bold}${text_color_green}✔${text_style_default}  %s" "$1"
    newline
}
