return {
  'mikavilpas/yazi.nvim',
  version = '*', -- use the latest stable version
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  keys = {
    {
      '<leader>y',
      mode = { 'n', 'v' },
      '<cmd>Yazi<cr>',
      desc = 'Yazi at the current file',
    },
    {
      '<leader>Y',
      '<cmd>Yazi cwd<cr>',
      desc = 'Yazi in current working directory',
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
  },
  init = function() vim.g.loaded_netrwPlugin = 1 end,
}
