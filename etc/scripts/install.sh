#!/bin/bash

set -eu

cd "${HOME}"

if ! type brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH=$PATH:/opt/homebrew/bin
fi

if [ ! -d dotfiles ]; then
    git clone https://github.com/rinchsan/dotfiles.git
fi

cd dotfiles

make deploy

make init
