# laravel-setup-script

Scripts for setting up a Laravel 12 on a Debian-based server.

The core idea is to be able to quickly and reliably establish a baseline configuration for Laravel development on a freshly installed Linux server. It has also been used to upgrade or fix a Laravel installation.

No extra database will be installed. Laravel comes with a `sqlite` file preinstalled for use. Add a database package and associated PHP extension for other databases.

Several tools will be installed, some as prerequisites for packages such as PHP, and others just because they are useful.

You may need to install and setup `sudo` first, along with any other user profile settings, such as SSH keys.

There are other Laravel-supported options for development setup, such as [Herd](https://laravel.com/docs/12.x#local-installation-using-herd) (Win/Mac) or [Sail](https://laravel.com/docs/12.x#docker-installation-using-sail) (Docker). [Forge](https://forge.laravel.com/) can be used for the production environment.

This script is not intended to be used in production.

## Supported OS

- Debian 12 Bookworm
- Debian 13 Trixie
- Linux Mint Debian Edition (LMDE Faye)

## Installation Overview

Run the script as `root` or with `sudo`.

If you run the script logged in as `root`, you'll need to update the Composer keys to your user's home folder or by running `composer self-update --update-keys` as your user. When running with `sudo`, the keys are updated into your user's home folder.

The script will perform the following:

- Update and upgrade using `apt-get`
- Install prereqs and tools: `git`, `lsb-release`, `ca-certificates`, `curl`, `gnupg2`, `debian-archive-keyring`, `tmux`, `vim`, `wget`, `unzip`, `tree`, `net-tools`, `ufw`, `htop`, `rsync`, `jq`
- Install latest (8.5) PHP using [sury.org](https://deb.sury.org/) sources
- Install PHP extensions (some are preinstalled with core PHP, others are manual) - ctype, curl, dom, fileinfo, filter, hash, mbstring, openssl, pcre, pdo, session, tokenizer, xml, zip
- Install Composer from [getcomposer.org](https://getcomposer.org/download/)
- Copy Composer public keys into `~/.config/composer/`
- Install nvm, Node.js 24 and npm

The script will NOT install Laravel. Ensure all dependencies and prerequisites are met before performing the Laravel installation with Composer.

## Post Install

- Run `php -v` to verify PHP version.
- Run `composer diagnose` to check for any issues.
- Run `composer global require laravel/installer` to install the Laravel installer.
- Run `laravel new example-app` to install a new Laravel application.
- Change to new app directory. 
- If Laravel installer did not prompt, or you skipped it, run `npm install && npm run build`.
- Run `composer run dev` to start the app.
