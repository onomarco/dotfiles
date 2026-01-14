#!/usr/bin/env bash

# Prerequisite checker for dotfiles installation
# Run this before executing install.sh

set -e

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source utilities
source "$DOTFILES_DIR/scripts/utils.sh"

# Track if all checks pass
ALL_CHECKS_PASSED=true

print_section "Dotfiles Installation Prerequisites"

###############################################################################
# Check 1: macOS                                                              #
###############################################################################

echo "Checking operating system..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    MACOS_VERSION=$(sw_vers -productVersion)
    print_success "macOS detected (version $MACOS_VERSION)"
else
    print_error "This script requires macOS"
    print_info "Detected OS: $OSTYPE"
    ALL_CHECKS_PASSED=false
fi
echo ""

###############################################################################
# Check 2: Xcode Command Line Tools                                          #
###############################################################################

echo "Checking Xcode Command Line Tools..."
if xcode-select -p &>/dev/null; then
    XCODE_PATH=$(xcode-select -p)
    print_success "Xcode Command Line Tools installed"
    print_info "Location: $XCODE_PATH"
else
    print_error "Xcode Command Line Tools not installed"
    print_info "Install with: xcode-select --install"
    ALL_CHECKS_PASSED=false
fi
echo ""

###############################################################################
# Check 3: Administrator Privileges                                          #
###############################################################################

echo "Checking administrator privileges..."
if sudo -n true 2>/dev/null; then
    print_success "Administrator privileges available (cached)"
else
    print_info "Testing sudo access (may prompt for password)..."
    if sudo -v; then
        print_success "Administrator privileges available"
    else
        print_error "Administrator privileges required"
        print_info "You need admin password to install software"
        ALL_CHECKS_PASSED=false
    fi
fi
echo ""

###############################################################################
# Check 4: Internet Connection                                               #
###############################################################################

echo "Checking internet connection..."
if ping -c 1 google.com &>/dev/null; then
    print_success "Internet connection active"
else
    print_error "No internet connection detected"
    print_info "Internet required to download packages"
    ALL_CHECKS_PASSED=false
fi
echo ""

###############################################################################
# Check 5: Git                                                                #
###############################################################################

echo "Checking Git..."
if command -v git &>/dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    print_success "Git installed (version $GIT_VERSION)"
else
    print_warning "Git not found (will be installed with Command Line Tools)"
fi
echo ""

###############################################################################
# Check 6: SSH Keys for GitHub                                               #
###############################################################################

echo "Checking SSH keys for GitHub..."
SSH_KEY_EXISTS=false

# Check for common SSH key types
for key_type in id_ed25519 id_rsa id_ecdsa; do
    if [ -f "$HOME/.ssh/${key_type}" ]; then
        SSH_KEY_EXISTS=true
        print_success "SSH key found: ~/.ssh/${key_type}"

        # Check if key is added to ssh-agent
        if ssh-add -l &>/dev/null | grep -q "$key_type"; then
            print_info "Key is loaded in ssh-agent"
        else
            print_warning "Key not loaded in ssh-agent (will be configured during install)"
        fi
        break
    fi
done

if [ "$SSH_KEY_EXISTS" = false ]; then
    print_warning "No SSH keys found in ~/.ssh/"
    print_info "SSH keys will be generated during installation"
    print_info "Or generate manually: ssh-keygen -t ed25519 -C \"your@email.com\""
fi

# Test GitHub SSH connection (only if key exists)
if [ "$SSH_KEY_EXISTS" = true ]; then
    print_info "Testing GitHub SSH connection..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_success "GitHub SSH authentication working"
    else
        print_warning "GitHub SSH not configured yet"
        print_info "After installation, add your public key to: https://github.com/settings/keys"
    fi
fi
echo ""

###############################################################################
# Optional Checks                                                             #
###############################################################################

echo "Optional checks:"

# Check if Homebrew is already installed
if command -v brew &>/dev/null; then
    BREW_VERSION=$(brew --version | head -n1 | cut -d' ' -f2)
    print_info "Homebrew already installed (version $BREW_VERSION)"
    print_warning "The script will update it"
else
    print_info "Homebrew not installed (will be installed by script)"
fi

# Check available disk space
AVAILABLE_SPACE=$(df -h / | awk 'NR==2 {print $4}')
print_info "Available disk space: $AVAILABLE_SPACE"
print_warning "Recommended: at least 10GB free"

echo ""

###############################################################################
# Summary                                                                     #
###############################################################################

print_section "Summary"

if [ "$ALL_CHECKS_PASSED" = true ]; then
    print_success "All prerequisites met!"
    echo ""
    print_info "You can now run the installation:"
    print_info "  ./install.sh"
else
    print_error "Some prerequisites are missing"
    echo ""
    print_warning "Please fix the issues above before running install.sh"
    echo ""
    print_info "Quick fixes:"
    print_info "  1. Install Command Line Tools: xcode-select --install"
    print_info "  2. Ensure you have admin access"
    print_info "  3. Connect to the internet"
fi
echo ""

# Exit with appropriate code
if [ "$ALL_CHECKS_PASSED" = true ]; then
    exit 0
else
    exit 1
fi
