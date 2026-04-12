return {
  'rmagatti/auto-session',
  dependencies = { 'romgrk/barbar.nvim' },
  lazy = false,
  config = function()
    -- local nvim_tree_api = require 'nvim-tree.api'
    -- nvim_tree_api.tree.open()
    -- nvim_tree_api.tree.change_root(vim.fn.getcwd())
    -- nvim_tree_api.tree.reload()
    local auto_session = require 'auto-session'

    auto_session.setup {
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    local keymap = vim.keymap
    keymap.set('n', '<leader>fa', '<cmd>AutoSession search<CR>', { desc = 'Search AutoSessions' })
    -- keymap.set('n', '<leader>ar', '<cmd>AutoSession restore<CR>', { desc = 'Restore session for cwd' })
    -- keymap.set('n', '<leader>as', '<cmd>AutoSession save<CR>', { desc = 'Save session for auto session root dir' })
  end,
}
