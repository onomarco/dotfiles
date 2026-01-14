# ~/.zshrc - Zsh configuration

###############################################################################
# PATH Configuration                                                          #
###############################################################################

# Homebrew (Apple Silicon)
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Python (uv)
export PATH="$HOME/.cargo/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# VS Code CLI
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

###############################################################################
# Shell Options                                                               #
###############################################################################

# Enable colors
autoload -Uz colors && colors

# Case-insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

###############################################################################
# Prompt                                                                      #
###############################################################################

# Two-line prompt with git branch and timestamp
# Line 1: username@hostname:current_directory (branch)     [HH:MM:SS]
# Line 2: $ (command input)

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git

setopt PROMPT_SUBST

# Main prompt (two lines)
PROMPT='%F{cyan}%n@%m%f: %F{yellow}%~%f%F{green}${vcs_info_msg_0_}%f'$'\n''$ '

# Right prompt with timestamp
RPROMPT='%F{240}[%D{%H:%M:%S}]%f'

###############################################################################
# Aliases                                                                     #
###############################################################################

# Source aliases file if it exists
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

###############################################################################
# Tool Configurations                                                         #
###############################################################################

# fzf - fuzzy finder
if command -v fzf &> /dev/null; then
    # Key bindings
    source <(fzf --zsh) 2>/dev/null || true

    # Use fd for fzf if available
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# zoxide - better cd
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# bat - better cat
if command -v bat &> /dev/null; then
    export BAT_THEME="TwoDark"
fi

###############################################################################
# Private Configuration                                                       #
###############################################################################

# Source private config (not in git)
# Contains sensitive data like API keys, git identity, etc.
if [ -f ~/.private ]; then
    source ~/.private
fi

###############################################################################
# Functions                                                                   #
###############################################################################

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick git add, commit, push
gacp() {
    git add .
    git commit -m "$1"
    git push
}

###############################################################################
# Welcome Message                                                             #
###############################################################################

# Show system info on new shell (optional, comment out if not needed)
# if command -v neofetch &> /dev/null; then
#     neofetch
# fi

# AWS CLI completion (zsh)
autoload -Uz bashcompinit && bashcompinit
complete -C '/opt/homebrew/bin/aws_completer' aws

# AWS Configuration
export AWS_DEFAULT_REGION="eu-west-1"
export AWS_DEFAULT_OUTPUT="json"
export AWS_PAGER=""  # Disable pager for long outputs

# Uncomment to set a default profile
# export AWS_PROFILE="dev"
