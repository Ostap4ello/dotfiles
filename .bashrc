#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export TERM='xterm-256color'
# Created by `pipx` on 2023-12-17 20:27:05
export PATH="$PATH:/home/ostap4ello/.local/bin"

stty werase \^H

## Aliases and functions
# directories
alias cdcd='cd ~/Workspace/ ; tree -d -L 2'
alias cds='cd ~/Workspace/stu-s4/ ; tree -d -L 2'
alias cdnv='cd ~/.config/nvim/ ; nvim'

# commands`
alias ls='ls --color=auto'
alias ll='ls -l -a --color=auto'
alias grep='grep --color=auto'
alias py='python3'
alias manual='man --locale=uk'
alias docker-compose='docker compose'
alias btcli='bluetoothctl'
alias btdefault='bluetoothctl connect 2C:FD:B3:4B:02:B4; bluetoothctl connect 00:9E:C8:F7:70:31'
alias nightmode='hyprshade toggle blue-light-filter'
alias fire="kitty --title \"Fireplace\" -o font_size=6 sh -c \"fireplace -f 65 -t 15\" & disown"

#functions
wl-img-saveto(){
    if [ -z "$1" ]; then
        echo "usage: wl-img-saveto <filename> (include .png in name)"
        return
    fi

    wl-paste | cat - > "$1"
}

external_display_brightness() {
    if [ -z "$1" ]; then
        echo "$(ddcutil getvcp 0x10 | sed 's/[^0-9 ]*//g' | awk '{print $2}')"
    else
        ddcutil setvcp 0x10 "$1"
    fi
}
lf() {
    # Define a temporary file to store the directory path
    tmpfile="$(mktemp)"
    # Launch lf and store the last directory in the temporary file
    /usr/bin/lf -last-dir-path="$tmpfile"
    # Change to the last directory lf was in, if the file exists and is not empty
    if [ -f "$tmpfile" ] && [ "$(cat "$tmpfile")" != "" ]; then
        cd "$(cat "$tmpfile")"
    fi
    # Clean up the temporary file
    rm -f "$tmpfile"
}
rgr() {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
#
# NOTE: supermount - name of mntpoint could be label
#
supermount() {
    # if not enough args
    device="$1"
    mntfolder="$2"
    if [[ "${mntfolder: -1}" == "/" ]]; then
        mntfolder="${mntfolder::-1}"
    fi

    if [ -z "1" ]; then #if no arguments (-z means zero length string)
        # lsblk -o name,mountpoint,label,size,uuid
        lsblk -f
        echo " \
            for help type 'pripizdosh help'"
    elif [ -z "$mntfolder" ]; then
        lsblk -o path,mountpoint,label,size,uuid | grep "$1"

    # flags or custom commands
    elif [[ "$1" == "help" ]]; then
        echo "pripizdosh [device] [mountpoint] - mounts the device to the mountpoint \
              vidpizdozh [device] - unmounts the device \
              when no arguments are given, lists all devices \
              when only one argument is given, lists info about the device"

    elif [ -e "$1" ]; then
        devfolder="$(
            lsblk -o path,name,label |
                grep "$device" |
                awk '{print $2, "-", $3}' |
                sed 's/[^a-zA-Z0-9-]//g'
        )"

        if [[ "${devfolder: -1}" == "-" ]]; then
            mntfolder="${devfolder::-1}"
        fi

        mkdir -p "$mntfolder/$devfolder" &&
            sudo mount -o umask=000 "$device" "$mntfolder/$devfolder" &&
            echo "Mounted $device to $mntfolder/$devfolder"
    else
        echo "No such device"
    fi
}

superumount() {
    if [ -z "$1" ]; then #if no arguments (-z means zero length string)
        # lsblk -o name,mountpoint,label,size,uuid
        lsblk -f
        echo " \
            for help type 'vidpizdosh help'"

    # flags or custom commands
    elif [[ "$1" == "help" ]]; then
        echo "vidpizdozh [device] - unmounts the device \
              when no arguments are given, lists all devices"

    elif [ -e "$1" ]; then
        sudo umount "$1" &&
            rmdir "$1" &&
            echo "Unmounted $1"

    else
        echo "No such device"
    fi
}

stmux() {
    out="$(tmux ls 2>/dev/null | grep -Eo '^TEMP')"
    if [ -z "$out" ]; then
        tmux new-session -s TEMP \; detach \;
    fi
    tmux attach-session -t TEMP \; lazy-restore-choose \;

    tmux kill-session -t TEMP
}

## Initializations
# enable bash completion in interactive shells
# https://github.com/scop/bash-completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
