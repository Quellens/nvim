return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = function()
      return {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      }
    end,
  },
}
