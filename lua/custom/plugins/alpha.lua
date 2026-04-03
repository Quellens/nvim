return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set header
    dashboard.section.header.val = {
      '███████╗██╗  ██╗ █████╗ ██████╗ ██╗   ██╗██╗   ██╗██╗███╗   ███╗',
      '██╔════╝██║  ██║██╔══██╗██╔══██╗ ██╗ ██╔╝██║   ██║██║████╗ ████║',
      '███████╗███████║███████║██║  ██║  ████╔╝ ██║   ██║██║██╔████╔██║',
      '╚════██║██╔══██║██╔══██║██║  ██║   ██║    ██╗ ██╔╝██║██║╚██╔╝██║',
      '███████║██║  ██║██║  ██║██████╔╝   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║',
      '╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝',
      '                  My neovim config - have fun!                  ',
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button('n', '  New File', '<cmd>ene<CR>'),
      dashboard.button('f', '󰱼  Find File', '<cmd>Telescope find_files<CR>'),
      dashboard.button('g', '  Live Grep', '<cmd>Telescope live_grep<CR>'),
      dashboard.button('o', '  Open Session', '<cmd>AutoSession search<CR>'),
      dashboard.button('d', '🗑 Delete Session', '<cmd>AutoSession deletePicker<CR>'),
      dashboard.button('r', '   Recent', ':Telescope oldfiles<CR>'),
      dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<CR>'),
      dashboard.button('m', '󰿘  Mason', '<cmd>Mason<CR>'),
      dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
    }

    dashboard.section.footer.val = {
      'stay tru 真',
    }
    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  end,
}
