local M = {}

local list = {}
-- Illuminate plugin
-- https://github.com/RRethy/vim-illuminate

list.illuminate = {
  on = true,

  enable = function()
    if vim.fn.exists ':IlluminateResumeBuf' ~= 2 then
      return
    end
    vim.cmd 'IlluminateResumeBuf'
  end,

  disable = function()
    if vim.fn.exists ':IlluminatePauseBuf' ~= 2 then
      return
    end
    vim.cmd 'IlluminatePauseBuf'
  end,
}

-- MatchParen

list.matchparen = {
  on = true,

  enable = function()
    if vim.fn.exists ':DoMatchParen' ~= 2 then
      return
    end
    vim.cmd 'DoMatchParen'
  end,

  disable = function()
    if vim.fn.exists ':NoMatchParen' ~= 2 then
      return
    end
    vim.cmd 'NoMatchParen'
  end,
}

-- LSP

list.lsp = {
  on = true,

  enable = function()
    if vim.fn.exists ':LspStart' ~= 2 then
      return
    end
    vim.cmd 'LspStart'
  end,

  disable = function()
    if vim.fn.exists ':LspStop' ~= 2 then
      return
    end
    vim.cmd 'LspStop'
  end,
}

-- Treesitter

local treesitter_backup = {}
local treesitter_disabled = false

list.treesitter = {
  on = true,

  enable = function()
    local status_ok, _ = pcall(require, 'nvim-treesitter.configs')
    if not status_ok then
      return
    end

    if vim.fn.exists ':TSBufEnable' ~= 2 then
      return
    end

    if treesitter_disabled == true then
      -- Return treesitter module state from backup
      for _, mod_state in ipairs(treesitter_backup) do
        if mod_state.enable then
          vim.cmd('TSBufEnable ' .. mod_state.mod_name)
        end
      end
      treesitter_disabled = false
    end
  end,

  disable = function()
    local status_ok, treesitter_config = pcall(require, 'nvim-treesitter.configs')
    if not status_ok then
      return
    end

    if vim.fn.exists ':TSBufDisable' ~= 2 then
      return
    end

    -- Backup current treesitter module "enable" state
    if treesitter_disabled == false then
      for _, mod_name in ipairs(treesitter_config.available_modules()) do
        local module_config = treesitter_config.get_module(mod_name) or {}
        table.insert(treesitter_backup, { mod_name = mod_name, enable = module_config.enable })
      end
      treesitter_disabled = true
    end

    for _, mod_name in ipairs(treesitter_config.available_modules()) do
      vim.cmd('TSBufDisable ' .. mod_name)
    end
  end,
}

-- Indent Blankline
-- https://github.com/lukas-reineke/indent-blankline.nvim

list.indent_blankline = {
  on = true,

  enable = function()
    if vim.fn.exists ':IBLEnable' ~= 2 then
      return
    end
    vim.cmd 'IBLEnable'
  end,

  disable = function()
    if vim.fn.exists ':IBLDisable' ~= 2 then
      return
    end
    vim.cmd 'IBLDisable'
  end,
}

-- Vimopts
--

local vimopts_backup = {}
local vimopts_disabled = false

list.vimopts = {
  on = true,

  enable = function()
    if vimopts_disabled == true then
      vim.opt_local.statuscolumn = vimopts_backup.statuscolumn
      vim.opt_local.conceallevel = vimopts_backup.conceallevel
      vim.opt_local.swapfile = vimopts_backup.swapfile
      vim.opt_local.foldmethod = vimopts_backup.foldmethod
      vim.opt_local.undolevels = vimopts_backup.undolevels
      vim.opt_local.undoreload = vimopts_backup.undoreload
      vim.opt_local.list = vimopts_backup.list
      vimopts_disabled = false
    end
  end,

  disable = function()
    if vimopts_disabled == false then
      vimopts_backup.statuscolumn = vim.opt_local.statuscolumn
      vimopts_backup.conceallevel = vim.opt_local.conceallevel
      vimopts_backup.swapfile = vim.opt_local.swapfile
      vimopts_backup.foldmethod = vim.opt_local.foldmethod
      vimopts_backup.undolevels = vim.opt_local.undolevels
      vimopts_backup.undoreload = vim.opt_local.undoreload
      vimopts_backup.list = vim.opt_local.list
      vimopts_disabled = true
    end
    vim.opt_local.statuscolumn = ''
    vim.opt_local.conceallevel = 0
    vim.opt_local.swapfile = false
    vim.opt_local.foldmethod = 'manual' --- Bad for me, it folds everything
    -- vim.opt_local.undolevels = -1 --- Makes no undo
    vim.opt_local.undoreload = 0
    vim.opt_local.list = false
  end,
}

