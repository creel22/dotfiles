#!/usr/bin/env nu

def main [...profiles: string] {
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

    # 3. Symlink Bin scripts
    let bin_src = ($dotfiles_root | path join "bin")
    let local_bin_dest = ($env.HOME | path join ".local/bin")
    
    if not ($local_bin_dest | path exists) {
        mkdir $local_bin_dest
    }
    
    ls $bin_src | each { |item|
        let target = ($local_bin_dest | path join ($item.name | path basename))
        if ($target | path exists) {
            print $"  - Skipping ($target) [already exists]"
        } else {
            print $"  - Symlinking ($item.name) -> ($target)"
            ln -s $item.name $target
        }
    }

    # 4. Brew Bundle
    if (which brew | is-not-empty) {
        let available_profiles = ["shell", "dev", "server", "media"]
        mut selected_profiles = []

        if ($profiles | is-empty) {
            print "🍺 No profiles provided. Entering interactive mode..."
            for p in $available_profiles {
                let ans = (input $"Do you want to install the '($p)' profile? (y/N) ")
                if ($ans | str downcase) == "y" {
                    $selected_profiles = ($selected_profiles | append $p)
                }
            }
        } else {
            $selected_profiles = $profiles
        }

        if ($nu.os-info.name == "macos") and ("workstation" not-in $selected_profiles) {
            print "🖥️  Mac detected: Automatically adding 'workstation' profile..."
            $selected_profiles = ($selected_profiles | append "workstation")
        }

        for p in $selected_profiles {
            let brewfile_path = ($dotfiles_root | path join $"Brewfile.($p)")
            if ($brewfile_path | path exists) {
                print $"🍺 Running Brew Bundle for ($p)..."
                brew bundle --file=$brewfile_path
            } else {
                print $"⚠️ Warning: Brewfile.($p) not found!"
            }
        }

        # Generate Broot launcher locally
        if (which broot | is-not-empty) {
            print "🌳 Generating Broot launcher..."
            let broot_dir = ($config_dest | path join "broot/launcher/nushell")
            mkdir $broot_dir
            let br_path = ($broot_dir | path join "br")
            rm -f $br_path # Ensure we're not fighting a symlink
            broot --print-shell-function nushell 
            | str replace "export def --env br" "export def --env main"
            | save -f $br_path
        }
    }

    print "✅ Installation Complete! Restart your shell to see changes."
}
