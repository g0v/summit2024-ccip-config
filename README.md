# g0v Summit 2024 CCIP server config

<!-- MarkdownTOC -->

- [How to](#how-to)
  - [Preinstall on local](#preinstall-on-local)
  - [Preinstall on the CCIP server](#preinstall-on-the-ccip-server)
  - [Initial setup on local](#initial-setup-on-local)
- [Change data, files or configs.](#change-data-files-or-configs)
  - [For CCIP configs](#for-ccip-configs)
  - [For Caddyfile](#for-caddyfile)
- [Architecture](#architecture)
  - [Server](#server)
- [User management](#user-management)

<!-- /MarkdownTOC -->

## How to

### Preinstall on local

- Make sure to install `make`, `rsync`

### Preinstall on the CCIP server

- Make sure to install `make`, `rsync`, `caddy-server`

### Initial setup on local

- Duplicate the `.env.sample` file as `.env` file.
- Change the `RSYNC_TARGET` in the `.env` to the server IP, host name, or alias name that available for `rsync` or `ssh` CLI.

## Change data, files or configs.

### For CCIP configs

- Execute on the local:  
  `make sync`
- Shell login to the server
- cd to the directory  
  `cd /opass/CCIP-Server`
- Execute the command:  
  `make go`

### For Caddyfile

- Execute on the local:  
  `make sync`
- Shell login to the server
- cd to the directory  
  `cd /opass/CCIP-Server/app`
- Execute the command:  
  `make caddy`

## Architecture

### Server

- A debian distro VM on GCP.
- A caddy web server in the VM as the reverse proxy.
- Run CCIP-Server with `docker`  
  <https://github.com/CCIP-App/CCIP-Server>

## User management

- New user added via GCP VM settings with ssh key generated via the following command:  
  `ssh-keygen -t rsa -f user_name -C user_name -b 2048`
- New user should be added to opass group via the following command on the server:  
  `usermod -a -G opass user_name`
