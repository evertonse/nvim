local owner_repo = 'nvim-focus/focus.nvim'
local fork_repo = 'evertonse/focus.nvim'

return {
  fork_repo,
  version = false,
  lazy = false,
  enabled = false,
  config = function()
    local DEBUG = false
    require('focus').setup {
      enable = true, -- Enable module
      commands = true, -- Create Focus commands
      autoresize = {
        enable = false, -- Enable or disable auto-resizing of splits
        width = 0, -- Force width for the focused window
        height = 0, -- Force height for the focused window
        minwidth = 0, -- Force minimum width for the unfocused window
        minheight = 0, -- Force minimum height for the unfocused window
        height_quickfix = 10, -- Set the height of quickfix panel
      },
      split = {
        bufnew = false, -- Create blank buffer for new split windows
        tmux = false, -- Create tmux splits instead of neovim splits
      },
      ui = {
        number = false, -- Display line numbers in the focussed window only
        relativenumber = true, -- Display relative line numbers in the focussed window only
        hybridnumber = true, -- Display hybrid line numbers in the focussed window only
        absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

        cursorline = true, -- Display a cursorline in the focussed window only
        cursorcolumn = false, -- Display cursorcolumn in the focussed window only
        colorcolumn = {
          enable = false, -- Display colorcolumn in the foccused window only
          list = '+1', -- Set the comma-saperated list for the colorcolumn
        },
        signcolumn = true, -- Display signcolumn in the focussed window only
        winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
      },
    }

    local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

    local ignore_filetypes = { 'neo-tree', 'NvimTree' }
    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      callback = function(_)
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ''
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) or is_floating then
          vim.b.focus_disable = true
          if DEBUG then
            print('recognized focus filetype = ' .. vim.bo.filetype)
          end
        else
          vim.b.focus_disable = false
        end
      end,
      desc = 'Disable focus autoresize for FileType',
    })

    -- NOTE: All this code is to not fuckup column placement of code when going into a floating window
    local previous_win = {
      id = -1,
      config = nil,
    }
    local ignore_buftypes = { 'nofile', 'prompt', 'popup' }
    vim.api.nvim_create_autocmd({ 'WinLeave' }, {
      group = augroup,
      callback = function(args)
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ''
        if not is_floating then
          previous_win.config = vim.api.nvim_win_get_config(0)
          previous_win.id = vim.api.nvim_get_current_win()
        end
      end,
    })
    -- vim.api.nvim_create_autocmd({ 'BufLeave' }, {
    vim.api.nvim_create_autocmd({ 'WinEnter' }, {
      group = augroup,
      callback = function(args)
        local is_floating = vim.api.nvim_win_get_config(0).relative ~= ''
        local is_valid_win = vim.api.nvim_win_is_valid(previous_win.id)

        if is_floating and is_valid_win then
          if DEBUG then
            vim.fn.confirm(vim.inspect(previous_win))
            vim.cmd [[setlocal ]]
          end
          local win_id = previous_win.id
          -- vim.api.nvim_win_set_config(previous_win.id, previous_win.config)
          vim.api.nvim_win_set_option(win_id, 'signcolumn', vim.opt.signcolumn:get())
          vim.api.nvim_win_set_option(win_id, 'relativenumber', vim.opt.relativenumber:get())
          vim.api.nvim_win_set_option(win_id, 'number', vim.opt.number:get())
        end

        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) or is_floating then
          vim.w.focus_disable = true
        else
          vim.w.focus_disable = false
        end
      end,
    })
  end,
}
