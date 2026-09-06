return {
  'chrisgrieser/nvim-chainsaw',
  event = 'VeryLazy',
  opts = {}, -- required even if left empty

  config = function()
    local chainsaw = require 'chainsaw'
    chainsaw.setup {}
    vim.keymap.set('n', '<leader>v', chainsaw.variableLog, { desc = 'Log Variable' })
    vim.keymap.set('n', '<leader>V', chainsaw.removeLogs, { desc = 'Remove all Logs' })
  end,
}
