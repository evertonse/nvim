return {
  'akinsho/git-conflict.nvim',
  version = '*',
  opts = {
    default_mappings = {
      ours = 'o',
      theirs = 't',
      none = '0',
      both = 'b',
      next = 'n',
      prev = 'p',
    },
  },
  config = function(_, opts)
    require('git-conflict').setup(opts)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitConflictDetected',
      callback = function()
        vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>')
        -- vim.keymap.set('n', 'cww', function() end)
      end,
    })
  end,
}
-- You can list conflicts in the quick fix list using the GitConflictListQf command
-- GitConflictChooseOurs — Select the current changes.
-- GitConflictChooseTheirs — Select the incoming changes.
-- GitConflictChooseBoth — Select both changes.
-- GitConflictChooseNone — Select none of the changes.
-- GitConflictNextConflict — Move to the next conflict.
-- GitConflictPrevConflict — Move to the previous conflict.
-- GitConflictListQf — Get all conflict to quickfix
