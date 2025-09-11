#!/bin/sh

# laravel-setup-script
# https://github.com/jimdiroffii/laravel-setup-script

# Set PHP version variable
PHP_VERSION=8.4
NODE_VERSION=22

# Check for root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please rerun this script as root or sudo"
    exit 1
fi

## Update, upgrade, install prereqs
echo "\e[47m\e[31mRunning update and upgrade...\e[0m"
apt-get update
apt-get -y upgrade

echo "\e[47m\e[31mInstalling prereqs and tools...\e[0m"
apt-get -y install git lsb-release ca-certificates curl gnupg2 debian-archive-keyring tmux vim wget unzip tree net-tools ufw htop rsync jq openssl

## Source the version codename (needed for debian-based varients, such as LMDE)
. /etc/os-release

if [ -n "$DEBIAN_CODENAME" ]; then
	debian_codename="$DEBIAN_CODENAME"
else
	debian_codename=$(lsb_release -sc)
fi

## Setup PHP Repo
echo "\e[47m\e[31mInstall PHP source repository...\e[0m"
curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
dpkg -i /tmp/debsuryorg-archive-keyring.deb
echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ ${debian_codename} main" > /etc/apt/sources.list.d/php.list
apt-get update

## Install PHP and Extensions
# FPM and CLI are installed first to remove Apache dependency
# Thanks https://askubuntu.com/users/583418/dan-delaney
# https://askubuntu.com/a/1357414
echo "\e[47m\e[31mInstalling PHP $PHP_VERSION FPM and CLI...\e[0m"
apt-get -y install php$PHP_VERSION-fpm php$PHP_VERSION-cli
echo "\e[47m\e[31mInstalling PHP $PHP_VERSION...\e[0m"
apt-get -y install php$PHP_VERSION
echo "\e[47m\e[31mInstalling PHP $PHP_VERSION Extensions...\e[0m"
apt-get -y install php$PHP_VERSION-cgi php$PHP_VERSION-common php$PHP_VERSION-curl php$PHP_VERSION-mbstring php$PHP_VERSION-sqlite3 php$PHP_VERSION-xml php$PHP_VERSION-zip

## Setup Composer v2.8.8
echo "\e[47m\e[31mInstalling composer...\e[0m"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Composer installer verified'; } else { echo 'Composer installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
php -r "unlink('composer-setup.php');"

## Setup Composer keys
echo "\e[47m\e[31mInstalling composer keys...\e[0m"
# Determine the non-root username
if [ "$SUDO_USER" ]; then
    USERNAME="$SUDO_USER"
else
    # Fallback to using logname if SUDO_USER is not set
    USERNAME=$(logname 2>/dev/null)
fi

# Create composer key directory
USER_HOME=$(eval echo "~$USERNAME")
KEY_DIR="$USER_HOME/.config/composer"
mkdir -p "$KEY_DIR"

# Download the Dev / Snapshot Public Key
curl -sS https://composer.github.io/snapshots.pub -o "$KEY_DIR/keys.dev.pub"

# Download the Tags Public Key
curl -sS https://composer.github.io/releases.pub -o "$KEY_DIR/keys.tags.pub"

chown -R "$USERNAME":"$USERNAME" "$KEY_DIR"

## Install nvm, node, npm as user
echo "\e[47m\e[31mInstalling nvm, node and npm...\e[0m"
sudo -u $USERNAME bash <<EOF
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && . "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install $NODE_VERSION

node -v
npm -v
EOF
