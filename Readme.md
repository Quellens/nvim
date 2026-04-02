<img width="1285" height="380" alt="image" src="https://github.com/user-attachments/assets/f9a2f13f-db39-4f5b-b580-33ed38909e8f" />

# Shady Vim - My Neovim Setup

1. Install Neovim
2. Install a Nerd-Font (i currently use this)
```sh
font_family      JetBrainsMono Nerd Font 
```
3. Other Stuff to Install
```sh
sudo npm install -g tree-sitter-cli
sudo npm install -g markdownlint-cli
```
- fzf, yazi and lazygit should also be installed on your system


4. Clone Repo into nvim config

```sh
git clone https://github.com/Quellens/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

That's it!

### After Installation 
- `Lazy` -> Manage Plugins
- `Mason` -> Manage LSP, Linting, 
- `:TSInstall all` -> Treesitter
- Search for help with `:help`
- Checkhealth with `:checkhealth`
