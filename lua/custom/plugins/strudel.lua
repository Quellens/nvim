return {
  'gruvw/strudel.nvim',
  build = 'npm ci',
  config = function()
    require('strudel').setup {
      update_on_save = false,
      report_eval_errors = false,
      ui = {
        hide_error_display = true,
      },
    }

    vim.api.nvim_create_autocmd('BufWritePost', {
      callback = function()
        local ok, strudel = pcall(require, 'strudel')
        if ok and strudel.is_launched() then vim.cmd 'StrudelUpdate' end
      end,
    })

    vim.keymap.set('n', '<leader>Sl', '<cmd>StrudelLaunch<cr>', { desc = 'Strudel: Launch' })
    vim.keymap.set('n', '<leader>Sq', '<cmd>StrudelQuit<cr>', { desc = 'Strudel: Quit' })
    vim.keymap.set('n', '<leader>Ss', '<cmd>StrudelStop<cr>', { desc = 'Strudel: Stop' })

    local chromatic = { 'c', 'c#', 'd', 'd#', 'e', 'f', 'f#', 'g', 'g#', 'a', 'a#', 'b' }
    local flat_to_sharp = { db = 'c#', eb = 'd#', gb = 'f#', ab = 'g#', bb = 'a#' }

    local function cycle_note(direction)
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]

      local pos = 1
      while pos <= #line do
        local s, e, note_part = line:find('([a-g]b?#?%d?)', pos)
        if not s then break end

        local octave_str = note_part:match '(%d+)$'
        local note_name_part = note_part:match '^([a-g]b?#?)'
        local note_name_len = #note_name_part

        if col >= s - 1 and col <= s + note_name_len - 2 then
          local letter = note_part:sub(1, 1)
          local accidental = note_part:match '^[a-g](b?#?)' or ''
          local octave = octave_str and tonumber(octave_str) or 3

          local note_name = letter .. accidental
          if flat_to_sharp[note_name] then note_name = flat_to_sharp[note_name] end

          local idx = nil
          for i, n in ipairs(chromatic) do
            if n == note_name then
              idx = i
              break
            end
          end
          if not idx then break end

          idx = idx + direction
          if idx > #chromatic then
            idx = 1
            octave = octave + 1
          elseif idx < 1 then
            idx = #chromatic
            octave = octave - 1
          end

          local new_note = chromatic[idx] .. octave
          local new_line = line:sub(1, s - 1) .. new_note .. line:sub(e + 1)
          vim.api.nvim_set_current_line(new_line)
          vim.api.nvim_win_set_cursor(0, { vim.fn.line '.', s - 1 })
          return
        end

        pos = e + 1
      end

      local npos = 1
      while npos <= #line do
        local ns, ne, num_str = line:find('(%d+)', npos)
        if not ns then break end

        if col >= ns - 1 and col <= ne - 1 then
          local num = tonumber(num_str) + direction
          local new_line = line:sub(1, ns - 1) .. tostring(num) .. line:sub(ne + 1)
          vim.api.nvim_set_current_line(new_line)
          vim.api.nvim_win_set_cursor(0, { vim.fn.line '.', ns - 1 })
          return
        end

        npos = ne + 1
      end
    end

    vim.keymap.set('n', '<C-a>', function() cycle_note(1) end, { desc = 'Note up / Increment' })
    vim.keymap.set('n', '<C-x>', function() cycle_note(-1) end, { desc = 'Note down / Decrement' })
  end,
}
