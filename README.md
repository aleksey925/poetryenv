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

Аfter successful installation you will see the following line in the console: `poetryenv has been installed.`.

## Usage

This script is recommended for use with `direnv` to automatically switch between
different versions of Poetry. In this case, you just need to create a `.envrc` file in
your project, add the command from the output of the `install` command there, and run `direnv allow`.

For example, you can install Poetry 1.7.1 with the following command:
`poetryenv install --python 3.11.2 --poetry 1.7.1`.
At the end of the output, you will see a command that you need to add to the `.envrc`
file. Here is an example of the last lines of the output:

```
Poetry version 1.7.1 has been installed.
To begin using it, add the following line to your shell configuration file:
export PATH="$HOME/.poetryenv/1.7.1:$PATH"
```

Here is an example of a `.envrc` file:

```bash
export PATH="$HOME/.poetryenv/1.7.1:$PATH"
```

Alternatively, you can modify your PATH environment variable in ~/.bashrc or ~/.zshrc to use one version of Poetry globally.
