#!/bin/bash

set -u

files=(
    etc/scripts/deploy.sh
    etc/scripts/init.sh
    etc/scripts/install.sh
    etc/scripts/lint.sh
)
for file in "${files[@]}"
do
    shellcheck "${file}"
done
