return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {},
  config = function()
    require('mini.icons').setup()
    require('mini.icons').mock_nvim_web_devicons()
    local nvimtree = require 'nvim-tree'

    nvimtree.setup {
      view = {
        -- relativenumber = true,
      },
      renderer = {
        root_folder_label = false,
        icons = {
          show = {
            git = false,
          },
        },
        indent_markers = {
          enable = true,
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      git = {
        ignore = false,
      },
    }

    -- set keymaps
    local keymap = vim.keymap

    keymap.set('n', '<leader>E', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' }) -- toggle file explorer
    keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer on current file' }) -- toggle file explorer on current file
  end,
}
