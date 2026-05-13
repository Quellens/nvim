return {
  'vuki656/package-info.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  ft = { 'json' },
  config = function()
    require('package-info').setup {
      autostart = false,
      hide_up_to_date = false,
      hide_unstable_versions = false,
    }

    local pi = require 'package-info'

    vim.keymap.set('n', '<leader>ns', pi.show, {
      desc = 'Package Info Show',
    })

    vim.keymap.set('n', '<leader>nc', pi.hide, {
      desc = 'Package Info Hide',
    })

    vim.keymap.set('n', '<leader>nu', pi.update, {
      desc = 'Package Update',
    })

    vim.keymap.set('n', '<leader>nd', pi.delete, {
      desc = 'Package Delete',
    })

    vim.keymap.set('n', '<leader>ni', pi.install, {
      desc = 'Package Install',
    })

    vim.keymap.set('n', '<leader>np', pi.change_version, {
      desc = 'Package Pick Version',
    })

    local function show_package_versions()
      local line = vim.api.nvim_get_current_line()

      -- package name
      local pkg = line:match [["(@?[%w%-%._/]+)"]]

      -- version aus package.json
      local declared_version = line:match [["[^"]+"%s*:%s*"([^"]+)"]]

      if not pkg then
        vim.notify('Kein Package gefunden 😢', vim.log.levels.ERROR)
        return
      end

      -- npm versions
      local versions_cmd = 'npm view ' .. pkg .. ' versions --json'

      local versions = vim.fn.systemlist(versions_cmd)

      if vim.v.shell_error ~= 0 then
        vim.notify('npm view fehlgeschlagen für ' .. pkg, vim.log.levels.ERROR)
        return
      end

      local decoded = vim.json.decode(table.concat(versions, '\n'))

      local filtered = {}

      local function semver_to_table(version)
        local major, minor, patch = version:match '^(%d+)%.(%d+)%.(%d+)$'

        return {
          major = tonumber(major) or 0,
          minor = tonumber(minor) or 0,
          patch = tonumber(patch) or 0,
        }
      end

      local function semver_gte(a, b)
        if a.major ~= b.major then return a.major > b.major end

        if a.minor ~= b.minor then return a.minor > b.minor end

        return a.patch >= b.patch
      end

      local declared_clean = (declared_version or ''):match '%d+%.%d+%.%d+'

      local declared_semver = nil

      if declared_clean then declared_semver = semver_to_table(declared_clean) end

      for _, v in ipairs(decoded) do
        -- prereleases/nightlies/etc raus
        if not v:match '[a-zA-Z]' then
          local current = semver_to_table(v)

          if declared_semver then
            if semver_gte(current, declared_semver) then table.insert(filtered, v) end
          else
            table.insert(filtered, v)
          end
        end
      end

      -- yarn why
      local why_output = vim.fn.systemlist('yarn why ' .. pkg)

      local found_line = 'Not found'

      for _, l in ipairs(why_output) do
        if l:match 'Found' then
          found_line = l
          break
        end
      end

      -- buffer
      local buf = vim.api.nvim_create_buf(false, true)

      local output = {
        '╔══════════════════════════════════════╗',
        '║         PACKAGE VERSIONS             ║',
        '╚══════════════════════════════════════╝',
        '',
        '  📦 Package    : ' .. pkg,
        '  📝 Declared   : ' .. (declared_version or '?'),
        '  ✅ Installed  : ' .. found_line,
        '',
        '━━━━━━━━━━ NEWER VERSIONS ━━━━━━━━━━',
        '',
      }

      for i = 1, #filtered do
        local version = filtered[i]

        local marker = '  📦 '

        if declared_version and declared_version:gsub('[%^~><= ]', '') == version then marker = '  🔴 ' end

        table.insert(output, marker .. version)
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

      vim.bo[buf].modifiable = false
      vim.bo[buf].bufhidden = 'wipe'
      vim.bo[buf].filetype = 'markdown'

      local width = math.floor(vim.o.columns * 0.7)

      local height = math.floor(vim.o.lines * 0.8)

      local row = math.floor((vim.o.lines - height) / 2)

      local col = math.floor((vim.o.columns - width) / 2)

      vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        border = 'rounded',
        style = 'minimal',
      })
    end

    vim.keymap.set('n', '<leader>nv', show_package_versions, {
      desc = 'See ALL Versions',
    })
  end,
}
