local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
  b.formatting.clang_format.with {
    filetype = { "c", "cpp", "cs", "java" },
    extra_args = { "--style", "{IndentWidth: 4}" },
  },
  -- Lua
  b.formatting.stylua,
  b.code_actions.gitsigns,
  -- cpp
  b.formatting.clang_format,
  b.diagnostics.eslint,
  -- b.completion.spell,

  -- python
  b.formatting.black,
  -- b.diagnostics.ruff,
  -- b.diagnostics.flake8,
  -- b.formatting.flake8,
  -- b.diagnostics.mypy,

  --b.diagnostics.shellcheck,
}

null_ls.setup {
  -- debug = true,
  sources = sources,
  on_init = function(new_client, _)
    new_client.offset_encoding = "utf-8"
  end,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- Uncomment with you prefer to format on save
          -- vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
