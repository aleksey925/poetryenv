![license](https://img.shields.io/github/license/aleksey925/poetryenv?style=for-the-badge) [![lint status](https://img.shields.io/github/actions/workflow/status/aleksey925/poetryenv/test.yml?branch=master&style=for-the-badge)](https://github.com/aleksey925/poetryenv/actions/workflows/test.yml)

poetryenv
=========

> This script is no longer maintained. Consider using [mise](https://github.com/jdx/mise) instead, which provides similar functionality.

poetryenv - it is simple bash script that allow you easily install different
versions of poetry separately and use them in project that requre different
version of poetry.

> This script is inspired by [pyenv](https://github.com/pyenv/pyenv)

Requirements:

- pyenv
- direnv


## Installation

You can install this script using the following command:

```bash
curl -sSL https://raw.githubusercontent.com/aleksey925/poetryenv/master/src/poetryenv.sh -o ~/poetryenv && bash ~/poetryenv self-install
```

After successful installation you will see the following line in the console: `poetryenv has been installed`.

## Usage

This script is designed to be used in conjunction with `direnv`. It automatically
applies commands from the `.envrc` file when you enter the folder, and automatically
unloads these commands when you exit.

For example, you can install Poetry 1.7.1 with the following command:

```bash
poetryenv install --python 3.11.2 --poetry 1.7.1
```

To apply it to the current project, use:

```bash
poetryenv local 1.7.1
```

Executing this command will generate a `.envrc` file in the current directory.

Alternatively, you can modify your PATH environment variable in `~/.bashrc` or
`~/.zshrc` to use one version of Poetry globally.


## Development

### Setup environment

1. Install `pyenv` and `direnv`
2. Copy `.envrc.example` to `.envrc` and run `direnv allow`
3. Install pre-commit `make pre-commit-install`
