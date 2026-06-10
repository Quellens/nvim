return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    cmdline = {
      enabled = true,
    },
    messages = {
      enabled = false,
    },
    presets = {
      lsp_doc_border = true,
    },
    views = {
      hover = {
        border = {
          style = 'rounded',
        },
        position = { row = 2, col = 0 },
      },
    },
    lsp = {
      progress = {
        enabled = false,
      },
      message = {
        enabled = false,
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
