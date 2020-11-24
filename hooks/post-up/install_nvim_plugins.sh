#!/bin/bash

set -eu

MINPAC_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/nvim/pack/minpac/opt/minpac

if [ -d $MINPAC_DIR ]; then
    pushd $MINPAC_DIR
    git pull
    popd
else
    git clone https://github.com/k-takata/minpac.git $MINPAC_DIR
fi

nvim -c PackClean -c PackUpdate -c qall
