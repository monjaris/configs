# Main-Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls --color=auto'
alias l='eza --icons --classify=auto'
alias lsa='eza -A --icons --classify auto'
alias t='lsd --tree'
alias rm='rm -vI'
alias cp='cp -v'
alias mv='mv -iv'
alias bashconf='ed $BASH_CONFIG_DIR/defines.sh; resh'
alias resh="echo sourcing '.bashrc'.. && source $HOME/.bashrc"
alias term='f(){ kitty bash -ic "$*; exec bash"; }; f; unset -f f'
alias yat='systemctl sleep || systemctl suspend'
alias xxx='exit'

# Useful-Aliases
alias pls='sudo'
alias fuckman='echo removing pacman lock..; sudo rm /var/lib/pacman/db.lck'
alias norphans='sudo pacman -Rns $(pacman -Qtdq)'
alias gr='ugrep'
alias projs="cd '$HOME/Documents/notes' && bat projs.md"
alias todos="cd '$HOME/Documents/notes' && bat todos.md"
alias py='python3'
alias zed='zeditor'
alias nano='type nano; micro'
alias qdbus='type qdbus; qdbus6'
alias seqs='type seqs; bat "$HOME/.config/bashrc.d/_sequences.sh"'
alias wget='wget -c'
alias grep='grep --color=auto'
alias ip='ip -color'
alias journal='type journal; journalctl --no-pager -l'
alias jerrors='type jerrors; journalctl -p 3 -xb --pager-end'
alias procs='ps aux'


# Development aliases
alias .='./run.sh dev'
alias mk='./build.sh dev'
alias xm='xmake'
alias xini='cp ~/Templates/xmake.lua ./xmake.lua'
alias xmreset='rmxm; xmake f -c; xmake c -a'
alias fdf='fd --glob'
alias loc='tokei --sort lines --exclude vendor --exclude examples --exclude tests --hidden'
alias gs='git status'
alias gd='git diff HEAD --stat'
alias grd='git fetch && git diff HEAD..@{u} --stat && printf "\n${BMAGENTA}* UPSTREAM CHANGES *\n"${CLR0}'
alias gcom='git commit -m'
alias gp='git push'
alias rmcm='rm -rf ./.cache ./build compile_commands.json'
alias rmxm='echo "Removing ./build/, ./.xmake/ and ./compile_commands.json...";
    command rm -rf ./.xmake ./build && command rm -f compile_commands.json'


cls () {
    local hour="$(date +'%H')"
    hour="${hour#0}"

    printf "\033[2J\033[3J\033[1;1H"

    if [ "${hour:-0}" -ge 8 ] && [ "${hour:-0}" -le 22 ]; then zdo f 2 0.05; fi
}


rmd () {
    local target="$1"

    if [ -z "${target}" ]; then
        printf "rmd: One argument required!\n"
        return 1
    fi

    if [ ! -d "${target}" ]; then
        printf "rmd: Directory ${RED}'%s'${CLR0} doesnt even exist nigga boy\n" "${target}"
        return 1
    fi

    local size
    size="$(du -sh -- "${target}" | cut -f1)"

    rm -rf -- "${target}" && printf "rmd: finished removing ${ULN_BLUE}%s${CLR0} %s\n" "${target}" "(${size})"
}


glp () {
    git log -g origin/main --format="%ct %gs" | awk -v now=$(date +%s) '{
        diff = now - $1;
        days = int(diff / 86400);
        $1 = ""; # Remove the timestamp from output
        printf "%d days ago:%s\n", days, $0
    }' | head -250
}


ghclone () {
    repo="${1}"

    if [ -z "${repo}" ]; then echo 'Need a an argument: `$owner/$repo`'; return 1; fi

    git clone --depth=1 https://github.com/"${repo}" && cd "$(basename "${repo}" ".git")"
}


silent () {
    bash -c "$*" >/dev/null 2>&1 || true
}


silent-sh () {
    sh -c "$*" >/dev/null 2>&1 || true
}


rape () {
    local proc="$1"
    if [[ -z "$proc" ]]; then
        echo 'Need an argument'; return 1
    fi

    pkill -9 "$proc"
}

