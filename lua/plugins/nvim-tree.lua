local HEIGHT_PADDING = 20
local WIDTH_PADDING = 10
local REPOSITORY = 'evertonse/nvim-tree.lua' -- 'nvim-tree/nvim-tree.lua',
-- local BRANCH = 'feat/icon_placement-right_align'
local BRANCH = 'master'
local ALLOW_PREVIEW = vim.g.self.enable_file_tree_preview and not OnSlowPath() and not OnWindows()
local WIDTH_MIN = 55
local HEIGHT_MIN = 28
local WIDTH_MAX = 75
local HEIGHT_MAX = 58
local WIDTH_PERCENTAGE = 0.45
local HEIGHT_PERCENTAGE = 0.65

-- Function to delete all selected files
-- Function to mark all files in the visual selection

local mark_selected_files = function(bufnr)
  local api = require 'nvim-tree.api'
  local lib = require 'nvim-tree.lib'
  -- Ensure visual mode is active and retrieve the visual selection range
  -- Get the buffer number

  -- api.marks.clear()
  -- vim.api.nvim_input [[gv]]

  vim.api.nvim_feedkeys([[:]] .. vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'c', true) --blocking
  -- vim.api.nvim_feedkeys([[:<CR>]], 'c', true) --blocking
  -- vim.api.nvim_command 'normal! gv'
  -- Retrieve the visual selection marks
  vim.schedule(function()
    local start_pos = vim.api.nvim_buf_get_mark(bufnr, '<')
    local end_pos = vim.api.nvim_buf_get_mark(bufnr, '>')

    -- Ensure marks are correctly retrieved
    if start_pos[1] == 0 or end_pos[1] == 0 then
      print(vim.inspect(vim.fn.getpos "'<") .. 'Failed to retrieve visual selection marks. Please try again.')
      return
    end

    -- Make sure the selection is in the correct order
    if start_pos[1] > end_pos[1] then
      start_pos, end_pos = end_pos, start_pos
    end
    print('nvim-tree marked from ' .. start_pos[1] .. ' to ' .. end_pos[1])
    -- Inspect { start_pos[1], end_pos[1] }

    -- Iterate over the selected lines and mark the files
    for line_num = start_pos[1], end_pos[1] do
      -- Move to the specific line
      vim.api.nvim_win_set_cursor(0, { line_num, 0 })
      -- Get the node under cursor
      local node = lib.get_node_at_cursor()
      -- If a valid node is found, toggle its mark
      if node then
        api.marks.toggle(node)
      end
    end
    if true then
      return
    end
  end)
end

local wrap_reload = function(fn)
  local api = require 'nvim-tree.api'
  return function()
    fn()
    api.tree.reload()
  end
end

local function delete_selected_files()
  local api = require 'nvim-tree.api'
  -- Bulk delete marked files

  vim.schedule(function()
    api.marks.bulk.delete()
    -- Clear marks after deletion
    api.marks.clear()
    api.tree.reload()
  end)
end

