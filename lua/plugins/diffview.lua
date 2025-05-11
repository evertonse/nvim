return {
  'sindrets/diffview.nvim',
  lazy = true,
  cmd = { 'DiffviewOpen' },
  config = function()
    local actions = require 'diffview.actions'
    local choose_prefix = ''

    require('diffview').setup {
      keymaps = {

        view = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
          { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
          { 'n', '[F', actions.select_first_entry, { desc = 'Open the diff for the first file' } },
          { 'n', ']F', actions.select_last_entry, { desc = 'Open the diff for the last file' } },
          { 'n', 'gf', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' } },
          { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open the file in a new split' } },
          { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' } },
          { 'n', '<leader>e', actions.focus_files, { desc = 'Bring focus to the file panel' } },
          { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle the file panel.' } },
          { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle through available layouts.' } },
          { 'n', '[x', actions.prev_conflict, { desc = 'In the merge-tool: jump to the previous conflict' } },
          { 'n', ']x', actions.next_conflict, { desc = 'In the merge-tool: jump to the next conflict' } },
          {
            'n',
            '<leader>' .. choose_prefix .. 'o',
            actions.conflict_choose 'ours',
            { desc = '[D]iff [C]hoose the OURS version of a conflict' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 't',
            actions.conflict_choose 'theirs',
            { desc = '[D]iff [C]hoose the THEIRS version of a conflict' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'b',
            actions.conflict_choose 'base',
            { desc = '[D]iff [C]hoose the BASE version of a conflict' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'a',
            actions.conflict_choose 'all',
            { desc = '[D]iff [C]hoose all the versions of a conflict' },
          },
          { 'n', 'dx', actions.conflict_choose 'none', { desc = 'Delete the conflict region' } },
          {
            'n',
            '<leader>' .. choose_prefix .. 'O',
            actions.conflict_choose_all 'ours',
            { desc = '[D]iff [C]hoose the OURS version of a conflict for the whole file' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'T',
            actions.conflict_choose_all 'theirs',
            { desc = '[D]iff [C]hoose the THEIRS version of a conflict for the whole file' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'B',
            actions.conflict_choose_all 'base',
            { desc = '[D]iff [C]hoose the BASE version of a conflict for the whole file' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'A',
            actions.conflict_choose_all 'all',
            { desc = '[D]iff [C]hoose all the versions of a conflict for the whole file' },
          },
          { 'n', 'dX', actions.conflict_choose_all 'none', { desc = 'Delete the conflict region for the whole file' } },
        },
        file_panel = {
          { 'n', 'j', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
          { 'n', '<down>', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
          { 'n', 'k', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
          { 'n', '<up>', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
          { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', 'l', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
          { 'n', '-', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry' } },
          { 'n', 's', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry' } },
          { 'n', 'S', actions.stage_all, { desc = 'Stage all entries' } },
          { 'n', 'U', actions.unstage_all, { desc = 'Unstage all entries' } },
          { 'n', 'X', actions.restore_entry, { desc = 'Restore entry to the state on the left side' } },
          { 'n', 'L', actions.open_commit_log, { desc = 'Open the commit log panel' } },
          { 'n', 'zo', actions.open_fold, { desc = 'Expand fold' } },
          { 'n', 'h', actions.close_fold, { desc = 'Collapse fold' } },
          { 'n', 'zc', actions.close_fold, { desc = 'Collapse fold' } },
          { 'n', 'za', actions.toggle_fold, { desc = 'Toggle fold' } },
          { 'n', 'zR', actions.open_all_folds, { desc = 'Expand all folds' } },
          { 'n', 'zM', actions.close_all_folds, { desc = 'Collapse all folds' } },
          { 'n', '<c-b>', actions.scroll_view(-0.25), { desc = 'Scroll the view up' } },
          { 'n', '<c-f>', actions.scroll_view(0.25), { desc = 'Scroll the view down' } },
          { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
          { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
          { 'n', '[F', actions.select_first_entry, { desc = 'Open the diff for the first file' } },
          { 'n', ']F', actions.select_last_entry, { desc = 'Open the diff for the last file' } },
          { 'n', 'gf', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' } },
          { 'n', '<C-w><C-f>', actions.goto_file_split, { desc = 'Open the file in a new split' } },
          { 'n', '<C-w>gf', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' } },
          { 'n', 'i', actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
          { 'n', 'f', actions.toggle_flatten_dirs, { desc = 'Flatten empty subdirectories in tree listing style' } },
          { 'n', 'R', actions.refresh_files, { desc = 'Update stats and entries in the file list' } },
          { 'n', '<leader>e', actions.focus_files, { desc = 'Bring focus to the file panel' } },
          { 'n', '<leader>b', actions.toggle_files, { desc = 'Toggle the file panel' } },
          { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle available layouts' } },
          { 'n', '[x', actions.prev_conflict, { desc = 'Go to the previous conflict' } },
          { 'n', ']x', actions.next_conflict, { desc = 'Go to the next conflict' } },
          { 'n', 'g?', actions.help 'file_panel', { desc = 'Open the help panel' } },
          {
            'n',
            '<leader>' .. choose_prefix .. 'O',
            actions.conflict_choose_all 'ours',
            { desc = '[D]iff [C]hoose the OURS version of a conflict for the whole file' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'T',
            actions.conflict_choose_all 'theirs',
            { desc = '[D]iff [C]hoose the THEIRS version of a conflict for the whole file' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'B',
            actions.conflict_choose_all 'base',
            { desc = '[D]iff [C]hoose the BASE version of a conflict for the whole file' },
          },
          {
            'n',
            '<leader>' .. choose_prefix .. 'A',
            actions.conflict_choose_all 'all',
            { desc = '[D]iff [C]hoose all the versions of a conflict for the whole file' },
          },
          { 'n', 'dX', actions.conflict_choose_all 'none', { desc = 'Delete the conflict region for the whole file' } },
        },
      },

      -- :h diffview-config-keymaps
      -- :h diffview-actions
      hooks = {

        diff_buf_read = function(bufnr)
          -- Change local options in diff buffers
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = { 80 }
        end,
        view_opened = function(view)
          print(('A new %s was opened on tab page %d!'):format(view.class:name(), view.tabpage))
        end,
        view_closed = function(view) end,
      },
    }
  end,
}
