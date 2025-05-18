

Files under `fdetect/` are sourced *only once*. They're meant to contain some autocommands to detect the filetype AFTER defaults neovim's file detection so it can be overriden. Autocommands should look like this:

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'StdinReadPost' }, ...

Plese see `:help ftdetect`. Or `:h filetype.txt` for thorough exaplanation.


If you want to run the autocommand *before* `runtime/filetype.lua` you must create with the `BufReadPre` event under `ftdetect` or create a `filetype.lua` under your own ~/.config/nvim. On you own filetype.lua you need
to add the group `filetypedetect` to the autocommand

See this for more info about how differently neovim handles filetype detection [filetype.lua](https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/)

They say that it should be sourced first. But despite the below, it seems, at leat on neovim, that filetype.lua from the runtime will be sourced first, not ours.

```txt
   Your filetype.vim will be sourced before the default FileType autocommands
   have been installed.  Your autocommands will match first, and the
   ":setfiletype" command will make sure that no other autocommands will set
   'filetype' after this.
```

If you call vim.filetype.add that will be used by runtime filety.lua to decide the filetype, done through `vim.filetype.match`. The only way I'm seeing to override this behavious is to override the filetypedetect
autogroup, effecitvely clearing it. If we create this autocommand then what happens when the user call `filetype on` ?

This is what happens, they're sourced as codumentation says, it should have been like this from the start. But on startup runtime runs first.
`
    sourced  ~/.config/nvim/filetype.lua
    sourced ~/.config/nvim/filetype.vim
    sourced runtime/filetype.lua
    Press ENTER or type command to continue
`


Order from files: `filetype.lua`, `runtime/filetype.vim`, `runtime/filetype.lua`, and `ftdetect/all.lua`:

sourced runtime/filetype.lua
{ "sourced runtime/filetype.lua",
  did_load_filetypes = "not set yet"
}
sourced ftdetect/all.lua
sourced ~/.config/nvim/filetype.lua
sourced ~/.config/nvim/filetype.vim
sourced runtime/filetype.lua

{ "runtime/filetype.lua BEFORE vim.filetype.match",
  args = {
    buf = 1,
    event = "BufReadPost",
    file = "/home/excyber/.local/bin/tmux-open-in-nvim",
    group = 20,
    id = 51,
    match = "/home/excyber/.local/bin/tmux-open-in-nvim"
  }
}
{ "runtime/filetype.lua AFTER vim.filetype.match" }
{ "all.lua: 'FileType'",
  args = {
    buf = 1,
    event = "FileType",
    file = "/home/excyber/.local/bin/tmux-open-in-nvim",
    id = 55,
    match = "sh"
  }
}

{ "all.lua: 'BufReadPost'",
  args = {
    buf = 1,
    event = "BufReadPost",
    file = "/home/excyber/.local/bin/tmux-open-in-nvim",
    id = 54,
    match = "/home/excyber/.local/bin/tmux-open-in-nvim"
  }
}

{ "all.lua BufRead" }
{ "all.lua: 'FileType'",
  args = {
    buf = 2,
    event = "FileType",
    file = "incline",
    id = 55,
    match = "incline"
  }
}

Overview: :filetype-overview
command   subcoomand           detection plugin    indent
:filetype on                   on        unchanged unchanged
:filetype off                  off       unchanged unchanged
:filetype plugin               on        on        on        unchanged
:filetype plugin               off       unchanged off       unchanged
:filetype indent               on        on        unchanged on
:filetype indent               off       unchanged unchanged off
:filetype plugin               indent    on        on        on  on
:filetype plugin               indent    off       unchanged off off
