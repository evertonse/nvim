-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--
-- vim.cmd [[ filetype plugin off]]
-- vim.cmd [[ set omnifunc= ]]
local session_opts = { 'nvim-possession', 'ressession', 'auto-session', 'persistence' }
local surround_opts = { 'mini.surround', 'vim-surround' }
local file_tree_opts = { 'nvim-tree', 'neo-tree' }
vim.g.self = {
  linting_by_default = false,
  terminal_always_insert = false,
  use_minipick_when_slow = OnSlowPath(),
  autoskip_cmdline_on_esc = true,
  inc_rename = false,
  icons = true,
  nerd_font = true,
  signcolumn = 'yes',
  is_transparent = true,
  theme = 'pastel',
  wilder = false,
  session_plugin = session_opts[2], --NOTE: Better note Idk, bugs with Telescope sometimes
  mini_map = true or OnWindows() or OnSlowPath(),
  mini_pick = true or OnWindows() or OnSlowPath() or OnSSH(),
  notification_poll_rate = 80,
  file_tree = file_tree_opts[OnWindows() and 1 or 1],
  open_win_config_recalculate_every_time = true,
  enable_file_tree_preview = false,
  dont_format = { c = true, cpp = true, odin = true, python = true },
  cycles = {
    { '==', '!=' },
    { 'true', 'false' },
    { 'False', 'True' },
    { 'public', 'private' },
    { 'if', 'else', 'elseif' },
    { 'and', 'or' },
    { 'off', 'on' },
    { 'yes', 'no' },
    { '1', '2', '3' },
  },
  -- BufferPaths = {}, -- XXX: SomeHow it does not user when i's on vim.g, too make problems no cap
}

vim.cmd [[ :set sessionoptions-=options ]]
vim.cmd [[ set t_kb=^?]]

-- Will prevent shada files from being generated or read in Neovim.
-- For vim, set viminfo="NONE"
vim.cmd [[ set shada="NONE"]]

local o, opt, g = vim.o, vim.opt, vim.g

g.mapleader = ' '
g.maplocalleader = ' '
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
opt.fillchars:append { eob = ' ' }

if false then
  vim.loader.enable()
end

vim.o.cursorlineopt = 'both' -- to enable cursorline
-- opt.wildmode = 'list:longest,list:full' -- for : stuff
opt.wildmode = 'list:longest' -- for : stuff
opt.wildignore:append { '.javac', 'node_modules', '*.pyc' }
opt.wildignore:append { '.aux', '.out', '.toc' } -- LaTeX
opt.wildignore:append {
  '.o',
  '.obj',
  '.dll',
  '.exe',
  '.so',
  '.a',
  '.lib',
  '.pyc',
  '.pyo',
  '.pyd',
  '.swp',
  '.swo',
  '.class',
  '.DS_Store',
  '.git',
  '.hg',
  '.orig',
}
vim.o.wildmenu = true -- if set to `false` disallow autocomplete on cmdline since I'm using cmp.cmdline

opt.suffixesadd:append { '.java', '.rs' } -- search for suffexes using gf
-- vim.filetype.add

-- vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
-- vim.o.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos'
opt.sessionoptions = { -- XXX: required for scope.nvim
  'buffers',
  'tabpages',
  'globals',
}

-- Preview substitutions live, as you type!
opt.inccommand = 'nosplit' -- NO spliting the windows to see preview
-- opt.inccommand = 'split'

g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1

g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1

-- g.loaded_matchit = 1
-- g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

