#!/bin/bash
#
# A script to deploy configs
#

log() {
    echo "- $*"
}

deploy_single_target() {
    local src=$1
    local dest=$2

    # log "Checking directory $check_dir"
    local check_dir;
    if [ -d "$src" ]; then
        check_dir="$dest"
    else
        check_dir="$(dirname "${dest%%/}")"
    fi
    if [ ! -d "$check_dir" ]; then
        log "Creating directory $check_dir"
        mkdir -p "$check_dir"
    fi

    if [ -d "$src" ] && [[ "${src: -1}" =~ "/" ]]; then
        src="${src:0:-1}"
        dest="${dest:0:-1}"
    fi

    log "Deploying $src to $dest"
    if [ -e "$dest" ]; then
        if [ -L "$dest" ]; then
            log "Removing existing symlink $dest"
            rm "$dest"
        elif [ -e "$dest.bak" ]; then
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

deploy_all() {

    log "Deploying all configuration files"

    # .config/*
    for src in .config/*; do
        if [ -f "$src" ]; then
            continue
        fi
        dest="$HOME/.config/$(basename "$src")"
        deploy_single_target "$src" "$dest"
    done

    # .local/share/*
    for src in .local/share/*; do
        if [ -f "$src" ]; then
            continue
        fi
        dest="$HOME/.local/share/$(basename "$src")"
        deploy_single_target "$src" "$dest"
    done

    # .bash*
    for src in .bash*; do
        dest="$HOME/$(basename "$src")"
        deploy_single_target "$src" "$dest"
    done

    # .tmux clone tpm
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
        log "Cloning tmux plugin manager (tpm)"
        mkdir -p "$HOME/.config/tmux"
        git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/tpm
    fi
}

main() {
    if [ "$#" -eq 0 ]; then
        echo "No arguments provided. Use --help or -h for usage information."
        exit 1;
    elif [[ "${IFS}$*${IFS}" =~ "${IFS}--help${IFS}" ]] || [[ "${IFS}$*${IFS}" =~ "${IFS}-h${IFS}" ]]; then
        echo ""
        echo "Usage: $0 [--help|-h] [-t <target> [<target> ...]]"
        echo "Deploy configuration files to home directory by creating symlinks to files in this repo."
        echo "If targets exist in the home directory, they will be backed up with a .bak suffix."
        echo "When no options are provided, all configurations are deployed."
        echo ""
        echo "Options:"
        echo "  --help, -h        Show this help message and exit"
        echo "  --all, -a         Deploy all configuration files"
        echo "  -t <target> ..., --target <target> ..."
        echo "                    Deploy only specified targets (any files or directories in the repo)"
        echo ""
        echo "NOTE: uses \$HOME as the base directory for deployment."
        echo ""
    elif [[ "${IFS}$*${IFS}" =~ "${IFS}--all${IFS}" ]] || [[ "${IFS}$*${IFS}" =~ "${IFS}-a${IFS}" ]]; then
        deploy_all
    else
        while [ "$#" -gt 0 ]; do
            case "$1" in
                -t|--target)
                    shift
                    while [ "$#" -gt 0 ] && [[ ! "$1" =~ ^- ]]; do
                        target="$1"
                        if [ -e "$target" ]; then
                            dest="$HOME/$target"
                            deploy_single_target "$target" "$dest"
                        else
                            log "Warning: Target $target does not exist."
                        fi
                        shift
                    done
                    ;;
                *)
                    log "Unknown option: $1"
                    exit 1
                    ;;
            esac
        done
    fi

    exit 0
}

# Main #
main "$@"
