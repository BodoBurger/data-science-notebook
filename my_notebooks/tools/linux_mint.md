# Linux Mint


## Installation

If you want to mount the *home* folder to a separate partition, select *Something else* during installation. Configure the following partitions:

- EFI (around 1 GB)
- EXT4 mounted to *"/"* (> 100 GB)
- EXT4 mounted to *"home"*


## After installation

- Go through steps of welcome screen (update manager, firewall settings).


## Apps

### Apt

- git

### Flatpak

- DBeaver
- Gimp
- KeePassXC

### Debian package

- VS Code: `sudo dpkg -i ./<file>.deb
    - The .deb package prompts to install the apt repository and signing key, which enables auto-update through the system package manager.

### Applets

- Bing Wallpaper

### Node

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Restart terminal
nvm install --lts
``

### Codex
```bash
npm install -g @openai/codex
```



