#!/usr/bin/env bash
set -e

ARCH=$(uname -m)
OS_TYPE=$(uname)

install_nvim() {
    command -v nvim >/dev/null && return

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        TAR_BALL="nvim-macos-$ARCH.tar.gz"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        TAR_BALL="nvim-linux-$ARCH.tar.gz"
    else
        echo "Unsupported OS for Neovim installation"
        return
    fi

    curl -Lo /tmp/$TAR_BALL https://github.com/neovim/neovim/releases/download/stable/$TAR_BALL
    tar -xzf /tmp/$TAR_BALL -C /tmp/
    sudo mv /tmp/${TAR_BALL%.tar.gz}/bin/nvim /usr/bin/nvim
    rm -rf /tmp/${TAR_BALL%.tar.gz} /tmp/$TAR_BALL
}

install_starship() {
  command -v starship >/dev/null && return
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
}

install_uv() {
  command -v uv >/dev/null && return
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_starship
install_uv
