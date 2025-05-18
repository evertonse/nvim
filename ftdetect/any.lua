---
--- Add treesitter autostart to some filetype and exclude some
---

-- grn 'ftdetect' runtime/
-- :lua print(vim.inspect(vim.treesitter.language.get_filetypes('c')))
-- :lua print(vim.inspect(vim.treesitter.language.get_lang('c')))
-- :lua print(vim.inspect(vim.treesitter.language.add('c')))
-- :lua print(vim.inspect(vim.treesitter.start(vim.api.nvim_get_current_buf(), 'c')))

-- :lua print(vim.inspect(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] or 'not active'))
-- :lua vim.treesitter.get_parser(vim.api.nvim_get_current_buf()):parse()

-- :lua print(vim.inspect(vim.treesitter.get_parser(vim.api.nvim_get_current_buf())))

-- :lua vim.treesitter.start(0, 'json5')

-- group = 'filetypedetect',

local DEBUG = false
local Inspect = DEBUG and Inspect or function(arg) end
local want_regex = false

local _ = true
  -- 'FileType'
  and vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPost' }, {
    group = vim.api.nvim_create_augroup('AnyHighlight', {}),
    -- pattern = '*',
    callback = function(args)
      if vim.b.did_syntax then
        return
      end
      vim.b.did_syntax = true

      local bufnr = args.buf
      if not vim.api.nvim_buf_is_loaded(bufnr) then
        if vim.api.nvim_buf_get_name(bufnr) ~= '' then
          pcall(vim.api.nvim_buf_call, bufnr, vim.cmd.edit)
        else
          vim.fn.bufload(bufnr)
        end
      end

      local ft = vim.bo.filetype
      local parser_name = vim.treesitter.language.get_lang(ft)

      if require('functions').disable_treesitter_highlight_when(parser_name, bufnr) then
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
            vim.bo[bufnr].syntax = 'ON'
          end

          --- Optional: enable legacy syntax highlighting if desired
          -- vim.bo[bufnr].syntax = 'on'
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

    md = 'markdown',
  },
  pattern = {
    ['.*'] = {
      function(path, bufnr, matched)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        local bin = 'sh'
        --- IIRC for runtime/filetype.lua this is not enough to determine that the filetype is pure posix shell, which is fair, sometime is it bash or csh.
        --- BUT for myself IT IS. I wanna load 100mb of shell scripts sometimes, because rmlint utility spits and other tools spits out huge scripts I need to take a look. 2025-05-18
        local matched = vim.regex([[^#!.*/]] .. bin):match_str(content) ~= nil
        Inspect { matched = matched, path = path, content = content, bufnr = bufnr }
        if matched then
          return 'sh'
        end
        return nil -- Fallback
      end,
      { priority = -math.huge },
    },
  },
}

--- NOTE: Any treesitter language registration must be done AFTER `nvim-tressiter` plugin setup,
---       because they register a lot of laguanges so our config would get overwritten.
---       You can verify this on ´lua/nvim-treesitter/parsers.lua´ from the plugins file tree
