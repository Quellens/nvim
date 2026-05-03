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

local function truncate(str, max_len)
  if #str <= max_len then return str end
  return str:sub(1, max_len - 1) .. '…'
end

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
      finder = finders.new_table {
        results = commits,
        entry_maker = function(entry)
          local hash, subject, reltime, author, refs = entry:match '^(%S+) | (.-) | (.-) | (.-) | (.*)$'

          display = function()
            local short_subject = truncate(subject, 30)
            local short_reltime = truncate(reltime, 11)
            return string.format('%s • %-30s  • %-10s • %s %s', hash, short_subject, short_reltime, author, refs or '')
          end
          return {
            value = entry,
            display = display,
            ordinal = subject .. ' ' .. author,
          }
        end,
      },
      previewer = previewers.new_termopen_previewer {
        get_command = function(entry)
          local hash = entry.value:match '^(%S+)'
          return { 'git', '--no-pager', 'diff', hash .. '^!', '--', rel_file }
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

          local base = vim.fn.fnamemodify(rel_file, ':t')

          local rel_file_name = rel_file:match '([^/]+)$' or 'file'
          local ext = rel_file_name:match '%.(%w+)$' or ''
          local tmpfile = '/tmp/' .. base .. '-' .. hash .. '.' .. ext
          vim.fn.writefile(content, tmpfile)

          -- Optional: set file permissions (z.B. 0644)
          vim.loop.fs_chmod(tmpfile, tonumber('0644', 8))

          -- Öffne die temporäre Datei in neuem Tab (oder passe an)
          vim.cmd('tabnew ' .. vim.fn.fnameescape(tmpfile))
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
