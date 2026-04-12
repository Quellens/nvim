return {
  'rmagatti/auto-session',
  dependencies = { 'romgrk/barbar.nvim' },
  lazy = false,
  config = function()
    local auto_session = require 'auto-session'

    -- nur auto-restore aktivieren, wenn keine CLI-Args übergeben wurden
    local enable_auto_restore = vim.fn.argc() == 0

    auto_session.setup {
      auto_restore_enabled = enable_auto_restore,
      auto_session_suppress_dirs = { '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function()
        if not enable_auto_restore then return end
      end,
    })
  end,
}
