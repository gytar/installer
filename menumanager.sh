#!/usr/bin/env bash

# ---------------------------------------
# Functions

function getsource() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

  echo $DIR
}

# prints the menu
function menu() {
  read -p "
1) Install package
2) Update
3) first setup
4) Exit

What will you do ? : " input
  echo $input
}

# handle user choice
function menuHandler() {
  source $manager_path
  case $1 in
    1)
      install
      ;;
    2)
      update
      ;;
    3)
      install_stuff_on_first_boot
      ;;
    4)
      echo "Bye"
      exit 1
      ;;
  esac
}

# ---------------------------------------
# Variables

directory="$(getsource)/"
conf_file="package_system.conf"
package_manager=$(cat $directory$conf_file  | awk -e '$1 ~ /^PACKAGE_MANAGER/ {print $0}' | cut -d= -f2)
manager_path=""
manager_file=""

# ---------------------------------------
# Program

if [[ $package_manager = "apt" ]]; then
  echo "--------------------"
  echo " Hello debian user!"
  echo "--------------------"
  manager_file="aptmanager.sh"
elif [[ $package_manager = "dnf" ]]; then
  echo "--------------------"
  echo " Hello fedora user!"
  echo "--------------------"
  manager_file="dnfmanager.sh"
fi

manager_path="$directory$manager_file"

while [[ true ]]; do
  choice=$(menu)
  menuHandler $choice
done
