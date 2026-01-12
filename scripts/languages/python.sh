#!/usr/bin/env bash

# Python installation via uv
# uv is an extremely fast Python package installer and resolver

###############################################################################
# Configuration (Extensible)                                                  #
###############################################################################

# Python versions to install (add more as needed)
PYTHON_VERSIONS=(
    "3.12"
    "3.13"
    # "3.11"  # Uncomment to install Python 3.11
)

# Default Python version
DEFAULT_PYTHON_VERSION="3.12"

# Global packages to install with uv tool (optional, add as needed)
UV_TOOLS=(
    "ruff"           # Fast Python linter
    "black"          # Code formatter
    "ipython"        # Enhanced Python shell
    "pytest"         # Testing framework
)

###############################################################################
# Installation Functions                                                      #
###############################################################################

install_uv() {
    if command_exists uv; then
        print_success "uv is already installed"
        print_info "Current version: $(uv --version)"
        print_info "Updating uv..."
        uv self update || true
        return 0
    fi

    print_info "Installing uv..."

    # Try Homebrew first (more reliable on macOS)
    if command_exists brew; then
        print_info "Installing uv via Homebrew..."
        if brew install uv; then
            print_success "uv installed successfully via Homebrew: $(uv --version)"
            return 0
        else
            print_warning "Homebrew installation failed, trying alternative method..."
        fi
    fi

    # Fallback to official installer
    print_info "Installing uv via official installer..."
    if curl -LsSf https://astral.sh/uv/install.sh | sh; then
        # Add uv to PATH
        export PATH="$HOME/.cargo/bin:$PATH"

        if command_exists uv; then
            print_success "uv installed successfully: $(uv --version)"
            return 0
        fi
    fi

    print_error "uv installation failed"
    print_info "Please try manual installation: brew install uv"
    return 1
}

install_python_versions() {
    print_info "Installing Python versions..."

    for version in "${PYTHON_VERSIONS[@]}"; do
        print_info "Installing Python $version..."
        uv python install "$version"
    done

    print_success "Python versions installed"
    print_info "Installed versions:"
    uv python list
}

set_default_python() {
    print_info "Setting Python $DEFAULT_PYTHON_VERSION as default..."

    # Note: uv uses per-project Python versions with uv.lock
    # This just ensures the version is available
    print_info "Python $DEFAULT_PYTHON_VERSION is available for projects"
    print_success "Default Python version configured"
}

install_global_tools() {
    if [ ${#UV_TOOLS[@]} -eq 0 ]; then
        print_info "No global tools configured to install"
        return 0
    fi

    print_info "Installing global tools..."

    for tool in "${UV_TOOLS[@]}"; do
        print_info "Installing $tool..."
        uv tool install "$tool"
    done

    print_success "Global tools installed"
}

###############################################################################
# Main Execution                                                              #
###############################################################################

install_uv
install_python_versions
set_default_python
install_global_tools

print_success "Python (uv) setup complete"
print_info ""
print_info "Usage examples:"
print_info "  uv python list              # List installed Python versions"
print_info "  uv python install 3.11      # Install specific version"
print_info "  uv venv                     # Create virtual environment"
print_info "  uv pip install <package>    # Install package"
print_info "  uv run python script.py     # Run script with uv"
