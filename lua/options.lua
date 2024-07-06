-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.loader.enable()
vim.o.cursorlineopt = 'both' -- to enable cursorline
vim.o.wildmenu = false -- if set to `false` disallow autocomplete on cmdline since I'm using cmp.cmdline
-- vim.opt.wildmode = 'list:longest,list:full' -- for : stuff
vim.opt.wildmode = 'list:longest' -- for : stuff
vim.opt.wildignore:append { '.javac', 'node_modules', '*.pyc' }
vim.opt.wildignore:append { '.aux', '.out', '.toc' } -- LaTeX
vim.opt.wildignore:append {
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
vim.opt.suffixesadd:append { '.java', '.rs' } -- search for suffexes using gf

-- vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
vim.o.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos'
vim.opt.sessionoptions = { -- required
  'buffers',
  'tabpages',
  'globals',
}

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false -- set to true to see whitespace
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '» ', trail = ' ', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'nosplit' -- NO spliting the windows to see preview
-- vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

local g = vim.g

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

g.loaded_matchit = 1
g.loaded_matchparen = 1
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
  backup = false, -- creates a backup file
  -- clipboard = nil, -- allows neovim to access the system clipboard
  clipboard = '',
  cmdheight = 1, -- more space in the neovim command line for displaying messages
  completeopt = { 'menuone', 'noselect' }, -- mostly just for cmp
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
  timeoutlen = 75, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 10, -- faster completion (4000ms default)
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

vim.opt.diffopt:append 'linematch:50'

for k, v in pairs(options) do
  vim.opt[k] = v
end
vim.opt.shortmess:append 'saAtilmnrxwWoOtTIFcC' -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append 'c' -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append '-' -- hyphenated words recognized by searches
vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove '/vimfiles' -- separate vim plugins from neovim in case vim still in use

-- Enable persistent undo
vim.opt.undofile = true

-- Set the directory for undo files
vim.opt.undodir = (os.getenv 'HOME' or '') .. '/.local/share/nvim'

-- [[ Setting vim cmds ]]
vim.cmd ':set display-=msgsep'
-- vim.cmd ':set display-=lastline' -- No Line on left
vim.cmd ':set nomore'
-- vim.cmd ':set lz' -- Lazy Redraw
-- vim.cmd ':set ttyfast' -- Lazy Redraw
vim.cmd [[ :set iskeyword-=- ]]
vim.cmd [[ :set backup ]]
-- vim.cmd ':set clipboard=""'

local on_wsl = function()
  local output = vim.fn.systemlist 'uname -r'
  return #output > 0 and string.find(output[1], 'WSL')
end

if on_wsl() then
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
