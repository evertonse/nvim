if vim.b.current_syntax then
  return
end

local ft = vim.bo.filetype

--- BEWARE: treesitter.language.add will return nil if it haven't found it yet, it just so happens that if treesitter is lazily loaded, it will say it does't have that parser at first
---         So maybe we should look for parsers ourselves
---         These mgiht be helpful for this ^:
---             nvim_get_runtime_file('parser/*.so', v:true)
---             ~/.local/share/nvim/lazy/nvim-treesitter/parser
---         For now a simpler solution is just not lazyload
local has_parser = vim.treesitter.language.add(ft)

--- DEBUG with this
-- Inspect { ins = ins, has_parser = has_parser ~= nil, ft = ft, bo = vim.bo }

--- If we DO have a parser I don't even wanna see the partial vim highlighting
--- Big files will show syntax artifacts, if we don't do this, quite slow.
if has_parser then
  --- No need to start it, as we have other hooks to start but nevertheless that how we would do it
  -- vim.treesitter.start(vim.bo, ft)
  vim.b.current_syntax = 'json'
end

--- Not necessary, neovim will find this correlating filetype with filename.vim
-- vim.cmd [[runtime! syntax/json.vim]]
