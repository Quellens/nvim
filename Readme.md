## Shady's nvim Setup
<img width="675" height="449" alt="image" src="https://github.com/user-attachments/assets/1400061b-bf93-4cdb-b471-41a12a71abd1" />

1. Treesitter
```sh
sudo npm install -g tree-sitter-cli
```
2. markdownlint-cli
```sh
sudo npm install -g markdownlint-cli
```
3. Nerdfont
I use this Font

```sh
font_family      JetBrainsMono Nerd Font 
bold_font        auto
italic_font      auto
bold_italic_font auto
```

4. Clone Repo into nvim config

```sh
git clone https://github.com/Quellens/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

### TSInstall

`:TSInstall all`


### Other plugin prerequisites
- yazi and lazygit should be installed on your system
