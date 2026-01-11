#!/usr/bin/env bash

# Go (Golang) installation and configuration

###############################################################################
# Configuration (Extensible)                                                  #
###############################################################################

# Go packages/tools to install (add more as needed)
GO_TOOLS=(
    "golang.org/x/tools/gopls@latest"              # Go language server
    "golang.org/x/tools/cmd/goimports@latest"      # Auto-import tool
    "github.com/go-delve/delve/cmd/dlv@latest"     # Debugger
    "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"  # Linter
)

# Go environment variables (extensible)
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

###############################################################################
# Installation Functions                                                      #
###############################################################################

install_go() {
    if command_exists go; then
        print_success "Go is already installed"
        print_info "Current version: $(go version)"
        return 0
    fi

    print_info "Go will be installed via Homebrew (from brew.sh)"
    print_info "If not installed yet, it will be installed during brew phase"

    # Verify installation
    if command_exists go; then
        print_success "Go installed: $(go version)"
    else
        print_warning "Go not found. Make sure it's in BREW_FORMULAE in brew.sh"
    fi
}

configure_go_env() {
    print_info "Configuring Go environment..."

    # Create GOPATH directory structure
    mkdir -p "$GOPATH"/{bin,src,pkg}
    print_success "GOPATH configured: $GOPATH"

    # Display Go environment
    if command_exists go; then
        print_info "Go environment:"
        go env | grep -E "GOPATH|GOROOT|GOBIN" || true
    fi
}

install_go_tools() {
    if ! command_exists go; then
        print_warning "Go not installed, skipping tools installation"
        return 0
    fi

    if [ ${#GO_TOOLS[@]} -eq 0 ]; then
        print_info "No Go tools configured to install"
        return 0
    fi

    print_info "Installing Go tools..."

    for tool in "${GO_TOOLS[@]}"; do
        print_info "Installing $tool..."
        go install "$tool" || print_warning "Failed to install $tool"
    done

    print_success "Go tools installed"
}

###############################################################################
# Main Execution                                                              #
###############################################################################

install_go
configure_go_env
install_go_tools

print_success "Go setup complete"
print_info ""
print_info "Go paths:"
print_info "  GOPATH: $GOPATH"
print_info "  GOBIN:  $GOBIN"
print_info ""
print_info "Make sure to add to your PATH in .zshrc:"
print_info '  export PATH="$HOME/go/bin:$PATH"'