-- Syntax

local syntax_backup = {}
local syntax_disabled = false

list.syntax = {
  on = false,

  enable = function()
    if syntax_disabled == true then
      vim.opt_local.syntax = syntax_backup.syntax
      syntax_disabled = false
    end
  end,

  disable = function()
    if syntax_disabled == false then
      syntax_backup.syntax = vim.opt_local.syntax
      syntax_disabled = true
    end
    vim.cmd 'syntax clear'
    vim.opt_local.syntax = 'off'
  end,
}

-- Filetype

local filetype_backup = {}
local filetype_disabled = false

list.filetype = {
  on = false,

  enable = function()
    if filetype_disabled == true then
      vim.opt_local.filetype = filetype_backup.filetype
      filetype_disabled = false
    end
  end,

  disable = function()
    if filetype_disabled == false then
      filetype_backup.filetype = vim.opt_local.filetype
      filetype_disabled = true
    end
    vim.opt_local.filetype = ''
  end,
}

-- Lualine
-- https://github.com/nvim-lualine/lualine.nvim

list.lualine = {
  on = true,

  enable = function()
    pcall(function()
      require('lualine').hide { unhide = true }
    end)
  end,

  disable = function()
    pcall(function()
      require('lualine').hide()
    end)
  end,
}

local should_disable = function(bufnr)
  local fts = { 'bin', 'odin', 'tmux', 'llvm', 'conf' }
  for i, ft in ipairs(fts) do
    if vim.bo.filetype == ft then
      return true
    end
  end

  local buf_name = vim.api.nvim_buf_get_name(bufnr)

  if string.find(buf_name, 'tmux%-') then
    return true
  end

  local info = vim.loop.fs_stat(buf_name)
  local file_size_permitted = (20 * 1024 * 1024)
  local is_large_file = vim.fn.getfsize(buf_name) > file_size_permitted
  local is_large_file = info and (info.size > (20 * 1024 * 1024))

  if is_large_file then
    return true
  end

  if vim.api.nvim_buf_line_count(bufnr) > 200 * 1000 then
    return true
  end

  return false
end

local disable = function(args)
  -- TODO confirm that it schedule is needed
  -- vim.schedule(function()
  if should_disable(args.buf) then
    vim.notify 'Huge File Detected'
    vim.api.nvim_buf_call(args.buf, function()
      if vim.fn.exists ':NoMatchParen' ~= 0 then
        vim.cmd [[NoMatchParen]]
      end
      vim.b.minianimate_disable = true

      local pedantic = false
      for name, plugin in pairs(list) do
        -- TODO check this config.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
        if plugin.disable ~= nil then
          if plugin.on then
            if pedantic then
              vim.notify('Applying ' .. name)
            end
            plugin.disable()
          end
        end
      end
    end)
  else
    if true then
      return
    end
    for name, plugin in pairs(list) do
      if plugin.enable ~= nil then
        if plugin.on then
          plugin.enable()
        end
      end
    end
  end
  -- end)
end

M.init = function()
  local augroup = vim.api.nvim_create_augroup('huge-file', {})

  vim.api.nvim_create_autocmd('BufReadPre', {
    pattern = { '*' },
    group = augroup,
    callback = disable,
    desc = 'Huge-file',
  })

  local _ = true
    and vim.api.nvim_create_autocmd('BufReadPost', {
      pattern = { '*' },
      group = augroup,
      callback = disable,
      desc = 'Huge-file Post',
    })
end

M.stop = function()
  vim.api.nvim_del_augroup_by_name 'huge-file'
end

M.setup = M.init

return M
