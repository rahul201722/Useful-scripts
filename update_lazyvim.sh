#!/bin/bash

# LazyVim Dependencies Update Script
# This script updates LazyVim, plugins, language servers, and related tools

set -e  # Exit on any error

echo "🚀 Starting LazyVim Dependencies Update..."
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    print_error "Neovim is not installed or not in PATH"
    exit 1
fi

print_status "Found Neovim version: $(nvim --version | head -1)"

# 1. Update LazyVim starter template (if using the starter)
print_status "Checking for LazyVim starter updates..."
LAZYVIM_CONFIG_DIR="$HOME/.config/nvim"

if [ -d "$LAZYVIM_CONFIG_DIR/.git" ]; then
    print_status "Updating LazyVim starter template..."
    cd "$LAZYVIM_CONFIG_DIR"
    git fetch origin
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || print_warning "Could not pull LazyVim starter updates"
    print_success "LazyVim starter template updated"
else
    print_warning "LazyVim config directory is not a git repository. Skipping starter update."
fi

# 2. Update Neovim plugins via Lazy.nvim
print_status "Updating Neovim plugins..."
nvim --headless "+Lazy! sync" +qa
print_success "Neovim plugins updated"

# 3. Update Mason packages (language servers, formatters, linters)
print_status "Updating Mason packages..."
nvim --headless "+MasonUpdate" +qa 2>/dev/null || print_warning "MasonUpdate command not available"
nvim --headless "+MasonToolsUpdate" +qa 2>/dev/null || print_warning "MasonToolsUpdate command not available"

# Alternative Mason update approach
print_status "Updating all Mason packages individually..."
nvim --headless -c "lua require('mason-registry').refresh()" -c "lua local registry = require('mason-registry'); for _, pkg in ipairs(registry.get_installed_packages()) do pkg:check_new_version(function(success, result) if success and result.can_update then pkg:install():once('closed', function() print('Updated ' .. pkg.name) end) end end) end" -c "sleep 5" -c "qa!" 2>/dev/null || print_warning "Could not update Mason packages automatically"

print_success "Mason packages update initiated"

# 4. Update Treesitter parsers
print_status "Updating Treesitter parsers..."
nvim --headless "+TSUpdate" +qa
print_success "Treesitter parsers updated"

# 5. Update Node.js packages (if using Node-based language servers)
if command -v npm &> /dev/null; then
    print_status "Updating global npm packages..."
    npm update -g
    print_success "Global npm packages updated"
else
    print_warning "npm not found. Skipping npm package updates."
fi

# 6. Update Python packages (if using Python-based tools)
if command -v pip &> /dev/null; then
    print_status "Updating Python packages..."
    pip list --outdated --format=json | jq -r '.[] | .name' | xargs -I {} pip install --upgrade {} 2>/dev/null || print_warning "Could not update all Python packages"
    print_success "Python packages updated"
else
    print_warning "pip not found. Skipping Python package updates."
fi

# 7. Update Rust tools (if using Rust-based tools)
if command -v cargo &> /dev/null; then
    print_status "Updating Rust tools..."
    cargo install-update -a 2>/dev/null || print_warning "cargo-update not installed. Install with: cargo install cargo-update"
else
    print_warning "cargo not found. Skipping Rust tool updates."
fi

# 8. Update Homebrew packages (macOS)
if command -v brew &> /dev/null; then
    print_status "Updating Homebrew packages..."
    brew update
    brew upgrade
    print_success "Homebrew packages updated"
else
    print_warning "Homebrew not found. Skipping Homebrew updates."
fi

# 9. Clean up
print_status "Cleaning up..."
nvim --headless "+Lazy! clean" +qa
print_success "Lazy.nvim cleanup completed"

# 10. Health check
print_status "Running Neovim health check..."
nvim --headless "+checkhealth" "+write! /tmp/nvim_health.log" +qa
if [ -f "/tmp/nvim_health.log" ]; then
    print_status "Health check completed. Check /tmp/nvim_health.log for details."
    # Show any errors or warnings from health check
    if grep -i "error\|warning\|fail" /tmp/nvim_health.log &> /dev/null; then
        print_warning "Some health check issues found:"
        grep -i "error\|warning\|fail" /tmp/nvim_health.log | head -10
    fi
else
    print_warning "Could not generate health check log"
fi

echo ""
print_success "LazyVim dependencies update completed!"
echo "========================================"
echo ""
print_status "Summary of updates:"
echo "  ✅ LazyVim starter template"
echo "  ✅ Neovim plugins (Lazy.nvim)"
echo "  ✅ Mason packages (LSPs, formatters, linters)"
echo "  ✅ Treesitter parsers"
echo "  ✅ System package managers (npm, pip, cargo, brew)"
echo "  ✅ Cleanup and health check"
echo ""
print_status "Restart Neovim to ensure all updates are loaded properly."
