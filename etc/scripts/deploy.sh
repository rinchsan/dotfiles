#!/bin/bash

set -eu

DOTFILES=$(dirname "$(cd "$(dirname "${0}")" && pwd)")

cd "${DOTFILES}"

for FILE in .??*
do
    [ "${FILE}" = ".git" ] && continue

    SRC=$(cd "$(dirname "${FILE}")" && pwd)/$(basename "${FILE}")
    ln -snfv "${SRC}" "${HOME}"/"${FILE}"
done
