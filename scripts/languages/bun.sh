#!/usr/bin/env bash

# Bun installation and configuration
# Bun is an all-in-one JavaScript runtime & toolkit
# Designed as a drop-in replacement for Node.js

###############################################################################
# Configuration (Extensible)                                                  #
###############################################################################

# Global packages to install with Bun (add more as needed)
BUN_GLOBAL_PACKAGES=(
    # "typescript"      # TypeScript compiler
    # "@biomejs/biome"  # Fast formatter/linter
    # "prettier"        # Code formatter
)

###############################################################################
# Installation Functions                                                      #
###############################################################################

install_bun() {
    if command_exists bun; then
        print_success "Bun is already installed"
        print_info "Current version: $(bun --version)"
        print_info "Upgrading Bun..."
        bun upgrade || true
        return 0
    fi

    print_info "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash

    # Add Bun to PATH
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # Source the shell config to get bun in PATH
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc" 2>/dev/null || true
    fi

    if command_exists bun; then
        print_success "Bun installed successfully: $(bun --version)"
    else
        print_error "Bun installation failed"
        return 1
    fi
}

configure_bun() {
    print_info "Configuring Bun..."

    # Bun installs to ~/.bun by default
    export BUN_INSTALL="$HOME/.bun"

    print_success "Bun configured"
    print_info "BUN_INSTALL: $BUN_INSTALL"
}

install_global_packages() {
    if ! command_exists bun; then
        print_warning "Bun not installed, skipping global packages"
        return 0
    fi

    if [ ${#BUN_GLOBAL_PACKAGES[@]} -eq 0 ]; then
        print_info "No global packages configured to install"
        return 0
    fi

    print_info "Installing global packages..."

    for package in "${BUN_GLOBAL_PACKAGES[@]}"; do
        print_info "Installing $package..."
        bun add -g "$package" || print_warning "Failed to install $package"
    done

    print_success "Global packages installed"
}

###############################################################################
# Main Execution                                                              #
###############################################################################

install_bun
configure_bun
install_global_packages

print_success "Bun setup complete"
print_info ""
print_info "Bun capabilities:"
print_info "  - JavaScript/TypeScript runtime (replaces Node.js)"
print_info "  - Package manager (replaces npm/yarn/pnpm)"
print_info "  - Bundler (replaces webpack/vite)"
print_info "  - Test runner (replaces jest/vitest)"
print_info ""
print_info "Usage examples:"
print_info "  bun run script.ts          # Run TypeScript directly"
print_info "  bun install                # Install dependencies"
print_info "  bun add <package>          # Add package"
print_info "  bun test                   # Run tests"
print_info "  bun build ./index.ts       # Bundle for production"
