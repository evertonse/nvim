--[[
-- This file exists only to visualize possible most important highlight 
-- that are possible, formely used on my old visual studio (not code) theme
--]]
local hl = vim.api.nvim_set_hl
local theme = {}

local highlight = function(group)
  for item, color_opts in pairs(group) do
    hl(0, item, color_opts)
  end
end

theme.set_highlights = function(opts)
  local c = require("vscode.colors").get_colors()
  local vs = require "vs.colors"
  c = vim.tbl_extend("force", c, opts["color_overrides"])
  local isDark = vim.o.background == "dark"

  local editor = {
    Normal = { fg = c.vscFront, bg = c.vscBack },
    ColorColumn = { fg = "NONE", bg = c.vscCursorDarkDark },
    Cursor = { fg = c.vscCursorDark, bg = c.vscCursorLight },
    CursorLine = { bg = c.vscCursorDarkDark },
    CursorColumn = { fg = "NONE", bg = c.vscCursorDarkDark },
    Directory = { fg = vs.Method, bg = c.vscBack },
    DiffAdd = { fg = "NONE", bg = c.vscDiffGreenLight },
    DiffChange = { fg = "NONE", bg = c.vscDiffRedDark },
    DiffDelete = { fg = "NONE", bg = c.vscDiffRedLight },
    DiffText = { fg = "NONE", bg = c.vscDiffRedLight },
    EndOfBuffer = { fg = c.vscBack, bg = "NONE" },
    ErrorMsg = { fg = c.vscRed, bg = c.vscBack },
    VertSplit = { fg = c.vscSplitDark, bg = c.vscBack },
    Folded = { fg = "NONE", bg = c.vscFoldBackground },
    FoldColumn = { fg = c.vscLineNumber, bg = c.vscBack },
    SignColumn = { fg = "NONE", bg = c.vscBack },
    IncSearch = { fg = c.vscNone, bg = c.vscSearchCurrent },
    LineNr = { fg = c.vscLineNumber, bg = c.vscBack },
    CursorLineNr = { fg = c.vscPopupFront, bg = c.vscBack },
    MatchParen = { fg = c.vscNone, bg = c.vscCursorDark },
    ModeMsg = { fg = c.vscFront, bg = c.vscLeftDark },
    MoreMsg = { fg = c.vscFront, bg = c.vscLeftDark },
    NonText = { fg = (isDark and c.vscLineNumber or c.vscTabOther), bg = c.vscNone },
    Pmenu = { fg = c.vscPopupFront, bg = c.vscPopupBack },
    PmenuSel = { fg = isDark and c.vscPopupFront or c.vscBack, bg = c.vscPopupHighlightBlue },
    PmenuSbar = { fg = "NONE", bg = c.vscPopupHighlightGray },
    PmenuThumb = { fg = "NONE", bg = c.vscPopupFront },
    Question = { fg = c.vscBlue, bg = c.vscBack },
    Search = { fg = c.vscNone, bg = c.vscSearch },
    SpecialKey = { fg = c.vscBlue, bg = c.vscNone },
    StatusLine = { fg = c.vscFront, bg = c.vscLeftMid },
    StatusLineNC = { fg = c.vscFront, bg = c.vscLeftDark },
    Todo = { fg = c.vscYellowOrange, bg = c.vscBack, bold = true },
    TabLine = { fg = c.vscFront, bg = c.vscTabOther },
    TabLineFill = { fg = c.vscFront, bg = c.vscTabOutside },
    TabLineSel = { fg = c.vscFront, bg = c.vscTabCurrent },
    Title = { fg = c.vscNone, bg = c.vscNone, bold = true },
    Visual = { fg = c.vscNone, bg = c.vscSelection },
    VisualNOS = { fg = c.vscNone, bg = c.vscSelection },
    WarningMsg = { fg = c.vscRed, bg = c.vscBack, bold = true },
    WildMenu = { fg = c.vscNone, bg = c.vscSelection },
  }

  local syntax = {
    Comment = { fg = vs.Comment, bg = "NONE", italic = opts.italic_comments },
    Variable = { fg = vs.Variable, bg = "None" },
    --Constant        =   { fg = "None", bg = 'NONE' },
    Global = { fg = vs.Global, bg = "NONE" },
    String = { fg = c.vscOrange, bg = "NONE" },
    Character = { fg = c.vscOrange, bg = "NONE" },
    Number = { fg = c.vscLightGreen, bg = "NONE" },
    Boolean = { fg = c.vscBlue, bg = "NONE" },
    Float = { fg = c.vscLightGreen, bg = "NONE" },
    Identifier = { fg = vs.Normal, bg = "NONE" },
    Function = { fg = c.vscYellow, bg = "NONE" },
    Statement = { fg = vs.Preprocessor, bg = "NONE" },
    Conditional = { fg = vs.ControlFlow, bg = "NONE" },
    Repeat = { fg = vs.ControlFlow, bg = "NONE" },
    Label = { fg = vs.ControlFlow, bg = "NONE" },
    Operator = { fg = vs.Normal, bg = "NONE" },
    Keyword = { fg = vs.Keyword, bg = "NONE" },
    Exception = { fg = vs.ControlFlow, bg = "NONE" },
    PreProc = { fg = vs.Preprocessor, bg = "NONE" },
    Include = { fg = vs.Preprocessor, bg = "NONE" },
    Define = { fg = vs.Preprocessor, bg = "NONE" },
    Macro = { fg = vs.Macro, bg = "NONE" },
    Type = { fg = vs.Type, bg = "NONE" },
    StorageClass = { fg = vs.Type, bg = "NONE" },
    Structure = { fg = vs.Type, bg = "NONE" },
    Typedef = { fg = vs.Type, bg = "NONE" },
    Special = { fg = c.vscYellowOrange, bg = "NONE" },
    Namespace = { fg = vs.Namespace },
    SpecialChar = { fg = c.vscFront, bg = "NONE" },
    Tag = { fg = c.vscFront, bg = "NONE" },
    Delimiter = { fg = c.vscFront, bg = "NONE" },
    SpecialComment = { fg = vs.Comment, bg = "NONE" },
    Debug = { fg = c.vscFront, bg = "NONE" },
    Underlined = { fg = c.vscNone, bg = "NONE", underline = true },
    Conceal = { fg = c.vscFront, bg = c.vscBack },
    Ignore = { fg = c.vscFront, bg = "NONE" },
    Error = { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed },
    SpellBad = { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed },
    SpellCap = { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed },
    SpellRare = { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed },
    SpellLocal = { fg = c.vscRed, bg = c.vscBack, undercurl = true, sp = c.vscRed },
    Whitespace = { fg = isDark and c.vscLineNumber or c.vscTabOther },
    TODO = { fg = c.vscRed },
    --[[   --]]
  }

  -->> Treesitter
  local treesitter = {
    ["@comment"] = { fg = vs.Comment, bg = "NONE", italic = opts.italic_comments },
    ["@keyword"] = { fg = vs.Keyword, bg = "NONE" },
    ["@keyword.return"] = { fg = vs.ControlFlow, bg = "NONE" }, -- return,
    ["@keyword.function"] = { fg = vs.Keyword, bg = "NONE" },
    ["@keyword.operator"] = { fg = vs.Keyword, bg = "NONE" },

    -- Fucntions
    ["@function"] = { fg = c.vscYellow, bg = "NONE" },
    ["@function.builtin"] = { fg = c.vscYellowOrange, bg = "NONE" },
    ["@function.macro"] = { fg = vs.MacroFunction, bg = "NONE" },
    --['@function.call']= { fg = vs.None, bg = 'NONE' },
    --['@method']= { fg = c.vscYellow, bg = 'NONE' },

    --Literals
    ["@string.regex"] = { fg = c.vscOrange, bg = "NONE" },
    ["@string"] = { fg = c.vscOrange, bg = "NONE" },
    ["@character"] = { fg = c.vscOrange, bg = "NONE" },
    ["@number"] = { fg = c.vscLightGreen, bg = "NONE" },
    ["@boolean"] = { fg = c.vscBlue, bg = "NONE" },
    ["@float"] = { fg = c.vscLightGreen, bg = "NONE" },

    -- Variables
    ["@variable"] = { fg = vs.Variable, bg = "NONE" },
    ["@variable.builtin"] = { fg = vs.VariableBuiltin, bg = "NONE" },
    ["@field"] = { fg = vs.Normal, bg = "NONE" },
    ["@property"] = { fg = vs.Normal, bg = "NONE" },
    ["@reference"] = { fg = vs.Normal, bg = "NONE" },
    -- Preprocessores
    ["@preproc"] = { fg = vs.Preprocessor, bg = "NONE" },
    ["@define"] = { fg = vs.Preprocessor, bg = "NONE" },
    ["@include"] = { fg = vs.Preprocessor, bg = "NONE" },

    -- Parameteres:
    ["@parameter"] = { fg = vs.Parameter, bg = "NONE" },
    ["@parameter.reference"] = { fg = vs.Parameter, bg = "NONE" },

    -- @Types
    ["@type"] = { fg = vs.Type, bg = "NONE" }, -- Type
    ["@type.qualifier"] = { fg = vs.Keyword, bg = "NONE" },
    ["@type.definition"] = { fg = vs.Keyword, bg = "NONE" },
    ["@type.builtin"] = { fg = vs.Keyword, bg = "NONE" },
    ["@type.builtin.py"] = { fg = vs.Type, bg = "NONE" },
    ["@type.builtin.python"] = { fg = vs.Type, bg = "NONE" },
    --['@storageClass']= { fg = vs.Keyword, bg = 'NONE' },
    --['@structure']= { fg = vs.Type, bg = 'NONE' },

    -- @Tags
    ["@tag.delimiter"] = { fg = c.vscGray, bg = "NONE" },
    ["@tag.attribute"] = { fg = c.Keyword, bg = "NONE" },

    ["@text.title"] = { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true },
    ["@text.literal"] = { fg = c.vscFront, bg = "NONE" },

    ["@namespace"] = { fg = vs.Namespace, bg = "NONE" },

    --['@definition.macro']= { fg = vs.Macro, bg = 'NONE' },
    --['@definition.var']= { fg = vs.Macro, bg = 'NONE' },

    --['@macro.cpp']= { fg = vs.Macro, bg = 'NONE' },
    --['@constant.macro.cpp']= { fg = vs.Macro, bg = 'NONE' },
    --['@error']= { fg = c.vscRed, bg = 'NONE' },
    --['@punctuation.bracket']= { fg = c.vscFront, bg = 'NONE' },
    ["@punctuation.special"] = { fg = c.vscYellow, bg = "NONE" },
    --['@constant']= { fg = c.Macro, bg = 'NONE' },
    --['@constant.builtin']= { fg = c.Macro, bg = 'NONE' },

    --['@annotation']= { fg = c.vscYellow, bg = 'NONE' },
    --['@attribute']= { fg = c.vscBlueGreen, bg = 'NONE' },

    ["@constructor"] = { fg = vs.Construtor },
    ["@constructor.cpp"] = { fg = vs.Construtor, bold = true },
    ["@constructor.py"] = { fg = vs.Construtor, bold = true },

    ["@conditional"] = { fg = vs.ControlFlow, bg = "NONE" },
    ["@repeat"] = { fg = vs.ControlFlow, bg = "NONE" },
    ["@label"] = { fg = vs.Debug, bg = "NONE" },
    ["@operator"] = { fg = c.vscFront, bg = "NONE" },

    --['@exception']= { fg = vs.ControlFlow, bg = 'NONE' },
    -- ['@variable.builtin']= { fg = vs.VariableBuiltin, bg = 'NONE' },
    -- ['@text']= { fg = c.vscFront, bg = 'NONE' },
    -- ['@text.underline']= { fg = c.vscYellowOrange, bg = 'NONE' },
    -- ['@tag']= { fg = vs.Normal, bg = 'NONE' },
    -- ['markdown@text.literal']= { fg = c.vscOrange, bg = 'NONE' },
    -- ['markdown_inline@text.literal']= { fg = c.vscOrange, bg = 'NONE' },
    -- ['@text.emphasis']= { fg = c.vscFront, bg = 'NONE', italic = true },
    -- ['@text.strong']= { fg = isDark and c.vscBlue or c.vscViolet, bold = true },
    -- ['@text.uri']= { fg = c.vscFront, bg = 'NONE' },
    -- ['@textReference']= { fg = isDark and c.vscOrange or c.vscYellowOrange },
    -- ['@punctuation.delimiter']= { fg = c.vscFront, bg = 'NONE' },
    -- ['@stringEscape']= { fg = isDark and c.vscOrange or c.vscYellowOrange, bold = true },
    -- ['@text.note']= { fg = c.vscBlueGreen, bg = 'NONE', bold = true },
    -- ['@text.warning']= { fg = c.vscYellowOrange, bg = 'NONE', bold = true },
    -- ['@text.danger']= { fg = c.vscRed, bg = 'NONE', bold = true },
    -- ['@scope']= { fg = c.vscRed, bg = 'NONE', bold = true },
  }

  local lsp_semantic = {
    LspGlobal = { fg = vs.Global, bg = "None", bold = true },
    GlobalScope = { fg = vs.Global, bg = "None", bold = true },
    ["@global"] = { fg = vs.Global, bg = "None", bold = true },
    LspGlobalScope = { fg = vs.Global, bg = "None", bold = true },
    LspNamespace = { fg = vs.Global, bg = "None", bold = true },
    namespace = { fg = vs.Global, bg = "None" },
    ["@class"] = { fg = vs.Type, bold = false, italic = false },
    ["@macro"] = { fg = vs.Macro, bold = false, italic = false },
    ["@namespace"] = { fg = vs.Namespace, bold = false, italic = false },
    ["@globalScope"] = { italic = true, bold = true },
    --['@variable#globalScope']  ={ fg = vs.Global,italic = true,  bold = true},
    ["@defaultLibrary.lua"] = { fg = vs.Native },
    ["@defaultLibrary.python"] = { fg = vs.Native },
  }
  --- @Remember you can use :Inspect to see all captures and hl groups on a token
  local lsp_semantic_with_treesitter = {
    --['@variable.global']  = { fg = vs.Global, bg = 'None', italic=true ,bold = true},
  }

  highlight(editor)
  highlight(syntax)
  highlight(treesitter)
  highlight(lsp_semantic)
  highlight(lsp_semantic_with_treesitter)
  -- Markdown
  hl(0, "markdownBold", { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true })
  hl(0, "markdownCode", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "markdownRule", { fg = isDark and c.vscBlue or c.vscYellowOrange, bold = true })
  hl(0, "markdownCodeDelimiter", { fg = c.vscFront, bg = "NONE" })
  hl(0, "markdownHeadingDelimiter", { fg = isDark and c.vscBlue or c.vscYellowOrange, bg = "NONE" })
  hl(0, "markdownFootnote", { fg = isDark and c.vscOrange or c.vscYellowOrange, bg = "NONE" })
  hl(0, "markdownFootnoteDefinition", { fg = isDark and c.vscOrange or c.vscYellowOrange })
  hl(0, "markdownUrl", { fg = c.vscFront, bg = "NONE", underline = true })
  hl(0, "markdownLinkText", { fg = isDark and c.vscOrange or c.vscYellowOrange })
  hl(0, "markdownEscape", { fg = isDark and c.vscOrange or c.vscYellowOrange })

  -- JSON
  hl(0, "jsonKeyword", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsonEscape", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "jsonNull", { fg = c.vscBlue, bg = "NONE" })
  hl(0, "jsonBoolean", { fg = c.vscBlue, bg = "NONE" })

  -- HTML
  hl(0, "htmlTag", { fg = c.vscGray, bg = "NONE" })
  hl(0, "htmlEndTag", { fg = c.vscGray, bg = "NONE" })
  hl(0, "htmlTagName", { fg = c.vscBlue, bg = "NONE" })
  hl(0, "htmlSpecialTagName", { fg = c.vscBlue, bg = "NONE" })
  hl(0, "htmlArg", { fg = c.vscLightBlue, bg = "NONE" })

  -- PHP
  hl(0, "phpStaticClasses", { fg = c.vscBlueGreen, bg = "NONE" })
  hl(0, "phpMethod", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "phpClass", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "phpFunction", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "phpInclude", { fg = vs.Type, bg = "NONE" })
  hl(0, "phpUseClass", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "phpRegion", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "phpMethodsVar", { fg = c.vscLightBlue, bg = "NONE" })

  -- CSS
  hl(0, "cssBraces", { fg = c.vscFront, bg = "NONE" })
  hl(0, "cssInclude", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "cssTagName", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "cssClassName", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "cssPseudoClass", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "cssPseudoClassId", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "cssPseudoClassLang", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "cssIdentifier", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "cssProp", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "cssDefinition", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "cssAttr", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssAttrRegion", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssColor", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssFunction", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssFunctionName", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssVendor", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssValueNumber", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssValueLength", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssUnitDecorators", { fg = c.vscOrange, bg = "NONE" })
  hl(0, "cssStyle", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "cssImportant", { fg = vs.Type, bg = "NONE" })

  -- JavaScript
  hl(0, "jsVariableDef", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsFuncArgs", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsFuncBlock", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsRegexpString", { fg = c.vscLightRed, bg = "NONE" })
  hl(0, "jsThis", { fg = vs.Type, bg = "NONE" })
  hl(0, "jsOperatorKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "jsDestructuringBlock", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsObjectKey", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsGlobalObjects", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "jsModuleKeyword", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsClassDefinition", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "jsClassKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "jsExtendsKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "jsExportDefault", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "jsFuncCall", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "jsObjectValue", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsParen", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsObjectProp", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsIfElseBlock", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsParenIfElse", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsSpreadOperator", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "jsSpreadExpression", { fg = c.vscLightBlue, bg = "NONE" })

  -- Typescript
  hl(0, "typescriptLabel", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptExceptions", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptBraces", { fg = c.vscFront, bg = "NONE" })
  hl(0, "typescriptEndColons", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptParens", { fg = c.vscFront, bg = "NONE" })
  hl(0, "typescriptDocTags", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptDocComment", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptLogicSymbols", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptImport", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "typescriptBOM", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptVariableDeclaration", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptVariable", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptExport", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "typescriptAliasDeclaration", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptAliasKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptClassName", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptAccessibilityModifier", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptOperator", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptArrowFunc", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptMethodAccessor", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptMember", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "typescriptTypeReference", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptTemplateSB", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "typescriptArrowFuncArg", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptParamImpl", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptFuncComma", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptCastKeyword", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptCall", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptCase", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptReserved", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "typescriptDefault", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptDecorator", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "typescriptPredefinedType", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptClassHeritage", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptClassExtends", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptClassKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptBlock", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptDOMDocProp", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptTemplateSubstitution", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptClassBlock", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptFuncCallArg", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptIndexExpr", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptConditionalParen", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptArray", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "typescriptES6SetProp", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptObjectLiteral", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptTypeParameter", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptEnumKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptEnum", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptLoopParen", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptParenExp", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptModule", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "typescriptAmbientDeclaration", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptFuncTypeArrow", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptInterfaceHeritage", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptInterfaceName", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptInterfaceKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptInterfaceExtends", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptGlobal", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "typescriptAsyncFuncKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptFuncKeyword", { fg = vs.Type, bg = "NONE" })
  hl(0, "typescriptGlobalMethod", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "typescriptPromiseMethod", { fg = c.vscYellow, bg = "NONE" })

  -- XML
  hl(0, "xmlTag", { fg = vs.Type, bg = "NONE" })
  hl(0, "xmlTagName", { fg = vs.Type, bg = "NONE" })
  hl(0, "xmlEndTag", { fg = vs.Type, bg = "NONE" })

  -- Ruby
  hl(0, "rubyClassNameTag", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "rubyClassName", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "rubyModuleName", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "rubyConstant", { fg = c.vsTypeGreen, bg = "NONE" })

  -- Golang
  hl(0, "goPackage", { fg = vs.Type, bg = "NONE" })
  hl(0, "goImport", { fg = vs.Type, bg = "NONE" })
  hl(0, "goVar", { fg = vs.Type, bg = "NONE" })
  hl(0, "goConst", { fg = vs.Type, bg = "NONE" })
  hl(0, "goStatement", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "goType", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "goSignedInts", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "goUnsignedInts", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "goFloats", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "goComplexes", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "goBuiltins", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "goBoolean", { fg = vs.Type, bg = "NONE" })
  hl(0, "goPredefinedIdentifiers", { fg = vs.Type, bg = "NONE" })
  hl(0, "goTodo", { fg = c.vscGreen, bg = "NONE" })
  hl(0, "goDeclaration", { fg = vs.Type, bg = "NONE" })
  hl(0, "goDeclType", { fg = vs.Type, bg = "NONE" })
  hl(0, "goTypeDecl", { fg = vs.Type, bg = "NONE" })
  hl(0, "goTypeName", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "goVarAssign", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "goVarDefs", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "goReceiver", { fg = c.vscFront, bg = "NONE" })
  hl(0, "goReceiverType", { fg = c.vscFront, bg = "NONE" })
  hl(0, "goFunctionCall", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "goMethodCall", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "goSingleDecl", { fg = c.vscLightBlue, bg = "NONE" })

  -- Python
  hl(0, "pythonStatement", { fg = vs.Type, bg = "NONE" })
  hl(0, "pythonOperator", { fg = vs.Type, bg = "NONE" })
  hl(0, "pythonException", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "pythonExClass", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "pythonBuiltinObj", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "pythonBuiltinType", { fg = c.vsTypeGreen, bg = "NONE" })
  hl(0, "pythonBoolean", { fg = vs.Type, bg = "NONE" })
  hl(0, "pythonNone", { fg = vs.Type, bg = "NONE" })
  hl(0, "pythonTodo", { fg = vs.Type, bg = "NONE" })
  hl(0, "pythonClassVar", { fg = vs.Type, bg = "NONE" })
  hl(0, "pythonClassDef", { fg = vs.Debug, bg = "NONE" })

  -- TeX
  hl(0, "texStatement", { fg = vs.Type, bg = "NONE" })
  hl(0, "texBeginEnd", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "texBeginEndName", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "texOption", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "texBeginEndModifier", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "texDocType", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "texDocTypeArgs", { fg = c.vscLightBlue, bg = "NONE" })

  -- Git
  hl(0, "gitcommitHeader", { fg = c.vscGray, bg = "NONE" })
  hl(0, "gitcommitOnBranch", { fg = c.vscGray, bg = "NONE" })
  hl(0, "gitcommitBranch", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "gitcommitComment", { fg = c.vscGray, bg = "NONE" })
  hl(0, "gitcommitSelectedType", { fg = c.vscGreen, bg = "NONE" })
  hl(0, "gitcommitSelectedFile", { fg = c.vscGreen, bg = "NONE" })
  hl(0, "gitcommitDiscardedType", { fg = c.vscRed, bg = "NONE" })
  hl(0, "gitcommitDiscardedFile", { fg = c.vscRed, bg = "NONE" })
  hl(0, "gitcommitOverflow", { fg = c.vscRed, bg = "NONE" })
  hl(0, "gitcommitSummary", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "gitcommitBlank", { fg = vs.Preprocessor, bg = "NONE" })

  -- Lua
  hl(0, "luaFuncCall", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "luaFuncArgName", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "luaFuncKeyword", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "luaLocal", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "luaBuiltIn", { fg = vs.Type, bg = "NONE" })

  -- SH
  hl(0, "shDeref", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "shVariable", { fg = c.vscLightBlue, bg = "NONE" })

  -- SQL
  hl(0, "sqlKeyword", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "sqlFunction", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "sqlOperator", { fg = vs.Preprocessor, bg = "NONE" })

  -- YAML
  hl(0, "yamlKey", { fg = vs.Type, bg = "NONE" })
  hl(0, "yamlConstant", { fg = vs.Type, bg = "NONE" })

  -- Gitgutter
  hl(0, "GitGutterAdd", { fg = c.vscGreen, bg = "NONE" })
  hl(0, "GitGutterChange", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "GitGutterDelete", { fg = c.vscRed, bg = "NONE" })

  -- Git Signs
  hl(0, "GitSignsAdd", { fg = c.vscGreen, bg = "NONE" })
  hl(0, "GitSignsChange", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "GitSignsDelete", { fg = c.vscRed, bg = "NONE" })
  hl(0, "GitSignsAddLn", { fg = c.vscBack, bg = c.vscGreen })
  hl(0, "GitSignsChangeLn", { fg = c.vscBack, bg = c.vscYellow })
  hl(0, "GitSignsDeleteLn", { fg = c.vscBack, bg = c.vscRed })

  -- NvimTree
  hl(0, "NvimTreeRootFolder", { fg = c.vscFront, bg = "NONE", bold = true })
  hl(0, "NvimTreeGitDirty", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "NvimTreeGitNew", { fg = c.vscGreen, bg = "NONE" })
  hl(0, "NvimTreeImageFile", { fg = c.vscViolet, bg = "NONE" })
  hl(0, "NvimTreeEmptyFolderName", { fg = c.vscGray, bg = "NONE" })
  hl(0, "NvimTreeFolderName", { fg = c.vscFront, bg = "NONE" })
  hl(0, "NvimTreeSpecialFile", { fg = vs.Preprocessor, bg = "NONE", underline = true })
  hl(0, "NvimTreeNormal", { fg = c.vscFront, bg = opts.disable_nvimtree_bg and c.vscBack or c.vscLeftDark })
  hl(0, "NvimTreeCursorLine", { fg = "NONE", bg = opts.disable_nvimtree_bg and c.vscCursorDarkDark or c.vscLeftMid })
  hl(0, "NvimTreeVertSplit", { fg = opts.disable_nvimtree_bg and c.vscSplitDark or c.vscBack, bg = c.vscBack })
  hl(0, "NvimTreeEndOfBuffer", { fg = opts.disable_nvimtree_bg and c.vscCursorDarkDark or c.vscLeftDark })
  hl(
    0,
    "NvimTreeOpenedFolderName",
    { fg = c.vscFront, bg = opts.disable_nvimtree_bg and c.vscCursorDarkDark or c.vscLeftDark }
  )
  hl(0, "NvimTreeGitRenamed", { fg = c.vscGitRenamed, bg = "NONE" })
  hl(0, "NvimTreeGitIgnored", { fg = c.vscGitIgnored, bg = "NONE" })
  hl(0, "NvimTreeGitDeleted", { fg = c.vscGitDeleted, bg = "NONE" })
  hl(0, "NvimTreeGitStaged", { fg = c.vscGitStageModified, bg = "NONE" })
  hl(0, "NvimTreeGitMerge", { fg = c.vscGitUntracked, bg = "NONE" })
  hl(0, "NvimTreeGitDirty", { fg = c.vscGitModified, bg = "NONE" })
  hl(0, "NvimTreeGitNew", { fg = c.vscGitAdded, bg = "NONE" })
  hl(0, "NvimTreeFolderIcon", { fg = vs.Native, bg = "NONE" })

  -- Bufferline
  hl(0, "BufferLineIndicatorSelected", { fg = c.vscLeftDark, bg = "NONE" })
  hl(0, "BufferLineFill", { fg = "NONE", bg = c.vscLeftDark })

  -- BarBar
  hl(0, "BufferCurrent", { fg = c.vscFront, bg = c.vscTabCurrent })
  hl(0, "BufferCurrentIndex", { fg = c.vscFront, bg = c.vscTabCurrent })
  hl(0, "BufferCurrentMod", { fg = c.vscYellowOrange, bg = c.vscTabCurrent })
  hl(0, "BufferCurrentSign", { fg = c.vscFront, bg = c.vscTabCurrent })
  hl(0, "BufferCurrentTarget", { fg = c.vscRed, bg = c.vscTabCurrent })
  hl(0, "BufferVisible", { fg = c.vscGray, bg = c.vscTabCurrent })
  hl(0, "BufferVisibleIndex", { fg = c.vscGray, bg = c.vscTabCurrent })
  hl(0, "BufferVisibleMod", { fg = c.vscYellowOrange, bg = c.vscTabCurrent })
  hl(0, "BufferVisibleSign", { fg = c.vscGray, bg = c.vscTabCurrent })
  hl(0, "BufferVisibleTarget", { fg = c.vscRed, bg = c.vscTabCurrent })
  hl(0, "BufferInactive", { fg = c.vscGray, bg = c.vscTabOther })
  hl(0, "BufferInactiveIndex", { fg = c.vscGray, bg = c.vscTabOther })
  hl(0, "BufferInactiveMod", { fg = c.vscYellowOrange, bg = c.vscTabOther })
  hl(0, "BufferInactiveSign", { fg = c.vscGray, bg = c.vscTabOther })
  hl(0, "BufferInactiveTarget", { fg = c.vscRed, bg = c.vscTabOther })
  hl(0, "BufferTabpages", { fg = c.vscFront, bg = c.vscTabOther })
  hl(0, "BufferTabpagesFill", { fg = c.vscFront, bg = c.vscTabOther })

  -- IndentBlankLine
  hl(0, "IndentBlanklineContextChar", { fg = c.vscContextCurrent, bg = "NONE", nocombine = true })
  hl(0, "IndentBlanklineContextStart", { sp = c.vscContextCurrent, bg = "NONE", nocombine = true, underline = true })
  hl(0, "IndentBlanklineChar", { fg = c.vscContext, bg = "NONE", nocombine = true })
  hl(0, "IndentBlanklineSpaceChar", { fg = c.vscContext, bg = "NONE", nocombine = true })
  hl(0, "IndentBlanklineSpaceCharBlankline", { fg = c.vscContext, bg = "NONE", nocombine = true })

  -- LSP
  hl(0, "DiagnosticError", { fg = c.vscRed, bg = "NONE" })
  hl(0, "DiagnosticWarn", { fg = c.vscYellow, bg = "NONE" })
  hl(0, "DiagnosticInfo", { fg = vs.Method, bg = "NONE" })
  hl(0, "DiagnosticHint", { fg = vs.Method, bg = "NONE" })
  hl(0, "DiagnosticUnderlineError", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vscRed })
  hl(0, "DiagnosticUnderlineWarn", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vscYellow })
  hl(0, "DiagnosticUnderlineInfo", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vsType })
  hl(0, "DiagnosticUnderlineHint", { fg = "NONE", bg = "NONE", undercurl = true, sp = c.vsType })
  hl(0, "LspReferenceText", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })
  hl(0, "LspReferenceRead", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })
  hl(0, "LspReferenceWrite", { fg = "NONE", bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue })

  -- Nvim compe
  hl(0, "CmpItemKindVariable", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "CmpItemKindInterface", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "CmpItemKindText", { fg = c.vscLightBlue, bg = "NONE" })
  hl(0, "CmpItemKindFunction", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "CmpItemKindMethod", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "CmpItemKindKeyword", { fg = c.vscFront, bg = "NONE" })
  hl(0, "CmpItemKindProperty", { fg = c.vscFront, bg = "NONE" })
  hl(0, "CmpItemKindUnit", { fg = c.vscFront, bg = "NONE" })
  hl(0, "CmpItemKindConstructor", { fg = c.vscUiOrange, bg = "NONE" })
  hl(0, "CmpItemMenu", { fg = c.vscPopupFront, bg = "NONE" })
  hl(0, "CmpItemAbbr", { fg = c.vscFront, bg = "NONE" })
  hl(0, "CmpItemAbbrDeprecated", { fg = c.vscCursorDark, bg = c.vscPopupBack, strikethrough = true })
  hl(0, "CmpItemAbbrMatch", { fg = isDark and c.vscMediumBlue or c.vscDarkBlue, bg = "NONE", bold = true })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = isDark and c.vscMediumBlue or c.vscDarkBlue, bg = "NONE", bold = true })

  -- Dashboard
  hl(0, "DashboardHeader", { fg = vs.Type, bg = "NONE" })
  hl(0, "DashboardCenter", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "DashboardCenterIcon", { fg = c.vscYellowOrange, bg = "NONE" })
  hl(0, "DashboardShortCut", { fg = vs.Preprocessor, bg = "NONE" })
  hl(0, "DashboardFooter", { fg = vs.Type, bg = "NONE", italic = true })

  if isDark then
    hl(0, "NvimTreeFolderIcon", { fg = vs.Native, bg = "NONE" })
    hl(0, "NvimTreeIndentMarker", { fg = c.vscLineNumber, bg = "NONE" })

    hl(0, "LspFloatWinNormal", { fg = c.vscFront, bg = "NONE" })
    hl(0, "LspFloatWinBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaHoverBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaSignatureHelpBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaCodeActionBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaDefPreviewBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspLinesDiagBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaRenameBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaBorderTitle", { fg = c.vscCursorDark, bg = "NONE" })
    hl(0, "LSPSagaDiagnosticTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaDiagnosticBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaDiagnosticBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaShTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaShTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaDocTruncateLine", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaRenameBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "LspSagaLspFinderBorder", { fg = c.vscLineNumber, bg = "NONE" })

    hl(0, "TelescopePromptBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "TelescopeResultsBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "TelescopePreviewBorder", { fg = c.vscLineNumber, bg = "NONE" })
    hl(0, "TelescopeNormal", { fg = c.vscFront, bg = "NONE" })
    hl(0, "TelescopeSelection", { fg = c.vscFront, bg = c.vscPopupHighlightBlue })
    hl(0, "TelescopeMultiSelection", { fg = c.vscFront, bg = c.vscPopupHighlightBlue })
    hl(0, "TelescopeMatching", { fg = c.vscMediumBlue, bg = "NONE", bold = true })
    hl(0, "TelescopePromptPrefix", { fg = c.vscFront, bg = "NONE" })

    -- symbols-outline
    -- white fg and lualine blue bg
    hl(0, "FocusedSymbol", { fg = "#ffffff", bg = c.vscUiBlue })
    hl(0, "SymbolsOutlineConnector", { fg = c.vscLineNumber, bg = "NONE" })
  else
    hl(0, "NvimTreeFolderIcon", { fg = vs.Native, bg = "NONE" })
    hl(0, "NvimTreeIndentMarker", { fg = c.vscTabOther, bg = "NONE" })

    hl(0, "LspFloatWinNormal", { fg = c.vscFront, bg = "NONE" })
    hl(0, "LspFloatWinBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaHoverBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaSignatureHelpBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaCodeActionBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaDefPreviewBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspLinesDiagBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaRenameBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaBorderTitle", { fg = c.vscCursorDark, bg = "NONE" })
    hl(0, "LSPSagaDiagnosticTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaDiagnosticBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaDiagnosticBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaShTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaShTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaDocTruncateLine", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaRenameBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "LspSagaLspFinderBorder", { fg = c.vscTabOther, bg = "NONE" })

    hl(0, "TelescopePromptBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "TelescopeResultsBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "TelescopePreviewBorder", { fg = c.vscTabOther, bg = "NONE" })
    hl(0, "TelescopeNormal", { fg = c.vscFront, bg = "NONE" })
    hl(0, "TelescopeSelection", { fg = "#FFFFFF", bg = c.vscPopupHighlightBlue })
    hl(0, "TelescopeMultiSelection", { fg = c.vscBack, bg = c.vscPopupHighlightBlue })
    hl(0, "TelescopeMatching", { fg = "orange", bg = "NONE", bold = true, nil })
    hl(0, "TelescopePromptPrefix", { fg = c.vscFront, bg = "NONE" })

    -- COC.nvim
    hl(0, "CocFloating", { fg = "NONE", bg = c.vscPopupBack })
    hl(0, "CocMenuSel", { fg = "#FFFFFF", bg = "#285EBA" })
    hl(0, "CocSearch", { fg = "#2A64B9", bg = "NONE" })

    -- Pmenu
    hl(0, "Pmenu", { fg = "NONE", bg = c.vscPopupBack })
    hl(0, "PmenuSel", { fg = "#FFFFFF", bg = "#285EBA" })

    -- symbols-outline
    -- white fg and lualine blue bg
    hl(0, "FocusedSymbol", { fg = c.vscBack, bg = "#AF00DB" })
    hl(0, "SymbolsOutlineConnector", { fg = c.vscTabOther, bg = "NONE" })
  end
