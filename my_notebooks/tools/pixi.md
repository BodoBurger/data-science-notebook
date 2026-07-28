---
# Core page metadata
title: Pixi 
description: uv is a Python package and project manager.
date: 2026-07-28"
tags:
  - python
keywords:
  - environments
  - package management
  - project management
---

## Overview

[uv](https://docs.astral.sh/uv/) is a modern Python package management tool, replacing / improving on `conda` and `mamba`.

## Installation, Update and Uninstall

Follow the instructions on: https://pixi.prefix.dev/latest/installation/

The installation script will add Pixi to the path.

### Update

```bash
pixi self-update
```
### Uninstall

```bash
pixi clean cache

# remove environments from pixi workspaces
cd path/to_workspace
pixi clean

# remove pixi executable
rm -r ~/.pixi

# remove pixi binary from `PATH`
...
```

## Workspaces

Workspaces enable reproducible environments inside a folder (e.g. root of a Git repository).

```bash
# Create workspace inside existing folder:
pixi init

# Create workspace in a new folder
pixi init my_new_project
```

### Adding dependencies

```bash
pixi add polars pytest

pixi add --pypi geopy # add package from PyPI instead of conda-forge
```

## Environments

...

## Working with Jupyter Lab

...

## Resources

- [Pixi documentation](https://pixi.prefix.dev/)
- [Insightful blog post: Python package managers: uv vs pixi?](https://jacobtomlinson.dev/posts/2025/python-package-managers-uv-vs-pixi/)
