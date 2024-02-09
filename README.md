poetryenv
=========

poetryenv - it is simple bash script that allow you easily install different 
versions of poetry separately and use them in project that requre different 
version of poetry. 


Requirements:

- pyenv

Usage:

```bash
curl -sSL https://raw.githubusercontent.com/aleksey925/poetryenv/master/poetryenv.sh | bash -s -- python=3.11.2 poetry=1.7.1
```

After executing this command, you need to find in output string like this:

```
Poetry version 1.7.1 has been installed.
To begin using it, add the following line to your shell configuration file:
export PATH="/Users/alex/.poetryenv/1.7.1":$PATH
```

Copy command from output and add it to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc) 
or `.envrc` file in your project if you use `direnv`.