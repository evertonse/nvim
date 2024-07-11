local HEIGHT_PADDING = 20
local WIDTH_PADDING = 10
-- Function to delete all selected files

local function delete_selected_files()
  local api = require 'nvim-tree.api'
  -- Bulk delete marked files
  api.marks.bulk.delete()
  -- Clear marks after deletion
  api.marks.clear()
end

-- Function to mark all files in the visual selection
local function mark_selected_files()
  local api = require 'nvim-tree.api'
  -- Get the current visual selection
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  -- Make sure the selection is in the correct order
  if start_pos[2] > end_pos[2] then
    start_pos, end_pos = end_pos, start_pos
  end

  -- Iterate over the selected lines and mark the files
  for line_num = start_pos[2], end_pos[2] do
    local node = api.tree.get_node_under_cursor(line_num)
    if node and node.absolute_path then
      api.marks.toggle(node)
    end
  end
end

local function nvimtree_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()
    if false then
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
  vim.keymap.set({ 'v', 'x' }, 'D', function()
    mark_selected_files()
    delete_selected_files()
  end, opts 'Delete Bookmarked')
  vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts 'Delete Bookmarked')
  vim.keymap.set('n', 'bt', api.marks.bulk.trash, opts 'Trash Bookmarked')
  vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')

  vim.keymap.set('n', 'C-]', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
  vim.keymap.set('n', 'K', api.node.show_info_popup, opts 'Info')
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
  if false then
    vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts 'First Sibling')
    vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
    vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts 'Open: No Window Picker')
    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    vim.keymap.set('n', 'Y', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
    vim.keymap.set('n', '<BS>', api.tree.change_root_to_parent, opts 'Close Directory')
  end
  vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')

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
  vim.keymap.set('n', 'y', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  vim.keymap.set('n', 'gy', api.fs.copy.filename, opts 'Copy Name')
  vim.keymap.set('n', 'l', edit_or_open, opts 'Open: No Window Picker')

  vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts 'Open: No Window Picker')

  vim.keymap.set('n', 'o', api.tree.change_root_to_node, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'O', api.tree.change_root_to_parent, opts 'Close Directory')

  vim.keymap.set('n', '<leader>c', api.tree.close, opts 'Close')
  -- vim.keymap.set("n", "<leader>e", function(node)
  --   vim.cmd ":wincmd p"
  -- end, opts "Go back to previous Window")
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
  -- vim.keymap.set('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')
  require('float-preview').attach_nvimtree(bufnr)
end

return {
  'nvim-tree/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  dependencies = {
    {
      'b0o/nvim-tree-preview.lua',
      enabled = false,
    },
    {
      'JMarkin/nvim-tree.lua-float-preview',
      lazy = true,
      -- default
      opts = {
        -- Whether the float preview is enabled by default. When set to false, it has to be "toggled" on.
        toggled_on = true,
        -- wrap nvimtree commands
        wrap_nvimtree_commands = true,
        -- lines for scroll
        scroll_lines = 20,
        -- window config
        window = {
          style = 'minimal',
          relative = 'win',
          border = 'rounded',
          wrap = false,
          trim_height = false,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = math.floor((screen_w - WIDTH_PADDING * 2 - 1) / 2)
            local window_h = screen_h - HEIGHT_PADDING * 2
            local center_x = window_w + WIDTH_PADDING + 30
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

            return {
              style = 'minimal',
              relative = 'editor',
              border = 'single',
              zindex = 4000,
              row = center_y,
              col = center_x,
              width = window_w,
              height = window_h,
            }
          end,
        },
        mapping = {
          -- scroll down float buffer
          down = { '<C-d>' },
          -- scroll up float buffer
          up = { '<C-e>', '<C-u>' },
          -- enable/disable float windows
          toggle = { '<C-x>' },
        },
        -- hooks if return false preview doesn't shown
        hooks = {
          pre_open = function(path)
            -- if file > 5 MB or not text -> not preview
            local size = require('float-preview.utils').get_size(path)
            if type(size) ~= 'number' then
              return false
            end
            local is_text = require('float-preview.utils').is_text(path)
            return size < 5 and is_text
          end,
          post_open = function(bufnr)
            return true
          end,
        },
      },
    },
    'nvim-lua/plenary.nvim',
  },
  -- version = '*',
  opts = {

    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    root_dirs = {},
    prefer_startup_root = true,
    reload_on_bufenter = false,
    respect_buf_cwd = true,
    select_prompts = true,

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
      use_system_clipboard = true,
      change_dir = {
        enable = true,
        global = false,
        restrict_above_cwd = false,
      },
    },
    disable_netrw = true,

    open_on_tab = true,
    hijack_cursor = false,

    sync_root_with_cwd = true,

    update_focused_file = {
      enable = false, -- Enable it to always start with cursor at your file
      update_cwd = false, -- uncomment this line to make update cwd when focusing a tab
      update_root = {
        enable = true,
      },
    },

    renderer = {
      add_trailing = true,
      group_empty = false,
      full_name = true,
      root_folder_label = ':~:s?$?/..?',
      special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },

      symlink_destination = true,
      highlight_diagnostics = 'none',
      highlight_opened_files = 'none',
      highlight_modified = 'none',
      highlight_bookmarks = 'none',
      highlight_clipboard = 'name',

      indent_width = 2,
      -- root_folder_label = true,
      -- root_folder_modifier = ':t',
      highlight_git = 'none',
      icons = {
        web_devicons = {
          file = {
            enable = true,
            color = true,
          },
          folder = {
            enable = false,
            color = true,
          },
        },

        git_placement = 'after',
        modified_placement = 'after',
        diagnostics_placement = 'signcolumn',
        bookmarks_placement = 'signcolumn',
        padding = ' ',
        symlink_arrow = ' ➛ ',

        show = {
          file = true,
          folder = true,
          diagnostics = true,
          bookmarks = true,
          folder_arrow = false,
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
            arrow_open = ' ',
            arrow_closed = ' ',
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
      indent_markers = {
        enable = true,
        -- icons = {
        --   corner = '└',
        --   edge = '│',
        --   -- edge = '▕',
        --   item = '│',
        --   -- item = '▕',
        --   bottom = '─',
        --   none = ' ',
        --   -- none = '▕',
        --   -- none = '│',
        -- },
      },
    },

    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    modified = {
      enable = false,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },
    filters = {
      enable = true,
      git_ignored = true,
      dotfiles = true,
      git_clean = false,
      no_buffer = false,
      no_bookmark = false,
      custom = {},
      exclude = {},
    },

    diagnostics = {
      enable = true,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = {
        hint = '',
        info = '',
        warning = '',
        error = '',
      },
    },
    view = {
      debounce_delay = 5,
      preserve_window_proportions = true,

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