local options = {
  laststatus = 3,
  -- clipboard = nil, -- allows neovim to access the system clipboard
  clipboard = '',
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  completeopt = { 'noinsert', 'menuone', 'noselect', 'popup' }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = 'utf-8', -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  incsearch = true, -- Set Incremental search
  ignorecase = true, -- ignore case in search patterns
  mouse = 'a', -- allow the mouse to be used in neovim
  pumheight = 5, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 1, -- always show tabs
  smartcase = true, -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 10, -- faster completion (4000ms default)
  backup = false, -- creates a backup file
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

  expandtab = true, -- convert tabs to spaces
  tabstop = 4, -- insert 2 spaces for a tab
  softtabstop = -1,
  shiftwidth = 4, -- the number of spaces inserted for each indentation

  -- 'softtabstop' 'sts'	number	(default 0)
  -- 			local to buffer
  -- 	Number of spaces that a <Tab> counts for while performing editing
  -- 	operations, like inserting a <Tab> or using <BS>.  It "feels" like
  -- 	<Tab>s are being inserted, while in fact a mix of spaces and <Tab>s is
  -- 	used.  This is useful to keep the 'ts' setting at its standard value
  -- 	of 8, while being able to edit like it is set to 'sts'.  However,
  -- 	commands like "x" still work on the actual characters.
  -- 	When 'sts' is zero, this feature is off.
  -- 	When 'sts' is negative, the value of 'shiftwidth' is used.
  -- 	See also |ins-expandtab|.  When 'expandtab' is not set, the number of
  -- 	spaces is minimized by using <Tab>s.
  -- 	The 'L' flag in 'cpoptions' changes how tabs are used when 'list' is
  -- 	set.
  --
  -- 	The value of 'softtabstop' will be ignored if |'varsofttabstop'| is set
  -- 	to anything other than an empty string.
  -- :set tabstop? | set shiftwidth? | set softtabstop?

  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 1, -- set number column width to 2 {default 4}
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  linebreak = true, -- companion to wrap, don't split words
  scrolloff = 4, -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 4, -- minimal number of screen columns either side of cursor if wrap is `false`
  guifont = 'JetBrainsMono NF:h9.1', -- the font used in graphical neovim applications
  whichwrap = 'bs<>[]hl', -- which "horizontal" keys are allowed to travel to prev/next line
  breakindent = true,
}

o.undofile = true -- Enable persistent undo (see also `:h undodir`)

o.backup = false -- Don't store backup while overwriting the file
o.writebackup = false -- Don't store backup while overwriting the file

vim.cmd 'filetype plugin indent on' -- Enable all filetype plugins
vim.cmd [[ set backspace=indent,eol,start ]]

-- Appearance

o.ruler = false -- Don't show cursor position in command line
o.showmode = false -- Don't show mode in command line
o.wrap = false -- Display long lines as just one line

o.signcolumn = 'yes' -- Always show sign column (otherwise it will shift text)
o.fillchars = 'eob: ' -- Don't show `~` outside of buffer

o.infercase = true -- Infer letter cases for a richer built-in keyword completion

o.virtualedit = 'block' -- Allow going past the end of line in visual block mode
opt.formatoptions = 'qjl1' -- Don't autoformat comments

if vim.fn.has 'nvim-0.10' == 0 then
  o.termguicolors = true -- Enable gui colors
end

o.pumblend = vim.g.self.is_transparent and 0 or 10 -- Make builtin completion menus slightly transparent

o.pumheight = 10 -- Make popup menu smaller
o.winblend = vim.g.self.is_transparent and 0 or 10 -- Make floating windows slightly transparent

-- NOTE: Having `tab` present is needed because `^I` will be shown if
-- omitted (documented in `:h listchars`).
-- Having it equal to a default value should be less intrusive.

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = true -- Show some helper symbols
-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.listchars = { extends = '…', tab = '» ', trail = ' ', nbsp = '␣' }
-- o.listchars = 'tab:> ,,precedes:…,nbsp:␣' -- Define which helper symbols to show

-- Enable syntax highlighting if it wasn't already (as it is time consuming)
--if vim.fn.exists 'syntax_on' ~= 1 then
--vim.cmd [[syntax enable]]
--end

opt.diffopt:append 'linematch:50'

for k, v in pairs(options) do
  local ok = pcall(function()
    vim.opt[k] = v
  end)
  if not ok then
    vim.schedule(function() -- schedule to pretify warn later
      vim.notify('opt: ' .. tostring(k) .. ' not valid', vim.log.levels.WARN)
    end)
  end
end

-- NOTE: I'm not understanding something about this iskeyword thing because it
-- Actually jumps over '.' is I set this from lua !??
-- vim.opt.iskeyword:append { ':', '-' }

