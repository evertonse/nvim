local augroup = vim.api.nvim_create_augroup('huge-file', {})
local M = {}

local bufs = {}
local list = {}

-- NOTE: At the point this function gets called (in Pre buffer read) we don't have access to filetype nor line count xD, now go my child, go play with this footgun.
--       Also, filetype is not decided by vim at this point (^Pre), it's actully an extension XD, sorry
local should_disable = function(bufnr)
  local buf = bufs[bufnr]
  local buf_ft = buf:ft()

  local fts = { 'bin', 'odin', 'tmux', 'llvm', 'conf' }
  for i, ft in ipairs(fts) do
    if buf_ft == ft then
      return true
    end
  end

  if string.find(buf.name, 'tmux%-') then
    return true
  end

  local MB = 8
  if buf.size > (MB * 1024 * 1024) then
    return true
  end

  -- NOTE: line_count in BufReadPre is always 1, useless here
  if buf:line_count() > 25 * 1000 then
    return true
  end

  return false
end

local should_disable_aggressively = function(bufnr)
  local buf = bufs[bufnr]
  local ft = buf:ft()
  if (ft == 'sh' or ft == 'zsh') and buf:line_count() > 100 * 1000 then
    return true
  end

  if ft == 'c' then
    return false
  end

  return false
end
-- Illuminate plugin
-- https://github.com/RRethy/vim-illuminate

list.misc = {
  on = true,
  disable = function()
    if vim.fn.exists ':NoMatchParen' ~= 0 then
      vim.cmd [[NoMatchParen]]
    end
    vim.b.minianimate_disable = true
  end,
}

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
      -- Never disable highlight should be done in Very Huge if necessary
      if not mod_name == 'highlight' then
        vim.cmd('TSBufDisable ' .. mod_name)
      end
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
  schedule = true,

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

  disable = vim.schedule_wrap(function(bufnr)
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

    vim.opt_local.cursorline = false
    vim.opt_local.redrawtime = 12525
    vim.opt_local.cursorcolumn = false
    -- vim.cmd [[setlocal nocursorcolumn]]
    -- vim.cmd [[setlocal nocursorline]]
    vim.cmd [[setlocal norelativenumber]]
    vim.cmd [[syntax sync minlines=256]]
  end),
}

-- Syntax

local syntax_backup = {}
local syntax_disabled = false

list.syntax = {
  on = true,
  schedule = true,

  enable = function(bufnr)
    if syntax_disabled == true then
      vim.opt_local.syntax = syntax_backup.syntax
      syntax_disabled = false
    end
  end,

  disable = function(bufnr)
    if syntax_disabled == false then
      syntax_backup.syntax = vim.opt_local.syntax
      syntax_disabled = true
    end

    if should_disable_aggressively(bufnr) and vim.treesitter.highlighter.active[bufnr] == nil then
      vim.cmd 'syntax clear'
      vim.opt_local.synmaxcol = 200
      vim.opt_local.syntax = 'off'
      vim.opt_local.filetype = ''
    end
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

------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------

local buf_populate = function(bufnr)
  bufs[bufnr] = {
    processed = false,
    name = vim.api.nvim_buf_get_name(bufnr),
    ft = function(self)
      local ft = vim.bo[bufnr].filetype
      if ft ~= nil and ft ~= '' then
        return ft
      end

      local ext = self.name:match '^.+(%..+)$' or ''
      return ext:gsub('^%.', '')
    end,

    line_count = function(self)
      if self.__line_count > 1 then
        return self.__line_count
      end

      self.__line_count = vim.api.nvim_buf_line_count(bufnr)

      local ft = vim.bo[bufnr].filetype
      if ft ~= nil and ft ~= '' and self.__line_count == 1 then
        return -1
      end

      return self.__line_count
    end,

    __line_count = -1,
  }

  local info = vim.loop.fs_stat(bufs[bufnr].name) -- vim.fn.getfsize(bufs[bufnr].name)
  bufs[bufnr].size = info and info.size or -1
end

local pre_bufread_callback = function(bufnr)
  if bufs[bufnr] and bufs[bufnr].processed then
    return
  end
  buf_populate(bufnr)

  local pedantic = false
  local rest = {}

  if should_disable(bufnr) then
    bufs[bufnr].processed = true

    local msg = ('Huge File Detected' .. vim.api.nvim_buf_get_name(bufnr))
    vim.notify(msg)

    for name, plugin in pairs(list) do
      if plugin and plugin.disable ~= nil and plugin.on then
        if plugin.schedule == nil or plugin.schedule == false then
          if pedantic then
            vim.notify('Applying ' .. name)
          end
          plugin.disable(bufnr)
        else
          rest[name] = plugin
        end
      end
    end
  end

  -- Schedule disabling deferred features
  vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    group = group,
    buffer = bufnr,
    callback = vim.schedule_wrap(function()
      -- Inspect { plugin }
      for name, plugin in pairs(rest) do
        if pedantic then
          vim.notify('Applying scheduled ' .. name)
        end
        plugin.disable(bufnr)
      end
    end),
    -- callback = vim.schedule_wrap(function()
    --   Inspect { plugin }
    --   vim.api.nvim_buf_call(bufnr, function()
    --     for name, plugin in pairs(rest) do
    --       if pedantic then
    --         vim.notify('Applying scheduled ' .. name)
    --       end
    --       plugin.disable(bufnr)
    --     end
    --   end)
    -- end),
  })
end

M.init = function()
  -- 'BufReadPre' is too early for local options
  vim.api.nvim_create_autocmd({ 'VimEnter', 'BufReadPre' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(args)
      pre_bufread_callback(args.buf)
    end,
    desc = 'Huge-file',
  })

  vim.api.nvim_create_autocmd({ 'BufDelete' }, {
    pattern = { '*' },
    group = augroup,
    callback = function(args)
      bufs[args.buf] = nil
    end,
    desc = 'Huge-file',
  })
end

M.stop = function()
  vim.api.nvim_del_augroup_by_name 'huge-file'
end

M.setup = M.init

return M
