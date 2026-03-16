return {
  'erl-koenig/theme-hub.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'rktjmp/lush.nvim',
  },
  config = function()
    require('theme-hub').setup {
      -- Configuration options (see below)
      persistent = true,
    }
    vim.keymap.set('n', '<leader>c', '<cmd>ThemeHub<CR>', { desc = '[C]olor Themes' })
  end,
}
