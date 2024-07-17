return {
  'rmagatti/alternate-toggler', --NOTE: Maybe instead of alternater we want CYCLER
  lazy = false,
  event = 'BufReadPost',
  config = function()
    local cycles = {
      { '==', '!=' },
      { 'and', 'or' },
      { 'true', 'false' },
      { 'if', 'else', 'elseif' },
      { '1', '2', '3' },
    }

    local alternates = {}

    for _, cycle in ipairs(cycles) do
      for i = 1, #cycle - 1, 1 do
        alternates[cycle[i]] = cycle[i + 1]
      end
      alternates[cycle[#cycle]] = cycle[1]
    end

    require('alternate-toggler').setup {
      alternates = alternates,
    }

    vim.keymap.set(
      'n',
      '<C-x>', -- <space><space>
      function()
        require('alternate-toggler').toggleAlternate()
      end
    )
  end,
}
