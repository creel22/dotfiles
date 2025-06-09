#!/bin/bash
set -ex
cd "$(dirname "$0")"

cp .gitconfig ~
git config --global commit.template ~/.gitmessage

# install powerline fonts if not present
if [ ! -d ~/fonts ]; then
  git clone https://github.com/powerline/fonts.git ~/fonts
  bash ~/fonts/install.sh
  rm -rf ~/fonts
fi

# install oh-my-zsh only if not installed
if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no KEEP_ZSHRC=yes \
    bash -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
fi

# install plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

cp .zshrc ~

# Update theme to agnoster
if ! grep -q 'ZSH_THEME="agnoster"' ~/.zshrc; then
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
fi

cat ./bashrc.additions >> ~/.bashrc