fsz () {
    local item="$1"
    local postfix="MiB"
    local size=0

    if [ -d "${item}" ]; then
        size=" $(du -sbL "${item}") "
    else
        size=" $(stat -Lc%s "${item}") "
    fi

    awk -v size="${size}" -v postfix="$postfix" 'BEGIN { printf "%.4f %s", size/(1024*1024), postfix }'
}


ass () {
    local out="$(basename "$1" .asm)"

    as "${out}.asm" -o "${out}.o"
    ld "${out}.o" -o "${out}"
    ./"${out}"

    rm "${out}.o" "${out}"
}


perfo () {
    perf stat ${file}
}


ascii() {
    if [[ $1 == -- ]]; then
        printf '"'
        printf "\\$(printf '%03o' "$2")"
        printf '"\n'
    else
        printf '%d\n' "'$1"
    fi
}



# === PACKAGE MANAGER HELPERS ===

ispkg() {
    pacman -Si "$1" >/dev/null 2>&1
}
isaupkg() {
    yay -Si "$1" >/dev/null 2>&1
}

pacs() {
    pacman -Ssq "$1"
}
pacaus() {
    yay -Ssq "$1"
}

new() {
    printf "${UBLUE}:: pacman${CLR0} — install new packages\n\n"

    printf "${BWHITE}:: Search${CLR0}\n"
    for pkg in "$@"; do
        pacman -Ss "$pkg"
    done

    printf "${BWHITE}:: Install${CLR0}\n"
    sudo pacman -S --needed "$@"
}

aunew() {
    printf "${UYELLOW}:: yay${CLR0} — install new packages from AUR\n\n"

    for pkg in "$@"; do
        yay -Ss "$pkg"
    done

    printf "${BWHITE}:: Install${CLR0} ${BYELLOW}%s${CLR0}\n" "$*"
    yay -S --needed --rebuild "$@"
}

pacrem() {
    printf "${UBLUE}:: pacman${CLR0} — remove packages\n\n"

    printf "${BWHITE}:: Search${CLR0}\n"
    pacman -Qs "$*"

    printf "${BWHITE}:: Remove${CLR0}\n"
    sudo pacman -Rns "$@"
}



# Edit files
ed () {
    local file="$1"; local temp_buffer="unsaved"
    if [ $# -eq 0 ]; then
        # 0 args: edit temporary buffer
        $EDITOR "$temp_buffer"
        if [ -f "$temp_buffer" ]; then
            # User saved the temp buffer, prompt for filename
            echo -n "Press Enter to save as newfile_$(date +%b_%H:%M) or type filename: "
            read -r filename
            if [ -z "$filename" ]; then
                filename="newfile_$(date +%b_%H:%M)"
            fi
            mv "$temp_buffer" "$filename"
            echo -e "\033[32m✓ Saved as $filename\033[0m"
            return 0
        else
            # User didn't save
            return 1
        fi
    elif [ $# -eq 1 ]; then
        # 1 arg: edit specific file
        if [ -f "$file" ]; then
            # File exists, edit it
            $EDITOR "$file"
            echo -e "$GREEN ✓ Edited $file in $EDITOR\033[0m"
            return 0
        else
            # File doesn't exist, micro will create temp buffer
            $EDITOR "$file"
            if [ -f "$file" ]; then
                # User saved, file now exists
                echo -e "$MAGENTA ✓ Created $file in $EDITOR\033[0m"
                return 0
            else
                # User didn't save, file still doesn't exist
                echo -e "$YELLOW ✓ Temporarily edited $file and deleted\033[0m"
                return 1
            fi
        fi
    else
        echo "Usage: ed [file]"
        return 1
    fi
}


# Run command in background and exit terminal
run () {
    if [[ -z "$*" ]]; then
        echo "Usage: run <command>" >&2
        return 1
    fi

    bash --login -i -c "$@" &>/dev/null &
    disown
    exit
}


#
getline () {
    read -r GETLINE_READ_VAR
    printf "\033[1A2K\r${GETLINE_READ_VAR}\n"
}


# Translate text
def () {
    local engine="google"; local flags="";
    local src="en"; local dest="az"; local text=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e)
                engine="$2"; shift 2
                ;;
            -s|-src)
                src="$2"; shift 2
                ;;
            -d|-dest)
                dest="$2"; shift 2
                ;;
            -r)
                temp=$src; src=$dest; dest=$temp; shift
                ;;
            --)
                shift; flags="$@"; break
                ;;
            *)
                text="$1"; shift
                ;;
        esac
    done
    #
    [[ -z "$text" ]] && return 1
    trans -e "$engine" "$src:$dest" "$text" "$flags"
}



