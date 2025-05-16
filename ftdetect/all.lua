--- Add treesitter autostart to some filetype and exclude some
vim.api.nvim_create_autocmd('FileType', {
  once = true,
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    local skip = { 'llvm' }
    for _, skipft in ipairs(skip) do
      if ft == skipft then
        return
      end
    end

    if vim.treesitter.highlighter.active[args.buf] == nil then
      local has_parser = vim.treesitter.language.add(ft)
      if has_parser then
        -- Note: By default, disables regex syntax highlighting, which may be
        -- required for some plugins. In this case, add `vim.bo.syntax = 'on'` after
        -- the call to `start`.
        vim.treesitter.start(bufnr, ft)

        -- Optional: enable legacy syntax highlighting if desired
        -- vim.bo[bufnr].syntax = 'on'
      end
    end
  end,
})

--- IMPORTANT: Sometimes the nvim runtime takes a huge amount of time to decipher the filetype.
---            I mean they see ``.sh`` and think it might be all kinds of shells, so they decide to load the entire contents of the file into memory (or a window of 100 lines) to see if any use of function of builtin can giveaway the acual shell being used (zsh or some bashism) then they can decide the filetype.
---            The problem is that in pure posix shell syntax we're never gonna be sure of what filetype it is untill the very end where we would give up and just say it is bash or sh or whatever. The point is, is the file is big, we're reading and processing a huge amount of lines which was the slowdown on opening the rmlint.sh buffer that has 200k+ lines of shell.
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

-- Inspect 'You should only see this once' -- if you uncomment
vim.filetype.add {
  extension = {
    sh = 'bash',
    zsh = 'zsh',

    c = 'c',
    h = 'c',

    cpp = 'cpp',
    hpp = 'cpp',

    glsl = 'glsl',

    md = 'markdown',
  },
}