-- " Set options on the newly created buffer.
-- setlocal undolevels=-1     " Does not require undo (save memory).
-- setlocal buftype=nofile    " Is not associated with a file.
-- setlocal noswapfile        " Never has a swapfile.
-- setlocal colorcolumn=      " No color column (slows down scrolling).
-- setlocal syntax=off        " Syntax hl is very slow with long lines.
-- setlocal foldmethod=manual " Only manual folding.
-- setlocal nofoldenable      " Off means 'all folds open'.
-- setlocal complete-=wbuU    " Disable parts of completion.

opt.shortmess:append 'saAtilmnrxwWoOtTIFcC' -- flags to shorten vim messages, see :help 'shortmess'
opt.shortmess:append 'c' -- don't give |ins-completion-menu| messages
if vim.fn.has 'nvim-0.9' == 1 or (vim.version().major > 10) then
  opt.shortmess:append 'WcC' -- Reduce command line messages
else
  opt.shortmess:append 'Wc' -- Reduce command line messages
end
o.splitkeep = 'screen' -- Reduce scroll during window split

-- see :h fo-table
opt.formatoptions:append 'n'
vim.cmd [[set formatoptions=qrn1j]]
opt.formatoptions:remove { 'c', 'r', 'o' } -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.cmd [[:set formatoptions-=cro ]]

opt.runtimepath:remove '/vimfiles' -- separate vim plugins from neovim in case vim still in use

-- Set the directory for undo files
opt.undodir = (os.getenv 'HOME' or '') .. '/.local/share/nvim'

-- [[ Setting vim cmds ]]
vim.cmd ':set display-=msgsep'
-- vim.cmd ':set display-=lastline' -- No Line on left
-- vim.cmd ':set nomore'
vim.cmd ':set more'

if OnSSH() then
  vim.cmd ':set lz' -- Lazy Redraw
  vim.cmd ':set ttyfast'
  vim.o.ttyfast = true
  vim.opt.timeoutlen = 300
  vim.opt.ttimeoutlen = 10 -- Default is 100 ms
  vim.opt.undolevels = 100 -- Default is 1000
  vim.opt.swapfile = false
  vim.opt.mouse = ''
  vim.opt.foldenable = false
  vim.opt.synmaxcol = 128 -- Only highlight the first 128 columns
  vim.opt.lazyredraw = true -- Don't redraw while executing macros
  vim.opt.signcolumn = 'no' -- Disable the sign column
  vim.opt.foldmethod = 'manual'
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.cmd [[autocmd! CursorHold,CursorHoldI]] -- Minimize autocmd activity
  vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
else
  vim.cmd ':set nolz'
  vim.opt.foldenable = true
end

--vim.cmd [[ :set iskeyword-=- ]]
vim.cmd ':set clipboard=""'

-- vim.opt.matchpairs:append '<:>'
-- NOTE: Needs to make sure matchit is not disabled
-- vim.g.matchit_words = vim.g.matchit_words and vim.g.matchit_words .. ',function:end' or 'function:end'
-- Ensure matchit is not disabled
local matchit_extend = function()
  -- List of pairs to add
  local pairs_to_add = {
    'function:end',
    'if:endif',
    'switch:case',
    'case:break',
    'for:endfor',
    'while:endwhile',
    'try:endtry',
    'case:endcase',
    'do:done',
    'repeat:until',
  }

  -- Loop through each pair and append to matchit_words
  for _, pair in ipairs(pairs_to_add) do
    if vim.g.matchit_words then
      vim.g.matchit_words = vim.g.matchit_words .. ',' .. pair
    else
      vim.g.matchit_words = pair
    end
  end
  -- If matchit_words is not set, initialize it with the first pair
end

matchit_extend()

-- Long lines a the single most important reason for when it's lagging for no reason
-- Limiting the highlighting based on column looks like a decent solution
vim.cmd [[set synmaxcol=250]]

if OnWsl() then
  vim.cmd [[
  "set clipboard+=unnamedplus
  let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
  ]]
end
