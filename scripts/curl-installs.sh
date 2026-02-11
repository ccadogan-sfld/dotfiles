#!/usr/bin/env bash
set -e


## VERSIONS
K9S_VERSION=v0.50.18
GO_VERSION=1.25.6
TERRAFORM_VERSION=1.14.4
LAZYGIT_VERSION=0.58.1


ARCH=$(uname -m)
OS_TYPE=$(uname)

install_nvim() {
    echo "Installing nvim..."
    command -v nvim >/dev/null && { echo "nvim already installed"; return; }

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        TAR_BALL="nvim-macos-$ARCH.tar.gz"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        TAR_BALL="nvim-linux-$ARCH.tar.gz"
    else
        echo "Unsupported OS for Neovim installation"
        return
    fi

    curl -sLo /tmp/$TAR_BALL https://github.com/neovim/neovim/releases/download/stable/$TAR_BALL
    tar -xzf /tmp/$TAR_BALL -C /tmp/ 2>/dev/null
    sudo cp -rf /tmp/${TAR_BALL%.tar.gz}/* /usr/local/
    rm -rf /tmp/${TAR_BALL%.tar.gz} /tmp/$TAR_BALL
    echo "nvim installation complete"
}

install_k9s() {
    echo "Installing k9s..."
    command -v k9s >/dev/null && { echo "k9s already installed"; return; }
    command -v kubectl >/dev/null || { echo "kubectl not found, skipping k9s"; return; }

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

    tar -xzf /tmp/$TAR_BALL -C /tmp/ 2>/dev/null
    sudo mv /tmp/k9s /usr/local/bin/k9s
    rm -rf /tmp/${TAR_BALL%.tar.gz} /tmp/$TAR_BALL
    echo "k9s installation complete"
}

install_rust() {
  echo "Installing rust and cargo..."
  command -v cargo >/dev/null && { echo "cargo already installed"; return; }
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$HOME/.cargo/bin:$PATH"
  echo "rust and cargo installation complete"
}

install_starship() {
  echo "Installing starship..."
  command -v starship >/dev/null && { echo "starship already installed"; return; }
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y &>/dev/null
  echo "starship installation complete"
}

install_tree_sitter_cli() {
  echo "Installing tree-sitter-cli..."
  command -v tree-sitter >/dev/null && { echo "tree-sitter-cli already installed"; return; }

  # Ensure cargo is available
  if ! command -v cargo >/dev/null; then
    echo "cargo not found, installing rust first..."
    install_rust
  fi

  # Add cargo to PATH for current shell
  export PATH="$HOME/.cargo/bin:$PATH"

  cargo install tree-sitter-cli
  echo "tree-sitter-cli installation complete"
}

install_uv() {
  echo "Installing uv..."
  command -v uv >/dev/null && { echo "uv already installed"; return; }
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "uv installation complete"
}

install_go() {
    echo "Installing go..."
    command -v go >/dev/null && { echo "go already installed"; return; }

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
    sudo tar -C /usr/local -xzf /tmp/$TAR_BALL 2>/dev/null
    rm -rf /tmp/$TAR_BALL
    echo "go installation complete"
}

install_terraform() {
    echo "Installing terraform..."
    command -v terraform >/dev/null && { echo "terraform already installed"; return; }

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
    unzip -q /tmp/$ZIP_BALL -d /tmp/
    sudo mv /tmp/terraform /usr/local/bin/terraform
    rm -rf /tmp/$ZIP_BALL
    echo "terraform installation complete"
}

install_lazygit() {
    echo "Installing lazygit..."
    command -v lazygit >/dev/null && { echo "lazygit already installed"; return; }

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        LAZYGIT_OS="darwin"
    elif [[ "$OS_TYPE" == "Linux" ]]; then
        LAZYGIT_OS="linux"
    else
        echo "Unsupported OS for lazygit installation"
        return
    fi

    TAR_BALL="lazygit_${LAZYGIT_VERSION}_${LAZYGIT_OS}_${ARCH}.tar.gz"

    curl -sLo /tmp/$TAR_BALL https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/$TAR_BALL
    tar -xzf /tmp/$TAR_BALL -C /tmp/ 2>/dev/null
    sudo mv /tmp/lazygit /usr/local/bin/lazygit
    rm -rf /tmp/${TAR_BALL%.tar.gz} /tmp/$TAR_BALL
    echo "lazygit installation complete"
}

install_kubectx(){
    echo "Installing kubectx..."
    command -v kubectx >/dev/null && { echo "kubectx already installed"; return; }

    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
}

install_rust
install_go

install_starship
install_uv
install_k9s
install_terraform
install_kubectx

# Neovim and tools
install_nvim
install_tree_sitter_cli
install_lazygit
