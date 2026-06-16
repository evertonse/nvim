-- Highlight groups don't have priority. They just define the highlighting.
--
-- The priority is set from the syntax in case of legacy highlighting :help :syn-priority, or by the query pattern in case of treesitter :help treesitter-highlight-priority. So in your case, if you want to make type.java have a higher priority, you need to find the query where it is defined. Copy the query into your config and manually set a higher priority.
--
-- Read :help treesitter-query for more information.
-- Help pages for:
--
-- :syn-priority in syntax.txt
--
-- treesitter-highlight-priority in treesitter.txt
--
-- treesitter-query in treesitter.txt

local disable_treesitter_when = require('functions').disable_treesitter_highlight_when

local go_do = function()
  require('nvim-treesitter').setup {}
  require('nvim-treesitter').install {
    'bash',
    'blade',
    'c',
    'cpp',
    'glsl',
    'hlsl',
    'comment',
    'css',
    'diff',
    'dockerfile',
    'fish',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'html',
    'ini',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'luadoc',
    'luap',
    'make',
    'markdown',
    'markdown_inline',
    'nginx',
    'nix',
    'proto',
    'python',
    'query',
    'regex',
    'rust',
    'scss',
    'sql',
    'terraform',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
    'zig',
  }

  require('nvim-treesitter-textobjects').setup {
    select = {
      enable = true,
      lookahead = true,
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      include_surrounding_whitespace = false,
    },
    move = {
      enable = true,
      set_jumps = true,
    },
  }

  -- SELECT keymaps
  local sel = require 'nvim-treesitter-textobjects.select'
  for _, map in ipairs {
    { { 'x', 'o' }, 'af', '@function.outer' },
    { { 'x', 'o' }, 'if', '@function.inner' },
    { { 'x', 'o' }, 'ac', '@class.outer' },
    { { 'x', 'o' }, 'ic', '@class.inner' },
    { { 'x', 'o' }, 'aa', '@parameter.outer' },
    { { 'x', 'o' }, 'ia', '@parameter.inner' },
    { { 'x', 'o' }, 'ad', '@comment.outer' },
    { { 'x', 'o' }, 'as', '@statement.outer' },
  } do
    vim.keymap.set(map[1], map[2], function()
      sel.select_textobject(map[3], 'textobjects')
    end, { desc = 'Select ' .. map[3] })
  end

  -- MOVE keymaps
  local mv = require 'nvim-treesitter-textobjects.move'
  for _, map in ipairs {
    { { 'n', 'x', 'o' }, ']m', mv.goto_next_start, '@function.outer' },
    { { 'n', 'x', 'o' }, '[m', mv.goto_previous_start, '@function.outer' },
    { { 'n', 'x', 'o' }, ']]', mv.goto_next_start, '@class.outer' },
    { { 'n', 'x', 'o' }, '[[', mv.goto_previous_start, '@class.outer' },
    { { 'n', 'x', 'o' }, ']M', mv.goto_next_end, '@function.outer' },
    { { 'n', 'x', 'o' }, '[M', mv.goto_previous_end, '@function.outer' },
    { { 'n', 'x', 'o' }, ']o', mv.goto_next_start, { '@loop.inner', '@loop.outer' } },
    { { 'n', 'x', 'o' }, '[o', mv.goto_previous_start, { '@loop.inner', '@loop.outer' } },
  } do
    local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
    -- build a human-readable desc
    local qstr = (type(query) == 'table') and table.concat(query, ',') or query
    vim.keymap.set(modes, lhs, function()
      fn(query, 'textobjects')
    end, { desc = 'Move to ' .. qstr })
  end

  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function()
      local filetype = vim.bo.filetype
      if filetype and filetype ~= '' then
        local success = pcall(function()
          vim.treesitter.start()
        end)
        if not success then
          return
        end
      end
    end,
  })
end

-- NOTE: custom parser -> https://github.com/nvim-treesitter/nvim-treesitter/issues/2241

return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main', -- 0.12 nvim support
  build = ':TSUpdate',
  lazy = false,
  enabled = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', enabled = true, lazy = false },
  config = function()
    -- Before (nvim-treesitter plugin)
    go_do()
  end,
}
