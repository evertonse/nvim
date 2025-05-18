--- See `:help vim.opt`
local o, opt, g = vim.o, vim.opt, vim.g

---  Sync clipboard between OS and Neovim.
---  See `:help 'clipboard'`

--- This idk what it is exactly just a vague idea
-- vim.cmd [[ set omnifunc= ]]

-- vim.cmd [[ set t_kb=^?]]
vim.cmd [[set sessionoptions-=options ]]
--- WARNING: These lines are dangerous, they might break 'gF' for example
-- vim.cmd [[filetype plugin on]]
-- vim.cmd [[filetype plugin indent off]]

--- WARNING: These below are about find certain filetypes
---          See: https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
-- g.do_filetype_lua = 0 -- I don't think this works anymore
-- - A value of 0 for this variable disables filetype.vim. A value of 1 disables both filetype.vim and filetype.lua (which you probably don't want).
-- g.did_load_filetypes = 0

g.mapleader = ' '
g.maplocalleader = ' '

-- Disable some default providers
g.loaded_perl_provider = 1
g.loaded_ruby_provider = 1
g.loaded_node_provider = 1
g.loaded_python_provider = 1
g.loaded_python3_provider = 1

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_matchparen = 1
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_rrhelper = 1
g.loaded_2html_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_logiPat = 1
g.loaded_spellfile_plugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

opt.fillchars:append { eob = ' ' }

opt.shadafile = 'NONE' -- equilavent to vim.cmd [[set shada=]]

o.cursorlineopt = 'both' -- to enable cursorline
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

-- if set to `false` disallow autocomplete on cmdline since I'm using completion plugin
o.wildmenu = false
--
-- Search for suffixes using gf
opt.suffixesadd:append { '.java', '.rs' }

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

opt.laststatus = 3

--- UFrom here
opt.completeopt = { 'noinsert', 'menuone', 'noselect', 'popup' } -- mostly just for cmp
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = 'utf-8' -- the encoding written to a file
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.incsearch = true -- Set Incremental search
opt.ignorecase = true
opt.smartcase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.mouse = 'a' -- allow the mouse to be used in neovim
opt.pumheight = 5 -- pop up menu height
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 1 -- always show tabs
opt.smartindent = true -- make indenting smarter againopt
opt.autoindent = true -- Keep identation from previous line
opt.breakindent = true
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- creates a swapfile
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true -- enable persistent undo
opt.updatetime = 75 -- CursorHold
opt.backup = false -- creates a backup file
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab = true -- convert tabs to spaces
opt.tabstop = 4 -- insert 2 spaces for a tab
opt.softtabstop = -1
opt.shiftwidth = 4 -- the number of spaces inserted for each indentation

opt.cursorline = true -- highlight the current line
opt.number = true -- set numbered lines
opt.relativenumber = true -- set relative numbered lines
opt.signcolumn = 'yes' -- always show the sign column, otherwise it would shift the text each time
opt.numberwidth = 2 -- set number column width to 2 {default 4}
opt.wrap = false -- display lines as one long line
opt.linebreak = true -- companion to wrap, don't split words
opt.scrolloff = 3 -- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 4 -- minimal number of screen columns either side of cursor if wrap is `false`
opt.guifont = 'JetBrainsMono NF:h9.1' -- the font used in graphical neovim applications
opt.whichwrap = 'bs<>[]hl' -- which "horizontal" keys are allowed to travel to prev/next line

opt.cmdheight = 1 -- more space in the neovim command line for displaying messages

o.undofile = true -- Enable persistent undo (see also `:h undodir`)

o.backup = false -- Don't store backup while overwriting the file
o.writebackup = false -- Don't store backup while overwriting the file

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

o.pumblend = g.self.is_transparent and 0 or 10 -- Make builtin completion menus slightly transparent

o.winblend = g.self.is_transparent and 0 or 10 -- Make floating windows slightly transparent

-- NOTE: Having `tab` present is needed because `^I` will be shown if
-- omitted (documented in `:h listchars`).
-- Having it equal to a default value should be less intrusive.

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = true -- Show some helper symbols

-- chars: '·'
opt.listchars = { extends = '…', tab = '» ', trail = ' ', nbsp = '␣' }

opt.diffopt:append 'linematch:50'

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
opt.display = 'uhex'
-- vim.cmd ':set nomore'
vim.cmd ':set more'

if OnSSH() then
  vim.cmd ':set lz' -- Lazy Redraw
  vim.cmd ':set ttyfast'
  o.ttyfast = true
  opt.timeoutlen = 300
  opt.ttimeoutlen = 10 -- Default is 100 ms
  opt.undolevels = 100 -- Default is 1000
  opt.swapfile = false
  opt.mouse = ''
  opt.foldenable = false
  opt.synmaxcol = 128 -- Only highlight the first 128 columns
  opt.lazyredraw = true -- Don't redraw while executing macros
  opt.signcolumn = 'no' -- Disable the sign column
  opt.foldmethod = 'manual'
  opt.backup = false
  opt.writebackup = false
  vim.cmd [[autocmd! CursorHold,CursorHoldI]] -- Minimize autocmd activity
  lsp.handlers['textDocument/publishDiagnostics'] = function() end
else
  -- vim.cmd ':set nolz'
  opt.foldenable = false
end

--vim.cmd [[ :set iskeyword-=- ]]

-- NOTE: Needs to make sure matchit is not disabled
-- g.loaded_matchit = 1
-- g.loaded_matchparen = 1
vim.g.matchit_words = vim.g.matchit_words and vim.g.matchit_words .. ',function:end' or 'function:end'
-- Ensure matchit is not disabled
local matchit_extend = function()
  -- List of pairs to add
  local pairs_to_add = {
    '<:>',
    'pica:final',
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
-- vim.cmd [[set synmaxcol=250]]
vim.opt.synmaxcol = 420

-- opt.clipboard = nil, -- allows neovim to access the system clipboard
opt.clipboard = ''
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

local fuck_with_runtime = function()
  local paths = {
    '~/.config/nvim',
    ------------------
    -- Lazy.vim End --
    ------------------

    '~/.local/share/nvim/lazy/lazy.nvim',
    '~/.local/share/nvim/lazy/friendly-snippets',
    '~/.local/share/nvim/lazy/blink.cmp',
    '~/.local/share/nvim/lazy/mini.icons',
    '~/.local/share/nvim/lazy/oil.nvim',
    '~/.local/share/nvim/lazy/dressing.nvim',
    '~/.local/share/nvim/lazy/telescope-hop.nvim',
    '~/.local/share/nvim/lazy/telescope-ui-select.nvim',
    '~/.local/share/nvim/lazy/plenary.nvim',
    '~/.local/share/nvim/lazy/telescope.nvim',
    '~/.local/share/nvim/lazy/yazi.nvim',
    '~/.local/share/nvim/lazy/bufjump.nvim',
    '~/.local/share/nvim/lazy/which-key.nvim',
    '~/.local/share/nvim/lazy/vim-sleuth',
    '~/.local/share/nvim/lazy/zen-mode.nvim',
    '~/.local/share/nvim/lazy/mini.nvim',
    '~/.local/share/nvim/lazy/indent-blankline.nvim',
    '~/.local/share/nvim/lazy/cycler.nvim',
    '~/.local/share/nvim/lazy/telescope-fzf-native.nvim',
    '~/.local/share/nvim/lazy/dropbar.nvim',
    '~/.local/share/nvim/lazy/mason.nvim',
    '~/.local/share/nvim/lazy/nvim-web-devicons',
    '~/.local/share/nvim/lazy/lualine.nvim',
    '~/.local/share/nvim/lazy/nvim-treesitter-textobjects',
    '~/.local/share/nvim/lazy/nvim-treesitter',
    '~/.local/share/nvim/lazy/vim-bbye',
    '~/.local/share/nvim/lazy/scope.nvim',
    '~/.local/share/nvim/lazy/resession.nvim',
    '~/.local/share/nvim/lazy/multiple-cursors.nvim',
    '~/.local/share/nvim/lazy/stickybuf.nvim',
    '~/.local/share/nvim/lazy/colorscheme.nvim',
    ------------------
    -- Lazy.vim End --
    ------------------

    '~/.local/nvim-linux-x86_64/share/nvim/runtime',
    '~/.local/nvim-linux-x86_64/share/nvim/runtime/pack/dist/opt/matchit',
    '~/.local/nvim-linux-x86_64/lib/nvim',
    ------------------
    -- Runtime End  --
    ------------------

    '~/.local/share/nvim/lazy/indent-blankline.nvim/after',
    '~/.local/share/nvim/lazy/colorscheme.nvim/after',
    ------------------------
    -- After plugins End  --
    ------------------------

    '~/.config/nvim/after',
    ------------------------
    -- Our Config after   --
    ------------------------

    '~/.local/state/nvim/lazy/readme',
  }

  -- Comma separated
  vim.opt.runtimepath = vim.fn.stdpath 'config' .. ',' .. vim.fn.stdpath 'data' .. ',' .. vim.fn.stdpath 'config' .. '/after'
  -- .. "/home/excyber/.local/nvim-linux-x86_64/share/nvim/runtime/"
  -- .. "/home/excyber/.config/nvim/runtime/"
end
