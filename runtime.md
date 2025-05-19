# Why

Sometimes it bugs out or the runtime is too slow on certain things and I need to debug (ftdetect/all.lua). Some times the neovim version I'm using works better with a specific runtime. Because of that, we're embedding the runtime in our config.

To avoid unintentional modifications:

      find ./runtime/ -type f -exec chmod 444 {} \;

When updates neovim updates this, or if the slowness on somethings have been fixed, then you could symlink it

# Find cheanged parts
Diffs won't help as I'd like, every single change is marked with a comment `@runtime-modified`. Grep it to find them all

## Runtime Structure Explained by GPT xD, will check later tho the order

First it look at $VIMRUTIME if not then it looks is uses /usr/local/share/nvim/runtime/ or maybe some other default place. You can  check where it's running from with `nvim --startuptime startup.log`. Also it for sure looks at a relative folder from bin

### Directories

1. **`autoload/`**
   - Contains scripts that are loaded on-demand when called
   - Only loaded when explicitly requested via functions
   - Not evaluated at startup unless explicitly autoloaded

2. **`colors/`**
   - Contains colorscheme definitions
   - Only loaded when a specific colorscheme is requested
   - Not evaluated during initial file loading

3. **`compiler/`**
   - Contains compiler definitions for various programming languages
   - Only loaded when `:compiler` command is used
   - Not evaluated during initial file loading

4. **`doc/`**
   - Documentation files
   - Not executed during runtime
   - Only accessed when help is requested

5. **`ftplugin/`**
   - FileTYPE specific plugins
   - Loaded when a buffer's filetype is set
   - For `.sh` files, `ftplugin/sh.vim` and `ftplugin/sh/*.vim` would be loaded
   - **A common cause of slowdowns for specific filetypes**

6. **`indent/`**
   - Indentation rules for specific filetypes
   - Loaded after ftplugin when a buffer's filetype is set
   - For `.sh` files, `indent/sh.vim` would be loaded

7. **`keymap/`**
   - Keyboard mapping tables for non-English input
   - Only loaded when a specific keymap is requested
   - Not evaluated during normal file loading

8. **`lua/`**
   - Lua modules for Neovim
   - Loaded on-demand or when required
   - Can include filetype-specific modules

9. **`pack/`**
   - Package manager directory for plugins
   - Structure follows the packages specification
   - Loading depends on whether plugins are "start" or "opt"

10. **`plugin/`**
    - Global plugins loaded for all filetypes
    - Loaded during startup
    - Can affect performance but equally for all filetypes

11. **`queries/`**
    - Treesitter queries for highlighting, indentation, etc.
    - Loaded when treesitter is active for a buffer
    - Can cause slowdowns for specific filetypes

12. **`scripts/`**
    - Various utility scripts
    - Not automatically loaded during runtime

13. **`syntax/`**
    - Syntax highlighting definitions
    - For `.sh` files, `syntax/sh.vim` would be loaded
    - **Often a major source of slowdowns for complex filetypes**

14. **`tutor/`**
    - Neovim tutorial files
    - Not loaded during normal use

### Root Files

1. **`delmenu.vim`**
   - Removes menus from GUI version
   - Only loaded in GUI contexts

2. **`filetype.lua`**
   - Handles filetype detection in Lua
   - Run early to determine file types
   - Can cause slowdowns if detection is complex

3. **`ftoff.vim`**, **`ftplugof.vim`**, **`indoff.vim`**
   - Used to disable filetype plugins, filetype detection, or indentation
   - Not loaded during normal operation

4. **`ftplugin.vim`**
   - Sets up the filetype plugin system
   - Loaded after filetype detection

5. **`indent.vim`**
   - Sets up the indentation system
   - Loaded after filetype detection

6. **`makemenu.vim`**, **`menu.vim`**, **`synmenu.vim`**
   - Creates menus for GUI version
   - Not loaded in terminal Neovim

7. **`optwin.vim`**
   - Option window script
   - Not loaded during normal file opening

## Order of Evaluation for File Loading

When opening a `.sh` file, Neovim follows this approximate sequence:

