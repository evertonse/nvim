local should_ts_hl_disable = require('functions').disable_treesitter_highlight_when
local should_rx_hl_disable = require('functions').disable_regex_highlight_when

--- This is read before filetype.lua and it's meant block regex syntax highlight
--- to even load, I don't wanna see a breach of regex highlight if we have treesitter
--- BEWARE: This is problably imperfect as we bypass filetype.lua, expect some strangeness from LSP, or something, for you to fix.
local _ = false
  and vim.api.nvim_create_autocmd({ 'BufReadPre', 'StdinReadPre' }, {
    group = vim.api.nvim_create_augroup('PreHighlight', {}),
    callback = function(args, ext)
      local loaded = vim.api.nvim_buf_is_loaded(args.buf)
      if not loaded then
        if vim.api.nvim_buf_get_name(args.buf) ~= '' then
          pcall(vim.api.nvim_buf_call, args.buf, vim.cmd.edit)
        else
          vim.fn.bufload(args.buf)
        end
      end

      --- If it's loaded then it's always valid?
      local valid = vim.api.nvim_buf_is_valid(args.buf)
      if not valid then
        return
      end

      local ft, on_detect = vim.filetype.match {
        filename = args.file,
        buf = args.buf,
      }

      Inspect { 'Pre after filetype.match', did_ft = vim.fn.did_filetype() or '?', ft = ft or 'no ft' }

      if ft then
        -- on_detect is called before setting the filetype so that it can set any buffer local
        -- variables that may be used the filetype's ftplugin
        if on_detect then
          on_detect(args.buf)
        end

        --- DONE: Check if this is enough for not having to modify 'runtime/filetype.lua', 2025-05-19
        --- Doing this *assignment* triggers all Filetype events. So does 'setf' and 'setfiletype'.
        -- vim.bo[args.buf].filetype = ft
      else
        vim.bo[args.buf].filetype = ''
      end
    end,
  })

--- NOTE: Any treesitter language registration must be done AFTER `nvim-tressiter` plugin setup,
---       because they register a lot of laguanges so our config would get overwritten.
---       You can verify this on ´lua/nvim-treesitter/parsers.lua´ from the plugins file tree
