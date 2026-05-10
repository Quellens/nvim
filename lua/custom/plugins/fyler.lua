return {
  'A7Lavinraj/fyler.nvim',
  lazy = false,
  branch = 'stable',
  opts = {
    default_explorer = true,
    views = {
      finder = {
        win = {
          border = 'rounded',
          kinds = {
            float = {
              height = '70%',
              width = '80%',
              top = '10%',
              left = '10%',
            },
          },
        },
        indentscope = { enabled = false },
      },
    },
  },

  config = function(_, opts)
    require('mini.icons').setup()
    require('mini.icons').mock_nvim_web_devicons()
    local fyler = require 'fyler'
    fyler.setup(opts)

    vim.keymap.set('n', '<leader>e', function() fyler.toggle { kind = 'float' } end, { desc = 'Open Fyler View' })
  end,
}
