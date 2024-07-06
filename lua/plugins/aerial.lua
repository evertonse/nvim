return {
  'stevearc/aerial.nvim',
  cmd = { 'AerialPrev', 'AerialNext', 'AerialToggle' },
  opts = {
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      local maps = {
        n = {
          ['<leader>at'] = { ':AerialToggle<cr>', '[A]erial [T]oggle' },
        },
      }
      SetKeyMaps(maps)
    end,
  },
  keymaps = {
    ['?'] = 'actions.show_help',
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
    ['<C-v>'] = 'actions.jump_vsplit',
    ['<C-s>'] = 'actions.jump_split',
    ['p'] = 'actions.scroll',
    ['<C-j>'] = 'actions.down_and_scroll',
    ['<C-k>'] = 'actions.up_and_scroll',
    ['{'] = 'actions.prev',
    ['}'] = 'actions.next',
    ['[['] = 'actions.prev_up',
    [']]'] = 'actions.next_up',
    ['q'] = 'actions.close',
    ['za'] = 'actions.tree_toggle',
    ['O'] = 'actions.tree_toggle_recursive',
    ['zA'] = 'actions.tree_toggle_recursive',
    ['o'] = 'actions.tree_toggle',
    ['l'] = 'actions.jump',
    ['zo'] = 'actions.tree_open',
    ['L'] = 'actions.tree_open_recursive',
    ['zO'] = 'actions.tree_open_recursive',
    ['h'] = 'actions.tree_close',
    ['zc'] = 'actions.tree_close',
    ['H'] = 'actions.tree_close_recursive',
    ['zC'] = 'actions.tree_close_recursive',
    ['zr'] = 'actions.tree_increase_fold_level',
    ['zR'] = 'actions.tree_open_all',
    ['zm'] = 'actions.tree_decrease_fold_level',
    ['zM'] = 'actions.tree_close_all',
    ['zx'] = 'actions.tree_sync_folds',
    ['zX'] = 'actions.tree_sync_folds',
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
