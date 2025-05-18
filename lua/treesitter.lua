if vim.g.self and vim.g.self.treesitter_registrations then
  for lang, fts in pairs(vim.g.self.treesitter_registrations) do
    assert(lang ~= nil and fts ~= nil)
    -- print(vim.inspect { lang, fts })
    vim.treesitter.language.register(lang, fts)
  end
else
  vim.notify 'Missing vim.g.self.treesitter_registrations'
end
