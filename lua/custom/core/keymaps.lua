-- keymaps for buffers / navigation
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- safe buffer
vim.keymap.set('n', '<leader>w', '<Cmd>w<CR>')
-- Close buffer
map('n', '<leader>q', '<Cmd>BufferClose<CR>', opts)
map('n', '<leader>Q', '<Cmd>BufferClose!<CR>', opts)

vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window

-- resize windows
vim.keymap.set('n', '<M-t>', '<c-w>+')
vim.keymap.set('n', '<M-s>', '<c-w>-')
vim.keymap.set('n', '<M-,>', '<c-w>5<')
vim.keymap.set('n', '<M-.>', '<c-w>5>')

-- Move to previous/next
map('n', 'H', '<Cmd>BufferPrevious<CR>', opts)
map('n', 'L', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<A-h>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A-l>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

-- Quick Close (AltGr + x)
map('n', '«', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', opts)

-- Lazy and Mason
map('n', '<leader>L', '<Cmd>Lazy<CR>', opts)
map('n', '<leader>M', '<Cmd>Mason<CR>', opts)

-- Restart
map('n', 'ZR', '<cmd>AutoSession save<CR><Cmd>restart<CR>', opts)

-- Escape Terminal mode
map('t', '<esc><esc>', '<C-\\><C-n>', opts)

local function close_and_open_git_changes()
  local git_files = {}

  local handle = io.popen 'git diff --name-only --diff-filter=ADMRCU'
  if handle then
    for line in handle:lines() do
      table.insert(git_files, line)
    end
    handle:close()
  end

  handle = io.popen 'git ls-files --others --exclude-standard'
  if handle then
    for line in handle:lines() do
      table.insert(git_files, line)
    end
    handle:close()
  end

  local pinned_set = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local ok, pinned = pcall(vim.api.nvim_buf_get_var, buf, 'barbar_pin')
      if ok and pinned then pinned_set[buf] = true end
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and not pinned_set[buf] then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  for _, file in ipairs(git_files) do
    vim.cmd('edit ' .. vim.fn.fnameescape(file))
  end
end

vim.keymap.set('n', '<leader>G', close_and_open_git_changes, { noremap = true, silent = true, desc = 'Close all, open git changes' })

-- copy reference for agents
local function copy_ref(opts)
  local path = vim.fn.expand '%:.'
  local ref = path

  if opts.visual then
    local start_line = vim.fn.line 'v'
    local end_line = vim.fn.line '.'
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    ref = path .. ':' .. start_line .. ':' .. end_line
  end

  local note = vim.fn.input 'Prompt'
  if note ~= '' then ref = ref .. ' ' .. note end

  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref)
end

-- normal: copy just the file path
vim.keymap.set('n', '<leader>ai', function() copy_ref {} end, { desc = 'Copy file path' })

-- visual: copy the file path plus the selected line range
vim.keymap.set('v', '<leader>ai', function() copy_ref { visual = true } end, { desc = 'Copy file path with line range' })
