return {
  'akinsho/git-conflict.nvim',
  version = '*',
  -- config = true,
  config = function()
    require('git-conflict').setup {}

    vim.keymap.set('n', 'cc', '<Plug>(git-conflict-ours)')
    vim.keymap.set('n', 'ci', '<Plug>(git-conflict-theirs)')
  end,
}