end

theme.link_highlight = function()
  -- Legacy groups for official git.vim and diff.vim syntax
  hl(0, "diffAdded", { link = "DiffAdd" })
  hl(0, "diffChanged", { link = "DiffChange" })
  hl(0, "diffRemoved", { link = "DiffDelete" })
  -- Nvim compe
  hl(0, "CompeDocumentation", { link = "Pmenu" })
  hl(0, "CompeDocumentationBorder", { link = "Pmenu" })
  hl(0, "CmpItemKind", { link = "Pmenu" })
  hl(0, "CmpItemKindClass", { link = "CmpItemKindConstructor" })
  hl(0, "CmpItemKindModule", { link = "CmpItemKindKeyword" })
  hl(0, "CmpItemKindOperator", { link = "@operator" })
  hl(0, "CmpItemKindReference", { link = "@parameter.reference" })
  hl(0, "CmpItemKindValue", { link = "@field" })
  hl(0, "CmpItemKindField", { link = "@field" })
  hl(0, "CmpItemKindEnum", { link = "@field" })
  hl(0, "CmpItemKindSnippet", { link = "@text" })
  hl(0, "CmpItemKindColor", { link = "cssColor" })
  hl(0, "CmpItemKindFile", { link = "@text.uri" })
  hl(0, "CmpItemKindFolder", { link = "@text.uri" })
  hl(0, "CmpItemKindEvent", { link = "@constant" })
  hl(0, "CmpItemKindEnumMember", { link = "@field" })
  hl(0, "CmpItemKindConstant", { link = "@constant" })
  hl(0, "CmpItemKindStruct", { link = "@structure" })
  hl(0, "CmpItemKindTypeParameter", { link = "@parameter" })
