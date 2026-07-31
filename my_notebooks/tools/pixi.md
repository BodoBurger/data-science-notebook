---
title: Pixi 
description: uv is a Python package and project manager.
date: 2026-07-28
tags:
  - python
keywords:
  - environments
  - package management
  - project management
---

## Overview

[Pixi](https://pixi.prefix.dev) is a modern Python package management tool, replacing / improving on `conda` and `mamba`.

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

## Setup

### Global environments

```bash
pixi global install \ 
    --environment data-science \ 
    --expose ds-python=python \
    pandas polars geopandas statsmodels \
    scikit-learn lightgbm xgboost catboost \
    matplotlib seaborn plotly streamlit \
    pydantic openpyxl fastexcel ipykernel ipywidgets tqdm
```


### Jupyter Lab

Detailed instructions how to setup a global JupyterLab installation: https://github.com/BodoBurger/pixi-jupyter/blob/main/README.md


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

# add package from PyPI instead of conda-forge:
pixi add --pypi geopy 

# add local editable package as pypi dependency:
pixi add --pypi "project @ file:///absolute/path/to/project" --editable

# add package from github as pypi dependency:
pixi add --git https://github.com/username/my_package.git my_package --pypi
```

### Update workspace environment

```bash
pixi update --dry-run # preview

pixi update
```

### `pixi.lock`

Commit and track `pixi.lock` if you want reproduce the exact environment.

Rebuild environment from lockfile:

```bash
pixi clean # removes workspace environment under .pixi
pixi install --locked # recreates environment from lockfile
```


## Resources

- [Pixi documentation](https://pixi.prefix.dev/)
  - [uv vs. Pixi](https://pixi.prefix.dev/latest/switching_from/uv/#quick-look-at-the-differences)
- [Insightful blog post: Python package managers: uv vs pixi?](https://jacobtomlinson.dev/posts/2025/python-package-managers-uv-vs-pixi/)
