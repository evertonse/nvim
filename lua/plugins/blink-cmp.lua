local is_too_big = require('functions').is_too_big_for_completions
return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    'evertonse/friendly-snippets',
    'moyiz/blink-emoji.nvim',
    'ray-x/cmp-sql',
    'mikavilpas/blink-ripgrep.nvim',

    {
      'saghen/blink.compat',
      -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
      version = '*',
      -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
      lazy = true,
      -- make sure to set opts so that lazy.nvim calls blink.compat's setup
      opts = {},
    },
  },
  event = { 'CmdlineChanged', 'InsertCharPre' },
  -- event = { 'InsertCharPre' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'default',
      ['<C-y>'] = { 'accept', 'fallback' },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = true } },
    signature = { enabled = false },
    cmdline = {
      -- ignores cmdline completions when executing shell commands
      enabled = true,

      completion = {

        menu = {
          auto_show = true,
        },

        list = {
          selection = { preselect = false },
        },
        -- Show documentation when selecting a completion item
        -- Display a preview of the selected item on the current line
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    -- NOTE: see: https://cmp.saghen.dev/recipes.html#sources
    sources = {
      min_keyword_length = function()
        return vim.bo.filetype == 'markdown' and 3 or 2
      end,
      default = function(ctx)
        local success, node = pcall(vim.treesitter.get_node)
        if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
          return { 'buffer' }
        elseif vim.bo.filetype == 'txt' then
          return {
            'lsp',
            'path',
            'snippets',
            'buffer',
            'ripgrep',
            'emoji',
          }
        elseif vim.bo.filetype == 'sql' then
          return {
            'lsp',
            'path',
            'snippets',
            --- PERF: Pulling in from the buffer is SLOW when the file is too big
            'buffer',
            'sql',
          }
        else
          return {
            'lsp',
            'path',
            'snippets',
            --- PERF: Pulling in from the buffer is SLOW when the file is too big
            'buffer',
          }
        end
      end,

      providers = {

        cmdline = {
          --- Ignores cmdline completions when executing shell commands
          enabled = function()
            if true then
              return true
            end
            return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match "^[%%0-9,'<>%-]*!"
          end,
        },

        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
            end, items)
          end,
        },
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
        buffer = {
          opts = {
            --- Get all buffers, even ones like neo-tree
            -- get_bufnrs = vim.api.nvim_list_bufs,

            --- Get only decent not too big buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == '' and (not is_too_big(bufnr))
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
        ripgrep = {
          module = 'blink-ripgrep',
          name = 'Ripgrep',
          -- the options below are optional, some default values are shown
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {
            -- For many options, see `rg --help` for an exact description of
            -- the values that ripgrep expects.

            -- the minimum length of the current word to start searching
            -- (if the word is shorter than this, the search will not start)
            prefix_min_len = 3,

            -- The number of lines to show around each match in the preview
            -- (documentation) window. For example, 5 means to show 5 lines
            -- before, then the match, and another 5 lines after the match.
            context_size = 5,

            -- The maximum file size of a file that ripgrep should include in
            -- its search. Useful when your project contains large files that
            -- might cause performance issues.
            -- Examples:
            -- "1024" (bytes by default), "200K", "1M", "1G", which will
            -- exclude files larger than that size.
            max_filesize = '1M',

            -- Specifies how to find the root of the project where the ripgrep
            -- search will start from. Accepts the same options as the marker
            -- given to `:h vim.fs.root()` which offers many possibilities for
            -- configuration. If none can be found, defaults to Neovim's cwd.
            --
            -- Examples:
            -- - ".git" (default)
            -- - { ".git", "package.json", ".root" }
            project_root_marker = '.git',

            -- Enable fallback to neovim cwd if project_root_marker is not
            -- found. Default: `true`, which means to use the cwd.
            project_root_fallback = true,

            -- The casing to use for the search in a format that ripgrep
            -- accepts. Defaults to "--ignore-case". See `rg --help` for all the
            -- available options ripgrep supports, but you can try
            -- "--case-sensitive" or "--smart-case".
            search_casing = '--ignore-case',

            -- (advanced) Any additional options you want to give to ripgrep.
            -- See `rg -h` for a list of all available options. Might be
            -- helpful in adjusting performance in specific situations.
            -- If you have an idea for a default, please open an issue!
            --
            -- Not everything will work (obviously).
            additional_rg_options = {},

            -- When a result is found for a file whose filetype does not have a
            -- treesitter parser installed, fall back to regex based highlighting
            -- that is bundled in Neovim.
            fallback_to_regex_highlighting = true,

            -- Absolute root paths where the rg command will not be executed.
            -- Usually you want to exclude paths using gitignore files or
            -- ripgrep specific ignore files, but this can be used to only
            -- ignore the paths in blink-ripgrep.nvim, maintaining the ability
            -- to use ripgrep for those paths on the command line. If you need
            -- to find out where the searches are executed, enable `debug` and
            -- look at `:messages`.
            ignore_paths = {},

            -- Any additional paths to search in, in addition to the project
            -- root. This can be useful if you want to include dictionary files
            -- (/usr/share/dict/words), framework documentation, or any other
            -- reference material that is not available within the project
            -- root.
            additional_paths = {},

            -- Keymaps to toggle features on/off. This can be used to alter
            -- the behavior of the plugin without restarting Neovim. Nothing
            -- is enabled by default. Requires folke/snacks.nvim.
            toggles = {
              -- The keymap to toggle the plugin on and off from blink
              -- completion results. Example: "<leader>tg"
              on_off = nil,
            },

            -- Features that are not yet stable and might change in the future.
            -- You can enable these to try them out beforehand, but be aware
            -- that they might change. Nothing is enabled by default.
            future_features = {
              backend = {
                -- The backend to use for searching. Defaults to "ripgrep".
                -- Available options:
                -- - "ripgrep", always use ripgrep
                -- - "gitgrep", always use git grep
                -- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
                --   ripgrep
                use = 'ripgrep',
              },
            },

            -- Show debug information in `:messages` that can help in
            -- diagnosing issues with the plugin.
            debug = false,
          },
          -- (optional) customize how the results are displayed. Many options
          -- are available - make sure your lua LSP is set up so you get
          -- autocompletion help
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              -- example: append a description to easily distinguish rg results
              item.labelDetails = {
                description = '(rg)',
              }
            end
            return items
          end,
        },
        emoji = {
          module = 'blink-emoji',
          name = 'Emoji',
          score_offset = 15, -- Tune by preference
          opts = { insert = true }, -- Insert emoji (default) or complete its name
          should_show_items = function()
            return vim.tbl_contains(
              -- Enable emoji completion only for git commits and markdown.
              -- By default, enabled for all file-types.
              { 'gitcommit', 'markdown' },
              vim.o.filetype
            )
          end,
        },
        sql = {
          -- IMPORTANT: use the same name as you would for nvim-cmp
          name = 'sql',
          module = 'blink.compat.source',

          -- all blink.cmp source config options work as normal:
          score_offset = -3,

          -- this table is passed directly to the proxied completion source
          -- as the `option` field in nvim-cmp's source config
          --
          -- this is NOT the same as the opts in a plugin's lazy.nvim spec
          opts = {},
          should_show_items = function()
            return vim.tbl_contains(
              -- Enable emoji completion only for git commits and markdown.
              -- By default, enabled for all file-types.
              { 'sql' },
              vim.o.filetype
            )
          end,
        },
      },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
