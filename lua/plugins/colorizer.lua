-- PERF aware, this is slow hence events or call it yourself because if big buffer then big trouble
return {
  'NvChad/nvim-colorizer.lua',
  event = 'User FilePost',
  -- event = 'VezyLazy',
  -- event = 'VimEnter',
  -- event = 'BufEnter',
  cmd = {
    'ColorizerAttachToBuffer',
    'ColorizerDetachFromBuffer',
    'ColorizerReloadAllBuffers',
    'ColorizerToggle',
  },
  opts = {
    user_default_options = {
      names = false,
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      RRGGBBAA = false, -- #RRGGBBAA hex codes
      AARRGGBB = false, -- 0xAARRGGBB hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = 'background', -- Set the display mode.
      -- Available methods are false / true / "normal" / "lsp" / "both"
      -- True is same as normal
      tailwind = true, -- Enable tailwind colors
      -- parsers can contain values used in |user_default_options|
      sass = { enable = true, parsers = { 'css' } }, -- Enable sass colors
      virtualtext = '■',
      -- update color values even if buffer is not focused
      -- example use: cmp_menu, cmp_docs
      always_update = false,
    },

    filetypes = {
      -- '*',
      'css',
      'lua',
      'javascript',
      'yaml',
      'yml',
      html = {
        mode = 'foreground',
      },
    },
  },
  config = function(_, opts)
    local status_ok, colorizer = pcall(require, 'colorizer')
    if not status_ok then
      return
    end
    -- Attach to certain Filetypes, add special configuration for `html`
    -- Use `background` for everything else.
    colorizer.setup(opts)
    --  |:ColorizerAttachToBuffer|
    --
    -- Attach to the current buffer and start highlighting with the settings as
    -- specified in setup (or the defaults).
    --
    -- If the buffer was already attached (i.e. being highlighted), the settings will
    -- be reloaded with the ones from setup. This is useful for reloading settings
    -- for just one buffer.
    --
    -- |:ColorizerDetachFromBuffer|
    --
    -- Stop highlighting the current buffer (detach).
    --
    -- |:ColorizerReloadAllBuffers|
    --
    -- Reload all buffers that are being highlighted with new settings from the setup
    -- settings (or the defaults). Shortcut for ColorizerAttachToBuffer on every
    -- buffer.
    --
    -- |:ColorizerToggle|
    --
    -- Toggle highlighting of the current buffer.
  end,
}
