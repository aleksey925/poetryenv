poetryenv
=========

poetryenv - it is simple bash script that allow you easily install different
versions of poetry separately and use them in project that requre different
version of poetry.

> This script is inspired by [pyenv](https://github.com/pyenv/pyenv)

Requirements:

- pyenv
- direnv (recommended)


## Installation

You can install this script using the following command:

```bash
curl -sSL https://raw.githubusercontent.com/aleksey925/poetryenv/master/src/poetryenv.sh -o ~/poetryenv && bash ~/poetryenv self-install
```

Аfter successful installation you will see the following line in the console: `poetryenv has been installed`.

## Usage

This script is recommended for use with `direnv` to automatically switch between
different versions of Poetry. In this case, you just need to create a `.envrc` file in
your project, add the command from the output of the `install` command there, and run `direnv allow`.

For example, you can install Poetry 1.7.1 with the following command:

```bash
poetryenv install --python 3.11.2 --poetry 1.7.1
```

To apply it to the current project, use:

```bash
poetryenv local --poetry 1.7.1
```

Executing this command will generate a `.envrc` file in the current directory,
containing a command to switch to the specified version of Poetry.

Alternatively, you can modify your PATH environment variable in `~/.bashrc` or
`~/.zshrc` to use one version of Poetry globally.


## Development

### Setup environment

1. Install `pyenv` and `direnv`
2. Copy `.envrc.example` to `.envrc` and run `direnv allow`
3. Install pre-commit `make pre-commit-install`
