---return root of AST
---@return TSNode
local function get_curr_bufr_root()
  local parser = vim.treesitter.get_parser()
  local tree = parser:parse()
  local root = tree[1]:root()

  return root
end

---@class CustomModule
local M = {}

---@return string
M.my_first_function = function(greeting)
  return greeting
end

return M
