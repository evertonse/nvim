-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

local them = {
  repo = 'nvim-telescope/telescope.nvim',
  commit_working_path_support = 'bfcc7d5c6f12209139f175e6123a7b7de6d9c18a',
  commit_working_path_support_branch = 'master',
}

local self = {
  repo = 'evertonse/telescope.nvim',
  commit_working_path_support = '964e776d04ae9c9924b2536dffc299125703d103',
  commit_working_path_support_branch = 'master',
}

local using = {
  repo = self.repo,
  commit_working_path_support = self.commit_working_path_support_branch,
  commit_working_path_support_branch = self.commit_working_path_support_branch,
}

return { -- Fuzzy Finder (files, lsp, etc)
  using.repo,
  event = 'VimEnter',
  -- lazy = false,
  -- tag = '0.1.8',
  branch = using.commit_working_path_support_branch,
  commit = using.commit_working_path_support,
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
}
