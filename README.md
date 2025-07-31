# Useful Scripts

A collection of useful scripts for various development tasks.

## Scripts

### 🚀 LazyVim Update Script (`update_lazyvim.sh`)

A comprehensive bash script to update all LazyVim dependencies including plugins, language servers, formatters, linters, and system packages.

#### Features:
- ✅ Updates LazyVim starter template (if using git-based config)
- ✅ Updates all Neovim plugins via Lazy.nvim
- ✅ Updates Mason packages (LSPs, formatters, linters)
- ✅ Updates Treesitter parsers
- ✅ Updates system packages (npm, pip, cargo, homebrew)
- ✅ Performs cleanup and health checks
- ✅ Colored output for better readability
- ✅ Error handling and graceful degradation

#### Usage:
```bash
# Make executable (if not already)
chmod +x update_lazyvim.sh

# Run the script
./update_lazyvim.sh
```

#### Requirements:
- Neovim with LazyVim configuration
- Git (for LazyVim starter updates)
- Optional: npm, pip, cargo, homebrew (for additional package updates)

#### What it updates:
1. **LazyVim Core**: Updates the starter template if your config is a git repository
2. **Plugins**: All Neovim plugins managed by Lazy.nvim
3. **Language Servers**: LSPs installed via Mason
4. **Tools**: Formatters and linters via Mason
5. **Parsers**: Treesitter parsers for syntax highlighting
6. **System Packages**: Global npm, pip, cargo, and homebrew packages
7. **Cleanup**: Removes unused plugins and runs health checks

The script is designed to be safe and will continue running even if some tools aren't available, showing warnings for missing components without failing completely.

---

## Contributing

Feel free to contribute more useful scripts by creating a pull request!

## License

This repository is open source and available under the [MIT License](LICENSE).
