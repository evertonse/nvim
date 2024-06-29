local M = {}

M.code =  {
  None              = "NONE",
  Debug             = "#FF00FF",
  DeadCode          = "#878787",
  Comment           = "#7a9f79",
  Args              = "#a08080",
  Parameter         = "#a08080",
  Type              = "#6E92B8", -- Darker pastel blue
  EnumType          = "#6E92B8", -- Darker pastel blue
  Construtor        = "#6E92B8", -- Darker pastel blue
  BuiltInType       = "#5E82A8",
  ConstrutorOnClass = "#5A7393", -- Slightly darker pastel blue

  -- Type              = "#569CD6", -- Pastel blue
  -- EnumType          = "#569CD6", -- Pastel blue
  -- ConstrutorOnClass = "#7D97AD", -- Slightly darker pastel blue
  -- Construtor        = "#569CD6", -- Pastel blue

  -- Type              = , -- Warm pastel orange
  -- EnumType          = "#E9BBB5", -- Warm pastel pink
  -- Construtor        = "#F09683", -- Warm pastel orange
  -- ConstrutorOnClass = "#C3B783", -- Warm pastel yellow

  Namespace         = "#FFEDC0", -- Warm pastel yellow
  Global            = "#FFDBB5", -- Warm pastel orange
  FileScope         = "#E2E2E2", -- Light gray
  Property          = "#C0C0C0", -- Silver
  SelfParameter     = "#D5D5FF", -- Pastel lavender
  Numeric           = "#D7ECC8", -- Pastel green
  Invalid           = "#F47E7E", -- Pastel red
  MacroFunction     = "#D5D5FF", -- Pastel lavender
  Macro             = "#D0C2FF", -- Pastel purple
  Normal            = "#E2E2E2", -- Light gray
  Preprocessor      = "#ABABAB", -- Gray
  Unnecessary       = "#B7B7B7", -- Light gray
  -- Keyword           = "#FFB366", -- Pastel orange
  -- Keyword           = "#569CD6", -- Pastel orange
  -- Keyword           = "#F09683", -- Pastel orange
  Keyword           = "#E08673", -- Pastel orange
  VariableLocal     = "#B5D4FF", -- Pastel blue
  Variable          = "#B5D4FF", -- Pastel blue
  VariableBuiltin   = "#92B8E0", -- Light pastel blue
  ControlFlow       = "#FFA1A1", -- Pastel pink
  Label             = "#FFA1A1", -- Pastel pink
  Method            = "#FFEDC0", -- Warm pastel yellow
  Function          = '#FFEDC0', -- Warm pastel yellow
  FunctionCall      = '#FFEDC0', -- Warm pastel yellow
  Native            = "#FFDCA1", -- Pastel orange
  Special           = "#FFDCA1", -- Pastel orange
  Constant          = "#D7ECC8", -- Pastel green
  EnumConstant      = "#D7ECC8", -- Pastel green
  BuiltInConstant   = "#D7ECC8", -- Pastel green
}

M.text = {
  Background        = "NONE",
  DiffAdd           = "#81b88b",
  Title             = "#90A0A0",
  DiffDelete        = "#f44747",
}

M.editor = {
  None           = "NONE",
  Folder         = "#90A0A0",
  Front          = "#D4D4D4",
  Back           = "#1E1E1E",

  TabCurrent  = "#1E1E1E",
  TabOther    = "#2D2D2D",
  TabOutside  = "#252526",

  LeftDark        = "#252526",
  LeftMid         = "#373737",
  LeftLight       = "#636369",

  PopupFront = "#BBBBBB",
  PopupBack = "#272727",
  PopupHighlightBlue = "#004b72",
  PopupHighlightGray = "#343B41",

  SplitLight = "#898989",
  SplitDark = "#444444",
  SplitThumb = "#424242",

  CursorDarkDark = "#222222",
  CursorDark = "#51504F",
  CursorLight = "#AEAFAD",
  Selection = "#264F78",
  LineNumber = "#5A5A5A",

  DiffRedDark = "#4B1818",
  DiffRedLight = "#6F1313",
  DiffRedLightLight = "#FB0101",
  DiffGreenDark = "#373D29",
  DiffGreenLight = "#4B5632",
  SearchCurrent = "#515c6a",
  Search = "#613315",

  GitAdded = "#81b88b",
  GitModified = "#e2c08d",
  GitDeleted = "#c74e39",
  GitRenamed = "#73c991",
  GitUntracked = "#73c991",
  GitIgnored = "#8c8c8c",
  GitStageModified = "#e2c08d",
  GitStageDeleted = "#c74e39",
  GitConflicting = "#e4676b",
  GitSubmodule = "#8db9e2",

  Context = "#404040",
  ContextCurrent = "#707070",

  FoldBackground = "#202d39",

  -- Syntax colors
  Gray = "#808080",
  Violet = "#646695",
  Blue = "#569CD6",
  DarkBlue = "#223E55",
  MediumBlue = "#18a2fe",
  LightBlue = "#9CDCFE",
  Green = "#6A9955",
  BlueGreen = "#4EC9B0",
  LightGreen = "#B5CEA8",
  Red = "#F44747",
  Orange = "#CE9178",
  LightRed = "#D16969",
  YellowOrange = "#D7BA7D",
  Yellow = "#DCDCAA",
  Pink = "#C586C0",
}

return M

