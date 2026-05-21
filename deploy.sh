#!/bin/bash
#
# A script to deploy configs
#

help() { echo <<EOF

Usage: $0 [<option> ...] [<command>]
Deploy configuration files to \$HOME by creating symlinks to files in this repo.
If targets exist in \$HOME, they will be backed up with a .bak suffix.

Commands:
  t <target> ..., target <target> ...
                    Deploy only specified targets (creates symlinks for each target)
  a, all         Deploy all available configuration files

Options:
  --help, -h        Show this help message and exit
  --notes           Show other notes
(specialized)
  --tmux-pm         Install tmux plugin manager (tpm) if not already installed
  --yay             Install yay (AUR helper) if not already installed
  --dms             Install dms (DANK LINUX)
  --cli             Install essential CLI tools:
                       ${cli_list[*]}
  --de              Install essential desktop applications:
                       ${de_list[*]}
  --nvime            Install neovim + utils needed for this repo's config:
                       ${nvim_list[*]}
  --flatpak         Install Flatpak + user-level

EOF
}

cli_list=(
    "git"
    "tmux"
    "fzf"
    "ripgrep"
    "fd"
    "vi"
    "vim"
    "ranger"
    "lazygit"
)

de_list=(
    "firefox"
    "chromium"
    "brightnessctl"
    "kitty"
    "zathura"
    "zathura-pdf-mupdf"
)

nvim_list=(
    "neovim"
    "yarn"
    "npm"
    "fd"
    "fzf"
    "ripgrep"
    "plantuml"
)

log() {
    echo "- $*"
}

deploy_target() {
    local src=$1
    local dest=$2

    # log "Checking directory $check_dir"
    local check_dir="$(dirname "${dest%%/}")"
    if [ ! -d "$check_dir" ]; then
        log "Creating directory $check_dir"
        mkdir -p "$check_dir"
    fi

    if [ -d "$src" ] && [[ "${src: -1}" =~ "/" ]]; then
        src="${src:0:-1}"
        dest="${dest:0:-1}"
    fi

    # Dependencies
    case "$dest" in
        $HOME/.local/bin/hyprland)
            log "Deploying keyboard layout - 'custom' for Hyprland"
            set -x
            sudo cp xkb/custom /usr/share/X11/xkb/symbols/.
            set +x
            ;;
        *)
            ;;
    esac

    log "Deploying $src to $dest"
    if [ -L "$dest" ]; then
        log "Removing existing symlink $dest"
        rm "$dest"
    elif [ -e "$dest" ]; then
        if [ -e "$dest.bak" ]; then
            i=1
            while [ -e "$dest.bak.$i" ]; do
                ((i++))
                if [ $i -gt 100 ]; then
                    log "Error: Too many backup files for $dest.bak"
                    exit 1
                fi
            done
            log "Backing up existing $dest.bak to $dest.bak.$i"
            mv "$dest.bak" "$dest.bak.$i"
        else
            log "Backing up existing $dest to $dest.bak"
            mv "$dest" "$dest.bak"
        fi
    fi
    log "Creating symlink from $src to $dest"
    ln -s "$(realpath "$src")" "$dest"
}

install_from_list() {
    local list=("$@")
    for pkg in "${list[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            set -x
            sudo pacman -S --noconfirm "$pkg"
            set +x
        else
            log "$pkg is already installed"
        fi
    done
}

# Specialized functions

deploy_all() {
    log "Deploying all configuration files"

    # .config/*
    for src in .config/*; do
        dest="$HOME/.config/$(basename "$src")"
        deploy_target "$src" "$dest"
    done

    # .local/share/*
    for src in .local/share/*; do
        dest="$HOME/.local/share/$(basename "$src")"
        deploy_target "$src" "$dest"
    done

    # .local/bin/*
    for src in .local/bin/*; do
        dest="$HOME/.local/bin/$(basename "$src")"
        deploy_target "$src" "$dest"
    done

    # .bash*
    for src in .bash*; do
        dest="$HOME/$(basename "$src")"
        deploy_target "$src" "$dest"
    done

    # .tmux clone tpm
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
        log "Cloning tmux plugin manager (tpm)"
        mkdir -p "$HOME/.config/tmux"
        git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/tpm
    fi
}

install_yay() {
    if command -v yay &> /dev/null; then
        log "yay is already installed"
        return 0
    fi

    log "Installing yay (AUR helper)..."
    local tmp_dir=$(mktemp -d)
    log "Cloning yay to $tmp_dir"
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"

    if [ $? -ne 0 ]; then
        log "Error: Failed to clone yay repository"
        rm -rf "$tmp_dir"
        return 1
    fi

    log "Building and installing yay..."
    cd "$tmp_dir/yay"
    makepkg -si --noconfirm
    cd - > /dev/null
    rm -rf "$tmp_dir"

    if [ $? -ne 0 ]; then
        log "Error: Failed to build/install yay"
        return 1
    else
        log "yay installed successfully"
        return 0
    fi
}

install_dms() {
    set -x
    curl -fsSL https://install.danklinux.com | sh
    set +x
}

install_cli() {
    log "Installing essential CLI tools..."
    install_from_list "${cli_list[@]}"
}

install_de() {
    log "Installing essential desktop applications..."
    install_from_list "${de_list[@]}"
}

install_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        set -x
        sudo pacman -S --noconfirm flatpak
        set +x
    else
        log "Flatpak is already installed"
    fi

    if [ ! -d "$HOME/.local/share/flatpak" ]; then
        set -x
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        set +x
    else
        log "User-level Flatpak is already set up"
    fi
}

install_nvime() {
    log "Installing neovim and related utilities..."
    install_from_list "${nvim_list[@]}"
}

notes() {
    $EDITOR ./other/notes.md
}

main() {
    if [ "$#" -eq 0 ]; then
        echo "No arguments provided. Use --help or -h for usage information."
        exit 1;
    elif [[ "${IFS}$*${IFS}" =~ "${IFS}--help${IFS}" ]] || [[ "${IFS}$*${IFS}" =~ "${IFS}-h${IFS}" ]]; then
        help
        exit 0
    fi

    while [ "$#" -gt 0 ]; do
        case "$1" in
            --yay)
                install_yay
                shift
                ;;
            --dms)
                install_dms
                shift
                ;;
            --cli)
                install_cli
                shift
                ;;
            --de)
                install_de
                shift
                ;;
            --flatpak)
                install_flatpak
                shift
                ;;
            --nvime)
                install_nvime
                shift
                ;;
            t|target|a|all)
                break
                ;;
            *)
                log "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    if [[ "$1" == "a" || "$1" == "all" ]]; then
        deploy_all
    elif [[ "$1" == "t" || "$1" == "target" ]]; then
        shift
        while [ "$#" -gt 0 ]; do
            src="$1"
            if [ -e "$src" ]; then
                dest="$HOME/$src"
                deploy_target "$src" "$dest"
            else
                log "Warning: Target $src does not exist."
            fi
            shift
        done
    else
        log "Unknown command: $1"
        exit 1
    fi

    exit 0
}

# Main #
main "$@"
