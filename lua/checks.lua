if not vim.g.did_load_filetypes then
  vim.notify(
    "Personal `filetype.lua` detection won't work properly! Place `vim.g.did_load_filetypes = 1` somewhere in init.lua, options.lua or whatever.",
    vim.log.levels.ERROR
  )
  return
end
