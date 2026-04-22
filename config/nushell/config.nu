# ---------------------------------
# Source Generated Inits
# ---------------------------------
source ($nu.cache-dir | path join "starship/init.nu")
source ($nu.cache-dir | path join "carapace/init.nu")
source ($nu.cache-dir | path join "zoxide/init.nu")
use ~/.config/broot/launcher/nushell/br

# ---------------------------------
# Settings
# ---------------------------------
$env.config.show_banner = false
$env.config.edit_mode = "emacs" # or "vi"

# ---------------------------------
# Aliases
# ---------------------------------
alias v  = nvim
alias cat = bat

# eza (modern ls)
alias l  = eza --icons --group-directories-first
alias ll = eza -l --icons --git --group-directories-first
alias la = eza -a --icons --git --group-directories-first
alias lt = eza --tree --level 2 --icons --group-directories-first

# Git shorthands
alias g   = git
alias gs  = git status
alias gd  = git diff
alias gl  = git pull
alias gp  = git push
alias ga  = git add
alias gc  = git commit
alias gco = git checkout
alias gwt = git worktree
alias gwl = git worktree list
alias glop = git log --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an %Cgreen%s" --date=short

# Docker
alias dcup = docker compose up -d
alias dcdwn = docker compose down
alias dcbuild = docker compose up -d --build --remove-orphans
alias dcpull = docker compose pull
alias dsysprune = docker system prune -a
alias dvolprune = docker volume prune

# ---------------------------------
# Custom Commands
# ---------------------------------

# Docker PS with proper column alignment for Nu tables
def dps [ --all (-a) ] {
    if $all {
        docker ps -a | from ssv --aligned-columns
    } else {
        docker ps | from ssv --aligned-columns
    }
}

# Display Docker container names and IP addresses in a structured table
def dips [] {
    docker ps --format '{{.Names}}'
    | lines
    | each { |name|
        let info = (docker inspect $name | from json | get 0)
        let networks = $info.NetworkSettings.Networks
        let ips = ($networks | values | get IPAddress | where { $in != "" })
        
        # Format ports: "8080->80/tcp" or just "80/tcp" if not mapped
        let ports = ($info.NetworkSettings.Ports 
            | items { |port, mapping| 
                if ($mapping | is-empty) { $port } else { $"($mapping.0.HostPort)->($port)" }
            } 
            | str join ", ")

        # Handle containers without health checks
        let health_status = ($info.State | get -o Health.Status)
        let status_str = (if ($health_status | is-not-empty) { 
            $"($info.State.Status) \(($health_status)\)" 
        } else { 
            $info.State.Status 
        })

        {
            name: $name,
            image: ($info.Config.Image | split row "/" | last), # Just the image name
            status: $status_str,
            ips: ($ips | str join ", "),
            ports: $ports
        }
    }
}

# Navigation (Standard shortcuts)
def .. [] { cd .. }
def ... [] { cd ../.. }
def .... [] { cd ../../.. }

# Git rebase main helper
def grm [] {
    let branch = (git branch --show-current)
    print $"Rebasing ($branch) onto main..."
    git checkout main
    git pull origin main
    git checkout $branch
    git rebase main
}

# Load .env files manually
def --env load-local-env [] {
    if (".env" | path exists) {
        open .env | lines 
        | where not ($it | str starts-with "#") and ($it | str contains "=")
        | reduce -f {} {|it, acc| 
            let parts = ($it | split row -n 2 "=")
            $acc | insert ($parts.0 | str trim) ($parts.1 | str trim | str replace -r '^["'']' '' | str replace -r '["'']$' '')
          }
        | load-env
    }
}

# ---------------------------------
# Completions Settings
# ---------------------------------
$env.config = (
    $env.config 
    | upsert completions.external.max_results 100
    | upsert completions.external.enable true
)

# ---------------------------------
# FZF Integration
# ---------------------------------

# Interactive history search
def --env fzf-history [] {
    let selection = (
        history 
        | get command 
        | reverse 
        | uniq 
        | str join (char newline) 
        | fzf --height 40% --layout=reverse --border --prompt="History> " --query (commandline)
    )
    
    if ($selection | is-not-empty) {
        commandline edit --replace $selection
    }
}

# Add Ctrl+R binding
$env.config = ($env.config | upsert keybindings (
    $env.config.keybindings ++ [
        {
            name: fzf_history
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert]
            event: { send: executehostcommand, cmd: "fzf-history" }
        }
        {
            name: fzf_find
            modifier: control
            keycode: char_p
            mode: [emacs, vi_insert]
            event: { send: executehostcommand, cmd: "fzf-find" }
        }
    ]
))

# ---------------------------------
# Direnv Integration
# ---------------------------------
$env.config = (
    $env.config 
    | upsert hooks.env_change.PWD [
        { |before, after|
            if (which direnv | is-not-empty) {
                let envs = (direnv export json | from json | default {})
                if ($envs | is-not-empty) {
                    $envs | load-env
                    if ($env.PATH | describe) == "string" {
                        $env.PATH = ($env.PATH | split row (char env_sep))
                    }
                }
            }
        }
    ]
)

# ---------------------------------
# Interactive file search with preview
# ---------------------------------
def --env fzf-find [] {
    let selection = (
        fd --type f --hidden --exclude .git --exclude node_modules 
        | fzf --height 60% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'
    )
    
    if ($selection | is-not-empty) {
        commandline edit --insert $selection
    }
}

# Search and open in Neovim
def --env vf [] {
    let selection = (
        fd --type f --hidden --exclude .git --exclude node_modules 
        | fzf --height 60% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'
    )
    
    if ($selection | is-not-empty) {
        nvim $selection
    }
}

# Git Worktree Switcher
def --env gws [] {
    let paths = (
        git worktree list 
        | lines 
        | parse -r '^(?P<path>/[^\s]+)' 
        | get path
    )
    
    if ($paths | is-empty) {
        print "Error: No worktrees found."
        return
    }

    let selected = ($paths | str join (char newline) | fzf --height 40% --reverse --border)
    
    if ($selected | is-not-empty) and ($selected | path exists) {
        cd $selected
    }
}

# Docker Exec with FZF selection
def dexecf [] {
    let selected = (
        docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}'
        | lines
        | str join (char newline)
        | fzf --height 40% --reverse --preview 'docker logs --tail=50 {1}'
    )

    if ($selected | is-not-empty) {
        let container = ($selected | split row (char tab) | get 0 | str trim)
        print $"Connecting to ($container)..."
        try {
            docker exec -it $container bash
        } catch {
            docker exec -it $container sh
        }
    }
}
