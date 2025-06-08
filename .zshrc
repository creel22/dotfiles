# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias gitlogonelinepretty='git log --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an %Cgreen%s" --date=short'
alias glop=gitlogonelinepretty
alias gitbranchclean='git remote prune origin && git branch --merged | egrep -v "(^\*|main|dev|master)" | xargs git branch -d'
alias gitlogcurrentworkingdirectory='git log --oneline -- **/*'
alias glcwd=gitlogcurrentworkingdirectory
alias gprom='git pull --rebase origin master'
alias hflabels='gh pr edit $(git rev-parse --abbrev-ref HEAD) --add-label "tribe: ${TRIBE}" --add-label "squad: ${SQUAD}"'
alias assignme='gh pr edit $(git rev-parse --abbrev-ref HEAD) --add-assignee @me'
alias pr-create='gh pr create --draft && hflabels && assignme'
alias need-dev='gh pr edit $(git rev-parse --abbrev-ref HEAD) --add-label "need-dev"'

alias l='eza'
alias la='eza -a'
alias ll='eza -lah'
alias ls='eza --color=auto'


# Configuration Variables
USERNAME=vscode
WORKSPACE_DIR="${DEVCONTAINER_WORKSPACE_FOLDER:-$PWD}"
DOCKER_DIR="$WORKSPACE_DIR"/".devcontainer"
COMPOSE_FILE="docker-compose.yml"
COMPOSE_PATH="$WORKSPACE_DIR/$COMPOSE_FILE"

# Docker Commands
alias dstopcont='docker stop $(docker ps -a -q)'
alias dstopall='docker stop $(docker ps -aq)'
alias drmcont='docker rm $(docker ps -a -q)'
alias dvolprune='docker volume prune'
alias dsysprune='docker system prune -a'
alias ddelimages='docker rmi $(docker images -q)'
alias docerase='dstopcont; drmcont; ddelimages; dvolprune; dsysprune'
alias docprune='ddelimages; dvolprune; dsysprune'
alias dexec='docker exec -ti'
alias docps='docker ps -a'
alias docdf='docker system df'
alias dlogs='docker logs -tf --tail="50" '
alias dips="docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';"

# Docker Compose Wrapper Function
dcrun() {
    cd "$DOCKER_DIR" || return
    docker compose --profile all -f "$COMPOSE_PATH" "$@"
}

# Generalized Docker Compose Function
dcmanage() {
    local profile="$1"
    local action="$2"
    shift 2
    docker compose --profile "$profile" -f "$COMPOSE_PATH" "$action" "$@"
}

# Docker Compose Shortcuts
alias dclogs='dcrun logs -tf --tail="50"'
alias dcup='dcrun up -d'
alias dcbuild='dcrun up -d --build --remove-orphans'
alias dcdown='dcrun down'
alias dcrec='dcrun up -d --force-recreate --remove-orphans'
alias dcstop='dcrun stop'
alias dcstart='dcrun start'
alias dcrestart='dcrun restart'
alias dcpull='dcrun pull'

alias stopdbs='dcmanage dbs stop'

#_docker_alias_complete() {
#  local -a containers
#  containers=(${(f)"$(docker ps --format '{{.Names}}')"})
#  _describe -t containers 'Docker containers' containers
#}

_docker_alias_complete() {
  local -a containers
  containers=(${(f)"$(docker ps --format '{{.Names}}')"})
  compadd -a containers
}

compdef _docker_alias_complete dexec
compdef _docker_alias_complete dclogs
compdef _docker_alias_complete dcbuild
zstyle ':completion:*' completer _complete _ignored
compdef dexec=docker

# remove username@hostname in prompt as advised at
# https://github.com/ohmyzsh/ohmyzsh/issues/5581#issuecomment-256825141
prompt_context() {}
