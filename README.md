# laravel-setup-script
Scripts for setting up a Laravel Linux server. 

The core idea is to be able to quickly and reliably establish a baseline configuration for Laravel development on a freshly installed Linux server. The currently supported server installation is Debian 12 (bookworm).

No extra database will be installed. Laravel comes with a `sqlite` file preinstalled for use. Add a database package and associated PHP extension for other databases.

Several tools will be installed, some as prerequisites for packages such as PHP or Nginx, and others just because they are useful.

You may need to install and setup `sudo` first, along with any other user profile settings, such as SSH keys. 

There are other Laravel-supported options for development setup, such as [Herd](https://laravel.com/docs/11.x#local-installation-using-herd) (Win/Mac) or [Sail](https://laravel.com/docs/11.x#docker-installation-using-sail) (Docker). [Forge](https://forge.laravel.com/) can be used for the production environment. 

This script is not intended to be used in production. 

## Supported OS
- Debian 12

## Installation Overview
The script will install the following:

- Prereqs and tools: `git`, `lsb-release`, `ca-certificates`, `curl`, `gnupg2`, `debian-archive-ring`, `tmux`, `vim`, `wget`, `unzip`, `tree`, `net-tools`, `ufw`, `htop`, `rsync`, `jq`
- Latest (8.3) PHP using [sury.org](https://deb.sury.org/) sources
- PHP Extensions (some are preinstalled with core PHP, others are manual) - ctype, curl, dom, fileinfo, filter, hash, mbstring, openssl, pcre, pdo, session, tokenizer, xml, zip
- Composer from [getcomposer.org](https://getcomposer.org/download/)
- nginx using [nginx.org](https://nginx.org/en/linux_packages.html#Debian) sources
- 

