#!/bin/bash
POETRYENV_PATH=~/.poetryenv

print_help() {
    echo "Usage: $0 [OPTIONS] python=PYTHON_VERSION poetry=POETRY_VERSION"
    echo "Install specific versions of Python and Poetry in a virtual environment."
    echo
    echo "Options:"
    echo "  -h, --help    Show help information."
    echo
    echo "Arguments:"
    echo "  python=PYTHON_VERSION    The version of Python that will be used."
    echo "  poetry=POETRY_VERSION    The version of Poetry to install."
}

# if the script is launched without arguments or with the -h/--help switch, display help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_help
    exit 0
fi

# extract command line arguments
for arg in "$@"; do
    case $arg in
        python=*)
            PYTHON_VERSION="${arg#*=}"
            shift
            ;;
        poetry=*)
            POETRY_VERSION="${arg#*=}"
            shift
            ;;
        *)
            echo "Invalid argument: $arg"
            print_help
            exit 1
            ;;
    esac
done

# python version and Poetry version must be specified
if [ -z "$PYTHON_VERSION" ] || [ -z "$POETRY_VERSION" ]; then
    echo "Error: You must specify both python and poetry versions."
    print_help
    exit 1
fi

# validate python version format
for version in $PYTHON_VERSION $POETRY_VERSION; do
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version of python and poetry must be in the format X.Y.Z"
        exit 1
    fi
done

if [ -d "$POETRYENV_PATH/$POETRY_VERSION" ]; then
    echo "Poetry version $POETRY_VERSION is already installed."
    exit 0
fi

if ! pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
    pyenv install "$PYTHON_VERSION"
fi

POETRY_PATH=$POETRYENV_PATH/$POETRY_VERSION
mkdir -p "$POETRY_PATH"
cd "$POETRY_PATH" || exit 1

# install poetry in a virtual environment
pyenv local "$PYTHON_VERSION"
python -m venv .
source bin/activate
pip install poetry=="$POETRY_VERSION"
deactivate

ln -s "$POETRY_PATH"/bin/poetry "$POETRY_PATH"/poetry

echo
echo "Poetry version $POETRY_VERSION has been installed."
echo "To begin using it, add the following line to your shell configuration file:"
echo 'export PATH="'"$POETRY_PATH"'":$PATH'
