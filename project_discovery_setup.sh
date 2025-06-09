#!/bin/bash

set -e

# --- Configs ---
GO_VERSION="1.22.2"
GOPATH="$HOME/.pdtm"
GOBIN="$GOPATH/go/bin"
FALLBACK_BIN="$HOME/.local/bin"

# Shell profile detection
user_shell=$(getent passwd "$USER" | cut -d: -f7)
case "$user_shell" in
    */zsh) PROFILE_FILE="$HOME/.zshrc" ;;
    */bash) PROFILE_FILE="$HOME/.bashrc" ;;
    *) PROFILE_FILE="$HOME/.profile" ;;
esac

# --- Step 1: Install Go if missing ---
if ! command -v go &>/dev/null; then
    echo "[!] Go not found. Installing Go $GO_VERSION locally..."
    ARCH=$(uname -m)
    OS=$(uname | tr '[:upper:]' '[:lower:]')
    case $ARCH in
        x86_64) ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        *) echo "[X] Unsupported architecture: $ARCH"; exit 1 ;;
    esac
    curl -LO "https://go.dev/dl/go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
    tar -C "$HOME" -xzf "go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
    rm "go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
    export GOROOT="$HOME/go"
    export PATH="$GOROOT/bin:$PATH"
    echo "[+] Go installed locally to $GOROOT"
fi

# --- Step 2: Export GOPATH/GOBIN now ---
export GOPATH="$GOPATH"
export GOBIN="$GOBIN"
export PATH="$GOBIN:$PATH"

# --- Step 3: Persist config in shell ---
if ! grep -q 'PDTM environment' "$PROFILE_FILE"; then
    echo "[*] Adding PDTM env to $PROFILE_FILE"
    {
        echo ''
        echo '# PDTM environment'
        echo 'export GOPATH="$HOME/.pdtm"'
        echo 'export GOBIN="$HOME/.pdtm/go/bin"'
        echo 'export PATH="$GOBIN:$PATH"'
    } >> "$PROFILE_FILE"
fi

# --- Step 4: Install PDTM to GOBIN ---
echo "[*] Installing PDTM..."
go install github.com/projectdiscovery/pdtm/cmd/pdtm@latest

# --- Step 5: Use PDTM to install all tools ---
echo "[*] Installing all ProjectDiscovery tools..."
"$GOBIN/pdtm" -ia

# --- Step 6: Symlink everything ---
if command -v sudo &>/dev/null; then
    echo "[*] Creating symlinks in /usr/local/bin (requires sudo)..."
    sudo true
    for bin in $GOBIN/*; do
        name=$(basename "$bin")
        if [[ "$name" == "httpx" ]]; then
            sudo ln -sf "$bin" /usr/local/bin/pdhttpx
        else
            sudo ln -sf "$bin" /usr/local/bin/"$name"
        fi
    done
    echo "[+] Symlinks added to /usr/local/bin"
else
    echo "[!] sudo not found. Falling back to ~/.local/bin"
    mkdir -p "$FALLBACK_BIN"
    for bin in $GOBIN/*; do
        name=$(basename "$bin")
        if [[ "$name" == "httpx" ]]; then
            ln -sf "$bin" "$FALLBACK_BIN/pdhttpx"
        else
            ln -sf "$bin" "$FALLBACK_BIN/$name"
        fi
    done
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$PROFILE_FILE"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$PROFILE_FILE"
    fi
    echo "[+] Symlinks added to $FALLBACK_BIN and PATH updated in $PROFILE_FILE"
fi

# --- Done ---
echo ""
echo "[✓] PDTM setup complete!"
echo "→ Restart your shell or run: source $PROFILE_FILE"
echo "→ Test with: pdhttpx -version or nuclei -version"

