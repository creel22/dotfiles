#!/bin/bash
set -e

echo "🚀 Bootstrapping your Modern Terminal Environment..."

# 1. Install Homebrew if missing
if ! command -v brew &> /dev/null; then
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || true
    fi
fi

# 2. Install Nushell if missing
if ! command -v nu &> /dev/null; then
    echo "🐚 Installing Nushell..."
    brew install nu
fi

# 3. Hand off to the Nushell installer
echo "🏃 Handing off to install.nu..."
nu "$(dirname "$0")/install.nu"
