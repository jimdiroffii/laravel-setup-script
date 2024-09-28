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
Run the script as `root` or with `sudo`. 

If you run the script logged in as `root`, you'll need to update the Composer keys to your user's home folder or by running `composer self-update --update-keys` as your user.

The script will install the following:

- Prereqs and tools: `git`, `lsb-release`, `ca-certificates`, `curl`, `gnupg2`, `debian-archive-keyring`, `tmux`, `vim`, `wget`, `unzip`, `tree`, `net-tools`, `ufw`, `htop`, `rsync`, `jq`
- Latest (8.3) PHP using [sury.org](https://deb.sury.org/) sources
- PHP Extensions (some are preinstalled with core PHP, others are manual) - ctype, curl, dom, fileinfo, filter, hash, mbstring, openssl, pcre, pdo, session, tokenizer, xml, zip
- Composer from [getcomposer.org](https://getcomposer.org/download/)
- Composer public keys into `~/.config/composer/`
- nvm, nodejs and npm

## Post Install
Run `php -v`.
Run `composer diagnose` to check for any issues.

Install or clone a laravel app. 

To install a fresh app: 

```bash
composer create-project laravel/laravel test_example
```

Change into the `test_example` directory, then test it by running server in the background:

```bash
php artisan serve --host=0.0.0.0 &
[1] 29097
```

The output from `artisan serve` prints a PID that can be used to kill the server. If you miss it or forget it, check using `ps`. Kill the 2nd PID listed.

```bash
ps -ef | grep server.php
```

Output:
```bash
user    29099   29097  2 19:29 pts/0    00:00:00 /usr/bin/php8.3 -S 0.0.0.0:8000 /srv/test/test_example/vendor/laravel/framework/src/Illuminate/Foundation/Console/../resources/server.php
user    29101     972  0 19:29 pts/0    00:00:00 grep --color=auto server.php
```

Kill:
```bash
kill 29097
```
