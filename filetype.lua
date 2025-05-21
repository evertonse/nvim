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

--- IMPORTANT: Sometimes the nvim runtime takes a huge amount of time to decipher the filetype.
---            I mean they see ``.sh`` and think it might be all kinds of shells, so they decide to load the entire
---            contents of the file into memory (or a window of 100 lines) to see if any use of function of builtin can giveaway
---            the acual shell being used (zsh or some bashism) then they can decide the filetype.
---            The problem is that in pure posix shell syntax we're never gonna be sure of what filetype it is untill the very end where
---            we would give up and just say it is bash or sh or whatever. The point is, is the file is big, we're reading and processing
---            a huge amount of lines which was the slowdown on opening the rmlint.sh buffer that has 200k+ lines of shell.
---
---            You can fiddle around the $VIMRUTIME search for runtime/filetype.lua usually you see if its not deciding something there.
---            Here's some options to set filetype to avoid going through runtime/filetype.lua, you could set in a autocommand.
---            The event should be BufReadPre and not BufReadPost, because in Post vim has already set the ft.
---            Could be like this:
---            vim._with({ buf = args.buf }, function()
---               vim.api.nvim_cmd({ cmd = 'setf', args = { ft } }, {})
---            end)
---            Maybe something like this vim.g.do_filetype_bash = 0
---            This one definitely impedes runtime/filetype.lua from running vim.g.did_load_filetypes = 1
---
---
--- If you take a look at vim.filetype.detect:1497 you are gonna fine the following function, thats what takes time because .sh can be a whole lotta of different shell
--- So it calls getlines with just the bufnr as argument with means it gets all lines. It uses these lines to try to deduce the filetype.
--- That is done before BufReadPost, that's why is doesn't even show the buffer before everything is read.
---  ```lua
---     local function sh_with(name)
---       return function(path, bufnr)
---         return sh(path, getlines(bufnr), name)
---       end
---     end
---    M.sh = sh_with()
---    M.bash = sh_with 'bash'
---    M.ksh = sh_with 'ksh'
---    M.tcsh = sh_with 'tcsh'
---  ```
--- You may inject temporarily vim.print(vim.inspect { name = name }) to check things out for yourself.
---
--- TLDR: If slow to open, add the filetype by extension below (:h vim.filetype.add)

-- Inspect 'You should only see this once per neovim entire ssession' -- if you uncomment

vim.filetype.add {
  extension = {
    sh = function(path, bufnr)
      Inspect 'sh extension thats how we find out'
      return 'sh',
        function(bufnr)
          --- Just leaving as example for if you wanna do something extra, you can on this return
          vim.b[bufnr].did_syntax = false
        end
    end,

    zsh = 'zsh',

    c = 'c',
    h = 'c',

    cpp = 'cpp',
    hpp = 'cpp',

    glsl = 'glsl',
    json = 'json5',
    log = 'log',

    md = 'markdown',
  },
  pattern = {
    --- TODO: Maybe change the pattern to do only on extensionless filetypes
    ['.*'] = {
      function(path, bufnr, matched)
        --- NOTE: IIRC for runtime/filetype.lua this is not enough to determine that the filetype is pure posix shell, which is fair, sometime is it bash or csh.
        ---       BUT for myself IT IS. I wanna load 100mb of shell scripts sometimes, because rmlint utility spits and other tools spits out huge scripts I need to take a look. 2025-05-18
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        local bin = 'sh'
        local matched = vim.regex([[^#!.*/]] .. bin):match_str(content) ~= nil
        Inspect { 'pattern', loaded = vim.api.nvim_buf_is_loaded(bufnr), matched = matched, path = path, content = content, bufnr = bufnr }
        if matched then
          return 'sh'
        end
        return nil -- Fallback
      end,
      -- If + math.huge it's made first, if -math.huge then is the very last thing
      { priority = math.huge },
    },
  },
}

--- This is read before filetype.lua and it's meant block regex syntax highlight
--- to even load, I don't wanna see a breach of regex highlight if we have treesitter
--- BEWARE: This is problably imperfect as we bypass filetype.lua, expect some strangeness from LSP, or something, for you to fix.
local _ = false
  and vim.api.nvim_create_autocmd({ 'BufReadPre', 'StdinReadPre' }, {
    group = vim.api.nvim_create_augroup('PreHighlight', {}),
    callback = function(args, ext)
      local loaded = vim.api.nvim_buf_is_loaded(args.buf)
      Inspect {
        'Pre',
        ft = ft or 'no ft',
        args = args,
        ext = ext or 'no ext',
        valid = vim.api.nvim_buf_is_valid(args.buf),
        loaded = vim.api.nvim_buf_is_loaded(args.buf),
      }

      if not loaded then
        if vim.api.nvim_buf_get_name(args.buf) ~= '' then
          Inspect { 'Pre', 'about to edit ' }
          pcall(vim.api.nvim_buf_call, args.buf, vim.cmd.edit)
        else
          Inspect { 'Pre', 'about to bufload ' }
          vim.fn.bufload(args.buf)
        end
      end

      --- If it's loaded then it's always valid?
      local valid = vim.api.nvim_buf_is_valid(args.buf)
      if not valid then
        return
      end

      --- TODO: There should be a on detect call here to setup some vars and context or whatever
      Inspect { 'Pre before filetype.match', did_ft = vim.fn.did_filetype() or '?', ft = ft or 'no ft' }
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

        --- TODO: Check if this is enough for not having to modify 'runtime/filetype.lua', 2025-05-19
        --- Doing this *assignment* triggers all Filetype events. So does 'setf' and 'setfiletype'.
        vim.bo[args.buf].filetype = ft

        -- vim._with({ buf = args.buf }, function()
        --   vim.api.nvim_cmd({ cmd = 'setf', args = { ft } }, {})
        -- end)

        local parser_name = vim.treesitter.language.get_lang(ft) or ft
        if not should_ts_hl_disable(parser_name, args.buf, ft) then
          Inspect { 'Pre', parser_name = parser_name, ft = ft or 'no ft' }
          local parser_exist = vim.treesitter.language.add(parser_name)
          if parser_exist then
            --- This 'current_syntax' buffer variable should disallow any regex highlighting
            vim.b.current_syntax = ft
            --- Idk setting this just in case
            vim.bo[args.buf].syntax = ''
            Inspect { 'Pre parser exist', did_ft = vim.fn.did_filetype() or '?', ft = ft or 'no ft' }
          end
        end
      else
        vim.bo[args.buf].filetype = ''
      end
    end,
  })

--- NOTE: Any treesitter language registration must be done AFTER `nvim-tressiter` plugin setup,
---       because they register a lot of laguanges so our config would get overwritten.
---       You can verify this on ´lua/nvim-treesitter/parsers.lua´ from the plugins file tree
