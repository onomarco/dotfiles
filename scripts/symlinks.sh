#!/usr/bin/env bash

# Create symlinks for dotfiles

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_SOURCE="$DOTFILES_DIR/dotfiles"

print_info "Creating symlinks for dotfiles..."
print_info "Source: $DOTFILES_SOURCE"
print_info "Target: $HOME"

# Array of dotfiles to symlink (filename in dotfiles/ -> target in $HOME)
DOTFILES=(
    ".zshrc"
    ".aliases"
    ".gitconfig"
    ".gitignore_global"
    ".editorconfig"
)

# Create symlinks
for dotfile in "${DOTFILES[@]}"; do
    source_file="$DOTFILES_SOURCE/$dotfile"
    target_file="$HOME/$dotfile"

    if [ ! -f "$source_file" ]; then
        print_warning "Source file not found: $source_file (skipping)"
        continue
    fi

    create_symlink "$source_file" "$target_file"
done

print_success "Symlinks created successfully"
print_info "Dotfiles are now managed from: $DOTFILES_DIR"
