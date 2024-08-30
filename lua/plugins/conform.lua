return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    enabled = true,
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Conform + [L]sp [F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = vim.tbl_deep_extend(
          'force',
          { java = true, proto = true, c = true, cpp = true, odin = true, python = true },
          vim.g.self.dont_format or {}
        )
        if disable_filetypes[vim.bo[0].filetype] then
          return false
        end
        return {
          timeout_ms = 1200,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- You can use a function here to determine the formatters dynamically
        python = function(bufnr)
          if require('conform').get_formatter_info('ruff_format', bufnr).available then
            return { 'ruff_format' }
          else
            -- Conform can also run multiple formatters sequentially
            return { 'isort', 'black' }
          end
        end,
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        java = { 'clang-format' },
        -- java = { 'google-java-format' },
        -- java = { 'jdtls' },

        -- Use the "*" filetype to run formatters on all filetypes.
        -- ["*"] = { "codespell" },

        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
