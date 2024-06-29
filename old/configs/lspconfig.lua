local default_on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities = vim.tbl_deep_extend("force", capabilities, {
  offsetEncoding = { "utf-8" },
  general = {
    positionEncodings = { "utf-8" },
  },
})

-- please take a look at this https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItemKind
local cmp = require "cmp"
local CompletionItemKind = {
  --[[Text ]]
  30,
  --[[Method = ]]
  2,
  --[[Function = ]]
  1,
  --[[Constructor = ]]
  4,
  --[[Field = ]]
  4,
  --[[Variable = ]]
  3,
  --[[Class = ]]
  7,
  --[[Interface = ]]
  8,
  --[[Module = ]]
  9,
  --[[Property = ]]
  10,
  --[[Unit = ]]
  11,
  --[[Value = ]]
  12,
  --[[Enum = ]]
  13,
  --[[Keyword = ]]
  14,
  --[[Snippet = ]]
  3,
  --[[Color = ]]
  16,
  --[[File = ]]
  17,
  --[[Reference = ]]
  18,
  --[[Folder = ]]
  19,
  --[[EnumMember = ]]
  20,
  --[[Constant = ]]
  21,
  --[[Struct = ]]
  22,
  --[[Event = ]]
  23,
  --[[Operator = ]]
  24,
  --[[TypeParameter = ]]
  25,
}

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = {
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm { select = true },
  ["<C-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), --['<C-space>'] = cmp.mapping.complete(),
  --['<Tab>'] = cmp.mapping(function()end, {'i', 'c'}),  --['<C-space>'] = cmp.mapping.complete(),

  -- disable completion with tab
  -- this helps with copilot setup
  ["<Tab>"] = nil,
  ["<S-Tab>"] = nil,
}

local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup {
  sorting = {
    priority_weight = 1.2,
    comparators = {
      -- cmp.score_offset, -- not good at all
      cmp.config.compare.exact,
      function(e1, e2)
        local k1 = CompletionItemKind[e1:get_kind()]
        local k2 = CompletionItemKind[e2:get_kind()]
        if k1 < k2 then
          return true
        end
        return false
      end,
      cmp.scopes, -- what?
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.recently_used,
      cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
      cmp.config.compare.order,
      -- compare.sort_text,
      -- compare.exact,
      -- compare.length, -- useless
      cmp.config.compare.offset,
      -- cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  mapping = cmp_mappings,
}

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"
-- if you just want default config for the servers then put them in a table
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "html",
  "cssls",
  "bashls",
  --"tsserver",

  --[[ Rust ]]
  "rust_analyzer",

  --[[ Dart ]]
  "dartls",

  --[[ C/C++ ]]
  "clangd",

  --[[ OpenCL ]]
  "opencl_ls",

  --[[ OLS  https://github.com/DanielGavin/ols.gits ]]
  "ols",

  --[[ zig ]]
  "zls",

  --[[ MuttRC ]]
  -- "mutt_ls",

  --[[ Python ]]
  "jedi_language_server",
  -- "pylyzer",
  -- "pylsp",
  -- "pyright",  -- Piss Slow on wsl and notebook idk, more diagnotics about unecessary code but too slow for usage
  --"pyre",
  -- "ruff_lsp",
}

local lsp_keymaps = function(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  --keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>lspinfo<cr>", opts)
  keymap(bufnr, "n", "<leader>li", "<cmd>lspinstallinfo<cr>", opts)
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
  keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  --keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  keymap(bufnr, "n", "<leader>lr", "<cmd>lua require('nvchad_ui.renamer').open()<cr>", opts)

  keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", opts)
  keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
end

local on_attach = function(client, bufnr)
  default_on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = true
  client.resolved_capabilities.document_range_formatting = true

  client.resolved_capabilities.offset_encoding = "utf-8"
  client.resolved_capabilities.offset_encoding = "utf-8"
  client.offsetEncoding = "utf-8"
  client.offset_encoding = "utf-8"
  lsp_keymaps(bufnr)
end

for _, lsp in ipairs(servers) do
  if lsp == "clangd" then
    lspconfig["clangd"].setup {
      on_attach = on_attach,
      cmd = {
        "clangd",
        "--header-insertion=never",
      },
      offset_encoding = "utf-8",
      capabilities = capabilities,
    }
  elseif lsp == "pyright" then
    print "pyrgith balling"
    lspconfig[lsp].setup {
      on_attach = on_attach,
      autostart = true, -- This is the important new option
      offset_encoding = "utf-8",
      capabilities = capabilities,
      filetypes = { "python" },
      settings = {
        pyright = { autoImportCompletion = false },
        python = {
          formatting = {
            provider = "black",
          },
          analysis = {
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
            autoSearchPaths = false,
            typeCheckingMode = "off",
          },
        },
      },
    }
  else
    lspconfig[lsp].setup {
      on_attach = on_attach,
      autostart = true, -- This is the important new option
      offset_encoding = "utf-8",
      capabilities = capabilities,
    }
  end
end

-- Start or restart Neovim.
-- The Black formatter should now be enabled for Python files. Y
-- ou can trigger formatting by using the appropriate Neovim command
-- (such as :lua vim.lsp.buf.formatting()).

local illuminate_ok, illuminate = pcall(require, "illuminate")
if not illuminate_ok then
  return
end
