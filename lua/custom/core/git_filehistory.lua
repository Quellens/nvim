local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local M = {}

M.open_file_at_commit = function()
  local file = vim.fn.expand '%:p'
  local rel_file = vim.fn.expand '%'

  if file == '' then
    print 'No file open'
    return
  end

  local handle = io.popen("git log --pretty=format:'%h %s' -- " .. rel_file)
  local result = handle:read '*a'
  handle:close()

  local commits = {}
  for line in result:gmatch '[^\r\n]+' do
    table.insert(commits, line)
  end

  pickers
    .new({}, {
      prompt_title = 'File History',

      finder = finders.new_table {
        results = commits,
      },

      -- 🔥 DIFF PREVIEW
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          local hash = entry.value:match '^(%S+)'
          return {
            'git',
            'diff',
            hash .. '^!',
            '--',
            rel_file,
          }
        end,
      },

      sorter = conf.generic_sorter {},

      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          local hash = selection.value:match '^(%S+)'

          actions.close(prompt_bufnr)

          -- 🧘‍♂️ SCRATCH BUFFER (READ ONLY)
          local content = vim.fn.systemlist('git show ' .. hash .. ':' .. rel_file)

          local buf = vim.api.nvim_create_buf(false, true)

          vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

          -- buffer settings
          vim.bo[buf].bufhidden = 'wipe'
          vim.bo[buf].buftype = 'nofile'
          vim.bo[buf].swapfile = false
          vim.bo[buf].modifiable = false
          vim.bo[buf].filetype = vim.bo.filetype

          -- open in new tab (optional: vsplit / split)
          vim.cmd 'tabnew'
          vim.api.nvim_set_current_buf(buf)
        end)

        return true
      end,
    })
    :find()
end

return M
