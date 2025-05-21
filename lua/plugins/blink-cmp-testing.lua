--
-- blink-cmp keymaps api: https://github.com/Saghen/blink.cmp/blob/main/doc/configuration/keymap.md
--
-- Common patterns: https://github.com/Saghen/blink.cmp/blob/main/doc/recipes.md
--
-- Default Config: https://cmp.saghen.dev/configuration/reference.html#completion-trigger
--
local transform_items = function(ctx, items)
  return vim.tbl_filter(function(item)
    -- Get the text from the line at the position specified by textEdit.insert
    local start_char = item.textEdit and item.textEdit.insert and item.textEdit.insert.start.character or 0
    local end_char = item.textEdit and item.textEdit.insert and item.textEdit.insert['end'].character or ctx.line:len()

    -- Extract the substring from ctx.line
    local line_substring = string.sub(ctx.line, start_char + 1, end_char)
    -- Check if filterText is a substring of the extracted text
    local is_substring = item.filterText:find(line_substring)
    -- if ctx.line:len() > 5 then
    --   Inspect {
    --     aaaitemfilterText = item.filterText,
    --     aaaline_substring = line_substring,
    --     -- ctx = ctx,
    --     aaacursor = ctx:get_cursor(),
    --     aaakeyword = ctx:get_keyword() or 'lol',
    --     -- items = items,
    --     is_substring = is_substring,
    --   }
    -- end

    return is_substring
  end, items)
end

local cmdline_sort = function(a, b)
  -- local cmdline = vim.fn.getcmdline()
  local is_substring = function(item)
    -- Get the text from the line at the position specified by textEdit.insert
    local start_char = item.textEdit and item.textEdit.insert and item.textEdit.insert.start.character or 0
    local end_char = item.textEdit and item.textEdit.insert and item.textEdit.insert['end'].character or ctx.line:len()

    -- Extract the substring from ctx.line
    local line_substring = string.sub(cmdline, start_char + 1, end_char)
    -- Inspect { item.filterText, cmdline = line_substring, textEdit = item.textEdit, newText = item.textEdit.newText }
    -- Open a file in append mode ('a' will create the file if it doesn't exist)
    local file = io.open('output.txt', 'a')
    Inspect { file = file, line_substring = line_substring }

    if line_substring:len() > 3 then
    end
    -- Check if the file was opened successfully
    if file then
      -- Write the string to the file
      file:write(line_substring)
      -- Close the file
      file:close()
    end
    -- Check if filterText is a substring of the extracted text
    -- item.textEdit.newText
    local is_substring = item.filterText:find(line_substring)
    return is_substring
  end
end

local inloop = false

local setup_blink_cmp_vim_on_key = function()
  vim.on_key(function(key, typed)
    -- key is a string like '\t' for Tab, '\x1b[Z' for S-Tab, etc.
    -- Exit loop on any key that is not Tab or S-Tab
    vim.schedule(function()
      if inloop and key ~= '\t' and key ~= vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true) then
        inloop = false
      end
    end)
  end) -- or 0 for current buffer
end

setup_blink_cmp_vim_on_key()

local setup_blink_cmp_schedule_key_read = function()
  vim.schedule(function()
    local key = vim.fn.getcharstr()
    if key == '\t' or key == vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true) then
      inloop = false
    end
    -- Feed the key back to Neovim to be processed normally
    -- vim.api.nvim_feedkeys(key, vim.api.nvim_get_mode().mode, false)
    vim.api.nvim_feedkeys(key, vim.api.nvim_get_mode().mode, false)
  end)
end

local setup_blink_cmp_timer = function()
  local loop_timer = nil
  local function reset_loop_state()
    if loop_timer then
      loop_timer:stop()
      loop_timer:close()
      loop_timer = nil
    end

    -- Create a timer that will automatically reset inloop after a delay
    loop_timer = vim.loop.new_timer()
    loop_timer:start(
      500,
      0,
      vim.schedule_wrap(function()
        inloop = false
        loop_timer:stop()
        loop_timer:close()
        loop_timer = nil
      end)
    )
  end
end

local setup_blink_cmp_autocommands = function()
  -- Create an autocommand to reset the inloop state when any key is pressed except Tab/S-Tab
  vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = '*',
    callback = function()
      -- Reset inloop state when command line changes due to non-Tab/S-Tab keys
      if inloop then
        -- Save the current command line text to compare
        local current_cmdline = vim.fn.getcmdline()
        -- Use vim.schedule to check after the Tab key handler completes
        vim.schedule(function()
          -- If command line changed and not due to Tab/S-Tab (which your function handles)
          if current_cmdline ~= vim.fn.getcmdline() then
            inloop = false
          end
        end)
      end
    end,
  })

  -- Also reset when leaving insert mode or cmdline mode
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'CmdlineLeave' }, {
    pattern = '*',
    callback = function()
      inloop = false
    end,
  })
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
  local suffix = '[/ ]'
  return line:match(suffix .. '$') ~= nil
