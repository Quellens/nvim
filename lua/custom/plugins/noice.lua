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
