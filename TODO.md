
- [ ] When renaming a file the treesitter detaches
- [x] Fix highlight pattern

- [ ] Investigate blink-cmp bug(?) where c-p actually changes another window on the side of the completion window
- [ ] if .bak, and has another .lua in front highlight as lua normally

- [ ] Extend mini.ai to use < > in cib

- [ ] @low(there an issue that is getting looked at. iirc i'm subscribed to it) blink when matching if substring matching >> prio than fuzzy (Waiting for bug fixes from developer)

- [ ] Fix post.lua when using ressession. Probaly will need to dive in the source code
- [ ] @high @hiatus Fix treesitter init on post.lua
lua print(vim.inspect(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] or 'not active'))

- [ ] @low(problably will get done as i'm using and find its flaws in work flow) Make trails into a local plugin with support for lsp
- [ ] Fix or change multicursors
- [ ] Fix pasting before the very first line

- [ ] Make cmp only fuzzy on lsp or only prefix on paths

- [ ] Investigate LAG when holding delete and backspace on the cmdline (edit 2025-05-21: it disappeared)

- [ ] @high @hiatus(Can't reproduce. Have to encounter it again) Fix treesitter on filetype not getting started properly by post.lua.


- [ ] @low Fix post.lua when using ressession. Probaly will need to dive in the source code

- [ ] @low Fix error in Neovim compilation from source

- [ ] @low gfx make env varialbes work in paths "${XDG_CONFIG_HOME:-$HOME/.config}/shell/src/lscolor.sh".
- [ ] @low gfx learn about extending gF in ftplugins
- [ ] @low(When a problem appears with a path i'll do this) gfx Better "universal" path matching regex. If it contains allowed characters intermixed with

- [ ] Make cmp better like this: [https://www.youtube.com/watch?v=gK31IVy0Gp0]

---

- [x] Fix did_load_filetypes being set somewhere after lazy-plugins
- [x] add speed test files like sql amalgamation, zig.ll or zig.c (generated automatically)
- [x] edit: Yeah we can but we have to decided if we want ours to run first. Can we move queries, snippets to `after/`?
- [x] make snippet work again >.<

    
- [x] gfx is in selection mode, use the selection to goto file

- [x] (edit: just copied everything and didn't bother doing on_detect on BufReadPre) on_detect what is the problem with doing it on a BufPre event

- [x] Fix slow selection mode in BIG files (edit: lualine slow function was being picked)
- [x] Fix slow insertion of text in BIG files (edit: it was blink-cmp on buffer provider)

- [x] (fixed, it was todo highlighting) Investigate Tabline buffer switch lag
- [x] Make cycler receive functions
- [x] Fix shell search when doing something like :!sort or whatever, it's probably something about $PATH in wsl (again)

- [x] normal-cmdline - fix height when not opening from ':' cmdline
- [x] normal-cmdline make it not wrap (edit: still wraps on b and e but not on h and l)
- [x] normal-cmdline if we go cmdline-window we remape ESC to be goto normal mode just for this "session"


- [x] Fix linting to only on save using nvim-lint (on demand)
- [x] (edit: partial fix, we found out that is undofile) Fix  omega delay when entering neovim, probably by lsp or something




- [x] Fix treesitter on file detection

- [x] lsp/treesitter make it stoppable easily

- [x] edit: it was the completion  . lsp fix sync problem
- [x] lsp fix jump to definition whnere there is just two
- [x] lsp Fix client and server capabilities make it less bloated
- [x] lsp make it fast with client capabilities
- [x] lsp make it fast with client server_capabilities


- [x] cmp fix snippets
- [x] buffer switch on `<c-[lh]>`


- [x] Quick function to go ~/docs/notes/todo.md

- [x] Factor out cmdwin into a local plugin using cmdwinheight stuff
- [x] Fix normal mode cmdline

