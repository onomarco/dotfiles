#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source utilities
source "$DOTFILES_DIR/scripts/utils.sh"

# Check if running on macOS
check_macos

print_section "Starting dotfiles installation"

print_warning "This script will:"
print_warning "  - Install Homebrew and packages"
print_warning "  - Configure macOS system settings"
print_warning "  - Install Python (uv), Go, and Bun"
print_warning "  - Configure Git, VS Code, and Sublime Text"
print_warning "  - Create symlinks for dotfiles (backing up existing files)"
echo ""
print_warning "Existing files will be backed up with .backup extension"
echo ""

# Run installation scripts in order
print_section "1. Installing Homebrew and packages"
source "$DOTFILES_DIR/scripts/brew.sh"

print_section "2. Configuring macOS settings"
source "$DOTFILES_DIR/scripts/macos.sh"

print_section "3. Installing Python (uv)"
source "$DOTFILES_DIR/scripts/languages/python.sh"

print_section "4. Installing Go"
source "$DOTFILES_DIR/scripts/languages/golang.sh"

print_section "5. Installing Bun"
source "$DOTFILES_DIR/scripts/languages/bun.sh"

print_section "6. Configuring Git"
source "$DOTFILES_DIR/scripts/apps/git.sh"

print_section "7. Configuring VS Code"
source "$DOTFILES_DIR/scripts/apps/vscode.sh"

print_section "8. Configuring Sublime Text"
source "$DOTFILES_DIR/scripts/apps/sublime.sh"

print_section "9. Creating symlinks for dotfiles"
source "$DOTFILES_DIR/scripts/symlinks.sh"

# Final steps
print_section "Installation complete!"

print_success "All done!"
echo ""
print_info "Next steps:"
print_info "  1. Copy .private.example to ~/.private and fill with your data:"
print_info "     cp $DOTFILES_DIR/.private.example ~/.private"
print_info "  2. Restart your terminal or run: source ~/.zshrc"
print_info "  3. Verify installations:"
print_info "     uv --version"
print_info "     go version"
print_info "     bun --version"
echo ""
print_warning "Some macOS settings may require a logout/restart to take effect"
