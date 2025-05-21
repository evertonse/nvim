- [x] add speed test files like sql amalgamation, zig.ll or zig.c (generated automatically)
- [x] edit: Yeah we can but we have to decided if we want ours to run first. Can we move queries, snippets to `after/`?
- [x] make snippet work again >.<

- [x] gfx is in selection mode, use the selection to goto file
- [ ] gfx learn about extending gF in ftplugins
- [ ] gfx Better "universal" path matching regex. If it contains allowed characters intermixed with

- [ ] on_detect what is the problem with doing it on a BufPre event

- [ ] Fix any.lua when ressession and entering
- [ ] Fix slow selection mode in BIG files
- [ ] Fix slow insertion of text in BIG files


- [ ] if .bak, and has another .lua in front highglight as lua normally

- [ ] Extend mini.ai to use < > in cib
- [ ] Fix shell search when doing something like :!sort or whatever, it's probably something about $PATH in wsl (again)

- [x] normal-cmdline - fix height when not opening from ':' cmdline
- [ ] normal-cmdline make it not wrap
- [x] normal-cmdline if we go cmdline-window we remape ESC to be goto normal mode just for this "session"


- [x] Fix linting to only on save using nvim-lint (on demand)
- [ ] Fix  omega dealy when entering neovim, probably by lsp or something

- [ ] Investigate LAG when holding delete and backspace on the cmdline

- [x] Fix treesitter on file detection

- [ ] lsp/treesitter make it stoppable easily

- [x] edit: it was the completion  . lsp fix sync problem
- [x] lsp fix jump to definition whnere there is just two
- [x] lsp Fix client and server capabilities make it less bloated
- [x] lsp make it fast with client capabilities
- [x] lsp make it fast with client server_capabilities

- [ ] Make cmp better like this: [https://www.youtube.com/watch?v=gK31IVy0Gp0]

- [ ] blink when matching if substring matching >> prio than fuzzy (Waiting for bug fixes from developer)

- [x] cmp fix snippets
- [x] buffer switch on `<c-[lh]>`

- [ ] Investigate Tabline buffer switch lag
- [ ] Fix trails

- [ ] Quick function to go ~/docs/notes/todo.md

- [x] Factor out cmdwin into a local plugin using cmdwinheight stuff
- [x] Fix normal mode cmdline

- [ ] Fix or change multicursors
- [ ] Fix pasting before the very first line

- [ ] Make cmp only fuzzy on lsp or only prefix on paths
- [ ] Make cycler receive functions

