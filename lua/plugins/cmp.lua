-- https://github.com/hrsh6th/nvim-cmp/wiki/Advanced-techniques
return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'VimEnter', 'InsertEnter' },
    lazy = false,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if (vim.fn.has 'win32') == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          'onsails/lspkind.nvim',
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- please take a look at this https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      --https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItemKind
      local cmp = require 'cmp'
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
      -- See `:help cmp`
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      luasnip.config.setup {}
      cmp.event:on('confirm_done', function(event)
        cmp.config.compare.recently_used:add_entry(event.entry)
      end)

      local _ = true
        and cmp.setup {
          -- @class cmp.PerformanceConfig
          -- @field public debounce integer
          -- @field public throttle integer
          -- @field public fetching_timeout integer
          -- @field public confirm_resolve_timeout integer
          -- @field public async_budget integer Maximum time (in ms) an async function is allowed to run during one step of the event loop.
          -- @field public max_view_entries integer

          performance = {
            debounce = 10,
            throttle = 90,
            fetching_timeout = 500,
            confirm_resolve_timeout = 90,
            async_budget = 3,
            max_view_entries = 30,
          },

          sorting = {
            priority_weight = 1.2,
            comparators = {
              -- cmp.score_offset, -- not good at all
              cmp.config.compare.locality,
              cmp.config.compare.exact,
              cmp.config.compare.recently_used,

              function(e1, e2)
                local k1 = CompletionItemKind[e1:get_kind()]
                local k2 = CompletionItemKind[e2:get_kind()]
                if k1 < k2 then
                  return true
                end
                return false
              end,
              -- cmp.scopes, -- what?
              cmp.config.compare.kind,
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
          formatting = {
            format = lspkind.cmp_format {
              mode = 'symbol', -- show only symbol annotations
              maxwidth = 45, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              -- can also be a function to dynamically calculate max width such as
              -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
              ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
              show_labelDetails = false, -- show labelDetails in menu. Disabled by default

              -- The function below will be called before any actual modifications from lspkind
              -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
              before = function(entry, vim_item)
                return vim_item
              end,
            },
          },
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          -- completion = { completeopt = 'menu,menuone,noinsert,noselect,preview' },
          completion = { completeopt = 'menu,menuone,noinsert,preview' },
          -- experimental = {
          --   ghost_text = true, -- optional, can help show inline suggestions
          -- },

          -- For an understanding of why these mappings were
          -- chosen, you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          mapping = cmp.mapping.preset.insert {
            -- Select the [n]ext item
            ['<C-n>'] = cmp.mapping.select_next_item(),
            -- Select the [p]revious item
            ['<C-p>'] = cmp.mapping.select_prev_item(),

            ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
            ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down

            -- Scroll the documentation window [b]ack / [f]orward
            -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            -- ['<C-f>'] = cmp.mapping.scroll_docs(4),

            -- Accept ([y]es) the completion.
            --  This will auto-import if your LSP supports it.
            --  This will expand snippets if the LSP sent a snippet.
            ['<C-y>'] = cmp.mapping.confirm { select = true },
            ['<C-\\>'] = cmp.mapping.confirm { select = true },
            ['|'] = cmp.mapping.confirm { select = true },

            -- If you prefer more traditional completion keymaps,
            -- you can uncomment the following lines
            --['<CR>'] = cmp.mapping.confirm { select = true },
            --['<Tab>'] = cmp.mapping.select_next_item(),
            --['<S-Tab>'] = cmp.mapping.select_prev_item(),

            -- Manually trigger a completion from nvim-cmp.
            --  Generally you don't need this, because nvim-cmp will display
            --  completions whenever it has completion options available.
            ['<C-Space>'] = cmp.mapping.complete {},

            -- Think of <c-l> as moving to the right of your snippet expansion.
            --  So if you have a snippet that's like:
            --  function $name($args)
            --    $body
            --  end
            --
            -- <c-l> will move you to the right of each of the expansion locations.
            -- <c-h> is similar, except moving you backwards.
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),

            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer' },
            -- { name = 'cmdline' },
          },
        }
      local search_opts = {
        mapping = cmp.mapping.preset.cmdline(),
        completion = { completeopt = 'menu,menuone,noinsert,noselect,preview' },
        sources = {
          { name = 'buffer' },
        },
      }
      -- `/` cmdline setup.
      local _ = not vim.g.self.wilder and cmp.setup.cmdline('/', search_opts)
      local _ = not vim.g.self.wilder and cmp.setup.cmdline('?', search_opts)
      -- `:` cmdline setup.
      local _ = not vim.g.self.wilder
        and cmp.setup.cmdline(':', {
          autocomplete = false,
          enabled = function()
            -- Set of commands where cmp will be disabled
            local disabled = {
              IncRename = true,
            }
            -- Get first word of cmdline
            local cmd = vim.fn.getcmdline():match '%S+'
            -- Return true if cmd isn't disabled
            -- else call/return cmp.close(), which returns false
            return not disabled[cmd] or cmp.close()
          end,
          completion = { completeopt = 'menu,menuone,noinsert,noselect,preview' },
          -- completion = { completeopt = 'menu' },
          mapping = cmp.mapping.preset.cmdline {
            ['<C-y>'] = {
              c = function()
                if not cmp.get_selected_entry() then
                  cmp.select_next_item()
                end
                cmp.mapping.confirm { select = true }
              end,
            },
            ['<Tab>'] = {
              c = function()
                if cmp.visible() then
                  cmp.select_next_item()
                  cmp.mapping.confirm { select = true }
                else
                  cmp.complete()
                  cmp.mapping.complete_common_string()
                end
              end,
            },
          },
          sources = cmp.config.sources {
            { name = 'path' },
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' },
              },
            },
            {
              name = 'cmdline_window',
              option = {
                ignore_cmds = { 'Man', '!' },
              },
            },
            {
              name = 'cmdline_history', -- NOTE: Which cmdline history is right? Are they different concepts? they might just be
            },
            { name = 'cmp-cmdline-history' }, -- TODO: be sure -> I think this one is a Plugin
          },
        })
      -- Change sources based on filetype for cmdline window
      cmp.setup.filetype('vim', {
        sources = {
          -- { name = 'nvim_lsp' },
          -- { name = 'luasnip' },
          -- { name = 'path' },
          { name = 'cmdline' }, -- Example of an additional source
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
