local function nvimtree_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()
    if not OnWindows() then
      api.tree.reload()
    end
    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      --api.node.open.edit()
      api.node.open.no_window_picker()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end
  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH

  local map = vim.keymap.set
  vim.keymap.set('n', 'sC-]s', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts 'Info')
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts 'Rename: Omit Filename')
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts 'Open: New Tab')
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts 'Open Preview')
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts 'Next Sibling')
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts 'Previous Sibling')
  vim.keymap.set('n', '.', api.node.run.cmd, opts 'Run Command')
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts 'Up')
  vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
  vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')
  vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts 'Toggle No Buffer')
  -- vim.keymap.set("n", "c", api.fs.copy.node, opts "Copy")
  vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts 'Toggle Git Clean')
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
  vim.keymap.set('n', ']c', api.node.navigate.git.next, opts 'Next Git')
  vim.keymap.set('n', 'D', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'd', api.fs.cut, opts 'Cut')
  -- vim.keymap.set("n", "D", api.fs.trash, opts "Trash")
  vim.keymap.set('n', 'E', api.tree.expand_all, opts 'Expand All')
  vim.keymap.set('n', 'e', api.fs.rename_basename, opts 'Rename: Basename')
  vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  vim.keymap.set('n', 'F', api.live_filter.clear, opts 'Clean Filter')
  vim.keymap.set('n', 'f', api.live_filter.start, opts 'Filter')
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts 'Copy Absolute Path')

  -- Le Toggles
  vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts 'Toggle Dotfiles')
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')

  vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts 'Last Sibling')
  vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts 'First Sibling')
  vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
  vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts 'Parent Directory')
  vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
  vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')
  vim.keymap.set('n', 's', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', 'S', api.tree.search_node, opts 'Search')
  vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts 'Toggle Hidden')
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts 'Collapse')
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts 'CD')
  -- END_DEFAULT_ON_ATTACH

  -- Mappings migrated from view.mappings.list
  vim.keymap.set('n', '<leader>y', api.fs.copy.filename, opts 'Copy Name')
  -- vim.keymap.set("n", "gy", api.fs.copy.filename, opts "Copy Name")
  vim.keymap.set('n', 'y', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  -- vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts "Copy Absolute Path")
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'l', edit_or_open, opts 'Open: No Window Picker')

  vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'o', api.tree.change_root_to_node, opts 'Open: No Window Picker')
  --vim.keymap.set('n', '<BS>',  api.tree.change_root_to_parent,        opts('Close Directory'))
  vim.keymap.set('n', 'O', api.tree.change_root_to_parent, opts 'Close Directory')

  vim.keymap.set('n', '<leader>c', api.tree.close, opts 'Close')
  -- vim.keymap.set("n", "<leader>e", function(node)
  --   vim.cmd ":wincmd p"
  -- end, opts "Go back to previous Window")
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.del('n', '<C-k>', opts 'Info')

  --vim.cmd('colorscheme vs')
end

return {
  'nvim-tree/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  dependencies = {
    'b0o/nvim-tree-preview.lua',
    'nvim-lua/plenary.nvim',
  },
  -- version = '*',
  opts = {

    on_attach = nvimtree_on_attach,
    git = {
      enable = true,
      ignore = true,
      timeout = 200,
    },
    filesystem_watchers = {
      enable = true,
    },
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    disable_netrw = true,
    hijack_netrw = true,

    open_on_tab = true,
    hijack_cursor = false,

    update_cwd = true,

    update_focused_file = {
      enable = false, -- Enable it to always start with cursor at your file
      update_cwd = false, -- uncomment this line to make update cwd when focusing a tab
      -- update_cwd = false,
    },

    filters = {
      dotfiles = true,
      custom = {},
    },

    renderer = {
      -- root_folder_label = true,
      -- root_folder_modifier = ':t',
      highlight_git = true,
      icons = {
        git_placement = 'before',
        modified_placement = 'after',
        webdev_colors = true,
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
        },
        glyphs = {
          default = '󰈚', --"",
          symlink = '',
          folder = {
            default = '',
            empty = '',
            empty_open = '', --"",
            open = '', --"",
            symlink = '', --"",
            symlink_open = '',
            -- arrow_open = '',
            -- arrow_closed = '',
            arrow_open = '',
            arrow_closed = '',
          },

          -- neotree examples = {
          --   -- Change type
          --   added = '+', -- or "✚", but this is redundant info if you use git_status_colors on the name
          --   modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          --   deleted = '✖', -- this can only be used in the git_status source
          --   renamed = '󰁕', -- this can only be used in the git_status source Status type
          --   -- untracked = "",
          --   untracked = '?',
          --   ignored = '',
          --   unstaged = '-',
          --   staged = '',
          --   conflict = '',
          -- },
          git = {
            -- 󰀨󰗖󰕗󰰜󱖔󰁢󰪥󰮍󱍸󰊰󰮎󰗖
            -- unstaged = '✗', -- "",
            unstaged = '-',
            staged = '✓', --"S",
            unmerged = '', --"",
            renamed = '➜',
            -- untracked = '★', --"U",
            untracked = '?',
            deleted = '',
            ignored = '◌',
          },
        },
      },
      highlight_opened_files = 'none',

      indent_markers = {
        enable = true,
        icons = {
          corner = '└',
          edge = '│',
          item = '│',
          bottom = '─',
          -- none = ' ',
          none = '▕',
        },
      },
    },

    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = '',
        info = '',
        warning = '',
        error = '',
      },
    },
    view = {
      float = {
        enable = true,
        quit_on_focus_loss = false,
        open_win_config = {
          relative = 'editor',
          width = vim.opt.columns:get(),
          -- center_x = (screen_w - _width) / 2
          -- center_y = (vim.opt.lines:get() - _height) / 2
          height = math.floor((vim.opt.lines:get() - vim.opt.cmdheight:get()) * 0.75),
          bufpos = { 100, 100 },
          -- row = 0.5,
          -- col = 0.5,
        },
      },
      width = 38,
      side = 'left',
      number = false,
      relativenumber = false,
    },
  },
}