1. Load core configuration
2. Load plugins from `pack/*/start/`
3. Load scripts from `plugin/` directory
4. Run `filetype.lua` for filetype detection
5. Determine the file is a shell script
6. Load `ftplugin.vim` to enable filetype plugins
7. Load `ftplugin/sh.vim` and any scripts in `ftplugin/sh/`
8. Load `indent.vim` to enable indentation
9. Load `indent/sh.vim` for shell-specific indentation
10. Load `syntax/sh.vim` for shell syntax highlighting

## Debugging Your Slow `.sh` File Loading

### 1. Profile the startup time:

```bash
nvim --startuptime startup.log your_slow_file.sh
```

Then examine `startup.log` to see where time is being spent.

### 2. Isolate the slow component:

Test loading the file with various components disabled:

```bash
# Test without syntax highlighting
nvim --cmd "syntax off" your_slow_file.sh

# Test without filetype plugins
nvim --cmd "filetype plugin off" your_slow_file.sh

# Test without filetype indent
nvim --cmd "filetype indent off" your_slow_file.sh

# Test without filetype detection entirely
nvim --cmd "filetype off" your_slow_file.sh
```

### 3. Profile specific runtime files:

```lua
-- Add to your init.lua temporarily
local start_time = vim.loop.hrtime()
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.sh",
  callback = function()
    print("Before sh file load: " .. (vim.loop.hrtime() - start_time) / 1000000 .. "ms")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    print("FileType sh detected: " .. (vim.loop.hrtime() - start_time) / 1000000 .. "ms")
  end,
})

vim.api.nvim_create_autocmd("Syntax", {
  pattern = "sh",
  callback = function()
    print("Syntax sh loaded: " .. (vim.loop.hrtime() - start_time) / 1000000 .. "ms")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.sh",
  callback = function()
    print("After sh file load: " .. (vim.loop.hrtime() - start_time) / 1000000 .. "ms")
  end,
})
```

### 4. Identify the specific file causing issues:

```lua
-- Add to init.lua temporarily
vim.api.nvim_create_autocmd({"SourcePre"}, {
  pattern = "*",
  callback = function(ev)
    local start = vim.loop.hrtime()
    vim.api.nvim_create_autocmd({"SourcePost"}, {
      pattern = "*",
      callback = function()
        local duration = (vim.loop.hrtime() - start) / 1000000
        if duration > 10 then -- Only log files taking more than 10ms
          print(string.format("Loading %s took %.2fms", ev.match, duration))
        end
      end,
      once = true
    })
  end
})
```

### 5. Most likely culprits for `.sh` files:

1. **Complex syntax highlighting rules in `syntax/sh.vim`**
   - Shell scripts have complex syntax highlighting with many regex patterns
   - Check if the issue occurs with very long lines or specific shell constructs

2. **Filetype detection in `filetype.lua`**
   - Shell script detection might involve examining file contents
   - Could be slow for large files

3. **Treesitter parser for shell scripts**
   - If you're using Treesitter, the shell parser might struggle with large files

### 6. Solutions based on findings:

#### If it's syntax highlighting:
```vim
" Add to your config
autocmd BufReadPre *.sh if getfsize(expand("%")) > 1024 * 512 | syntax off | endif
```

#### If it's filetype plugins:
```vim
" Add to your config
autocmd BufReadPre *.sh if getfsize(expand("%")) > 1024 * 512 | set filetype= | endif
```

#### If it's Treesitter:
```lua
-- Add to your Treesitter config
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 512 * 1024 -- 512 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
}
```

#### Debug specific sh.vim files:
```lua
-- Add this to your init.lua to time sh.vim loading specifically
vim.api.nvim_create_autocmd({"SourcePre"}, {
  pattern = {"*/syntax/sh.vim", "*/ftplugin/sh.vim", "*/indent/sh.vim"},
  callback = function(ev)
    print("Loading " .. ev.match)
    local start = vim.loop.hrtime()
    vim.api.nvim_create_autocmd({"SourcePost"}, {
      pattern = {"*/syntax/sh.vim", "*/ftplugin/sh.vim", "*/indent/sh.vim"},
      callback = function()
        print("Loaded " .. ev.match .. " in " .. (vim.loop.hrtime() - start) / 1000000 .. "ms")
      end,
      once = true
    })
  end
})
```

