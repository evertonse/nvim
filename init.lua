------------------------------------------------------------------------------------------------------
-- TODO:
--    [x](edit: disabled for now, kinda buggy even with tmux optios ) zen mode needs better interection zindex with neotree
--    [x](edit: oil.nvim i think) find faster neotree for windows
--    [-](edit: Could not do it) configure noice cmdline to enable normal mode on it
--    [x](edit: Working fine) setup inc-rename to work with noice
--    [x] checkout tabby for neovim and other
--    [x] config oil.nvim to test it's performance
--    [x] configure mini.surround to surround word with quotes similar to le nvim.surround
--    [x] check keymaps
--    [x](edit: win32-yank-bin as the culprit) check why shit be slow these days when moving arround
--    [x](edit: done) check 'c' mapping for mini plugin
--    [x](edit: Some other time) see about this ---@field public performance?  done cmp.PerformanceConfig
--    [x](edit: seem the same I'll keep using mini.surround then I'll see about chagin)see if surround is better than mini.surround
--    [x](edit: I'm using auto-session) see the source code later ]:mksession
--    [x] ui select on telescope on normal mode by typing a number
--    [x] Mini lsp, recording
--    [x] Create a telescope options to select from yank history
--    [x] Take a look at https://github.com/ggandor/leap.nvim
--    [x] Take a look at hop.nvim
--    [x] NvimTree bulk delete
--    [x] NvimTree implement far-right icon placement
--    [x] NvimTree implement open_win_config as a function
--    [x] What is git cherrypick, squash and the other one?
--    [x](edit: did checkout) MORE PLUGINS https://github.com/rockerBOO/awesome-neovim#cursorline
--    [x] CmdLineWindow: Make so every insert char is transfered to the cmdline normally to ensure inccommand properly
--    [x] CmdLineWindow: Make the cmdheight be 0 when in cmdline window
--    [x] <3 NvimTree implement pattern dotfiles highlights (similar to gitignore highlights)
--    [x] NvimTree: implement amount of dotfiles per directory similar to neo-tree
--    [x] NvimTree: create separate PR for exposing NvimTreeFloatBorder
--    [ ] Search curious about the gui aspect of this: https://github.com/ray-x/guihua.lua
--    [ ] TELESCOPE: Take a look at https://github-wiki-see.page/m/nvim-telescope/telescope.nvim/wiki/Extensions
--    [ ] REFACTOR: Make all keymaps in keymaps, and require 'keymaps'.telescope for example in plugin site
--
--    [ ] See about: make named sessions and named tabs
--    [ ] See about: reordering/managing buffers
--
--    [ ] MARKS: better marks per project visualization and managiong (harpoon2, grapple, portal, marks.nvim, etc...)
--    [ ] NvimTree: bulk renamed when you actually need it
--    [ ] LazyDraw: Set it when problems slo, meaning, on ssh, how tho?
--    [ ] NvimTree-Important: Fix focus file to change cwd if necessary, save the cwd in stack, then pop it
--    [ ] NvimTree: possibly undo (working with trash)
--    [ ] NvimTree: Highlight current indent. Make current indent line diferent than the rest like mini.indent
--    [ ] NvimTree: Make when going back a dir move cursor to last folder (or even keep opened the folder that were opened like neotree)
--    [ ] NvimTree: Signs deprecated when in nvim 0.11, fix
--    [x] NvimTree: Decorator on far left for SIZE of file, should be easy
--    [x] cmdbuf: make you own with the autocmmd you made
--    [ ] OPTIONAL: cmdbuf(my own): ok i've done with cmdwin and autocommands, but what about an actuall window like cmdbuf?
--    [x] Focus: do you own focus looping through all windows that are not floating, and that's it =P
--    [x] Neovim: make cmdwin work with incpreview commands
--    [ ] Scope: Clean up and fix PR by pushing
--    [x] Colorscheme: Clean up and make it receive opts for transparancy
--    [x] Alacritty: change this BS of copying with crtl+shift+v, and remove crlt+y mapping
--    [x] Alacritty: Make it open on wsl
--    [ ] OPTIONAL: Either this rcarriga/nvim-notify or noice, if too many lsp message, altough it seems that fidget be aight for some notifications
--    [ ] KEYMAP MARKS: check for global marks per directory right? or is it for .git , check that about the plugin marks.nvim at some point
--    [ ] KEYMAP MARKS: keymaps for global marks could also be lowercase if we press shift couldn't it? See if you need some time from now
--    [ ] Nvimtree: make selection mode leave cursor at the last position before leaving
--    [x] incline.nvim: Experiment reverse order
--    [-] edit: dont wanna do itincline.nvim: and set percentage of file scrolling in the filename
--    [x] breadtrail.nvim: (edit: done it, but need to make signcolum better) plugin idea, simpler than trailblazer.nvim
--    [x] DONE: goto diagnostic bug
--    [x] fix cmdwin height
--    [x] auto preencha cmd line with Lastcmd
--    [x] fix quicklist keymaps
--    [x] insert "." and "_" in insert mode and ", "
--    [x] re in visaul mode first copy and restore register
--    [x] Telescope: path = {smart} for my picker
--    [x] CdHistory: stack of cds
--    [ ] fix nvimtree pr
--    [ ] Fix: start * on selection, it's slow and shit
--    [ ] Multiplecursor: make the thingy work better
--
--    [x] GOTTA TOGGLE comment better
--    [x] Comment: better when not in visual mode
--    [-] Comment: make it is not supported, insert single line comment on the start of cursor, should be doable with <> registers
--    [-] (edit: made my own focus) focus.nvim: Add test for new feature
--    [-] (edit: made my own focus) focus.nvim: better test when opening two floating windows
--    [x] Autocmd: Use remembered last number options when switching back
--    [x] 'visual' <leader>F need to scape '(' to '\('
--
--    [ ] marks.nvim: Check alternative for marks or fixit youself
--    [ ] IMPORTANT YANK_HISTORY slow
--    [x] AUTOCMD Enter terminal remove the lines and shit, autoquit when
--    [x] CmdwinEnter: Make StatusNC be conceal then return to previous when leaving
--    [x](edit: found le incline good) nvinca something like that
--
--
--    NOTE: Maybe you'd wnat this https://github.com/kdheepak/lazygit.nvim;
--          RN i don't see a reason to not just use lazygit on the terminal
--
--    IMPORTANT DONE: shit is crazy abouth treesitter combined with something else that I forgot (edit: vim-matchup is the thing)
--
--    IMPORTANT DONE: WSL `CMP` is rather slow if searches through the whole windows path,
--               My fix was to disable a bunch of file watcher and set dynamicRegistration = false to vairous
--               lspconfig default capabilities. Another fix is to set /etc/wsl.conf such as below (maybe even set enabled interop to false)
--                   [interop]
--                   enabled = true
--                   appendWindowsPath = false
--
--    IMPORTANT DONE: Conform is responsable for autoformat, but WHYY, Why do I need that instead of just a autocommand?
--
--    IMPORTANT (17-07-2024): Highlight float windows can only wither have winblend or background "none", but not both as it bugs out
--               see: https://github.com/rcarriga/nvim-notify/issues/47#issuecomment-1003326053
--               see: https://github.com/neovim/neovim/issues/18576
--
--    IMPORTANT COPILOT like https://github.com/b0o/supermaven-nvim
--
--    [ ] Alacritty graphics: support for sixel image on terminal: https://github.com/alacritty/alacritty/pull/4763 with this we might just do alot no  wiht neovim neoorg and stuff?
--    [ ] VScode like preview: https://github.com/DNLHC/glance.nvim
--    [ ] Read semantic HL (see about priority of hl): https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
--    [ ] LaTeX replacement for sure, made in rust from ground up: https://github.com/typst/typst
--    [x] DONE: Make the telescope prompt background not black
--    [x] DONE: focus when chaging into tree not change line number of previously focused window and stuff
--    [ ] INVESTIGATE .gitignore slow to type on big code paths
--    [ ] INVESTIGATE Snap on big code bases is it actually faster?
--    [ ] TEX: Check If I like that for TCC : https://github.com/jakewvincent/texmagic.nvim
--    [ ] @PR Nvimtree: only show folder icon if the file with gitsuff is not visible
--    [ ] @PR Nvimtree: Hiden folders with zero stuff in livefilter
--    [x] Nvimtree: why does this bs set numberline?
--    [x] DONE,HACK formatoptions being set by some plugin
--
------------------------------------------------------------------------------------------------------

--  NOTE: Tips I found in the wilds
--
-- (in VISUAL MODE)
-- :'<,'>!<shell_command><cr>
-- Output to buffer, or :redir @a :cmd and then :redir END to get the output of command into the `a` register

-- awesome list: https://github.com/rockerBOO/awesome-neovim

-- Non greedy search in vim is done using {-} operator. Like this:
-- %s/style=".\{-}"//g

-- :setlocal spell spelllang=en_us :help spell
-- ]s  " Move to the next misspelt word
-- [s  " Move to the previous misspelt word
-- z=  " Provide suggestions (you can entire the suggestion ID and enter to replace the word)
-- zg  " Add a word to the dictionary

-- nvim --clean or nvim -u NONE

------------------------------------------------------------------------------------------------------

-- [[ Setting globals utils functions before any plugin config function has any chance try to use a nil Global function ]]
require 'utils'

-- [[ Setting options ]]
require 'options'

-- NOTE: might be useful `vim.defer_fn` or `vim.schedule`

-- [[ Autocommands ]]
require 'autocommands'

-- [[ User Commands ]]
require 'commands'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'
