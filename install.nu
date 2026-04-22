#!/usr/bin/env nu

def main [] {
    let dotfiles_root = ($env.CURRENT_FILE | path dirname)
    
    print "🚀 Starting Dotfile Installation..."

    # 1. Symlink Configs
    let config_src = ($dotfiles_root | path join "config")
    let config_dest = ($env.HOME | path join ".config")
    
    mkdir $config_dest
    
    ls $config_src | each { |item|
        let target = ($config_dest | path join ($item.name | path basename))
        if ($target | path exists) {
            print $"  - Skipping ($target) [already exists]"
        } else {
            print $"  - Symlinking ($item.name) -> ($target)"
            ln -s $item.name $target
        }
    }

    # 2. Symlink Home files
    let home_src = ($dotfiles_root | path join "home")
    ls -a $home_src | where name !~ `\.$` | each { |item|
        let target = ($env.HOME | path join ($item.name | path basename))
        if ($target | path exists) {
            print $"  - Skipping ($target) [already exists]"
        } else {
            print $"  - Symlinking ($item.name) -> ($target)"
            ln -s $item.name $target
        }
    }

    # 3. Brew Bundle
    if (which brew | is-not-empty) {
        print "🍺 Running Brew Bundle (Core)..."
        brew bundle --file=($dotfiles_root | path join "Brewfile")

        # Only install workstation extras on macOS (assumed workstation)
        if ($nu.os-info.name == "macos") {
            print "🖥️  Mac detected: Installing Workstation extras (Casks & VSCode)..."
            brew bundle --file=($dotfiles_root | path join "Brewfile.workstation")
        }

        # Generate Broot launcher locally
        if (which broot | is-not-empty) {
            print "🌳 Generating Broot launcher..."
            let broot_dir = ($config_dest | path join "broot/launcher/nushell")
            mkdir $broot_dir
            let br_path = ($broot_dir | path join "br")
            broot --print-shell-function nushell 
            | str replace "export def --env br" "export def --env main"
            | save -f $br_path
        }
    }

    print "✅ Installation Complete! Restart your shell to see changes."
}
