#!/usr/bin/env bash

# AWS CLI and SAM CLI installation and configuration

###############################################################################
# Configuration (Extensible)                                                  #
###############################################################################

# AWS CLI tools to install
AWS_TOOLS=(
    "awscli"           # AWS CLI v2
    "aws-sam-cli"      # SAM CLI for serverless applications
)

# AWS Environment variables (extensible)
export AWS_DEFAULT_REGION="eu-west-1"
export AWS_DEFAULT_OUTPUT="json"  # json, yaml, text, table
export AWS_PAGER=""               # Disable pager for long outputs

###############################################################################
# Installation Functions                                                      #
###############################################################################

install_aws_tools() {
    print_info "Installing AWS tools..."

    for tool in "${AWS_TOOLS[@]}"; do
        if brew list "$tool" &>/dev/null; then
            print_success "$tool is already installed"
        else
            print_info "Installing $tool..."
            brew install "$tool" || print_warning "Failed to install $tool"
        fi
    done

    # Verify installations
    if command_exists aws; then
        print_success "AWS CLI installed: $(aws --version)"
    else
        print_warning "AWS CLI not found"
    fi

    if command_exists sam; then
        print_success "SAM CLI installed: $(sam --version)"
    else
        print_warning "SAM CLI not found"
    fi
}

configure_aws_completion() {
    if ! command_exists aws; then
        print_warning "AWS CLI not installed, skipping completion setup"
        return 0
    fi

    print_info "Configuring AWS CLI completion..."

    # AWS CLI completion for zsh
    local zshrc="$HOME/.zshrc"
    local completion_line="complete -C '/opt/homebrew/bin/aws_completer' aws"

    if ! grep -q "aws_completer" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# AWS CLI completion" >> "$zshrc"
        echo "$completion_line" >> "$zshrc"
        print_success "AWS CLI completion added to .zshrc"
    else
        print_success "AWS CLI completion already configured"
    fi

    # SAM CLI completion for zsh
    if command_exists sam; then
        if ! grep -q "sam --completion" "$zshrc" 2>/dev/null; then
            echo "" >> "$zshrc"
            echo "# SAM CLI completion" >> "$zshrc"
            echo 'eval "$(sam --completion zsh)"' >> "$zshrc"
            print_success "SAM CLI completion added to .zshrc"
        else
            print_success "SAM CLI completion already configured"
        fi
    fi
}

setup_aws_config() {
    print_info "Setting up AWS configuration structure..."

    local aws_dir="$HOME/.aws"
    local config_file="$aws_dir/config"

    # Create .aws directory
    mkdir -p "$aws_dir"
    chmod 700 "$aws_dir"

    # Create config file if it doesn't exist
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << 'EOF'
[default]
region = eu-west-1
output = json

# Example SSO configuration (uncomment and configure as needed)
# [profile dev]
# sso_start_url = https://your-sso-url.awsapps.com/start
# sso_region = eu-west-1
# sso_account_id = 123456789012
# sso_role_name = DeveloperAccess
# region = eu-west-1
# output = json

# [profile prod]
# sso_start_url = https://your-sso-url.awsapps.com/start
# sso_region = eu-west-1
# sso_account_id = 987654321098
# sso_role_name = ReadOnlyAccess
# region = eu-west-1
# output = json
EOF
        print_success "AWS config file created at $config_file"
        print_info "Configure your SSO profiles in: $config_file"
    else
        print_success "AWS config file already exists"
    fi

    # Ensure credentials file exists but is empty (for SSO)
    local credentials_file="$aws_dir/credentials"
    if [ ! -f "$credentials_file" ]; then
        touch "$credentials_file"
        chmod 600 "$credentials_file"
        print_info "Created empty credentials file (use SSO instead of access keys)"
    fi
}

configure_aws_env() {
    print_info "Configuring AWS environment variables..."

    local zshrc="$HOME/.zshrc"

    # Add AWS environment variables to .zshrc
    if ! grep -q "AWS_DEFAULT_REGION" "$zshrc" 2>/dev/null; then
        cat >> "$zshrc" << 'EOF'

# AWS Configuration
export AWS_DEFAULT_REGION="eu-west-1"
export AWS_DEFAULT_OUTPUT="json"
export AWS_PAGER=""  # Disable pager for long outputs

# Uncomment to set a default profile
# export AWS_PROFILE="dev"
EOF
        print_success "AWS environment variables added to .zshrc"
    else
        print_success "AWS environment variables already configured"
    fi
}

print_aws_instructions() {
    print_success "AWS setup complete!"
    print_info ""
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_info "Next steps for AWS SSO configuration:"
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_info ""
    print_info "1. Configure your SSO profile in ~/.aws/config:"
    print_info "   [profile dev]"
    print_info "   sso_start_url = https://your-company.awsapps.com/start"
    print_info "   sso_region = eu-west-1"
    print_info "   sso_account_id = YOUR_ACCOUNT_ID"
    print_info "   sso_role_name = YOUR_ROLE_NAME"
    print_info "   region = eu-west-1"
    print_info ""
    print_info "2. Login with SSO:"
    print_info "   aws sso login --profile dev"
    print_info ""
    print_info "3. Use the profile:"
    print_info "   aws s3 ls --profile dev"
    print_info "   OR"
    print_info "   export AWS_PROFILE=dev"
    print_info "   aws s3 ls"
    print_info ""
    print_info "4. Useful aliases have been added to ~/.aliases:"
    print_info "   awswho      - Check current AWS identity"
    print_info "   awslogin    - Login to AWS SSO"
    print_info "   samb        - sam build"
    print_info "   samd        - sam deploy"
    print_info "   saml        - sam local start-api"
    print_info ""
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

###############################################################################
# Main Execution                                                              #
###############################################################################

install_aws_tools
configure_aws_completion
setup_aws_config
configure_aws_env
print_aws_instructions
