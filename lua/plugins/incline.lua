return {
  'b0o/incline.nvim',
  event = 'VeryLazy',
  lazy = true,
  enabled = true,
  dependencies = {
    { 'SmiteshP/nvim-navic', opts = { lsp = { auto_attach = true } } },
  },
  config = function()
    local helpers = require 'incline.helpers'

    local navic = require 'nvim-navic'
    local devicons = require 'nvim-web-devicons'
    local use_winblend_even_in_transperancy = false

    local bg = vim.g.self.is_transparent and 'NONE' or '#222222'
    local winblend = vim.g.self.is_transparent and 0 or 30

    if use_winblend_even_in_transperancy and vim.g.self.is_transparent then
      bg = '#404040'
      winblend = vim.g.self.is_transparent and 25
    end

    require('incline').setup {
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false,
      },
      window = {
        overlap = {
          borders = true,
          statusline = true,
          tabline = false,
          winbar = true,
        },
        options = {
          winblend = winblend,
        },
        placement = {
          horizontal = 'right',
          vertical = 'top',
        },
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
        winhighlight = {
          active = {
            EndOfBuffer = 'None',
            -- Normal = 'InclineNormal',
            Normal = 'Normal',
            Search = 'None',
          },
          inactive = {
            Normal = 'Normal',
            -- Normal = 'InclineNormalNC',
            EndOfBuffer = 'None',
            Search = 'None',
          },
        },
      },
      render = function(props)
        local REVERSE = true

        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if filename == '' then
          filename = '[No Name]'
        end
        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        local res = {
          ft_icon and { ' ', ft_icon, ' ', guibg = bg, guifg = ft_color } or '',
          '',
          { filename, gui = modified and 'bold,italic' or 'bold' },
          guibg = bg,
        }
        if props.focused then
          for _, item in ipairs(navic.get_data(props.buf) or {}) do
            local res_item = {
              { item.icon },
              { item.name },
            }

            if REVERSE then
              table.insert(res_item, { ' < ' })
            else
              table.insert(res_item, 0, { ' > ' })
            end

            table.insert(res, res_item)
          end
          -- vim.api.nvim_set_hl(0, 'NavicIconsField', { default = true, bg = 'NONE', fg = '#ffffff' })
          -- vim.api.nvim_set_hl(0, 'NavicIconsConstructor', { default = true, bg = '#000000', fg = '#ffffff' })
          -- vim.api.nvim_set_hl(0, 'NavicIconsEnum', { default = true, bg = '#000000', fg = '#ffffff' })
          -- vim.api.nvim_set_hl(0, 'NavicIconsInterface', { default = true, bg = '#000000', fg = '#ffffff' })
          -- vim.api.nvim_set_hl(0, 'NavicIconsFunction', { default = true, bg = '#000000', fg = '#ffffff' })
          -- vim.api.nvim_set_hl(0, 'NavicIconsVariable', { default = true, bg = '#000000', fg = '#ffffff' })
          -- vim.api.nvim_set_hl(0, 'NavicIconsConstant', { default = true, bg = '#000000', fg = '#ffffff' })
        end
        table.insert(res, '')
        return REVERSE and ReverseTable(res) or res
      end,
    }

    vim.cmd [[:set laststatus=3]]
  end,
  -- Optional: Lazy load Incline
}
