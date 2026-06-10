return {
  'echaya/neowiki.nvim',
  enabled = false,
  opts = {
    wiki_dirs = {
      -- neowiki.nvim supports both absolute and tilde-expanded paths
      -- { name = 'Work', path = '~/work/wiki' },
      { name = 'Personal', path = '/home/joelshady/Dokumente/Export-da04320e-ad9a-4117-ad97-15bd02b7919d' },
    },
  },
  keys = {
    { '<leader>ww', "<cmd>lua require('neowiki').open_wiki()<cr>", desc = 'Open Wiki' },
    { '<leader>wW', "<cmd>lua require('neowiki').open_wiki_floating()<cr>", desc = 'Open Wiki in Floating Window' },
    { '<leader>wT', "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>", desc = 'Open Wiki in Tab' },
  },
}
