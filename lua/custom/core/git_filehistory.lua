local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local vim_fn = vim.fn

local M = {}

-- toggle state (persistiert zwischen Aufrufen)
local show_all = false

local function build_commits(rel_file)
  local rel_file_esc = vim_fn.shellescape(rel_file)
  local all_flag = show_all and '--all ' or ''
  local cmd = 'git log ' .. all_flag .. "--pretty=format:'%h | %s | %ar | %an | %d' -- " .. rel_file_esc
  local handle = io.popen(cmd)
  local result = handle:read '*a'
  handle:close()

  local commits = {}
  for line in result:gmatch '[^\r\n]+' do
    table.insert(commits, line)
  end
  return commits
end

M.open_file_at_commit = function()
  local rel_file = vim_fn.expand '%'

  if rel_file == '' then
    print 'No file open'
    return
  end

  local commits = build_commits(rel_file)

  pickers
    .new({}, {
      prompt_title = show_all and 'File History (all branches)' or 'File History',
      finder = finders.new_table { results = commits },
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          local hash = entry.value:match '^(%S+)'
          return { 'git', 'diff', hash .. '^!', '--', rel_file }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        -- Enter: open file at commit
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          local hash = selection.value:match '^(%S+)'
          actions.close(prompt_bufnr)

          local rel_file_esc = vim_fn.shellescape(rel_file)
          local content = vim_fn.systemlist('git show ' .. hash .. ':' .. rel_file_esc)

          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

          vim.bo[buf].bufhidden = 'wipe'
          vim.bo[buf].buftype = 'nofile'
          vim.bo[buf].swapfile = false
          vim.bo[buf].modifiable = false

          local ft = vim.filetype.match { filename = rel_file }
          if ft then vim.bo[buf].filetype = ft end

          vim.cmd 'tabnew'
          vim.api.nvim_set_current_buf(buf)
        end)

        -- Ctrl-h: toggle --all and reopen picker
        map('i', '<C-h>', function()
          show_all = not show_all
          actions.close(prompt_bufnr)
          -- kurz verzögern, damit Picker sauber geschlossen ist
          vim.defer_fn(function() M.open_file_at_commit() end, 10)
        end)
        map('n', '<C-h>', function()
          show_all = not show_all
          actions.close(prompt_bufnr)
          vim.defer_fn(function() M.open_file_at_commit() end, 10)
        end)

        return true
      end,
    })
    :find()
end

return M
