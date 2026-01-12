#!/usr/bin/env bash

# SSH configuration for GitHub and other services

print_info "Configuring SSH..."

# Create .ssh directory if it doesn't exist
SSH_DIR="$HOME/.ssh"
if [ ! -d "$SSH_DIR" ]; then
    print_info "Creating $SSH_DIR directory..."
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Check if SSH key already exists
SSH_KEY_EXISTS=false
KEY_TYPE=""
KEY_PATH=""

for key in id_ed25519 id_rsa id_ecdsa; do
    if [ -f "$SSH_DIR/$key" ]; then
        SSH_KEY_EXISTS=true
        KEY_TYPE=$key
        KEY_PATH="$SSH_DIR/$key"
        print_success "Found existing SSH key: $key"
        break
    fi
done

# Generate SSH key if none exists
if [ "$SSH_KEY_EXISTS" = false ]; then
    print_warning "No SSH key found. Generating new SSH key..."

    # Get email from git config or .private
    EMAIL=""
    if [ -f "$HOME/.private" ]; then
        EMAIL=$(grep "GIT_AUTHOR_EMAIL" "$HOME/.private" | cut -d'"' -f2 2>/dev/null)
    fi

    if [ -z "$EMAIL" ]; then
        EMAIL=$(git config --global user.email 2>/dev/null)
    fi

    if [ -z "$EMAIL" ]; then
        echo ""
        print_warning "═══════════════════════════════════════════════════════════"
        print_warning "  SSH Key Generation - Email Required"
        print_warning "═══════════════════════════════════════════════════════════"
        echo ""
        print_info "Please enter your email address for the SSH key:"
        echo -n "> "
        read -r EMAIL
        echo ""
    fi

    if [ -z "$EMAIL" ]; then
        print_error "Email is required to generate SSH key"
        print_info "You can skip SSH configuration and generate it later with:"
        print_info "  ssh-keygen -t ed25519 -C \"your@email.com\""
        print_warning "Skipping SSH configuration..."
        return 0
    fi

    # Generate ed25519 key (recommended by GitHub)
    print_info "Generating SSH key with email: $EMAIL"
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_DIR/id_ed25519" -N ""

    KEY_TYPE="id_ed25519"
    KEY_PATH="$SSH_DIR/id_ed25519"
    print_success "SSH key generated: $KEY_PATH"
fi

# Set proper permissions
chmod 600 "$KEY_PATH"
chmod 644 "${KEY_PATH}.pub"

# Configure SSH config file
SSH_CONFIG="$SSH_DIR/config"
print_info "Configuring SSH config..."

# Backup existing config if it exists
if [ -f "$SSH_CONFIG" ]; then
    backup_file "$SSH_CONFIG"
fi

# Create SSH config with GitHub settings
cat > "$SSH_CONFIG" << 'EOF'
# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
    UseKeychain yes

# GitLab (uncomment if needed)
# Host gitlab.com
#     HostName gitlab.com
#     User git
#     IdentityFile ~/.ssh/id_ed25519
#     AddKeysToAgent yes
#     UseKeychain yes

# Bitbucket (uncomment if needed)
# Host bitbucket.org
#     HostName bitbucket.org
#     User git
#     IdentityFile ~/.ssh/id_ed25519
#     AddKeysToAgent yes
#     UseKeychain yes

# Default settings for all hosts
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentitiesOnly yes
EOF

chmod 600 "$SSH_CONFIG"
print_success "SSH config created: $SSH_CONFIG"

# Start ssh-agent and add key
print_info "Adding SSH key to ssh-agent..."

# Start ssh-agent if not running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Add key to ssh-agent
ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null || ssh-add "$KEY_PATH"
print_success "SSH key added to ssh-agent"

# Display public key
echo ""
print_success "SSH configuration complete!"
echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_info "Your SSH public key (copy this to GitHub):"
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
cat "${KEY_PATH}.pub"
echo ""
print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_warning "To add this key to GitHub:"
print_info "  1. Copy the key above"
print_info "  2. Go to: https://github.com/settings/keys"
print_info "  3. Click 'New SSH key'"
print_info "  4. Paste your key and save"
echo ""
print_info "Or copy to clipboard with:"
print_info "  pbcopy < ${KEY_PATH}.pub"
echo ""
print_info "Test connection with:"
print_info "  ssh -T git@github.com"
echo ""
