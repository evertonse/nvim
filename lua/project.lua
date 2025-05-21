--- WARNING this already exists. It's caled exerc
local function source_project()
  local project_file = vim.fn.getcwd() .. '/local.lua'
  local config_path = vim.fn.stdpath 'config'
  if project_file and vim.fn.filereadable(project_file) and vim.fn.getcwd() ~= config_path then
    vim.schedule(function()
      dofile(project_file)
    end)
  end
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = source_project,
})
