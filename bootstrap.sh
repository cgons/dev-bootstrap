#! /bin/bash

# bootstrap.sh
# ------------
# Developer Bootstrap Script - Installs the most common developer tools
# (see below for a list of installed packages and applications)


# Script Header
cat << EOF

Developer Bootstrap
=============================
$(date)

EOF


# Ensure user runs this script as root
if [ "$EUID" -ne 0 ]; then 
  echo -e "\nPlease run this script as root: sudo ./bootstrap.sh\n"
  exit
fi

# ---

TMPDIR=$(mktemp -d)

finish() {
  sudo rm -rf $TMPDIR
}
trap finish EXIT


# Functions
# -----------------------------------------------
check_exec_installed() {
  # Determines if an executable is installed
  # ---
  # Returns 0 when exec found, 1 otherwise.
  which $1 >& /dev/null
  return $?
}
# -----------------------------------------------


cat << "EOF"

The following packages and software will be installed:

  Support packages:
  ---------------------
  - curl
  - build-essential
  - apt-transport-https
  - gdebi
  - openresolv (for OpenVPN)
  - ca-certificates (for Docker)
  - software-properties-common (for Docker)

  Application Software:
  ---------------------
  - Git (will be updated if already installed)
  - Google Chrome
  - Atom Editor
  - Visual Studio Code
  - Slack (as a Snap package)
  - OpenVPN
  - Docker + Docker Compose
  
EOF


# Install mandatory packages
# ---
sudo apt install -y \
  curl \
  build-essential \
  apt-transport-https \
  gdebi \
  openresolv \
  ca-certificates \
  software-properties-common


# Install Source Repos. + Keys
# ---

# Git
sudo add-apt-repository -y --no-update ppa:git-core/ppa

# Google Chrome
if ! check_exec_installed "google-chrome"; then
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
fi

# Atom Editor
if ! check_exec_installed "atom"; then
  curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
fi

# ---


# Apt Update
# ---
printf "\n--Apt Updating--\n"
sudo apt update


# Install Packages
# ---

# Git
printf "\n--Installing Git--\n"
sudo apt install -y git

# Google Chrome
if check_exec_installed "google-chrome"; then
  printf "\n-- Google Chrome already installed. Skipping. --\n"
else
  printf "\n--Installing Google Chrome--\n"
  sudo apt install -y google-chrome-stable
fi

# Atom Editor
if check_exec_installed "atom"; then
  printf "\n-- Atom Editor already installed. Skipping. --\n"
else
  printf "\n--Installing Atom Editor--\n"
  sudo apt install -y atom
fi

# Visual Studio Code
if check_exec_installed "code"; then
  printf "\n-- Visual Studio Code already installed. Skipping. --\n"
else
  printf "\n--Installing Visual Studio Code--\n"
  wget -O $TMPDIR/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
  sudo gdebi -n $TMPDIR/vscode.deb
fi

# Slack
if check_exec_installed "slack"; then
    printf "\n-- Slack already installed. Skipping. --\n"
else
    printf "\n--Installing Visual Studio Code--\n"
    sudo snap install slack --classic
fi

# OpenVPN
if check_exec_installed "openvpn"; then
    printf "\n-- OpenVPN already installed. Skipping. --\n"
else
    printf "\n--Installing OpenVPN--\n"
    sudo apt install -y openvpn
fi

# Docker
if check_exec_installed "openvpn"; then
  printf "\n-- Docker already installed. Skipping. --\n"
else
  # remove old versions
  sudo apt-get remove docker docker-engine docker.io


fi


exit
