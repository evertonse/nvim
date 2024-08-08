local is_nvim_11_or_higher = vim.version().major > 0 or (vim.version().major == 0 and vim.version().minor >= 11)
local on_list = function(options)
  -- Check the number of items in the options
  if #options.items == 1 then
    -- vim.lsp.util.jump_to_location(options.items[1])
    vim.lsp.buf.definition()
  else
    -- If there are multiple items, set the quickfix list and open it
    vim.fn.setqflist({}, ' ', options)
    vim.cmd 'horizontal copen'
    vim.cmd 'resize 6'
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode, opts)
      mode = mode or 'n'
      opts = vim.tbl_deep_extend('force', { noremap = true, expr = true, buffer = event.buf, desc = 'LSP: ' .. desc }, opts or {})
      vim.keymap.set(mode, keys, func, opts)
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gd', function()
      vim.lsp.buf.definition { on_list = on_list }
    end, '[G]oto [D]efinition')
    map('gD', vim.lsp.buf.declaration, '[G]o to [*D*]eclaration')

    -- Find references for the word under your cursor.
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>ltd', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[L]SP [D]ocument [S]ymbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('<leader>ls', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]SP workspace [S]ymbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    -- map('<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
    local rename_func = function()
      local inc_rename_available, _ = pcall(require, 'inc_rename')
      if inc_rename_available then
        return function()
          return ':IncRename ' .. vim.fn.expand '<cword>' .. '<Down>'
        end
      else
        return vim.lsp.buf.rename
      end
    end
    map('<leader>lr', rename_func(), '[L]SP [R]ename')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>lca', vim.lsp.buf.code_action, '[L]SP [C]ode [A]ction')
    -- Define a function to check if LSP is attached and call hover if it is
    local function lsp_hover_or_fallback()
      local clients = vim.lsp.get_clients()
      if next(clients) ~= nil then
        vim.lsp.buf.hover()
      else
        -- Fallback to the default 'K' behavior (looking up man pages)
        -- vim.api.nvim_feedkeys('K', 'n', false)
      end
    end

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map('K', (vim.version().minor >= 10) and lsp_hover_or_fallback or vim.lsp.buf.hover, 'Hover Documentation')
    -- map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Make sure to replace '<leader>r' with the keybinding of your choice.
    local _ = false and map('<leader>lf', vim.lsp.buf.format, 'Ranged [L]sp [F]formatting', 'v')

    map(
      '[d',
      is_nvim_11_or_higher and ':lua vim.diagnostic.jump({ count = -1, float = true })<cr>'
        or ':lua vim.diagnostic.goto_prev({ float = true })<cr>',
      'Go to previous [D]iagnostic message',
      'n',
      { noremap = true, expr = false, buffer = 0 }
    )

    map(
      ']d',
      is_nvim_11_or_higher and ':lua vim.diagnostic.jump({ count = 1, float = true })<cr>'
        or ':lua vim.diagnostic.goto_next({ float = true })<cr>',
      'Go to next [D]iagnostic message',
      'n',
      { noremap = true, expr = false, buffer = 0 }
    )

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>lth', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[L]SP [T]oggle Inlay [H]ints')
    end
  end,
})
