#!/usr/bin/env bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
}

# Ask for confirmation
confirm() {
    local prompt="$1"
    local response

    read -r -p "$prompt [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Backup file if it exists
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -L "$file" ]; then
        local backup="${file}.backup"
        print_info "Backing up $file to $backup"
        mv "$file" "$backup"
    fi
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ]; then
            local current_source=$(readlink "$target")
            if [ "$current_source" == "$source" ]; then
                print_success "Symlink already exists: $target -> $source"
                return 0
            fi
        fi
        backup_file "$target"
    fi

    ln -s "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

# Check if script is being run from the correct directory
check_dotfiles_dir() {
    if [ ! -f "install.sh" ]; then
        print_error "Please run this script from the dotfiles directory"
        exit 1
    fi
}

# Get absolute path of dotfiles directory
get_dotfiles_dir() {
    cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}
