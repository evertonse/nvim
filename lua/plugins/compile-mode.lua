return {
  -- 'evertonse/compile-mode.nvim',
  'ej-shafran/compile-mode.nvim',
  -- tag = 'v5.*',
  -- tag = 'v5.3.0',
  main = 'main',

  lazy = false,
  -- you can just use the latest version:
  -- branch = "latest",
  -- or the most up-to-date updates:
  -- branch = "nightly",
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- if you want to enable coloring of ANSI escape codes in
    -- compilation output, add:
    { 'm00qek/baleia.nvim', tag = 'v1.3.0' },
  },
  config = function()
    ---@type CompileModeOpts
    vim.g.compile_mode = {
      -- to add ANSI escape code support, add:
      -- baleia_setup = true,
    }
  end,
}
