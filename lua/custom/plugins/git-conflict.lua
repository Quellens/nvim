return {
  'akinsho/git-conflict.nvim',
  version = '*',
  -- config = true,
  config = function()
    require('git-conflict').setup {}

    vim.keymap.set('n', 'cC', '<Plug>(git-conflict-ours)')
    vim.keymap.set('n', 'cI', '<Plug>(git-conflict-theirs)')
  end,
}
