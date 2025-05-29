# My notebooks

A collection of Jupyter notebooks.

Website version: https://bodoburger.github.io/notebooks/


## Setup

### Tools

- MyST: https://mystmd.org


### Mamba environment

Create an environment to build the book locally:

```bash
mamba create -n myst mystmd
```

### Create empty project

```bash
git clone https://github.com/jupyter-book/mystmd-quickstart.git
cd mystmd-quickstart

myst init
```

https://mystmd.org/guide/quickstart


### Start dev server

```bash
myst start
```


### Github Pages

Activate Github Pages under the repo settings. Set the source for build and deployment to `GitHub Actions`.


## MyST configuration

### Prevent execution of notebooks

At the moment, execution of notebooks is disabled by default.

See https://mystmd.org/guide/execute-notebooks.
