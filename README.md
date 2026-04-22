# Modern Dotfiles

A cross-platform, highly hardened dotfiles configuration designed for macOS workstations and Ubuntu homelab servers.

Built with performance, portability, and beautiful UI in mind.

## Core Stack
- **Shell**: [Nushell](https://www.nushell.sh/) (Strict mode compliant)
- **Prompt**: [Starship](https://starship.rs/)
- **Editor**: [Neovim](https://neovim.io/) + [Ghostty](https://ghostty.org/) (macOS)
- **Environment**: [Direnv](https://direnv.net/) + [uv](https://github.com/astral-sh/uv)
- **Terminal UI**: `fzf`, `zoxide`, `bat`, `eza`, `broot`, `lazygit`, `lazydocker`, `btop`

## Features
- **Zero-Touch Syncing**: Safely symlinks configs without clobbering existing files.
- **Cross-Platform SSH**: Shielded 1Password agent forwarding exclusively for macOS.
- **Container Workflow**: Extensive Docker and Docker Compose integrations built into the shell.
- **AI-Powered Code**: Native AI integrations within Neovim and VS Code (via Brewfile).
- **Hardened Python Setup**: Fully relies on `uv` for lightning-fast virtual environments and project management.

## Bootstrapping a New Machine

To install these dotfiles on a fresh macOS or Ubuntu instance, simply run:

```bash
curl -fsSL https://raw.githubusercontent.com/jamiekt/dotfiles/main/bootstrap.sh | bash
```
*(Note: Change the GitHub URL if you fork this repository)*

### What the installer does:
1. Installs **Homebrew** (or Linuxbrew) if it is missing.
2. Installs **Nushell**.
3. Hands off execution to `install.nu`, which:
   - Symlinks all folders inside `config/` to `~/.config/`.
   - Symlinks all files inside `home/` to `~/`.
   - Symlinks all scripts in `bin/` to `~/.local/bin/`.
   - Installs all dependencies from the `Brewfile`.
   - On macOS, additionally installs casks and VS Code extensions from `Brewfile.workstation`.
   - Automatically patches and generates the `broot` launcher function for Nushell parity.

## Manual Installation
If you prefer to clone and install manually:

```bash
git clone https://github.com/jamiekt/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
./bootstrap.sh
```
