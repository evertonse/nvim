--- NOTE(2025-05-21): Our filetype.lua runs AFTER the runtime/filetype.lua
if vim.g.did_load_custom_filetypes then
  return
end
vim.g.did_load_custom_filetypes = 1

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
    log = 'log',

    md = 'markdown',
  },
  pattern = {
    --- TODO: Maybe change the pattern to do only on extensionless filetypes
    ['.*'] = {
      function(path, bufnr, matched)
        --- NOTE: IIRC for runtime/filetype.lua this is not enough to determine that the filetype is pure posix shell, which is fair, sometime is it bash or csh.
        ---       BUT for myself IT IS. I wanna load 100mb of shell scripts sometimes, because rmlint utility spits and other tools spits out huge scripts I need to take a look. 2025-05-18
        --- Content will be empty if you try to vim.filetype.match in a BufReadPre event
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
        local bin = 'sh'
        local matched = vim.regex([[^#!.*/]] .. bin):match_str(content) ~= nil
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

local highlights_handling = function(ft, bufnr)
  local should_ts_hl_disable = require('functions').disable_treesitter_highlight_when
  local should_rx_hl_disable = require('functions').disable_regex_highlight_when

  local parser_name = vim.treesitter.language.get_lang(ft) or ft
  if not should_ts_hl_disable(parser_name, bufnr, ft) then
    local parser_exist = vim.treesitter.language.add(parser_name)
    if parser_exist then
      --- This 'current_syntax' buffer variable should disallow any regex highlighting
      vim.b.current_syntax = ft
      --- Idk setting this just in case
      vim.bo[bufnr].syntax = ''
    end
  end
end
-----------------------------------------------------------------------------
--- From here on out it's basically the same as in runtime ------------------
-----------------------------------------------------------------------------
vim.api.nvim_create_augroup('filetypedetect', { clear = false })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'StdinReadPost' }, {
  group = 'filetypedetect',
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) then
      return
    end

    --- @modified NOTE(2025-05-21):
    --- `vim.b.pre_filetype` is supposed to be set on `BufReadPre`
    --- But one CAN'T just set vim.b.filetype in a BufReadPre event because it'll trigger FileType events.
    --- These events rely on a context that is set here, so that has been proven to have messed things up.
    --- such Lsp and all kinds of things.
    if vim.b[args.buf].pre_filetype then
      local ft = vim.b[args.buf].pre_filetype
      vim._with({ buf = args.buf }, function()
        vim.api.nvim_cmd({ cmd = 'setf', args = { ft } }, {})
      end)
      return
    end

    local ft, on_detect = vim.filetype.match {
      -- The unexpanded file name is needed here. #27914
      -- However, bufname() can't be used, as it doesn't work with :doautocmd. #31306
      filename = args.file,
      buf = args.buf,
    }

    if ft then
      --- @modified NOTE(2025-05-21):
      highlights_handling(ft, args.buf)

      -- on_detect is called before setting the filetype so that it can set any buffer local
      -- variables that may be used the filetype's ftplugin
      if on_detect then
        on_detect(args.buf)
      end

      vim._with({ buf = args.buf }, function()
        vim.api.nvim_cmd({ cmd = 'setf', args = { ft } }, {})
      end)
    else
      -- Generic configuration file used as fallback
      ft = require('vim.filetype.detect').conf(args.file, args.buf)
      if ft then
        vim._with({ buf = args.buf }, function()
          vim.api.nvim_cmd({ cmd = 'setf', args = { 'FALLBACK', ft } }, {})
        end)
      end
    end
  end,
})

-- Set up the autocmd for user scripts.vim
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'filetypedetect',
  command = "if !did_filetype() && expand('<amatch>') !~ g:ft_ignore_pat | runtime! scripts.vim | endif",
})

vim.api.nvim_create_autocmd('StdinReadPost', {
  group = 'filetypedetect',
  command = 'if !did_filetype() | runtime! scripts.vim | endif',
})

if not vim.g.ft_ignore_pat then
  vim.g.ft_ignore_pat = '\\.\\(Z\\|gz\\|bz2\\|zip\\|tgz\\)$'
end

-- These *must* be sourced after the autocommands above are created
vim.cmd [[
  augroup filetypedetect
  runtime! ftdetect/*.{vim,lua}
  augroup END
]]
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
