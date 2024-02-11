#!/bin/bash
POETRYENV_PATH=~/.poetryenv

print_help() {
    echo "Usage: poetryenv COMMAND"
    echo
    echo "Commands:"
    echo "  install --python PYTHON_VERSION --poetry POETRY_VERSION   Install specific versions of Poetry"
    echo
}

function install_poetry() {
    local python_ver="$1"
    local poetry_ver="$2"

    if [ -z "$python_ver" ] || [ -z "$poetry_ver" ]; then
        echo "Error: You must specify python and poetry versions."
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

    if [ -d "$POETRYENV_PATH/$poetry_ver" ]; then
        echo "Poetry version $poetry_ver is already installed."
        exit 0
    fi

    if ! pyenv versions --bare | grep -q "^${python_ver}$"; then
        pyenv install "$python_ver"
    fi

    poetry_path=$POETRYENV_PATH/$poetry_ver
    mkdir -p "$poetry_path"
    cd "$poetry_path" || exit 1

    # install poetry in a virtual environment
    pyenv local "$python_ver"
    python -m venv .
    source bin/activate
    pip install poetry=="$poetry_ver"
    deactivate

    cat << EOF > "$poetry_path/poetry"
#!/bin/bash
POETRY_CONFIG_DIR="~/Library/Application Support/pypoetry/${poetry_ver}"
POETRY_HOME="~/Library/Application Support/pypoetry/${poetry_ver}"
POETRY_DATA_DIR="~/Library/Application Support/pypoetry/${poetry_ver}"
export POETRY_CACHE_DIR=~/Library/Caches/pypoetry/${poetry_ver}
"$poetry_path/bin/poetry" "\$@"
EOF
    chmod +x "$poetry_path/poetry"

    echo
    echo "Poetry version $poetry_ver has been installed."
    echo "To begin using it, add the following line to your shell configuration file:"
    echo 'export PATH="'"$poetry_path"'":$PATH'
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
    --python)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PYTHON_VERSION="$2"
        shift 2
      else
        echo "Error: Value for --python is missing" >&2
        exit 1
      fi
      ;;
    --poetry)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
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
    -*|--*=) # unsupported flags
      echo "Error: Unsupported parameter $1" >&2
      exit 1
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
