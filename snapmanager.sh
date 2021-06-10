#!/usr/bin/env bash

# ---------------------------------------
# Functions to install snap based programs
# ---------------------------------------

function install_discord() {
  sudo snap install discord
  echo "---------------------------"
  echo "Discord installed with SNAP"
  echo "---------------------------"

}

function install_intellij() {
  sudo snap install intellij-idea-ultimate --classic
}

function install_kotlin() {
  sudo snap install --classic kotlin
}
bold=$(tput bold)
normal=$(tput sgr0)
function install_flutter() {
  sudo snap install flutter --classic
  flutter sdk-path
  echo "Don't forget to use ${bold}flutter doctor${normal}!"
}
