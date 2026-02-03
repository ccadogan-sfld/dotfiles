#!/usr/bin/env bash
set -e


## VERSIONS
K9S_VERSION=v0.50.18
GO_VERSION=1.25.6
TERRAFORM_VERSION=1.14.4


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

    curl -sLo /tmp/$TAR_BALL https://github.com/neovim/neovim/releases/download/stable/$TAR_BALL
    tar -xzf /tmp/$TAR_BALL -C /tmp/
    sudo cp -rf /tmp/${TAR_BALL%.tar.gz}/* /usr/local/
    rm -rf /tmp/${TAR_BALL%.tar.gz} /tmp/$TAR_BALL
}

install_k9s() {
    command -v k9s >/dev/null && return
    command -v kubectl >/dev/null || return

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        K9S_OS="Darwin"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        K9S_OS="Linux"
    else
        echo "Unsupported OS for k9s installation"
        return
    fi

    if [[ "$ARCH" == "x86_64" ]]; then
        K9S_ARCH="amd64"
    elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
        K9S_ARCH="arm64"
    else
        echo "Unsupported architecture for k9s installation"
        return
    fi

    TAR_BALL="k9s_${K9S_OS}_${K9S_ARCH}.tar.gz"

    curl -sLo /tmp/$TAR_BALL https://github.com/derailed/k9s/releases/download/$K9S_VERSION/$TAR_BALL

    tar -xzf /tmp/$TAR_BALL -C /tmp/
    sudo mv /tmp/k9s /usr/local/bin/k9s
    rm -rf /tmp/${TAR_BALL%.tar.gz} /tmp/$TAR_BALL
}

install_starship() {
  command -v starship >/dev/null && return
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y &>/dev/null
}

install_uv() {
  command -v uv >/dev/null && return
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_go() {
    command -v go >/dev/null && return

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        GO_OS="darwin"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        GO_OS="linux"
    else
        echo "Unsupported OS for Go installation"
        return
    fi

    if [[ "$ARCH" == "x86_64" ]]; then
        GO_ARCH="amd64"
    elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
        GO_ARCH="arm64"
    else
        echo "Unsupported architecture for Go installation"
        return
    fi


    TAR_BALL="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"

    curl -sLo /tmp/$TAR_BALL https://golang.org/dl/$TAR_BALL
    sudo tar -C /usr/local -xzf /tmp/$TAR_BALL
    rm -rf /tmp/$TAR_BALL
}

install_terraform() {
    command -v terraform >/dev/null && return

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        TERRAFORM_OS="darwin"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        TERRAFORM_OS="linux"
    else
        echo "Unsupported OS for Terraform installation"
        return
    fi

    if [[ "$ARCH" == "x86_64" ]]; then
        TERRAFORM_ARCH="amd64"
    elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
        TERRAFORM_ARCH="arm64"
    else
        echo "Unsupported architecture for Terraform installation"
        return
    fi

    ZIP_BALL="terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_ARCH}.zip"

    curl -sLo /tmp/$ZIP_BALL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/$ZIP_BALL
    unzip /tmp/$ZIP_BALL -d /tmp/
    sudo mv /tmp/terraform /usr/local/bin/terraform
    rm -rf /tmp/$ZIP_BALL
}

install_nvim
install_starship
install_uv
install_k9s
install_go
install_terraform