end

return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'evertonse/friendly-snippets', enabled = true },
  -- event = 'BufReadPost',
  -- event = { 'CmdlineChanged', 'InsertCharPre' },
  event = { 'InsertCharPre' },
  enabled = true,
  lazy = true,

  -- use a release tag to download pre-built binaries
  -- version = 'v1.2',
  -- version = 'v1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = { preset = 'default' },
    -- term = {}, -- There is term mode https://cmp.saghen.dev/configuration/reference.html#completion-trigger
    ------------------------------------------------------------------
    ---------------Term-----------------------------------------------
    ------------------------------------------------------------------
    term = {
      enabled = false,
      keymap = { preset = 'inherit' }, -- Inherits from top level `keymap` config when not set
      sources = {},
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
        },
        -- Inherits from top level config options when not set
        list = {
          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = nil,
            -- When `true`, inserts the completion item automatically when selecting it
            auto_insert = nil,
          },
        },
        -- Whether to automatically show the window when new completion items are available
        menu = { auto_show = nil },
        -- Displays a preview of the selected item on the current line
        ghost_text = { enabled = nil },
      },
    },
    ------------------------------------------------------------------
    ----------------CmdLine-------------------------------------------
    ------------------------------------------------------------------
    cmdline = {
      enabled = true,
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == '/' or type == '?' then
          return { 'buffer' }
        end
        -- Commands
        if type == ':' or type == '@' then
          return { 'cmdline' }
        end
        return {}
      end,
      keymap = {
        preset = 'super-tab',
        -- preset = 'none',
        -- preset = 'cmdline',

        -- If completion hasn't been triggered yet, insert the first suggestion; if it has, cycle to the next suggestion.
        ['<C-Tab>'] = {
          function(cmp)
            return cmp.insert_next()
          end,
          'fallback',
        },
        ['<Tab>'] = {
          function(cmp)
            -- Check if the previous character is a slash
            if inloop or cmdline_has_slash_before() then
              inloop = true
              -- return cmp.select_next { auto_insert = false }
              local res = cmp.insert_next {}

              -- cmp.show {}
              return res
            else
              inloop = false
              cmp:select_and_accept {}
              return cmp.show {}
            end
          end,
          'show_and_insert',
          'select_next',
          'fallback',
        },
        ['<S-Tab>'] = { 'show_and_insert', 'insert_prev', 'select_prev' },
        ['<Enter>'] = {
          function(cmp)
            inloop = false
            if cmdline_has_slash_before() then
              return cmp:select_and_accept {}
            end
            return cmp.accept()
          end,
          'fallback',
        },
        -- Navigate to the previous suggestion or cancel completion if currently on the first one.
      },

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

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      -- use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        snippets = {
          name = 'snippets',
          enabled = true,
          min_keyword_length = 2,
          opts = {
            search_paths = { vim.fn.stdpath 'config', vim.fn.stdpath 'config' .. '/after/snippets/' },
          },
        },
        cmdline = {
          enabled = function()
            -- return vim.fn.getcmdline():sub(1, 1) ~= '!'
            return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match "^[%%0-9,'<>%-]*!"
          end,
        },
      },
      -- optionally disable cmdline completions
      -- cmdline = {},
    },
    fuzzy = {
      -- use_typo_resistance = false,
      max_typos = function(keyword)
        -- math.floor(#keyword / #keyword)
        return 0
      end,

      -- Frecency tracks the most recently/frequently used items and boosts the score of the item
      -- Note, this does not apply when using the Lua implementation.
      use_frecency = false,

      -- Proximity bonus boosts the score of items matching nearby words
      -- Note, this does not apply when using the Lua implementation.
      use_proximity = false,

      -- implementation = 'prefer_rust',
      implementation = 'prefer_rust_with_warning',
      sorts = {},

      -- sorts = {
      --   cmdline_sort,
      --   'exact',
      --   'label',
      --   'score',
      --   'sort_text',
      -- },
    },
    -- signature = { enabled = true },-- experimental signature help support
    completion = {
      keyword = {
        -- https://main.cmp.saghen.dev/configuration/general#general
        range = 'prefix',
      },
      list = {
        selection = { preselect = false },
        cycle = {
          from_top = true,
          from_bottom = true,
        },
      },
      documentation = { auto_show = true },
      menu = {
        auto_show = true,
      },
      trigger = {
        prefetch_on_insert = true,
        show_on_keyword = true,
      },
      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = false },
    },
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { 'sources.default' },
}
