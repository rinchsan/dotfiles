#!/bin/bash

set -eu

DOTFILES=$(dirname $(cd $(dirname $0) && pwd))

cd ${DOTFILES}

for FILE in .??*
do
    [ "${FILE}" = ".git" ] && continue

    echo "Symlinking ${FILE}..."
    ln -snfv ${FILE} ${HOME}/${FILE}
done
