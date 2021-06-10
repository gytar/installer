#!/usr/bin/env bash


# ---------------------------------------
# Functions to install sofwares and
# programs on debian-based machines
# ---------------------------------------

# TODO: finish to code all functions (search for some programs
# you didn't think of)

# ---------------------------------------
# GENEREIC FUNCTIONS
# ---------------------------------------
function sure() {
  while [[ true ]]; do
    read -p "$1 [y/n] " input
    if [[ $input =~  ^[yn] ]]; then
      break
    fi
  done
  # might be a bash-ier / simplier way to do so (newbie to bash talking here)
  if [[ $input =~ ^[y] ]]; then
    echo "yes"
   else
    echo "no"
   fi
}

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

# update action
function update() {
  if [[ choice -eq 2 ]]; then
    sudo apt update
    imsure=$(sure "Do you want to upgrade?")
    if [[ $(sure) == "yes" ]]; then
      sudo apt upgrade
      echo "upgrade accomplished!"
    fi
  fi
}
# install action
function install() {
  echo "Installation function in progess"
  read -p "enter package to install: " package
  exists=$(apt-cache search --names-only "^$package")

  if [[ -n $exists ]]; then
    really_exists=$(apt-cache search --names-only "^$package$")
    if [[ -n $really_exists ]]; then
      echo "$package exists and is gonna be installed"
      sudo apt update
      sudo apt install $package
    else
      echo "$exists"
      read -p "pick up the one you want: " package
      sudo apt update
      sudo apt install $package
    fi
    echo "$package installed!"
  else
    echo "this package doesn't exist"
  fi
}

# ---------------------------------------
# Functions for first boot installation
# ---------------------------------------

function install_code() {
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt install apt-transport-https
  sudo apt update
  sudo apt install -y code
}

function install_brave() {
  sudo apt install apt-transport-https curl
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install -y brave-browser
}
function install_lolcat() {
  sudo apt install ruby
  wget https://github.com/busyloop/lolcat/archive/master.zip
  unzip master.zip
  cd lolcat-master/bin
  gem install lolcat
  rm master.zip
}

function install_atom() {
  wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  sudo apt update
  sudo apt install -y atom
}

function install_console_pack() {
  sudo apt install vim
  sudo apt install neovim # use nvim if doesn't work
  sudo apt install htop
  sudo apt install ranger
  sudo apt install cmake
  sudo apt install neofetch
  install_lolcat
  sudo apt install sl
  sudo apt install cowsay
  sudo apt install libnotify-bin # works on debian, not sure about ubuntu based distros
  sudo apt install exa
  echo "I'm all done!"
}
function install_steam() {
  sudo add-apt-repository multiverse
  sudo apt update
  sudo apt install steam
}
function install_stuff_on_first_boot() {
  directory="$(getsource)/"
  snap_file="snapmanager.sh"
  npm_file="npmmanager.sh"
  # ----------------------------------------------------
  # system installations

  # Console utilitaries pack
  imsure=$(sure "Do you want to install Console pack (vim, htop...)?")
  if [[ $imsure = "yes" ]]; then
    install_console_pack
  fi
  # VS Code
  imsure=$(sure "Do you want to install VSCode?")
  if [[ $imsure = "yes" ]]; then
    install_code
  fi
  # Atom
  imsure=$(sure "Do you want to install Atom?")
  if [[ $imsure = "yes" ]]; then
    install_atom
  fi
  # Okular
  imsure=$(sure "Do you want to install Okular?")
  if [[ $imsure = "yes" ]]; then
    sudo apt install -y okular
  fi
  # VLC
  imsure=$(sure "Do you want to install VLC?")
  if [[ $imsure = "yes" ]]; then
    sudo apt install -y vlc
  fi
  imsure=$(sure "Do you want to install Steam?")
  if [[ $imsure = "yes" ]]; then
    install_steam
  fi

  # ----------------------------------------------------
  # Web Browsers
  # Chrome
  imsure=$(sure "Do you want to install Google Chrome?")
  if [[ $imsure = "yes" ]]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
  fi
  # Brave
  imsure=$(sure "Do you want to install Brave?")
  if [[ $imsure = "yes" ]]; then
    install_brave
  fi
  # Firefox is generally installed, and wdgaf about the rest

  # -----------------------------------------------------
  # Snap installations
  source $directory$snap_file
  imsure=$(sure "Do you want to install Discord?")
  if [[ $imsure = "yes" ]]; then
    install_discord
  fi
  imsure=$(sure "Do you want to install Intellij?")
  if [[ $imsure = "yes" ]]; then
    install_intellij
  fi
  imsure=$(sure "Do you want to install Kotlin?")
  if [[ $imsure = "yes" ]]; then
    install_kotlin
  fi
  imsure=$(sure "Do you want to install Flutter?")
  if [[ $imsure = "yes" ]]; then
    install_flutter
  fi

  # -----------------------------------------------------
  # Node JS
  source $directory$npm_file
  imsurenodeJS=$(sure "Do you want to install Node JS?")

  if [[ $imsurenodeJS = "yes" ]]; then
    sudo apt update
    # sure works on debian, not sure about ubuntu based distro...
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
    sudo apt install -y nodejs

    # a few npm dependencies
    imsure=$(sure "Do you want to install Angular?")
    if [[ $imsure = "yes" ]]; then
      angular
    fi
    imsure=$(sure "Do you want to install Vue JS?")
    if [[ $imsure = "yes" ]]; then
      vue
    fi
  fi
}
