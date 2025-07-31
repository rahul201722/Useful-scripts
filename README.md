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

# Run the script manually
./update_lazyvim.sh

# Or use the auto-updater (see Auto-Update Setup below)
```

#### Auto-Update Setup:
The repository includes an auto-updater that can be configured to run every 15 days. To set it up:

1. **Install the auto-updater script:**
   ```bash
   # Copy the auto-updater to your home directory
   cp .lazyvim_auto_updater.sh ~/
   chmod +x ~/.lazyvim_auto_updater.sh
   ```

2. **Add to your shell configuration:**
   
   For **Zsh** (add to `~/.zshrc`):
   ```bash
   # LazyVim Auto-Updater - runs every 15 days
   if [[ -f "$HOME/.lazyvim_auto_updater.sh" ]]; then
       ("$HOME/.lazyvim_auto_updater.sh" auto &)
   fi
   
   # Manual update function
   lazyvim-update() {
       if [[ -f "$HOME/.lazyvim_auto_updater.sh" ]]; then
           "$HOME/.lazyvim_auto_updater.sh" force
       fi
   }
   alias lvu="lazyvim-update"
   ```
   
   For **Fish** (add to `~/.config/fish/config.fish`):
   ```fish
   # LazyVim Auto-Updater - runs every 15 days
   if test -f "$HOME/.lazyvim_auto_updater.sh"
       bash "$HOME/.lazyvim_auto_updater.sh" auto &
   end
   
   # Manual update function
   function lazyvim-update
       if test -f "$HOME/.lazyvim_auto_updater.sh"
           bash "$HOME/.lazyvim_auto_updater.sh" force
       end
   end
   alias lvu="lazyvim-update"
   ```

3. **Manual commands:**
   ```bash
   lazyvim-update  # Force update now
   lvu            # Alias for lazyvim-update
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
