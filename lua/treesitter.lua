-- Taken from here: https://github.com/nvim-treesitter/nvim-treesitter-refactor/blob/d8b74fa87afc6a1e97b18da23e762efb032dc270/lua/nvim-treesitter-refactor/navigation.lua#L20
local ts_utils = require 'nvim-treesitter.ts_utils'
local locals = require 'nvim-treesitter.locals'
local configs = require 'nvim-treesitter.configs'
local api = vim.api

local get_node_text = vim.treesitter.get_node_text or vim.treesitter.query.get_node_text

if vim.g.self and vim.g.self.treesitter_registrations then
  for lang, fts in pairs(vim.g.self.treesitter_registrations) do
    assert(lang ~= nil and fts ~= nil)
    -- print(vim.inspect { lang, fts })
    vim.treesitter.language.register(lang, fts)
  end
else
  vim.notify 'Missing vim.g.self.treesitter_registrations'
end

local M = {}

M.goto_definition = function(bufnr, fallback_function)
  local bufnr = bufnr or api.nvim_get_current_buf()
  local node_at_point = ts_utils.get_node_at_cursor()

  if not node_at_point then
    return
  end

  local definition = locals.find_definition(node_at_point, bufnr)

  if fallback_function and definition == node_at_point then
    fallback_function()
  else
    ts_utils.goto_node(definition)
  end
end

M.goto_definition_lsp_fallback = function(bufnr)
  M.goto_definition(bufnr, vim.lsp.buf.definition)
end

--- Get definitions of bufnr (unique and sorted by order of appearance).
local function get_definitions(bufnr)
  local local_nodes = locals.get_locals(bufnr)

  -- Make sure the nodes are unique.
  local nodes_set = {}
  for _, loc in ipairs(local_nodes) do
    if loc.definition then
      locals.recurse_local_nodes(loc.definition, function(_, node, _, match)
        -- lua doesn't compare tables by value,
        -- use the value from byte count instead.
        local _, _, start = node:start()
        nodes_set[start] = { node = node, type = match or '' }
      end)
    end
  end

  -- Sort by order of appearance.
  local definition_nodes = vim.tbl_values(nodes_set)
  table.sort(definition_nodes, function(a, b)
    local _, _, start_a = a.node:start()
    local _, _, start_b = b.node:start()
    return start_a < start_b
  end)

  return definition_nodes
end

M.list_definitions = function(bufnr)
  local bufnr = bufnr or api.nvim_get_current_buf()
  local definitions = get_definitions(bufnr)

  if #definitions < 1 then
    return
  end

  local qf_list = {}

  for _, node in ipairs(definitions) do
    local lnum, col, _ = node.node:start()
    local type = string.upper(node.type:sub(1, 1))
    local text = get_node_text(node.node, bufnr) or ''
    table.insert(qf_list, {
      bufnr = bufnr,
      lnum = lnum + 1,
      col = col + 1,
      text = text,
      type = type,
    })
  end

  vim.fn.setqflist(qf_list, 'r')
  api.nvim_command 'copen'
end
