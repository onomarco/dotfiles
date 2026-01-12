#!/usr/bin/env bash

# VS Code configuration and extensions

###############################################################################
# Extensions List (Extensible)                                                #
###############################################################################

VSCODE_EXTENSIONS=(
    # Python
    "ms-python.python"                      # Python extension
    "ms-python.vscode-pylance"             # Pylance
    "ms-python.pylint"                     # Pylint
    "ms-python.debugpy"                    # Python Debugger
    "donjayamanne.python-environment-manager"  # Python Environment Manager

    # Go
    "golang.go"                            # Go extension

    # JavaScript/TypeScript
    # "dbaeumer.vscode-eslint"             # ESLint (uncomment if needed)
    # "esbenp.prettier-vscode"             # Prettier (uncomment if needed)

    # General development
    "editorconfig.editorconfig"            # EditorConfig support
    "eamodio.gitlens"                      # GitLens
    "github.copilot"                       # GitHub Copilot (if you have access)

    # Utilities
    # "streetsidesoftware.code-spell-checker"  # Spell checker (uncomment if needed)
    # "wayou.vscode-todo-highlight"            # TODO highlight (uncomment if needed)

    # Add more extensions here as needed
)

###############################################################################
# Configuration                                                               #
###############################################################################

# VS Code settings (optional, can be extended)
# Settings are typically stored in ~/Library/Application Support/Code/User/settings.json
# You can manage them manually or add configuration here

###############################################################################
# Installation Functions                                                      #
###############################################################################

check_vscode() {
    # Check if VS Code CLI is available
    if command_exists code; then
        return 0
    fi

    # Check if VS Code app exists
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        print_info "VS Code app found, but 'code' command not in PATH"
        print_info "Adding 'code' command to PATH..."

        # This is typically done automatically, but just in case
        cat << 'EOF' >> ~/.zshrc

# VS Code CLI
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF
        export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        return 0
    fi

    return 1
}

install_extensions() {
    if ! check_vscode; then
        print_warning "VS Code not installed. It will be installed via Homebrew."
        print_info "Run this script again after VS Code is installed to add extensions"
        return 0
    fi

    print_info "Installing VS Code extensions..."

    local installed_extensions=$(code --list-extensions 2>/dev/null)

    for extension in "${VSCODE_EXTENSIONS[@]}"; do
        if echo "$installed_extensions" | grep -qi "^${extension}$"; then
            print_success "$extension is already installed"
        else
            print_info "Installing $extension..."
            code --install-extension "$extension" --force || print_warning "Failed to install $extension"
        fi
    done

    print_success "VS Code extensions installed"
}

configure_vscode() {
    print_info "VS Code settings can be customized manually or synced via Settings Sync"
    print_info "Settings location: ~/Library/Application Support/Code/User/settings.json"

    # You can add custom settings here if needed
    # Example:
    # local settings_file="$HOME/Library/Application Support/Code/User/settings.json"
    # if [ ! -f "$settings_file" ]; then
    #     mkdir -p "$(dirname "$settings_file")"
    #     echo '{}' > "$settings_file"
    # fi
}

###############################################################################
# Main Execution                                                              #
###############################################################################

install_extensions
configure_vscode

print_success "VS Code setup complete"
print_info ""
print_info "Installed extensions:"
if command_exists code; then
    code --list-extensions | head -20
    total=$(code --list-extensions | wc -l)
    print_info "Total: $total extensions"
else
    print_warning "VS Code CLI not available yet"
fi
