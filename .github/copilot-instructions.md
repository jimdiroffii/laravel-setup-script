# Copilot Instructions for AI Agents

## Project Overview
- This repository provides a shell script (`debian-laravel.sh`) to automate the setup of a Laravel development environment on Debian 12 or LMDE (Linux Mint Debian Edition).
- The script is intended for **development environments only**—not for production use.
- No database server is installed by default; Laravel's built-in `sqlite` is used unless the user installs another database and PHP extension.

## Key Files
- `debian-laravel.sh`: Main automation script. Handles all package installations, PHP setup, Composer, and Node.js environment.
- `README.md`: Contains usage instructions, supported OS, and post-installation steps.

## Setup Workflow
1. **Run as root or with sudo**: The script must be executed with root privileges.
2. **System Update**: Performs `apt-get update` and `upgrade`.
3. **Installs prerequisites**: Installs tools like `git`, `curl`, `vim`, `tmux`, `ufw`, etc.
4. **PHP 8.4 Setup**: Adds sury.org repo, installs PHP 8.4 (FPM, CLI, extensions).
5. **Composer**: Installs Composer globally and sets up Composer public keys in the user's config directory.
6. **Node.js**: Installs `nvm`, Node.js 22, and npm for the non-root user.

## Project-Specific Conventions
- **User Detection**: The script determines the non-root user for Composer and Node.js setup using `$SUDO_USER` or `logname`.
- **Composer Keys**: Always installs Composer keys to `~/.config/composer/` for the detected user.
- **No Database by Default**: Only `sqlite` is ready-to-use. For MySQL/Postgres, users must install the DB and PHP extension themselves.
- **No Apache/NGINX**: Only PHP FPM/CLI is installed; web server setup is out of scope.

## Post-Install Steps
- Run `php -v` and `composer diagnose` to verify setup.
- To create a new Laravel app: `composer create-project laravel/laravel <appname>`
- To serve: `php artisan serve --host=0.0.0.0 &` (backgrounds the server)
- To stop: Use `ps -ef | grep server.php` to find the PID, then `kill <PID>`

## Integration Points
- **External Repos**: Uses sury.org for PHP, getcomposer.org for Composer, and nvm for Node.js.
- **No Docker/VM**: Script is for direct host installation, not containerized environments.

## Examples
- To run the script: `sudo ./debian-laravel.sh`
- To install a Laravel app: `composer create-project laravel/laravel test_example`
- To serve: `php artisan serve --host=0.0.0.0 &`

## Important Notes
- Do not use this script for production servers.
- SSH keys and `sudo` may need to be set up manually before running the script.
- For alternative setups, see Laravel's [Herd](https://laravel.com/docs/11.x#local-installation-using-herd), [Sail](https://laravel.com/docs/11.x#docker-installation-using-sail), or [Forge](https://forge.laravel.com/).
