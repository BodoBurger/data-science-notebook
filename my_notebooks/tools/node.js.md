---
title: node.js
---

- `Node.js` / node is the actual JavaScript runtime. It executes JavaScript outside the browser.
- `npm` is the package manager that normally comes bundled with Node.js. It installs JavaScript packages and runs project scripts.
- `nvm` is a separate version manager for Node.js. It lets you install and switch between multiple Node versions.


>    nvm
>        └── manages Node.js versions
>            └── each Node.js installation includes npm
>                └── npm manages project packages


## Install & Update

Follow instructions on: https://nodejs.org/en/download

### Installed Node versions and the active/default version

```bash
nvm ls

# Globally installed npm packages for the active Node version
npm list -g --depth=0

# Dependencies installed in the current project
npm list --depth=0

# Check what has updates available
npm outdated -g
npm outdated
```

Global npm packages are separate for each NVM-managed Node version.

### Update Node while staying on LTS

This installs the newest LTS version and carries over your global packages:

```bash
nvm install --reinstall-packages-from=current 'lts/*'
nvm alias default 'lts/*'
nvm use 'lts/*'

# Verify afterward:
node --version
npm --version
nvm current
```

If you also want the newest npm version compatible with your active Node:

```bash
nvm install-latest-npm
```

npm itself doesn’t have an “LTS” channel; Node does.

### Update npm packages

```bash
# Global packages:
npm outdated -g
npm update -g

# Inside an individual project:
npm outdated
npm update
```

npm update respects the version ranges in that project’s package.json.
Major-version upgrades generally require an explicit install or a tool such as npm-check-updates.

### Update NVM itself

https://github.com/nvm-sh/nvm#install--update-script
