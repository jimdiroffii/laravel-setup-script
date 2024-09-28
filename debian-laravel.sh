#!/bin/sh

# laravel-setup-script
# https://github.com/jimdiroffii/laravel-setup-script

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

## Setup PHP Repo
echo "\e[47m\e[31mInstall PHP source repository...\e[0m"
curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
dpkg -i /tmp/debsuryorg-archive-keyring.deb
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update

## Install PHP and Extensions
# FPM and CLI are installed first to remove Apache dependency
# Thanks https://askubuntu.com/users/583418/dan-delaney
# https://askubuntu.com/a/1357414
echo "\e[47m\e[31mInstalling PHP 8.3 FPM and CLI...\e[0m"
apt-get -y install php8.3-fpm php8.3-cli
echo "\e[47m\e[31mInstalling PHP 8.3...\e[0m"
apt-get -y install php8.3
echo "\e[47m\e[31mInstalling PHP 8.3 Extensions...\e[0m"
apt-get -y install php8.3-cli php8.3-common php8.3-curl php8.3-mbstring php8.3-sqlite3 php8.3-xml php8.3-zip

## Setup Composer
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

## Install nvm, node and npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 22

## Verify Instllations
echo "\e[47m\e[31mNode Version Verifications...\e[0m"
node -v
npm -v