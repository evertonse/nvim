-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors
local M = {}

local vars = require "custom.user.vars"
local c = require("custom.user.colors." .. vars.theme)
local is_transparent = require("custom.user.vars").transparency
-- @important check https://github.com/NvChad/base46/blob/v2.0/lua/base46/integrations/tbline.lua
-- for better ideia of highlight groups
-- @imporant also check https://github.com/NvChad/ui/blob/v2.0/lua/nvchad_ui/tabufline/modules.lua for default config
-- of statusline and tabline
-- @important highlights https://github.com/folke/tokyonight.nvim/blob/284667adfff02b9a0adc65968c553c6096b543b6/lua/tokyonight/theme.lua#L182
-- @important lsp tutorial on nvim https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
-- @example vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg='Purple' })
M.override = {
  ---@type Base46HLGroupsList
  -----------------EDITOR------------------------------
  Normal = { fg = c.editor.Front, bg = is_transparent and "none" or c.editor.CursorDarkDark },
  ColorColumn = { fg = "NONE", bg = is_transparent and "none" or c.editor.CursorDarkDark },
  Cursor = {
    fg = c.editor.CursorDark, --[[ bg = c.editor.CursorLight ]]
  },
  CursorLine = { bg = c.editor.CursorDarkDark },
  CursorColumn = { fg = "NONE", bg = c.editor.CursorDarkDark },
  Directory = {
    fg = c.code.Method, --[[ bg = c.editor.Back ]]
  },
  EndOfBuffer = { fg = c.editor.Back, bg = "NONE" },
  ErrorMsg = {
    fg = c.editor.Red, --[[ bg = c.editor.Back ]]
  },
  VertSplit = {
    fg = c.editor.SplitDark, --[[ bg = c.editor.Back ]]
  },
  Folded = {
    fg = "NONE", --[[ bg = c.editor.FoldBackground ]]
  },
  FoldColumn = {
    fg = c.editor.LineNumber, --[[ bg = c.editor.Back ]]
  },
  SignColumn = {
    fg = "NONE", --[[ bg = c.editor.Back ]]
  },
  IncSearch = { fg = c.editor.None, bg = c.editor.SearchCurrent },
  LineNr = {
    fg = c.editor.LineNumber, --[[bg = c.editor.Back]]
  },
  CursorLineNr = {
    fg = c.editor.PopupFront, --[[bg = c.editor.Back ]]
  },
  MatchParen = { fg = c.editor.None, bg = c.editor.CursorDark },
  ModeMsg = {
    fg = c.editor.Front, --[[ bg = c.editor.LeftDark ]]
  },
  MoreMsg = {
    fg = c.editor.Front, --[[ bg = c.editor.LeftDark ]]
  },
  NonText = {
    fg = c.editor.LineNumber, --[[bg = c.editor.None]]
  },
  Pmenu = {
    fg = c.editor.PopupFront, --[[ bg = c.editor.PopupBack ]]
  },
  PmenuSel = { fg = c.editor.PopupFront, bg = c.editor.PopupHighlightBlue },
  PmenuSbar = {
    fg = "NONE", --[[ bg = c.editor.PopupHighlightGray ]]
  },
  PmenuThumb = {
    fg = "NONE", --[[ bg = c.editor.PopupFront ]]
  },
  Question = {
    fg = c.editor.Blue, --[[ bg = c.editor.Back ]]
  },
  Search = { fg = c.editor.None, bg = c.editor.Search },
  SpecialKey = { fg = c.editor.Blue, bg = c.editor.None },
  --StatusLine      =   { fg = c.editor.Front, --[[ bg = c.editor.LeftMid ]] },
  StatusLineNC = {
    fg = c.editor.Front, --[[ bg = c.editor.LeftDark ]]
  },
  Todo = {
    fg = c.code.Normal,
    bg = c.text.Todo,
    bold = true,
  },
  Note = {
    fg = c.code.Normal,
    bg = c.text.Todo,
    bold = true,
  },
  TabLine = { fg = c.editor.Front, bg = c.editor.TabOther },
  TabLineFill = { fg = c.editor.Front, bg = c.editor.TabOutside },
  TabLineSel = { fg = c.editor.Front, bg = c.editor.TabCurrent },
  Title = {
    --[[ fg = c.editor.None, bg = c.editor.None, ]]
    bold = true,
  },
  Visual              = { fg = c.editor.None, bg = c.editor.Selection },
  VisualNOS           = { fg = c.editor.None, bg = c.editor.Selection },
  WarningMsg          = { fg = c.editor.Red, bg = c.editor.Back, bold = true },
  WildMenu            = { fg = c.editor.None, bg = c.editor.Selection },
  ["@spell"]          = { fg = c.code.Normal, bg = c.code.None, italic = true },
  ["@spell.markdown"] = { fg = c.code.Normal, bg = c.code.None, italic = true, bold = true },
  -------------------------------------------------------------------------

  --------------------------BASIC-----------------
  Comment             = { fg = c.code.Comment, bg = "NONE" },
  Variable            = { fg = c.code.Variable, bg = "None" },

  Constant            = { fg = c.code.Constant, bg = "NONE" },
  Global              = { fg = c.code.Global, bg = "NONE" },
  String              = { fg = c.code.String, bg = "NONE" },
  Character           = { fg = c.editor.Orange, bg = "NONE" },
  Number              = { fg = c.code.Constant, bg = "NONE" },
  Boolean             = { fg = c.code.BuiltInConstant, bg = "NONE" },
  Float               = { fg = c.code.Constant, bg = "NONE" },
  Identifier          = { fg = c.code.Normal, bg = "NONE" },
  Function            = { fg = c.editor.Yellow, bg = "NONE" },
  Statement           = { fg = c.code.Preprocessor, bg = "NONE" },
  Conditional         = { fg = c.code.ControlFlow, bold = true, bg = "NONE" },
  Repeat              = { fg = c.code.ControlFlow, bold = true, bg = "NONE" },
  Label               = { fg = c.code.ControlFlow, bg = "NONE" },
  Operator            = { fg = c.code.Normal, bg = "NONE" },
  Keyword             = { fg = c.code.Keyword, bold = true, bg = "NONE" },
  Exception           = { fg = c.code.ControlFlow, bg = "NONE" },
  PreProc             = { fg = c.code.Preprocessor, bg = "NONE" },
  Include             = { fg = c.code.Include, bg = "NONE" },
  Define              = { fg = c.code.Preprocessor, bg = "NONE" },
  Macro               = { fg = c.code.Macro, bg = "NONE" },
  Type                = { fg = c.code.Type, bg = "NONE" },
  StorageClass        = { fg = c.code.Keyword, bg = "NONE" },
  Structure           = { fg = c.code.Type, bg = "NONE" },
  Typedef             = { fg = c.code.Type, bg = "NONE" },
  Special             = { fg = c.editor.YellowOrange, bg = "NONE" },
  Namespace           = { fg = c.code.Namespace },
  SpecialChar         = { fg = c.editor.Front, bg = "NONE" },
  Tag                 = { fg = c.editor.Front, bg = "NONE" },
  Delimiter           = { fg = c.editor.Front, bg = "NONE" },
  SpecialComment      = { fg = c.code.Comment, bg = "NONE" },
  Debug               = { fg = c.editor.Front, bg = "NONE" },
  Underlined          = { fg = c.editor.None, bg = "NONE", underline = true },
  Conceal             = { fg = c.editor.Front, --[[ bg = c.editor.Back ]] },
  Ignore              = { fg = c.editor.Front, bg = "NONE" },
  Error               = { fg = c.editor.Red, bg = c.editor.Back, undercurl = true, sp = c.editor.Red },
  -- SpellBad = { fg = c.editor.Red, bg = c.editor.Back, undercurl = true, sp = c.editor.Red },
  -- SpellCap = { fg = c.editor.Red, bg = c.editor.Back, undercurl = true, sp = c.editor.Red },
  -- SpellRare = { fg = c.editor.Red, bg = c.editor.Back, undercurl = true, sp = c.editor.Red },
  -- SpellLocal = { fg = c.editor.Red, bg = c.editor.Back, undercurl = true, sp = c.editor.Red },

  DiagnosticWarn = {
    fg        = c.text.Warn,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticError = {
    fg        = c.text.Error,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticInfo = {
    fg        = c.text.Info,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticHint = {
    fg        = c.text.Hint,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticUnnecessary = {
    fg        = c.code.DeadCode,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },

  --Whitespace                 =   { fg = c.editor.LineNumber },
  TODO                         = { fg = c.editor.Red },
  LspGlobal                    = { fg = c.code.Global, bg = "None", bold = true },
  GlobalScope                  = { fg = c.code.Global, bg = "None", bold = true },
  ["@global"]                  = { fg = c.code.Global, bg = "None", bold = true },
  LspGlobalScope               = { fg = c.code.Global, bg = "None", bold = true },
  LspNamespace                 = { fg = c.code.Namespace, bg = "None", bold = true },
  namespace                    = { fg = c.code.Namespace, bg = "None" },
  ["@class"]                   = { fg = c.code.Type, bold = false, italic = false },
  ["@macro"]                   = { fg = c.code.Macro, bold = false, italic = false },
  ["@namespace"]               = { fg = c.code.Namespace, bold = false, italic = false },
  ["@globalScope"]             = { italic = true, bold = true },
  --['@variable#globalScope']  ={ fg = c.code.Global,italic = true,  bold = true},
  ["@defaultLibrary.python"]   = { fg = c.code.Native },
  ["@defaultLibrary.lua"]      = { fg = c.code.Native },

  ["@comment"]                 = { fg = c.code.Comment, bg = "NONE" },
  ["@keyword"]                 = { fg = c.code.Keyword, bold = false, bg = "NONE" },
  ["@keyword.enum"]            = { fg = c.code.Keyword, bold = false, bg = "NONE" },
  ["@keyword.function"]        = { fg = c.code.Keyword, bold = false, bg = "NONE" },
  ["@keyword.operator"]        = { fg = c.code.Keyword, bold = false, bg = "NONE" },

  ["@keyword.return"]          = { fg = c.code.ControlFlow, bold = true, bg = "NONE" }, -- return,

  -- Fucntions
  ["@function"]                = { fg = c.code.Function, bg = "NONE" },
  ["@function.builtin"]        = { fg = c.editor.YellowOrange, bg = "NONE" },
  ["@function.macro"]          = { fg = c.code.MacroFunction, bg = "NONE" },
  ["@function.call"]           = { fg = c.code.FunctionCall, bg = "NONE" },

  ["@method.call.python"]      = { fg = c.code.Method, bg = "NONE" },
  ["@method.call"]             = { fg = c.code.Method, bg = "NONE" },
  ["@method"]                  = { fg = c.code.Method, bg = "NONE" },

  --Literals
  ["@string.regex"]            = { fg = c.code.Char, bg = "NONE" },
  ["@string.escape"]           = { fg = c.code.StringEscape, bg = "NONE" },
  ["@string"]                  = { fg = c.code.String, bg = c.code.None },

  ["@character"]               = { fg = c.code.Char, bg = "NONE" },
  ["@number"]                  = { fg = c.editor.LightGreen, bg = "NONE" },
  ["@boolean"]                 = { fg = c.code.BuiltInConstant, bg = "NONE" },
  ["@float"]                   = { fg = c.editor.LightGreen, bg = "NONE" },

  -- Variables
  ["@variable"]                = { fg = c.code.Variable, bg = "NONE" },
  ["@variable.builtin"]        = { fg = c.code.VariableBuiltin, bold = true, italic = false, bg = "NONE" },
  ["@field"]                   = { fg = c.code.Field, bg = "NONE" },
  ["@property"]                = { fg = c.code.Property, bg = "NONE" },
  ["@reference"]               = { fg = c.code.Normal, bg = "NONE" },
  -- Preprocessores
  ["@preproc"]                 = { fg = c.code.Preprocessor, bg = "NONE" },
  ["@define"]                  = { fg = c.code.Preprocessor, bg = "NONE" },
  ["@include"]                 = { fg = c.code.Include, bg = "NONE" },
  ["@include.c"]               = { fg = c.code.Preprocessor, bg = "NONE" },

  -- Parameteres:
  ["@parameter"]               = { fg = c.code.Parameter, bg = "NONE" },
  ["@parameter.reference"]     = { fg = c.code.Parameter, bg = "NONE" },

  -- @Types
  ["@type"]                  = { fg = c.code.Type, bg = "NONE" },
  ["@type.qualifier"]        = { fg = c.code.Keyword, bg = "NONE" },
  ["@type.qualifier.cpp"]    = { fg = c.code.Keyword, bg = "NONE" },
  ["@type.qualifier.c"]      = { fg = c.code.Keyword, bg = "NONE" },
  ["@type.definition"]       = { fg = c.code.Keyword, bg = "NONE" },
  ["@type.builtin"]          = { fg = c.code.BuiltInType, bg = "NONE" },
  ["@type.builtin.py"]       = { fg = c.code.BuiltInType, bg = "NONE" },
  ["@type.builtin.python"]   = { fg = c.code.BuiltInType, bg = "NONE" },
  ["@storageclass"]          = { fg = c.code.Keyword, bg = "NONE" },
  ["@structure"]             = { fg = c.code.Type, bg = "NONE" },

  -- @Tags
  ["@tag.delimiter"]         = { fg = c.editor.Gray, bg = "NONE" },
  ["@tag.attribute"]         = { fg = c.editor.Keyword, italic = true, bg = "NONE" },
  ["@tag.html"]              = { fg = c.editor.Keyword, bold = true, bg = "NONE" },

  ["@text.title"]            = { fg = c.editor.Blue, bold = true },
  ["@text.literal"]          = { fg = c.editor.Front, bg = "NONE" },
  ["@text.diff.delete.diff"] = { fg = c.text.DiffDelete },
  ["@text.diff.add.diff"]    = { fg = c.text.DiffAdd },

  --['@definition.macro']    = { fg = c.code.Macro, bg = 'NONE' },
  --['@definition.var']      = { fg = c.code.Macro, bg = 'NONE' },

  --['@macro.cpp']           = { fg = c.code.Macro, bg = 'NONE' },
  ["@constant.macro.cpp"]    = { fg = c.code.Macro, bg = "NONE" },
  --['@error']               = { fg = c.editor.Red, bg = 'NONE' },
  --['@punctuation.bracket'] = { fg = c.editor.Front, bg = 'NONE' },
  ["@punctuation.special"]   = { fg = c.code.Punct, bg = "NONE" },
  --['@constant']            = { fg = c.editor.Macro, bg = 'NONE' },
  ["@constant.builtin"]      = { fg = c.code.BuiltInConstant, bg = "NONE" },

  --['@annotation']          = { fg = c.editor.Yellow, bg = 'NONE' },
  --['@attribute']           = { fg = c.editor.BlueGreen, bg = 'NONE' },

  ["@constructor"]      = { fg = c.code.Construtor },
  ["@constructor.cpp"]  = { fg = c.code.Construtor, bold = true },
  ["@constructor.py"]   = { fg = c.code.Construtor, bold = true },

  ["@conditional"]      = { fg = c.code.ControlFlow, bold = true, bg = "NONE" },
  ["@repeat"]           = { fg = c.code.ControlFlow, bold = true, bg = "NONE" },
  ["@label"]            = { fg = c.code.Label, bg = "NONE" },
  ["@operator"]         = { fg = c.editor.Front, bg = "NONE" },

  ["@exception"]        = { fg = c.code.ControlFlow, bold = true, bg = "NONE" },
  ["@exception.python"] = { fg = c.code.ControlFlow, bold = true, bg = "NONE" },

  ["@lsp.mod.variable.global"] = { fg = c.code.Global },
  ["@lsp.typemod.variable.global"] = { fg = c.code.Global },
  ["@lsp.typemod.variable.globalScope"] = { fg = c.code.Global },
  ["@lsp.typemod.variable.fileScope"]   = { fg = c.code.FileScope },
  ["@lsp.mod.constructorOrDestructor"]  = { fg = c.code.ConstrutorOnClass },
  ["@lsp.type.comment.c"]               = { fg = c.code.DeadCode },
  ["@lsp.type.comment.cpp"]             = { fg = c.code.DeadCode },

  ["@text.title.1.markdown"] = { fg = c.text.Title, sp = c.code.None, bg = c.code.None },
  ["@text.title.markdown"]   = { fg = c.text.Title, sp = c.code.None, bg = c.code.None },
  -- ['@variable.builtin']= { fg = c.code.VariableBuiltin, bg = 'NONE' },
  -- ['@text']= { fg = c.editor.Front, bg = 'NONE' },
  -- ['@text.underline']= { fg = c.editor.YellowOrange, bg = 'NONE' },
  -- ['@tag']= { fg = c.code.Normal, bg = 'NONE' },
  -- ['markdown@text.literal']= { fg = c.editor.Orange, bg = 'NONE' },
  -- ['markdown_inline@text.literal']= { fg = c.editor.Orange, bg = 'NONE' },
  -- ['@text.emphasis']= { fg = c.editor.Front, bg = 'NONE', italic = true },
  -- ['@text.strong']= { fg = isDark and c.editor.Blue or c.editor.Violet, bold = true },
  -- ['@text.uri']= { fg = c.editor.Front, bg = 'NONE' },
  -- ['@textReference']= { fg = isDark and c.editor.Orange or c.editor.YellowOrange },
  -- ['@punctuation.delimiter']= { fg = c.editor.Front, bg = 'NONE' },
  -- ['@text.note']= { fg = c.editor.BlueGreen, bg = 'NONE', bold = true },
  -- ['@text.warning']= { fg = c.editor.YellowOrange, bg = 'NONE', bold = true },
  -- ['@text.danger']= { fg = c.editor.Red, bg = 'NONE', bold = true },
  -- ['@scope']= { fg = c.editor.Red, bg = 'NONE', bold = true },
  ----------------------TAB-----------------------------
  TblineFill = {
    bg = c.code.None,
  },

  TbLineBufOn = {
    bg = c.code.None,
  },

  TbLineBufOff = {
    bg = c.code.None,
  },

  TbLineBufOnModified = {
    bg = c.code.None,
  },

  TbBufLineBufOffModified = {
    bg = c.code.None,
  },

  TbLineBufOnClose = {
    bg = c.code.None,
  },

  TbLineBufOffClose = {
    bg = c.code.None,
  },

  -- TblineTabNewBtn = {
  --   fg = colors.white,
  --   bg = colors.one_bg3,
  --   bold = true,
  -- },
  --
  -- TbLineTabOn = {
  --   fg = colors.black,
  --   bg = colors.nord_blue,
  --   bold = true,
  -- },
  --
  -- TbLineTabOff = {
  --   fg = colors.white,
  --   bg = colors.one_bg2,
  -- },
  --
  -- TbLineTabCloseBtn = {
  --   fg = colors.black,
  --   bg = colors.nord_blue,
  -- },
  --
  -- TBTabTitle = {
  --   fg = colors.black,
  --   bg = colors.white,
  -- },
  --
  -- TbLineThemeToggleBtn = {
  --   bold = true,
  --   fg = colors.white,
  --   bg = colors.one_bg3,
  -- },
  --
  -- TbLineCloseAllBufsBtn = {
  --   bold = true,
  --   bg = colors.red,
  --   fg = colors.black,
  -- },
  StatusLine = {
    bg = c.code.None,
  },
  St_Mode = {
    fg = c.code.None,
    bg = c.code.None,
  },
  StText = {
    fg = c.code.None,
    bg = c.code.None,
  },
  St_EmptySpace = {
    fg = c.code.None,
    bg = c.code.None,
  },
  St_EmptySpace2 = {
    fg = c.code.None,
    bg = c.code.None,
  },
  -- St_pos_text = {
  --   fg = c.code.None,
  --   bg = c.code.None,
  -- },
  --
  NvimTreeOpenedFolderName = {
    --fg = "#9099dd",
    bold = true,
  },
}

---@type HLTable
M.add = {

  -- @Tags
  ["@tag.delimiter"]                    = { fg = c.editor.Gray, bg = "NONE" },
  ["@tag.attribute"]                    = { fg = c.editor.Keyword, italic = true, bg = "NONE" },
  ["@tag.html"]                         = { fg = c.editor.Keyword, bold = true, bg = "NONE" },
  ["@keyword.enum"]                     = { fg = c.code.Keyword, bg = "NONE" },
  ["@type.qualifier"]                   = { fg = c.code.Keyword, sp = c.code.None, bg = c.text.Background },
  DiffAdd                               = { fg = "NONE", sp = c.code.None, bg = c.editor.DiffGreenLight },
  DiffChange                            = { fg = "NONE", sp = c.code.None, bg = c.editor.DiffRedDark },
  DiffText                              = { fg = "NONE", sp = c.code.None, bg = c.editor.DiffRedLight },
  ["@text.diff.delete.diff"]            = { fg = c.text.DiffDelete, sp = c.code.None },
  ["@text.diff.add.diff"]               = { fg = c.text.DiffAdd, sp = c.code.None, bg = c.code.None },
  ["@text.title.1.markdown"]            = { fg = c.text.Title, sp = c.code.None, bg = c.code.None },
  ["@lsp.mod.variable.global"]          = { fg = c.code.Global },
  ["@lsp.typemod.variable.global"]      = { fg = c.code.Global },
  ["@lsp.typemod.variable.globalScope"] = { fg = c.code.Global },
  ["@lsp.typemod.variable.fileScope"]   = { fg = c.code.FileScope },
  ["@lsp.mod.constructorOrDestructor"]  = { fg = c.code.ConstrutorOnClass },
  ["@structure"]                        = { fg = c.code.Type, bg = "NONE" },
  ["@lsp.type.comment.c"]               = { fg = c.code.DeadCode, bg = "NONE" },
  ["cDefine"]                           = { fg = c.code.Preprocessor, bg = "NONE" },
  ["cppModifier"]                       = { fg = c.code.Keyword, bg = "NONE" },
  ["@lsp.type.variable"]                = { fg = c.code.Variable, bg = "NONE" },
  ["@lsp.type.comment.cpp"]             = { fg = c.code.DeadCode, bg = "NONE" },

  DiagnosticWarn = {
    fg        = c.text.Warn,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticError = {
    fg        = c.text.Error,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticInfo = {
    fg        = c.text.Info,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticHint = {
    fg        = c.text.Hint,
    bg        = c.code.None,
    italic    = true,
    underline = false,
    undercurl = false,
    sp        = c.code.None,
  },
  DiagnosticUnnecessary = {
    fg                  = c.code.DeadCode,
    bg                  = c.code.None,
    italic              = true,
    underline           = false,
    undercurl           = false,
    sp                  = c.code.None,
  },
  ["@keyword.python"] = { fg = c.code.Keyword, sp = c.code.None, bg = "NONE" },
}

return M
--return {override={}, add={}}
