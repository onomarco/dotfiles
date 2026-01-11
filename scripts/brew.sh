#!/usr/bin/env bash

# Homebrew installation and package management

###############################################################################
# Package Lists (Extensible)                                                  #
###############################################################################

# Formulae to install
BREW_FORMULAE=(
    # Version control
    "git"
    "gh"              # GitHub CLI

    # Containers
    "docker"
    "docker-compose"

    # Network tools
    "curl"
    "wget"

    # CLI utilities
    "jq"              # JSON processor
    "tree"            # Directory visualization
    "htop"            # Process monitor
    "tmux"            # Terminal multiplexer

    # Modern CLI replacements
    "fzf"             # Fuzzy finder
    "bat"             # Better cat
    "eza"             # Better ls
    "ripgrep"         # Fast grep
    "fd"              # Better find
    "zoxide"          # Better cd

    # Development tools
    "make"
    "cmake"

    # Add more packages here as needed
)

# Casks to install (GUI applications)
BREW_CASKS=(
    # Browsers
    "google-chrome"
    "firefox"

    # Development
    "visual-studio-code"
    "sublime-text"
    "docker"
    "iterm2"

    # Claude Code
    "claude"          # Claude desktop app with Code features

    # Utilities
    "rectangle"       # Window manager (free, highly recommended)
    "google-drive"    # Google Drive for Desktop
    # "alfred"        # Productivity launcher (uncomment if you want more than Spotlight)

    # Add more casks here as needed
)

###############################################################################
# Installation Functions                                                      #
###############################################################################

install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew is already installed"
        print_info "Updating Homebrew..."
        brew update
        return 0
    fi

    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed successfully"
}

install_formulae() {
    print_info "Installing Homebrew formulae..."

    for formula in "${BREW_FORMULAE[@]}"; do
        if brew list "$formula" &>/dev/null; then
            print_success "$formula is already installed"
        else
            print_info "Installing $formula..."
            brew install "$formula"
        fi
    done

    print_success "All formulae installed"
}

install_casks() {
    print_info "Installing Homebrew casks..."

    for cask in "${BREW_CASKS[@]}"; do
        if brew list --cask "$cask" &>/dev/null; then
            print_success "$cask is already installed"
        else
            print_info "Installing $cask..."
            brew install --cask "$cask"
        fi
    done

    print_success "All casks installed"
}

cleanup_homebrew() {
    print_info "Cleaning up Homebrew..."
    brew cleanup
    print_success "Homebrew cleanup complete"
}

###############################################################################
# Main Execution                                                              #
###############################################################################

install_homebrew
install_formulae
install_casks
cleanup_homebrew

print_success "Homebrew setup complete"
