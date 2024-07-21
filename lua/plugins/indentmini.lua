return {
  'nvimdev/indentmini.nvim',
  config = function()
    require('indentmini').setup {
      char = '', -- string type default is │,
      exclude = { 'markdown' }, -- table type add exclude filetype in this table ie { 'markdown', 'xxx'}
      minlevel = 1, -- number the min level that show indent line default is 1
    }
  end,
}
-- -- Colors are applied automatically based on user-defined highlight groups.
-- -- There is no default value.
-- vim.cmd.highlight('IndentLine guifg=#123456')
-- -- Current indent line highlight
-- vim.cmd.highlight('IndentLineCurrent guifg=#123456')
