#!/bin/sh

# laravel-setup-script
# https://github.com/jimdiroffii/laravel-setup-script

# Check for root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please rerun this script as root or sudo"
    exit 1
fi

## Update, upgrade, install prereqs
echo "Running update and upgrade..."
apt-get update
apt-get -y upgrade

echo "Installing prereqs and tools..."
apt-get -y install git lsb-release ca-certificates curl gnupg2 debian-archive-ring tmux vim wget unzip tree net-tools ufw htop rsync jq openssl

## Setup PHP Repo
echo "Install PHP source repository..."
curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
dpkg -i /tmp/debsuryorg-archive-keyring.deb
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update

## Install PHP and Extensions
echo "Installing PHP 8.3..."
apt-get -y install php8.3
echo "Installing PHP 8.3 Extensions..."
apt-get -y install php8.3-cli php8.3-common php8.3-curl php8.3-mbstring php8.3-sqlite3 php8.3-xml php8.3-zip

## Setup Composer
echo "Installing composer..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Composer installer verified'; } else { echo 'Composer installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
php -r "unlink('composer-setup.php');"

echo "Running composer diagnostic (verify there are no errors)..."
composer diagnose
read -p "Press Enter to continue..."
