return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  enabled = true,
  keys = {
    {
      '<leader>lle',
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr].can_lint = true
        pcall(require('lint').try_lint)
      end,
      mode = 'n',
      desc = '[L^2]int buffer [E]nable',
    },

    {
      '<leader>lld',
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.diagnostic.reset(nil, bufnr)
        vim.b[bufnr].can_lint = false
      end,
      mode = 'n',
      desc = '[L^2]int buffer [D]isable',
    },
  },

  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = lint.linters_by_ft or {}
    lint.linters_by_ft['lua'] = { 'luacheck' }
    lint.linters_by_ft['markdown'] = { 'markdownlint' }

    -- However, note that this will enable a set of default linters,
    -- which will cause errors unless these tools are available:
    -- {
    --   clojure = { "clj-kondo" },
    --   dockerfile = { "hadolint" },
    --   inko = { "inko" },
    --   janet = { "janet" },
    --   json = { "jsonlint" },
    --   markdown = { "vale" },
    --   rst = { "vale" },
    --   ruby = { "ruby" },
    --   terraform = { "tflint" },
    --   text = { "vale" }
    -- }
    --
    -- You can disable the default linters by setting their filetypes to nil:
    -- lint.linters_by_ft['clojure'] = nil
    -- lint.linters_by_ft['dockerfile'] = nil
    -- lint.linters_by_ft['inko'] = nil
    -- lint.linters_by_ft['janet'] = nil
    -- lint.linters_by_ft['json'] = nil
    -- lint.linters_by_ft['markdown'] = nil
    -- lint.linters_by_ft['rst'] = nil
    -- lint.linters_by_ft['ruby'] = nil
    -- lint.linters_by_ft['terraform'] = nil
    -- lint.linters_by_ft['text'] = nil

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      group = lint_augroup,
      callback = function()
        if not vim.b.can_lint or not vim.bo.modifiable then
          return
        end
        pcall(require('lint').try_lint)
      end,
    })
  end,
}
