#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source configs
BASH_CONFIG_DIR="$HOME/.config/bashrc.d"
if [ -d "$BASH_CONFIG_DIR" ]; then
    source "$BASH_CONFIG_DIR/constants.sh"
    source "$BASH_CONFIG_DIR/init.sh"
    source "$BASH_CONFIG_DIR/defines.sh"
    source "$BASH_CONFIG_DIR/functions.sh"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/ziya/.lmstudio/bin"
# End of LM Studio CLI section


# Created by `pipx` on 2026-08-23 22:53:31
export PATH="$PATH:/home/ziya/.local/bin"
