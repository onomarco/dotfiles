#!/usr/bin/env bash

# Git configuration
# Note: User identity (name/email) should be set in ~/.private

print_info "Configuring Git..."

# Check if git is installed
if ! command_exists git; then
    print_warning "Git not installed yet. Will be installed via Homebrew."
    return 0
fi

# Note: Basic git config is in dotfiles/.gitconfig
# That file will be symlinked to ~/.gitconfig

# Additional global git configurations
print_info "Setting additional Git configurations..."

# Use SSH instead of HTTPS for GitHub
git config --global url."git@github.com:".insteadOf "https://github.com/"

# Default branch name
git config --global init.defaultBranch main

# Pull strategy
git config --global pull.rebase false

# Push strategy
git config --global push.default simple
git config --global push.autoSetupRemote true

# Credential helper (macOS Keychain)
git config --global credential.helper osxkeychain

# Diff and merge tools
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Colors
git config --global color.ui auto
git config --global color.branch.current "yellow reverse"
git config --global color.branch.local yellow
git config --global color.branch.remote green
git config --global color.diff.meta "yellow bold"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"
git config --global color.status.added yellow
git config --global color.status.changed green
git config --global color.status.untracked cyan

print_success "Git configured successfully"
print_info ""
print_info "Remember to set your identity in ~/.private:"
print_info '  export GIT_AUTHOR_NAME="Your Name"'
print_info '  export GIT_AUTHOR_EMAIL="your.email@example.com"'
print_info ""
print_info "Or set it manually:"
print_info '  git config --global user.name "Your Name"'
print_info '  git config --global user.email "your.email@example.com"'
