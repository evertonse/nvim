local width_percentage = 0.6
local height_percentage = 0.5

local hook_term_open = function(t)
  t.hidden = true
  if t.direction == 'float' then
    t.float_opts.width = math.floor(vim.o.columns * height_percentage)
    t.float_opts.height = math.floor(vim.o.lines * height_percentage)
  end
  ShowStringAndWait(TableDump2(t))
end

return {
  'akinsho/toggleterm.nvim',
  lazy = true,
  event = 'VimEnter',
  version = '*',
  opts = {
    highlights = {
      -- highlights which map to a highlight group name and a table of it's values
      -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
      NormalFloat = {
        link = 'Normal',
      },
      FloatBorder = {
        link = 'FloatBorder',
      },
    },
    close_on_exit = true,
    persist_size = false,
    -- on_close = hook_term_open,
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      else
        while true do
          print(term.direction)
        end
      end
    end,
    auto_scroll = false,
    start_in_insert = true,
    autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    shade_terminals = false,
    float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      --border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      border = 'single',
      -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
      width = math.floor(vim.o.columns * width_percentage),
      height = math.floor(vim.o.lines * height_percentage),
      zindex = 1000,
      title_pos = 'center',
    },
    winbar = {
      enabled = false,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end,
    },
  },
}
