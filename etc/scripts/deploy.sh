#!/bin/bash

set -eu

DOTFILES="${HOME}"/go/src/github.com/rinchsan/dotfiles

cd "${DOTFILES}"

for FILE in .??*
do
    [ "${FILE}" = ".git" ] && continue

    SRC=$(cd "$(dirname "${FILE}")" && pwd)/$(basename "${FILE}")
    ln -snfv "${SRC}" "${HOME}"/"${FILE}"
done
