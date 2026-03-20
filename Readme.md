## Shady's nvim Setup

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