local function nvimtree_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()
    -- api.tree.reload()
    if node.nodes ~= nil then
      api.node.open.edit()
      -- api.node.open.no_window_picker()
      -- node.has_children == false
    else
      -- api.node.open.edit()
      api.node.open.no_window_picker()

      -- XXX:Idk why I need to schedule that now. Didn't used to need that, maybe change to default nvim_tree branch to check that that
      --Close the tree if file was opened but after opening so we schedule it
      vim.schedule(api.tree.toggle)
    end
  end

  local map = vim.keymap.set

  map({ 'v' }, 'D', function()
    api.marks.clear()
    mark_selected_files(bufnr)
    delete_selected_files()
    api.tree.reload()
  end, opts 'Delete Bookmarked')

  map({ 'v' }, '<Esc>', function()
    mark_selected_files(bufnr)
  end, opts 'Delete Bookmarked')

  map('n', '<Esc>', api.marks.clear, opts 'Unmark Bookmarke')
  ---------------- START_DEFAULT_ON_ATTACH ----------------
  -- api.marks.clear()
  map('n', 'bd', api.marks.bulk.delete, opts 'Delete Bookmarked')
  map('n', 'bt', api.marks.bulk.trash, opts 'Trash Bookmarked')
  map('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')

  map('n', 'C-]', api.tree.change_root_to_node, opts 'CD')
  map('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
  map('n', 'K', api.node.show_info_popup, opts 'Info')
  map('n', '<C-r>', api.fs.rename_sub, opts 'Rename: Omit Filename')
  map('n', '<C-t>', api.node.open.tab, opts 'Open: New Tab')
  map('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
  map('n', '<C-x>', api.node.open.horizontal, opts 'Open: Horizontal Split')
  map('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
  -- map('n', '<CR>', api.node.open.edit, opts 'Open')
  map('n', '<Tab>', api.node.open.preview, opts 'Open Preview')
  map('n', '>', api.node.navigate.sibling.next, opts 'Next Sibling')
  map('n', '<', api.node.navigate.sibling.prev, opts 'Previous Sibling')
  map('n', '.', api.node.run.cmd, opts 'Run Command')
  map('n', '-', api.tree.change_root_to_parent, opts 'Up')
  map('n', 'a', api.fs.create, opts 'Create')
  map('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')
  map('n', 'B', api.tree.toggle_no_buffer_filter, opts 'Toggle No Buffer')
  -- map("n", "c", api.fs.copy.node, opts "Copy")
  map('n', 'C', api.tree.toggle_git_clean_filter, opts 'Toggle Git Clean')
  map('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
  map('n', ']c', api.node.navigate.git.next, opts 'Next Git')
  map('n', 'D', wrap_reload(api.fs.remove), opts 'Delete')
  map('n', 'd', api.fs.cut, opts 'Cut')
  -- map("n", "D", api.fs.trash, opts "Trash")
  map('n', 'E', api.tree.expand_all, opts 'Expand All')
  map('n', 'e', api.fs.rename_basename, opts 'Rename: Basename')
  map('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  map('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  map('n', 'F', api.live_filter.clear, opts 'Clean Filter')
  map('n', 'f', api.live_filter.start, opts 'Filter')
  map('n', 'g?', api.tree.toggle_help, opts 'Help')
  map('n', 'gy', api.fs.copy.absolute_path, opts 'Copy Absolute Path')

  -- Le Toggles
  map('n', 'H', api.tree.toggle_hidden_filter, opts 'Toggle Dotfiles')
  map('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')

  map('n', 'J', api.node.navigate.sibling.last, opts 'Last Sibling')

  if false then
    map('n', 'K', api.node.navigate.sibling.first, opts 'First Sibling')
    map('n', 'o', api.node.open.edit, opts 'Open')
    map('n', 'O', api.node.open.no_window_picker, opts 'Open: No Window Picker')
    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    map('n', 'Y', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
    map('n', '<BS>', api.tree.change_root_to_parent, opts 'Close Directory')
  end

  map('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
  map('n', 'p', api.fs.paste, opts 'Paste')
  map('n', 'P', api.node.navigate.parent, opts 'Parent Directory')
  map('n', 'q', api.tree.close, opts 'Close')
  map('n', 'r', api.fs.rename, opts 'Rename')
  map('n', 'R', api.tree.reload, opts 'Refresh')
  map('n', 's', api.node.run.system, opts 'Run System')
  map('n', 'S', api.tree.search_node, opts 'Search')
  map('n', 'U', api.tree.toggle_custom_filter, opts 'Toggle Hidden')
  map('n', 'W', api.tree.collapse_all, opts 'Collapse')
  map('n', '<2-LeftMouse>', api.node.open.edit, opts 'Open')
  map('n', '<2-RightMouse>', api.tree.change_root_to_node, opts 'CD')
  ---------------- END_DEFAULT_ON_ATTACH ----------------

  -- Mappings migrated from view.mappings.list
  map('n', '<leader>y', api.fs.copy.filename, opts 'Copy Name')
  map('n', 'y', api.fs.copy.node, opts 'Copy')
  map('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  map('n', 'gy', api.fs.copy.filename, opts 'Copy Name')
  map('n', 'l', edit_or_open, opts 'Open: No Window Picker')
  map('n', 'L', function() end, opts 'Do Nothing')

  map('n', '<CR>', api.node.open.no_window_picker, opts 'Open: No Window Picker')

  map('n', 'o', api.tree.change_root_to_node, opts 'Open: No Window Picker')
  map('n', 'O', api.tree.change_root_to_parent, opts 'Close Directory')

  map('n', '<leader>c', api.tree.close, opts 'Close')
  -- map("n", "<leader>e", function(node)
  --   vim.cmd ":wincmd p"
  -- end, opts "Go back to previous Window")
  map('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
  -- vim.keymap.set('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')

  map('v', 'K', function()
    local node = api.tree.get_node_under_cursor()
    Inspect(node)
  end, opts 'Info')

  if ALLOW_PREVIEW then
    require('float-preview').attach_nvimtree(bufnr)
  end
end

return {
  REPOSITORY,
  branch = BRANCH,
  cmd = 'NvimTreeToggle',
  dependencies = {
    {
      'b0o/nvim-tree-preview.lua', -- dont work with float
      enabled = false,
    },
    {
      'JMarkin/nvim-tree.lua-float-preview',
      enabled = ALLOW_PREVIEW,
      lazy = false,
      -- default
      opts = {
        -- Whether the float preview is enabled by default. When set to false, it has to be "toggled" on.
        toggled_on = true,
        -- wrap nvimtree commands
        wrap_nvimtree_commands = true,
        -- lines for scroll
        scroll_lines = 10,
        -- window config
        window = {
          style = 'minimal',
          relative = 'win',
          border = vim.g.self.is_transparent and 'none' or 'single',
          wrap = false,
          trim_height = true,
          open_win_config = not vim.g.self.open_win_config_recalculate_every_time and {
            border = 'single',
            col = 81,
            height = 5,
            relative = 'editor',
            row = 19,
            style = 'minimal',
            width = 41,
            zindex = 4000,
          } or function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = math.abs(math.floor((screen_w - WIDTH_PADDING * 2 - 1) / 2))
            local window_h = math.abs(math.floor(screen_h - HEIGHT_PADDING * 2))
            local center_x = window_w + WIDTH_PADDING + 30
            local center_y = math.floor(((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get())

            local float_opts = {
              style = 'minimal',
              relative = 'editor',
              border = vim.g.self.is_transparent and 'single' or 'single',
              -- border = 'single',
              zindex = 4000,
              row = center_y,
              col = center_x,
              width = window_w,
              height = window_h,
            }
            return float_opts
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
          post_open = function(_)
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
    respect_buf_cwd = false,
    select_prompts = true,

    on_attach = nvimtree_on_attach,
    git = {
      enable = true,
      ignore = true,
      timeout = 200,
    },
    filesystem_watchers = {
      enable = true,
      ignore_dirs = {
        'node_modules',
        'venv',
        'queries',
      },
    },
    actions = {
      use_system_clipboard = false,
      change_dir = {
        enable = true,
        global = true,
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
      hidden_display = 'all',
      -- hidden_display = function(hidden_count)
      --   local total_count = 0
      --   for reason, count in pairs(hidden_count) do
      --     total_count = total_count + count
      --   end

      --   if total_count > 0 then
      --     return '> ' .. tostring(total_count) .. ' le hidden'
      --   end
      --   return nil
      -- end,
      full_name = true,
      -- Value can be `"none"`, `"icon"`, `"name"` or `"all"`.
      highlight_git = 'name',
      highlight_diagnostics = 'icon',
      highlight_opened_files = 'none',
      highlight_modified = 'all',
      highlight_hidden = 'all',
      highlight_bookmarks = 'icon',
      highlight_clipboard = 'icon',

      add_trailing = true,
      group_empty = false,
      root_folder_label = ':~:s?$?/..?',
      special_files = { '.*', 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },

      symlink_destination = true,

      indent_width = 2,
      root_folder_modifier = ':t',
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

        git_placement = 'right_align',
        modified_placement = 'right_align',
        hidden_placement = 'right_align',
        diagnostics_placement = 'right_align',
        bookmarks_placement = 'signcolumn',

        padding = ' ',
        symlink_arrow = ' ➛ ',

        show = {
          file = true,
          folder = true,
          diagnostics = true,
          bookmarks = true,
          hidden = false,
          folder_arrow = false,
          git = true,
          modified = true,
        },
        glyphs = {
          default = '󰈚', --"",
          symlink = '',
          hidden = '󰜌',
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
        icons = {
          corner = '└',
          -- corner = '└',
          edge = '│',
          -- edge = '▕',
          item = '│',
          -- item = '▕',
          bottom = '─',
          none = ' ',
          -- none = '▕',
          -- none = '│',
        },
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
    live_filter = {
      prefix = '> ',
      always_show_folders = true,
    },
    filters = {
      enable = true,
      git_ignored = true,
      dotfiles = true,
      git_clean = false,
      no_buffer = false,
      no_bookmark = false,
      -- custom = {},
      -- TODO: Make `exclude` / `custom` be a function based on node as well ok ?
      custom = { '^\\.git', '.*~' },
      -- custom = { '^%.git', '.*~+' },

      -- exclude = { '*~' },
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
      centralize_selection = true,
      cursorline = true,

      debounce_delay = 15,
      preserve_window_proportions = true,

      float = {
        enable = true,
        quit_on_focus_loss = false, -- TODO: On slow path does it lag if this is true? Test it
        open_win_config = function()
          local total_width = vim.o.columns
          local total_height = vim.o.lines

          local width = math.max(WIDTH_MIN, math.floor(total_width * WIDTH_PERCENTAGE))
          local height = math.max(HEIGHT_MIN, math.floor(total_height * HEIGHT_PERCENTAGE))
          width = math.min(width, WIDTH_MAX)
          height = math.min(height, HEIGHT_MAX)

          local float_opts = {
            relative = 'editor',
            width = math.floor(width),
            height = math.floor(height),
            row = math.floor((total_height - math.floor(total_height * 0.69)) / 2.0),
            col = math.floor((total_width - math.floor(total_width * 0.55)) / 2.0),

            border = vim.g.self.is_transparent and 'single' or 'single',
          }

          return float_opts
        end,
      },
      width = 38,
      side = 'left',
      number = false,
      relativenumber = false,
    },
  },
}