# Command info
wtf () {
    local pkg_or_cmd="$1"
    local verbose="$2"

    if [[ -z "$pkg_or_cmd" ]]; then
        echo "Usage: wtf <package> [?]" >&2
        echo "  Add '?' for full package info" >&2
        return 1
    fi

    # print whatis info
    tput setaf 2; tput bold
    whatis "$pkg_or_cmd" 2>/dev/null || echo "No whatis entry for $pkg_or_cmd"
    tput sgr0

    # print installed size
    tput setaf 5
    if pacman -Qi "$pkg_or_cmd" &>/dev/null; then
        pacman -Qi "$pkg_or_cmd" | grep "Installed Size"
    else
        echo "there is no installed package or command named $pkg_or_cmd!"
    fi
    tput sgr0

    echo ""

    if [[ "$verbose" == "?" ]]; then
        yay -Si "$pkg_or_cmd"
    fi
}



cf () {
    local help_text="Usage: cf [subcommand|flags]
    Subcommands:  bash, keyd, aur, ed, term, code, zed, ff, yazi, clangd
    Flags:  -r, -u, -p, -i"

    if [[ "$1" == -* ]]; then
        local do_r=0 do_u=0 do_p=0 do_i=0
        local OPTIND=1
        while getopts "rupih" opt "$@"; do
            case "$opt" in
                r) do_r=1 ;;
                u) do_u=1 ;;
                p) do_p=1 ;;
                i) do_i=1 ;;
                h) echo "$help_text"; return ;;
                ?)
                    echo "Unknown flag: -$OPTARG" >&2
                    return 1 ;;
            esac
        done

        [[ $do_r == 1 ]] && \
            cd "$HOME/Documents/configs/" && git status
        [[ $do_u == 1 ]] && \
            { echo "Updating configurations..."; "$HOME/Documents/configs/update.sh"; }
        [[ $do_p == 1 ]] && \
            { echo "Pushing to the repo..."; cd "$HOME/Documents/configs/"; ./push.sh; cd -; }
        [[ $do_i == 1 ]] && \
            { echo "Installing configurations..."; "$HOME/Documents/configs/install.sh"; }
        return
    fi

    case "$1" in
        bash)
            case "$2" in
                def)      ed "$BASH_CONFIG_DIR/defines.sh" ;;
                ini|init) ed "$BASH_CONFIG_DIR/init.sh" ;;
                seq)      ed "$BASH_CONFIG_DIR/sequences.sh" ;;
                fn|func)  ed "$BASH_CONFIG_DIR/functions.sh" ;;
                rc|.)     ed "$HOME/.bashrc"  ;;
                in|input) ed "$HOME/.inputrc" ;;
                *)        cd "$BASH_CONFIG_DIR/"; lsa ;;
            esac
            ;;
        autostart)
            cd "$HOME/.config/autostart"; lsa ;;
        keyd)
            cd "/etc/keyd"; lsa; sudo bat -n --paging=never "default.conf" ;;
        aur)
            cd "$HOME/.config/yay"; lsa ;;
        ed)
            cd "$HOME/.config/${EDITOR}"; lsa ;;
        term)
            cd "$HOME/.config/kitty"; lsa ;;
        code)
            cd "$HOME/.config/Code/User"; lsa ;;
        zed)
            cd "$HOME/.config/zed"; lsa ;;
        ff)
            cd "$HOME/.config/fastfetch"; lsa; bat "config.jsonc" ;;
        yazi)
            cd "$HOME/.config/yazi"; lsa; bat "yazi.toml" ;;
        clangd)
            cd "$HOME/.config/clangd"; lsa; bat "config.yaml" ;;
        *)
            cd "$HOME/.config" && lsa ;;
    esac
}

