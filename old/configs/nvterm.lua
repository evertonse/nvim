--https://github.com/NvChad/nvterm
local status_ok, nvterm = pcall(require, "nvterm")
if not status_ok then
  return false
end

nvterm.setup {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.3,
        col = 0.25,
        width = 0.4,
        height = 0.55,
        border = "single",
      },
      horizontal = {
        location = "rightbelow",
        split_ratio = 0.5,
        relative = "editor",
        border = "single",
      },
      vertical = { location = "rightbelow", split_ratio = 0.55 },
    },
  },
  behavior = {
    autoclose_on_quit = {
      enabled = false,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = false,
  },
}

local terminal = require "nvterm.terminal"

local toggle_modes = { "n", "t" }
local mappings = {
  {
    toggle_modes,
    "<A-h>",
    function()
      terminal.toggle "horizontal"
    end,
  },
  {
    toggle_modes,
    "<A-o>",
    function()
      terminal.toggle "vertical"
    end,
  },
  {
    toggle_modes,
    "<A-i>",
    function()
      terminal.toggle "float"
    end,
  },
  {
    toggle_modes,
    "<F5>",
    function()
      terminal.send("make run -j 3 > make.log &", "float")
      -- terminal.send("make -j 3 &" .. vim.fn.expand "%", "float")
    end,
  },
  {
    { "n" },
    "<leader><A-h>",
    function()
      terminal.new "horizontal"
    end,
  },
  {
    { "n" },
    "<leader><A-v>",
    function()
      terminal.new "vertical"
    end,
  },
  {
    { "n" },
    "<leader><A-i>",
    function()
      terminal.new "float"
    end,
  },
}
local opts = { noremap = true, silent = true }
for _, mapping in ipairs(mappings) do
  vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
end

return true
