BASH_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BASH_CONFIG_DIR

# ============================================
# PATH Configuration
# ============================================
path+ () {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}
path+ "$HOME/bin"
path+ "$HOME/dev/c++/projs/bin"


# ============================================
# History Configuration
# ============================================
export HISTSIZE=5000
export HISTFILESIZE=25000
export HISTCONTROL=
export HISTTIMEFORMAT="%F %T "  # Add timestamps to history
shopt -s histappend  # Append to history file, don't overwrite


# ============================================
# Shell Options
# ============================================
shopt -s autocd        # cd by just typing directory name (bash 4+)
shopt -s cdspell       # Autocorrect minor spelling errors in cd
shopt -s dirspell      # Autocorrect directory names during tab completion
shopt -s globstar      # Enable ** for recursive globbing
shopt -s dotglob       # Include hidden files in glob matches (optional)
# shopt -s checkwinsize  # Update LINES and COLUMNS after each command



# ============================================
# Terminal Options
# ============================================
# Prevent the TTY from hard-printing ^C characters on interrupt signals
# stty -echoctl 2>/dev/null
# Disable the driver level interrupt mapping so Readline can capture Ctrl+C
# stty intr undef 2>/dev/null


# ============================================
# Prompt Configuration
# ============================================
longcwd () {
    local home_color=""
    local path_color=""
    local reset="\e[0m"

    # parse flags
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h) home_color="$2"; shift 2 ;;
            -p) path_color="$2"; shift 2 ;;
            *)  shift ;;
        esac
    done

    if [[ $PWD == $HOME ]]; then
        printf "${home_color}%s${reset}\n" "$HOME"
    elif [[ $PWD == $HOME/* ]]; then
        printf "${home_color}%s/${reset}${path_color}%s${reset}\n" \
            "$HOME" "${PWD#$HOME/}"
    else
        printf "${path_color}%s${reset}\n" "$PWD"
    fi
}

pretty_status () {
    local prefix=""

    [[ "$2" == "+arrow" ]] && prefix="-> "

    if [[ $1 -eq 0 ]]; then
        printf "%s\001\e[32m\002(✓)\001\e[0m\002" "$prefix"
    else
        printf "%s\001\e[31m\002[✗]\001\e[0m\002" "$prefix"
    fi
}

PS_MIN='> '
PS_SIMPLE='\n$(longcwd)\n >\e[0m  '
PS_MAIN='\n $(longcwd -h $'\''\e[1;32m'\'' -p $'\''\e[1;35m'\'')'
    PS_MAIN+='\[\e[1;34m\] $(pretty_status $? +arrow)'
    PS_MAIN+=$'\n \[\e[1;90m\]╰─➤\[\e[0m\] \[\e[1;4;94m\]$\[\e[0m\] '

PS1="$PS_MAIN"


# ============================================
# Environment Variables
# ============================================
export VISUAL=micro
export EDITOR=fresh

# export XMAKE_PROFILE=perf:tag

# ============================================
# Tool Integrations
# ============================================