end

theme.base = {
  Comment = { fg = c.comment, style = config.commentStyle }, -- any comment
  ColorColumn = { bg = c.bg_visual }, -- used for the columns set with 'colorcolumn'
  Conceal = { fg = c.fg_gutter }, -- placeholder characters substituted for concealed text (see 'conceallevel')
  Cursor = { fg = c.bg, bg = c.fg }, -- character under the cursor
  lCursor = { fg = c.bg, bg = c.fg }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
  CursorIM = { fg = c.bg, bg = c.fg }, -- like Cursor, but used when in IME mode |CursorIM|
  CursorColumn = { bg = c.bg_highlight }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
  CursorLine = { bg = c.bg_highlight }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
  Directory = { fg = c.blue }, -- directory names (and other special names in listings)
  DiffAdd = { bg = c.diff.add }, -- diff mode: Added line |diff.txt|
  DiffChange = { bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
  DiffDelete = { bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
  DiffText = { bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|
  EndOfBuffer = { fg = c.bg }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
  -- TermCursor  = { }, -- cursor in a focused terminal
  -- TermCursorNC= { }, -- cursor in an unfocused terminal
  ErrorMsg = { fg = c.error }, -- error messages on the command line
  VertSplit = { fg = c.border }, -- the column separating vertically split windows
  Folded = { fg = c.blue, bg = c.fg_gutter }, -- line used for closed folds
  FoldColumn = { bg = c.bg, fg = c.comment }, -- 'foldcolumn'
  SignColumn = { bg = config.transparent and c.none or c.bg, fg = c.fg_gutter }, -- column where |signs| are displayed
  SignColumnSB = { bg = c.bg_sidebar, fg = c.fg_gutter }, -- column where |signs| are displayed
  Substitute = { bg = c.red, fg = c.black }, -- |:substitute| replacement text highlighting
  LineNr = { fg = c.fg_gutter }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  CursorLineNr = { fg = c.dark5 }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
  MatchParen = { fg = c.orange, style = "bold" }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
  ModeMsg = { fg = c.fg_dark, style = "bold" }, -- 'showmode' message (e.g., "-- INSERT -- ")
  MsgArea = { fg = c.fg_dark }, -- Area for messages and cmdline
  -- MsgSeparator= { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
  MoreMsg = { fg = c.blue }, -- |more-prompt|
  NonText = { fg = c.dark3 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
  Normal = { fg = c.fg, bg = config.transparent and c.none or c.bg }, -- normal text
  NormalNC = { fg = c.fg, bg = config.transparent and c.none or c.bg }, -- normal text in non-current windows
  NormalSB = { fg = c.fg_sidebar, bg = c.bg_sidebar }, -- normal text in non-current windows
  NormalFloat = { fg = c.fg, bg = c.bg_float }, -- Normal text in floating windows.
  FloatBorder = { fg = c.border_highlight },
  Pmenu = { bg = c.bg_popup, fg = c.fg }, -- Popup menu: normal item.
  PmenuSel = { bg = util.darken(c.fg_gutter, 0.8) }, -- Popup menu: selected item.
  PmenuSbar = { bg = util.lighten(c.bg_popup, 0.95) }, -- Popup menu: scrollbar.
  PmenuThumb = { bg = c.fg_gutter }, -- Popup menu: Thumb of the scrollbar.
  Question = { fg = c.blue }, -- |hit-enter| prompt and yes/no questions
  QuickFixLine = { bg = c.bg_visual, style = "bold" }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
  Search = { bg = c.bg_search, fg = c.fg }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
  IncSearch = { bg = c.orange, fg = c.black }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  SpecialKey = { fg = c.dark3 }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
  SpellBad = { sp = c.error, style = "undercurl" }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
  SpellCap = { sp = c.warning, style = "undercurl" }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
  SpellLocal = { sp = c.info, style = "undercurl" }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
  SpellRare = { sp = c.hint, style = "undercurl" }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
  StatusLine = { fg = c.fg_sidebar, bg = c.bg_statusline }, -- status line of current window
  StatusLineNC = { fg = c.fg_gutter, bg = c.bg_statusline }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
  TabLine = { bg = c.bg_statusline, fg = c.fg_gutter }, -- tab pages line, not active tab page label
  TabLineFill = { bg = c.black }, -- tab pages line, where there are no labels
  TabLineSel = { fg = c.black, bg = c.blue }, -- tab pages line, active tab page label
  Title = { fg = c.blue, style = "bold" }, -- titles for output from ":set all", ":autocmd" etc.
  Visual = { bg = c.bg_visual }, -- Visual mode selection
  VisualNOS = { bg = c.bg_visual }, -- Visual mode selection when vim is "Not Owning the Selection".
  WarningMsg = { fg = c.warning }, -- warning messages
  Whitespace = { fg = c.fg_gutter }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
  WildMenu = { bg = c.bg_visual }, -- current match in 'wildmenu' completion

  -- These groups are not listed as default vim groups,
  -- but they are defacto standard group names for syntax highlighting.
  -- commented out groups should chain up to their "preferred" group by
  -- default,
  -- Uncomment and edit if you want more specific syntax highlighting.

  Constant = { fg = c.orange }, -- (preferred) any constant
  String = { fg = c.green }, --   a string constant: "this is a string"
  Character = { fg = c.green }, --  a character constant: 'c', '\n'
  -- Number        = { }, --   a number constant: 234, 0xff
  -- Boolean       = { }, --  a boolean constant: TRUE, false
  -- Float         = { }, --    a floating point constant: 2.3e10

  Identifier = { fg = c.magenta, style = config.variableStyle }, -- (preferred) any variable name
  Function = { fg = c.blue, style = config.functionStyle }, -- function name (also: methods for classes)

  Statement = { fg = c.magenta }, -- (preferred) any statement
  -- Conditional   = { }, --  if, then, else, endif, switch, etc.
  -- Repeat        = { }, --   for, do, while, etc.
  -- Label         = { }, --    case, default, etc.
  Operator = { fg = c.blue5 }, -- "sizeof", "+", "*", etc.
  Keyword = { fg = c.cyan, style = config.keywordStyle }, --  any other keyword
  -- Exception     = { }, --  try, catch, throw

  PreProc = { fg = c.cyan }, -- (preferred) generic Preprocessor
  -- Include       = { }, --  preprocessor #include
  -- Define        = { }, --   preprocessor #define
  -- Macro         = { }, --    same as Define
  -- PreCondit     = { }, --  preprocessor #if, #else, #endif, etc.

  Type = { fg = c.blue1 }, -- (preferred) int, long, char, etc.
  -- StorageClass  = { }, -- static, register, volatile, etc.
  -- Structure     = { }, --  struct, union, enum, etc.
  -- Typedef       = { }, --  A typedef

  Special = { fg = c.blue1 }, -- (preferred) any special symbol
  -- SpecialChar   = { }, --  special character in a constant
  -- Tag           = { }, --    you can use CTRL-] on this
  -- Delimiter     = { }, --  character that needs attention
  -- SpecialComment= { }, -- special things inside a comment
  -- Debug         = { }, --    debugging statements

  Underlined = { style = "underline" }, -- (preferred) text that stands out, HTML links
  Bold = { style = "bold" },
  Italic = { style = "italic" },

  -- ("Ignore", below, may be invisible...)
  -- Ignore = { }, -- (preferred) left blank, hidden  |hl-Ignore|

  Error = { fg = c.error }, -- (preferred) any erroneous construct
  Todo = { bg = c.yellow, fg = c.bg }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

  qfLineNr = { fg = c.dark5 },
  qfFileName = { fg = c.blue },

  htmlH1 = { fg = c.magenta, style = "bold" },
  htmlH2 = { fg = c.blue, style = "bold" },

  -- mkdHeading = { fg = c.orange, style = "bold" },
  -- mkdCode = { bg = c.terminal_black, fg = c.fg },
  mkdCodeDelimiter = { bg = c.terminal_black, fg = c.fg },
  mkdCodeStart = { fg = c.teal, style = "bold" },
  mkdCodeEnd = { fg = c.teal, style = "bold" },
  -- mkdLink = { fg = c.blue, style = "underline" },

  markdownHeadingDelimiter = { fg = c.orange, style = "bold" },
  markdownCode = { fg = c.teal },
  markdownCodeBlock = { fg = c.teal },
  markdownH1 = { fg = c.magenta, style = "bold" },
  markdownH2 = { fg = c.blue, style = "bold" },
  markdownLinkText = { fg = c.blue, style = "underline" },

  debugPC = { bg = c.bg_sidebar }, -- used for highlighting the current line in terminal-debug
  debugBreakpoint = { bg = util.darken(c.info, 0.1), fg = c.info }, -- used for breakpoint colors in terminal-debug

  -- These groups are for the native LSP client. Some other LSP clients may
  -- use these groups, or use their own. Consult your LSP client's
  -- documentation.
  LspReferenceText = { bg = c.fg_gutter }, -- used for highlighting "text" references
  LspReferenceRead = { bg = c.fg_gutter }, -- used for highlighting "read" references
  LspReferenceWrite = { bg = c.fg_gutter }, -- used for highlighting "write" references

  LspDiagnosticsDefaultError = { fg = c.error }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
  LspDiagnosticsDefaultWarning = { fg = c.warning }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
  LspDiagnosticsDefaultInformation = { fg = c.info }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
  LspDiagnosticsDefaultHint = { fg = c.hint }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

  LspDiagnosticsVirtualTextError = { bg = util.darken(c.error, 0.1), fg = c.error }, -- Used for "Error" diagnostic virtual text
  LspDiagnosticsVirtualTextWarning = { bg = util.darken(c.warning, 0.1), fg = c.warning }, -- Used for "Warning" diagnostic virtual text
  LspDiagnosticsVirtualTextInformation = { bg = util.darken(c.info, 0.1), fg = c.info }, -- Used for "Information" diagnostic virtual text
  LspDiagnosticsVirtualTextHint = { bg = util.darken(c.hint, 0.1), fg = c.hint }, -- Used for "Hint" diagnostic virtual text

  LspDiagnosticsUnderlineError = { style = "undercurl", sp = c.error }, -- Used to underline "Error" diagnostics
  LspDiagnosticsUnderlineWarning = { style = "undercurl", sp = c.warning }, -- Used to underline "Warning" diagnostics
  LspDiagnosticsUnderlineInformation = { style = "undercurl", sp = c.info }, -- Used to underline "Information" diagnostics
  LspDiagnosticsUnderlineHint = { style = "undercurl", sp = c.hint }, -- Used to underline "Hint" diagnostics

  -- LspDiagnosticsFloatingError         = { }, -- Used to color "Error" diagnostic messages in diagnostics float
  -- LspDiagnosticsFloatingWarning       = { }, -- Used to color "Warning" diagnostic messages in diagnostics float
  -- LspDiagnosticsFloatingInformation   = { }, -- Used to color "Information" diagnostic messages in diagnostics float
  -- LspDiagnosticsFloatingHint          = { }, -- Used to color "Hint" diagnostic messages in diagnostics float

  -- LspDiagnosticsSignError             = { }, -- Used for "Error" signs in sign column
  -- LspDiagnosticsSignWarning           = { }, -- Used for "Warning" signs in sign column
  -- LspDiagnosticsSignInformation       = { }, -- Used for "Information" signs in sign column
  -- LspDiagnosticsSignHint              = { }, -- Used for "Hint" signs in sign column
}

theme.plugins = {

  -- These groups are for the neovim tree-sitter highlights.
  -- As of writing, tree-sitter support is a WIP, group names may change.
  -- By default, most of these groups link to an appropriate Vim group,
  -- TSError -> Error for example, so you do not have to define these unless
  -- you explicitly want to support Treesitter's improved syntax awareness.

  -- TSAnnotation        = { };    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
  -- TSAttribute         = { };    -- (unstable) TODO: docs
  -- TSBoolean           = { };    -- For booleans.
  -- TSCharacter         = { };    -- For characters.
  -- TSComment           = { };    -- For comment blocks.
  TSNote = { fg = c.bg, bg = c.info },
  TSWarning = { fg = c.bg, bg = c.warning },
  TSDanger = { fg = c.bg, bg = c.error },
  TSConstructor = { fg = c.magenta }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
  -- TSConditional       = { };    -- For keywords related to conditionnals.
  -- TSConstant          = { };    -- For constants
  -- TSConstBuiltin      = { };    -- For constant that are built in the language: `nil` in Lua.
  -- TSConstMacro        = { };    -- For constants that are defined by macros: `NULL` in C.
  -- TSError             = { };    -- For syntax/parser errors.
  -- TSException         = { };    -- For exception related keywords.
  TSField = { fg = c.green1 }, -- For fields.
  -- TSFloat             = { };    -- For floats.
  -- TSFunction          = { };    -- For function (calls and definitions).
  -- TSFuncBuiltin       = { };    -- For builtin functions: `table.insert` in Lua.
  -- TSFuncMacro         = { };    -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
  -- TSInclude           = { };    -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
  TSKeyword = { fg = c.purple, style = config.keywordStyle }, -- For keywords that don't fall in previous categories.
  TSKeywordFunction = { fg = c.magenta, style = config.functionStyle }, -- For keywords used to define a fuction.
  TSLabel = { fg = c.blue }, -- For labels: `label:` in C and `:label:` in Lua.
  -- TSMethod            = { };    -- For method calls and definitions.
  -- TSNamespace         = { };    -- For identifiers referring to modules and namespaces.
  -- TSNone              = { };    -- TODO: docs
  -- TSNumber            = { };    -- For all numbers
  TSOperator = { fg = c.blue5 }, -- For any operator: `+`, but also `->` and `*` in C.
  TSParameter = { fg = c.yellow }, -- For parameters of a function.
  -- TSParameterReference= { };    -- For references to parameters of a function.
  TSProperty = { fg = c.green1 }, -- Same as `TSField`.
  TSPunctDelimiter = { fg = c.blue5 }, -- For delimiters ie: `.`
  TSPunctBracket = { fg = c.fg_dark }, -- For brackets and parens.
  TSPunctSpecial = { fg = c.blue5 }, -- For special punctutation that does not fall in the catagories before.
  -- TSRepeat            = { };    -- For keywords related to loops.
  -- TSString            = { };    -- For strings.
  TSStringRegex = { fg = c.blue6 }, -- For regexes.
  TSStringEscape = { fg = c.magenta }, -- For escape characters within a string.
  -- TSSymbol            = { };    -- For identifiers referring to symbols or atoms.
  -- TSType              = { };    -- For types.
  -- TSTypeBuiltin       = { };    -- For builtin types.
  TSVariable = { style = config.variableStyle }, -- Any variable name that does not have another highlight.
  TSVariableBuiltin = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.

  -- TSTag               = { };    -- Tags like html tag names.
  -- TSTagDelimiter      = { };    -- Tag delimiter like `<` `>` `/`
  -- TSText              = { };    -- For strings considered text in a markup language.
  TSTextReference = { fg = c.red }, -- FIXME
  -- TSEmphasis          = { };    -- For text to be represented with emphasis.
  -- TSUnderline         = { };    -- For text to be represented with an underline.
  -- TSStrike            = { };    -- For strikethrough text.
  -- TSTitle             = { };    -- Text that is part of a title.
  -- TSLiteral           = { };    -- Literal text.
  -- TSURI               = { };    -- Any URI like a link or email.

  -- Lua
  -- luaTSProperty = { fg = c.red }, -- Same as `TSField`.

  -- LspTrouble
  LspTroubleText = { fg = c.fg_dark },
  LspTroubleCount = { fg = c.magenta, bg = c.fg_gutter },
  LspTroubleNormal = { fg = c.fg_sidebar, bg = c.bg_sidebar },

  -- Illuminate
  illuminatedWord = { bg = c.fg_gutter },
  illuminatedCurWord = { bg = c.fg_gutter },

  -- diff
  diffAdded = { fg = c.git.add },
  diffRemoved = { fg = c.git.delete },
  diffChanged = { fg = c.git.change },
  diffOldFile = { fg = c.yellow },
  diffNewFile = { fg = c.orange },
  diffFile = { fg = c.blue },
  diffLine = { fg = c.comment },
  diffIndexLine = { fg = c.magenta },

  -- Neogit
  NeogitBranch = { fg = c.magenta },
  NeogitRemote = { fg = c.purple },
  NeogitHunkHeader = { bg = c.bg_highlight, fg = c.fg },
  NeogitHunkHeaderHighlight = { bg = c.fg_gutter, fg = c.blue },
  NeogitDiffContextHighlight = { bg = util.darken(c.fg_gutter, 0.5), fg = c.fg_dark },
  NeogitDiffDeleteHighlight = { fg = c.git.delete, bg = c.diff.delete },
  NeogitDiffAddHighlight = { fg = c.git.add, bg = c.diff.add },

  -- GitGutter
  GitGutterAdd = { fg = c.gitSigns.add }, -- diff mode: Added line |diff.txt|
  GitGutterChange = { fg = c.gitSigns.change }, -- diff mode: Changed line |diff.txt|
  GitGutterDelete = { fg = c.gitSigns.delete }, -- diff mode: Deleted line |diff.txt|

  -- GitSigns
  GitSignsAdd = { fg = c.gitSigns.add }, -- diff mode: Added line |diff.txt|
  GitSignsChange = { fg = c.gitSigns.change }, -- diff mode: Changed line |diff.txt|
  GitSignsDelete = { fg = c.gitSigns.delete }, -- diff mode: Deleted line |diff.txt|

  -- Telescope
  TelescopeBorder = { fg = c.border_highlight },

  -- NvimTree
  NvimTreeNormal = { fg = c.fg_sidebar, bg = c.bg_sidebar },
  NvimTreeRootFolder = { fg = c.blue, style = "bold" },
  NvimTreeGitDirty = { fg = c.git.change },
  NvimTreeGitNew = { fg = c.git.add },
  NvimTreeGitDeleted = { fg = c.git.delete },
  NvimTreeSpecialFile = { fg = c.purple, style = "underline" },
  LspDiagnosticsError = { fg = c.error },
  LspDiagnosticsWarning = { fg = c.warning },
  LspDiagnosticsInformation = { fg = c.info },
  LspDiagnosticsHint = { fg = c.hint },
  NvimTreeIndentMarker = { fg = c.fg_gutter },
  NvimTreeImageFile = { fg = c.fg_sidebar },
  NvimTreeSymlink = { fg = c.blue },
  -- NvimTreeFolderName= { fg = c.fg_float },

  -- Dashboard
  DashboardShortCut = { fg = c.cyan },
  DashboardHeader = { fg = c.blue },
  DashboardCenter = { fg = c.magenta },
  DashboardFooter = { fg = c.yellow, style = "italic" },

  -- WhichKey
  WhichKey = { fg = c.cyan },
  WhichKeyGroup = { fg = c.blue },
  WhichKeyDesc = { fg = c.magenta },
  WhichKeySeperator = { fg = c.comment },
  WhichKeySeparator = { fg = c.comment },
  WhichKeyFloat = { bg = c.bg_sidebar },
  WhichKeyValue = { fg = c.dark5 },

  -- LspSaga
  DiagnosticError = { fg = c.error },
  DiagnosticWarning = { fg = c.warning },
  DiagnosticInformation = { fg = c.info },
  DiagnosticHint = { fg = c.hint },

  -- NeoVim
  healthError = { fg = c.error },
  healthSuccess = { fg = c.green1 },
  healthWarning = { fg = c.warning },

  -- BufferLine
  BufferLineIndicatorSelected = { fg = c.git.change },
  BufferLineFill = { bg = c.black },

  -- Sneak
  Sneak = { fg = c.bg_highlight, bg = c.magenta },
  SneakScope = { bg = c.bg_visual },

  -- Hop
  -- HopNextKey = { fg = c.teal },
  -- HopNextKey1 = { fg = c.blue },
  -- HopNextKey2 = { fg = util.lighten(c.blue, .3) },
  HopUnmatched = { fg = c.dark3 },
}

return theme
