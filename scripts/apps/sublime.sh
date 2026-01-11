#!/usr/bin/env bash

# Sublime Text configuration and packages

###############################################################################
# Packages List (Extensible)                                                  #
###############################################################################

# Sublime Text packages to install via Package Control
# Add package names here as you discover useful ones
SUBLIME_PACKAGES=(
    # "LSP"                      # Language Server Protocol support
    # "LSP-pyright"              # Python LSP
    # "GoSublime"                # Go support
    # "SideBarEnhancements"      # Enhanced sidebar
    # "GitGutter"                # Git diff in gutter
    # "Terminus"                 # Terminal in Sublime
    # "A File Icon"              # Better file icons
    # "BracketHighlighter"       # Bracket matching
    # "SublimeLinter"            # Linting framework
)

###############################################################################
# Installation Functions                                                      #
###############################################################################

check_sublime() {
    # Check if Sublime Text CLI is available
    if command_exists subl; then
        return 0
    fi

    # Check if Sublime Text app exists
    if [ -d "/Applications/Sublime Text.app" ]; then
        print_info "Sublime Text app found, but 'subl' command not in PATH"
        print_info "Adding 'subl' command to PATH..."

        # Create symlink for subl command
        sudo ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl 2>/dev/null || true

        if command_exists subl; then
            return 0
        fi
    fi

    return 1
}

install_package_control() {
    if ! check_sublime; then
        print_warning "Sublime Text not installed. It will be installed via Homebrew."
        return 0
    fi

    local package_control_dir="$HOME/Library/Application Support/Sublime Text/Installed Packages"
    local package_control_file="$package_control_dir/Package Control.sublime-package"

    if [ -f "$package_control_file" ]; then
        print_success "Package Control is already installed"
        return 0
    fi

    print_info "Installing Package Control..."

    mkdir -p "$package_control_dir"

    curl -fsSL "https://packagecontrol.io/Package%20Control.sublime-package" \
        -o "$package_control_file"

    if [ -f "$package_control_file" ]; then
        print_success "Package Control installed"
    else
        print_error "Failed to install Package Control"
        return 1
    fi
}

install_packages() {
    if ! check_sublime; then
        print_warning "Sublime Text not installed yet"
        return 0
    fi

    if [ ${#SUBLIME_PACKAGES[@]} -eq 0 ]; then
        print_info "No Sublime Text packages configured to install"
        print_info "Add packages to SUBLIME_PACKAGES array in scripts/apps/sublime.sh"
        return 0
    fi

    print_info "Sublime Text packages must be installed manually via Package Control:"
    print_info "  1. Open Sublime Text"
    print_info "  2. Press Cmd+Shift+P"
    print_info "  3. Type 'Install Package' and press Enter"
    print_info "  4. Search and install these packages:"
    echo ""
    for package in "${SUBLIME_PACKAGES[@]}"; do
        echo "     - $package"
    done
    echo ""
}

configure_sublime() {
    if ! check_sublime; then
        return 0
    fi

    print_info "Sublime Text settings can be customized manually"
    print_info "Settings location: ~/Library/Application Support/Sublime Text/Packages/User/"
    print_info ""
    print_info "You can add custom settings, keybindings, and snippets there"

    # You can add custom configuration here if needed
    # Example: copy settings files from a configs directory
}

###############################################################################
# Main Execution                                                              #
###############################################################################

check_sublime
install_package_control
install_packages
configure_sublime

print_success "Sublime Text setup complete"
print_info ""
if command_exists subl; then
    print_info "Launch Sublime Text with: subl ."
else
    print_warning "Sublime Text CLI not available yet"
    print_info "After installation, you may need to run this script again"
fi
