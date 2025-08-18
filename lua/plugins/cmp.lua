-- https://github.com/hrsh6th/nvim-cmp/wiki/Advanced-techniques
-- Working examples of cmp + friendly-snippets https://www.reddit.com/r/neovim/comments/qi09ym/a_working_example_for_nvimcmp_luasnip_and/

-- Could also implement using :sub? but i think find is faster
local is_prefix = function(str, prefix)
  local start_index = 1
  local found_start, found_end = string.find(str, prefix, start_index, true)
  return found_start == start_index
end

local has_words_before2 = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local has_words_before = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match '%s' == nil
end

local cmdline_has_slash_before = function()
  local line = vim.fn.getcmdline()
  local suffix = '/'
  return line:match(suffix .. '$') ~= nil
end

local ctx = {
  cmp = nil,
  mini = {
    MiniSnippets = nil,
  },
}
local snippet = {
  -- PERF: We're requiring all the time, is this slow?
  mini = {
    repo = 'echasnovski/mini.snippets',
    ctx = {},
    config = function()
      local gen_loader = require('mini.snippets').gen_loader
      local config_path = vim.fn.stdpath 'config'

      ctx.mini.MiniSnippets = require 'mini.snippets'
      ctx.mini.MiniSnippets.setup {
        snippets = {
          -- Load custom file with global snippets first (adjust for Windows)
          gen_loader.from_file(config_path .. '/nvim/after/snippets/global.json'),

          -- Load snippets based on current language by reading files from
          -- "snippets/" subdirectories from 'runtimepath' directories.
          gen_loader.from_lang(),
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Expand snippet at cursor position. Created globally in Insert mode.
          expand = '<tab>',
          expand = '',
          -- Interact with default `expand.insert` session.
          -- Created for the duration of active session(s)
          jump_next = '<tab>',
          jump_prev = '<s-tab>',
          stop = '<C-c>',
        },
      }
    end,
    expand = function(args) -- mini.snippets expands snippets from lsp...
      local MiniSnippets = ctx.mini.MiniSnippets
      local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      insert { body = args.body } -- Insert at cursor
      ctx.cmp.resubscribe { 'TextChangedI', 'TextChangedP' }
      require('cmp.config').set_onetime { sources = {} }
    end,

    select = function(snippets, insert)
      local MiniSnippets = ctx.mini.MiniSnippets
      -- Close completion window on snippet select - vim.ui.select
      -- Needed to remove virtual text for fzf-lua and telescope, but not for mini.pick...
      local select = MiniSnippets.default_select
      select(snippets, insert)
    end,

    source = {
      name = 'mini_snippets',
      repo = 'abeldekat/cmp-mini-snippets',
    },
  },
}

