#!/bin/bash
POETRYENV_HOME_PATH=~/.poetryenv
POETRYENV_SCRIPT_PATH="/usr/local/bin/poetryenv"

POETRY_HOME=~/"Library/Application Support/pypoetry"
POETRY_CACHE_DIR=~/"Library/Caches/pypoetry"


print_help() {
    echo "Usage: poetryenv COMMAND"
    echo
    echo "Commands:"
    echo "  install --python 3.11.2 --poetry 1.7.1   Install specific versions of Poetry"
    echo "  uninstall --poetry 1.7.1                 Uninstall specific versions of Poetry"
    echo "  versions                                 List all installed versions of Poetry"
    echo "  self-install                             Install poetryenv"
    echo "  self-uninstall                           Uninstall poetryenv"
    echo "  self-purge                               Uninstall poetryenv and remove all Poetry files"
    echo
}

function install_poetry() {
    local python_ver="$1"
    local poetry_ver="$2"

    if ! command -v pyenv &> /dev/null; then
        echo "pyenv is not installed. You need to install it https://github.com/pyenv/pyenv."
        exit 1
    fi

    if [ -z "$python_ver" ] || [ -z "$poetry_ver" ]; then
        echo "Error: You must specify python and poetry versions."
        echo
        print_help
        exit 1
    fi

    # validate python version format
    for version in $python_ver $poetry_ver; do
        if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Error: Version of python and poetry must be in the format X.Y.Z"
            exit 1
        fi
    done

    if [ -d "$POETRYENV_HOME_PATH/$poetry_ver" ]; then
        echo "Poetry version $poetry_ver is already installed."
        exit 0
    fi

    if ! pyenv versions --bare | grep -q "^${python_ver}$"; then
        pyenv install "$python_ver"
    fi

    poetry_path=$POETRYENV_HOME_PATH/$poetry_ver
    mkdir -p "$poetry_path"
    cd "$poetry_path" || exit 1

    # install poetry in a virtual environment
    pyenv local "$python_ver"
    python -m venv .
    # shellcheck disable=SC1091
    source bin/activate
    pip install poetry=="$poetry_ver"
    deactivate

    cat << EOF > "$poetry_path/poetry"
#!/bin/bash
export POETRY_CONFIG_DIR="$POETRY_HOME/${poetry_ver}"
export POETRY_HOME="/$POETRY_HOME/${poetry_ver}"
export POETRY_DATA_DIR="$POETRY_HOME/${poetry_ver}"
export POETRY_CACHE_DIR="$POETRY_CACHE_DIR/${poetry_ver}"
"$poetry_path/bin/poetry" "\$@"
EOF
    chmod +x "$poetry_path/poetry"

    echo
    echo "Poetry version $poetry_ver has been installed."
    echo "To begin using it, add the following line to your shell configuration file:"
    echo "export PATH=\"${poetry_path//${HOME}/\$HOME}:\$PATH\""
}

function uninstall_poetry() {
    local poetry_ver="$1"

    if [ -z "$poetry_ver" ]; then
        echo "Error: You must specify poetry versions."
        print_help
        exit 1
    fi

    # validate poetry version format
    if [[ ! $poetry_ver =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version of python and poetry must be in the format X.Y.Z"
        exit 1
    fi

    rm -rf "${POETRYENV_HOME_PATH:?}/$poetry_ver"
    rm -rf "${POETRY_HOME:?}/$poetry_ver"
    rm -rf "${POETRY_CACHE_DIR:?}/$poetry_ver"

    echo "Poetry version $poetry_ver has been uninstalled."
}

function print_versions() {
    if [[ ! -d "$POETRYENV_HOME_PATH" || -z "$(ls -A "$POETRYENV_HOME_PATH")" ]]; then
        return
    fi
    for filename in "$POETRYENV_HOME_PATH"/*; do
        version=$(basename "$filename")
        poetry_path="$POETRYENV_HOME_PATH/$version"
        echo "${version} - export PATH=\"${poetry_path//${HOME}/\$HOME}:\$PATH\""
    done
}

function self_install() {
    script_path=$(readlink -f "$0")
    mv "$script_path" "$POETRYENV_SCRIPT_PATH"
    chmod +x "$POETRYENV_SCRIPT_PATH"
    mkdir -p "$POETRYENV_HOME_PATH"
    echo "poetryenv has been installed."
}

function self_uninstall() {
    rm -rf "$POETRYENV_HOME_PATH"
    rm $POETRYENV_SCRIPT_PATH
    echo "poetryenv has been uninstalled."
}

function self_purge() {
    self_uninstall
    rm -rf "$POETRY_HOME"
    rm -rf "$POETRY_CACHE_DIR"
    rm -rf ~/Library/Preferences/pypoetry
    echo "All Poetry files have been removed."
}

# if the script is launched without arguments or with the -h/--help switch, display help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_help
    exit 0
fi

# extract command and command arguments
COMMAND=""
while (( "$#" )); do
  case "$1" in
    install)
      COMMAND="install"
      shift
      ;;
    uninstall)
      COMMAND="uninstall"
      shift
      ;;
    versions)
      COMMAND="versions"
      shift
      ;;
    self-install)
      COMMAND="self-install"
      shift
      ;;
    self-uninstall)
      COMMAND="self-uninstall"
      shift
      ;;
    self-purge)
      COMMAND="self-purge"
      shift
      ;;
    --python)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        PYTHON_VERSION="$2"
        shift 2
      else
        echo "Error: Value for --python is missing" >&2
        exit 1
      fi
      ;;
    --poetry)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        POETRY_VERSION="$2"
        shift 2
      else
        echo "Error: Value for --poetry is missing" >&2
        exit 1
      fi
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    *) # preserve positional arguments
      break
      ;;
  esac
done

if [ -z "$COMMAND" ]; then
    echo "Error: No command provided"
    print_help
    exit 1
fi

if [ "$COMMAND" = "install" ]; then
    install_poetry "$PYTHON_VERSION" "$POETRY_VERSION"
    exit 1
fi

if [ "$COMMAND" = "uninstall" ]; then
    uninstall_poetry "$POETRY_VERSION"
    exit 1
fi

if [ "$COMMAND" = "versions" ]; then
    print_versions
    exit 1
fi

if [ "$COMMAND" = "self-install" ]; then
    self_install
    exit 1
fi

if [ "$COMMAND" = "self-uninstall" ]; then
    self_uninstall
    exit 1
fi

if [ "$COMMAND" = "self-purge" ]; then
    self_purge
    exit 1
fi
