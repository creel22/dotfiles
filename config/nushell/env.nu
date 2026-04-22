# --------------------------------------------------
# PATH Configuration
# --------------------------------------------------
# Use a cleaner way to build the PATH
$env.PATH = (
    $env.PATH 
    | split row (char env_sep)
    | prepend [
        $"($env.HOME)/bin"
        $"($env.HOME)/.local/bin"
        $"($env.HOME)/.vite-plus/bin"
        $"($env.HOME)/.antigravity/antigravity/bin"
        $"($env.HOME)/.orbstack/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/home/linuxbrew/.linuxbrew/bin"
        "/home/linuxbrew/.linuxbrew/sbin"
    ]
    | uniq
)

# ---------------------------------
# XDG & Tool Envs
# ---------------------------------
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_DATA_HOME   = $"($env.HOME)/.local/share"
$env.XDG_CACHE_HOME  = $"($env.HOME)/.cache"

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.DOCKER_BUILDKIT = "1"
$env.COMPOSE_DOCKER_CLI_BUILD = "1"
$env.LESS = "-R"
$env.FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
$env.FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --exclude .git"
$env.BAT_THEME = "Catppuccin Mocha"
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.PAGER = "bat"

# ---------------------------------
# Terminal Compatibility (for SSH)
# ---------------------------------
# If terminal is unknown or 'dumb', fallback to xterm-256color
let current_term = ($env | get -o TERM | default "dumb")
if ($current_term == "ghostty") or ($current_term == "dumb") {
    # Check if ghostty terminfo is actually available
    if not ("/usr/share/terminfo/g/ghostty" | path exists) and not ("/lib/terminfo/g/ghostty" | path exists) {
        $env.TERM = "xterm-256color"
    }
}

# ---------------------------------
# Generate Inits (Cached for speed)
# ---------------------------------
let starship_cache = ($nu.cache-dir | path join "starship")
let starship_init = ($starship_cache | path join "init.nu")
if not ($starship_init | path exists) {
    if not ($starship_cache | path exists) { mkdir $starship_cache }
    starship init nu | save -f $starship_init
}

let carapace_cache = ($nu.cache-dir | path join "carapace")
let carapace_init = ($carapace_cache | path join "init.nu")
if not ($carapace_init | path exists) {
    if not ($carapace_cache | path exists) { mkdir $carapace_cache }
    carapace _carapace nushell | save -f $carapace_init
}

let zoxide_cache = ($nu.cache-dir | path join "zoxide")
let zoxide_init = ($zoxide_cache | path join "init.nu")
if not ($zoxide_init | path exists) {
    if not ($zoxide_cache | path exists) { mkdir $zoxide_cache }
    zoxide init nushell | save -f $zoxide_init
}

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