local snippet_name = 'mini'

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'VimEnter', 'InsertEnter' },
    -- lazy = false,
    enabled = true,
    dependencies = {
      { 'onsails/lspkind.nvim', enabled = true },
      -- { 'evertonse/friendly-snippets', enabled = true },

      snippet[snippet_name].repo,
      snippet[snippet_name].source.repo,

      -- 'dcampos/cmp-snippy',
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
      -- Please take a look at this https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItemKind
      local cmp = require 'cmp'
      ctx.cmp = cmp

      snippet[snippet_name].config()
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
      local lspkind = require 'lspkind'
      cmp.event:on('confirm_done', function(event)
        cmp.config.compare.recently_used:add_entry(event.entry)
      end)

      cmp.setup {
        matching = {
          disallow_fuzzy_matching = true,
          -- disallow_symbol_nonprefix_matching = true,
          -- disallow_fullfuzzy_matching = true,
          -- disallow_partial_fuzzy_matching = true,
          -- disallow_partial_matching = true,
          -- disallow_prefix_unmatching = false,
        },
        -- @class cmp.PerformanceConfig
        -- @field public debounce integer
        -- @field public throttle integer
        -- @field public fetching_timeout integer
        -- @field public confirm_resolve_timeout integer
        -- @field public async_budget integer Maximum time (in ms) an async function is allowed to run during one step of the event loop.
        -- @field public max_view_entries integer
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = snippet[snippet_name].source.name, keyword_length = 2 },
          -- { name = 'cmdline' },
        },

        snippet = {
          expand = snippet[snippet_name].expand,
        },

        performance = {
          debounce = 20,
          throttle = 250,
          fetching_timeout = 200,
          confirm_resolve_timeout = 90,
          async_budget = 1,
          max_view_entries = 20,
        },

        sorting = {
          priority_weight = 1.2,
          comparators = {
            -- cmp.score_offset, -- NOTE: Not good at all
            cmp.config.compare.exact,

            function(entry1, entry2)
              local input = entry1.match_view_args_ret.input
              local text1 = entry1.word
              local text2 = entry2.word
              local prefix1 = is_prefix(text1, input)
              -- local prefix2 = is_prefix(text2, input)
              if not prefix1 then
                entry1.score = 0
              end
              -- return text1:len() > text2:len()
            end,
            cmp.config.compare.score,

            function(entry1, entry2)
              local text1 = entry1.word
              local text2 = entry2.word
              return text1:len() < text2:len()
            end,
            cmp.config.compare.locality,

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
            function(entry1, entry2) -- Underscore :D
              local _, entry1_under = entry1.completion_item.label:find '^_+'
              local _, entry2_under = entry2.completion_item.label:find '^_+'
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,
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
          -- ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['|'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }), --['<C-space>'] = cmp.mapping.complete(),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
        },
      }
      local search_opts = {
        mapping = cmp.mapping.preset.cmdline(),
        autocomplete = true,
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

          autocomplete = true,
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
          -- completion = { completeopt = 'menu,menuone,noinsert,select,preview' },
          -- completion = { completeopt = 'menu' },

          -- mapping = cmp.mapping.preset.cmdline {
          mapping = {
            ['<C-y>'] = {
              c = function()
                if not cmp.get_selected_entry() then
                  cmp.select_next_item()
                end
                cmp.mapping.confirm { select = true }
              end,
            },

            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = false, -- Do not auto-select if nothing is selected
            },
            ['<Tab>'] = {
              c = function(fallback)
                -- cmp.mapping.confirm { select = true }(fallback)

                -- cmp.mapping.complete_common_string()(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                  cmp.confirm { select = true }
                end
                -- cmp.mapping.complete()(fallback)
                if cmdline_has_slash_before() then
                  cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                  }(fallback)
                  -- if not cmp.get_selected_entry() then
                  cmp.select_next_item()
                  -- end

                  -- cmp.mapping.confirm { select = true }
                else
                  -- cmp.confirm { select = true }
                end
              end,
            },

            -- -- Old behaviour
            -- ['<Tab>'] = {
            --   c = function()
            --     if cmp.visible() then
            --       cmp.select_next_item()
            --       cmp.confirm { select = true }
            --       cmp.complete() -- Trigger completion again after confirm
            --       -- -- cmp.mapping.complete_common_string()
            --       -- cmp.select_next_item()
            --       -- cmp.mapping.confirm { select = true }
            --       -- vim.api.nvim_input '<space><bs>'
            --       -- vim.schedule(function()
            --       --   cmp.complete()
            --       -- end)
            --     else
            --       cmp.complete()
            --       cmp.mapping.complete_common_string()
            --     end
            --   end,
            -- },
          },
          sources = cmp.config.sources {
            {
              name = 'path',
              option = {
                trailing_slash = true,
                -- matching = {
                --   disallow_symbol_nonprefix_matching = true,
                --   disallow_fuzzy_matching = true,
                --   disallow_fullfuzzy_matching = true,
                --   disallow_partial_fuzzy_matching = true,
                --   disallow_partial_matching = true,
                --   disallow_prefix_unmatching = false,
                -- },
              },
            },
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' },
                treat_trailing_slash = false,
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
          { name = 'path' },
          { name = 'cmdline' }, -- Example of an additional source
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
