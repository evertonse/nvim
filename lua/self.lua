local session_opts = { 'nvim-possession', 'ressession', 'auto-session', 'persistence' }
local surround_opts = { 'mini.surround', 'vim-surround' }
return {
  icons = true,
  nerd_font = true,
  transparency = true,
  theme = 'pastel',
  wilder = false,
  inc_rename = true,
  session_plugin = session_opts[2], --NOTE: Better note Idk, bugs with Telescope sometimes
  mini_pick = false,
  notification_poll_rate = 40,
  -- BufferPaths = {}, -- XXX: SomeHow it does not user when i's on vim.g, too make problems no cap
}
