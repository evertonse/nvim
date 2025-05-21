-- if vim.g.did_load_filetypes then
--   return
-- end
-- vim.g.did_load_filetypes = 1
---
--- Add treesitter autostart to some filetype and exclude some
---

-- grn 'ftdetect' runtime/
-- :lua print(vim.inspect(vim.treesitter.language.get_filetypes('c')))
-- :lua print(vim.inspect(vim.treesitter.language.get_lang('c')))
-- :lua print(vim.inspect(vim.treesitter.language.add('c')))
-- :lua print(vim.inspect(vim.treesitter.start(vim.api.nvim_get_current_buf(), 'c')))

--- Get active buffers
-- :lua print(vim.inspect(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] or 'not active'))
-- :lua vim.treesitter.get_parser(vim.api.nvim_get_current_buf()):parse()

-- :lua print(vim.inspect(vim.treesitter.get_parser(vim.api.nvim_get_current_buf())))

-- :lua vim.treesitter.start(0, 'json5')

-- group = 'filetypedetect',
local should_ts_hl_disable = require('functions').disable_treesitter_highlight_when
local should_rx_hl_disable = require('functions').disable_regex_highlight_when

local DEBUG = false
local AlwaysInspect = Inspect
local Inspect = DEBUG and Inspect or function(arg) end
local want_regex = false

local _ = true
  -- 'FileType'
  -- 'BufReadPost'
  and vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup('AnyHighlight', {}),

    -- The 'pattern' of the FileType event is a list of filetypes.
    -- pattern = '*',
    callback = function(args)
      local bufnr = args.buf
      -- Only ever attach to buffers that represent an actual file.
      if vim.bo[bufnr].buftype ~= '' then
        return
      end
      -- Inspect { 'Any FileType', args = args, ft = vim.bo.filetype, loaded = vim.api.nvim_buf_is_loaded(args.buf) or '??' }
      if vim.b[bufnr].did_syntax then
        return
      end
      vim.b[bufnr].did_syntax = true

      local ft = vim.bo.filetype
      local parser_name = vim.treesitter.language.get_lang(ft) or ft
      if should_ts_hl_disable(parser_name, bufnr) then
        Inspect {
          'disabled treesitter highlight',
          ft = ft,
        }
        if should_rx_hl_disable(parser_name, bufnr) then
          Inspect {
            'disabled regex highlight',
            ft = ft,
          }
          vim.schedule(function()
            vim.bo[bufnr].syntax = ''
          end)
        end
        return
      end

      Inspect {
        parser_active = vim.treesitter.highlighter.active[bufnr] ~= nil,
        parser_name = vim.treesitter.language.get_lang(ft),
        parser_exist = vim.treesitter.language.add(vim.treesitter.language.get_lang(ft) or ft),
      }

      local parser_active = vim.treesitter.highlighter.active[bufnr] ~= nil
      if not parser_active then
        local parser_exist = vim.treesitter.language.add(parser_name or ft)

        if parser_exist then
          --- NOTE: By default, disables regex syntax highlighting, which may be
          ---       required for some plugins. In this case, add `vim.bo.syntax = 'on'` after
          ---       the call to `start`.
          -- Inspect { 'about to start treesitter with parser = ' .. parser_name, ft = vim.bo.filetype, args }
          vim.treesitter.start(bufnr, parser_name)

          if want_regex then
            vim.bo[bufnr].syntax = 'on'
          end
        end
      end
    end,
  })
