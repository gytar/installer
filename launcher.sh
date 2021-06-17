#!/usr/bin/env bash

# Laucher of the app, get the os system, and which package manager it has.

# TODOS
# install themes (icons, shell...)
#   - check if it is gnome or kde
#     - if gnome, fetch things with wget and tar the packages into /usr/theme (I think)
#
#  

# ---------------------------------------
# Functions
# ---------------------------------------

# list_include_item : checks if the os is in a list
# $1: the list
# $2: the variable
function list_include_item {
  local list="$1"
  local item="$2"
  if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
    # yes, list include item
    result=0
  else
    result=1
  fi
  return $result
}

# getsource: get the directory in which the program is
function getsource() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

  echo "$DIR"
}

# ---------------------------------------
# Variables
# ---------------------------------------

aptlist="debian ubuntu pop_os mint"
dnflist="fedora redhat"
directory="$(getsource)/"
menu="menumanager.sh"
apt_file="aptmanager.sh"
dnf_file="dnfmanager.sh"
npm_file="npmmanager.sh"
snap_file="snapmanager.sh"

# ---------------------------------------
# Program
# ---------------------------------------

# checks if file /etc/os-release exists
if [ -e /etc/os-release ]; then
  OS_NAME=$(cat < /etc/os-release | awk -e '$1 ~ /^ID/ {print $0}' | cut -d= -f2)
fi


if list_include_item "$aptlist" "$OS_NAME"; then
  echo "PACKAGE_MANAGER=apt" > package_system.conf
  chmod a+x "$directory"$apt_file
elif list_include_item "$dnflist" "$OS_NAME"; then
  echo "PACKAGE_MANAGER=dnf" > package_system.conf
  chmod a+x "$directory"$dnf_file
elif [[ $OS_NAME = "manjaro" ]]; then
  echo "diy"
fi

chmod a+x "$directory"$menu
chmod a+x "$directory"$npm_file
chmod a+x "$directory"$snap_file

"$directory"$menu
