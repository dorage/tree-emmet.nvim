--
-- modules
--

local ts_utils = require("nvim-treesitter.ts_utils")

--
-- types
--

--- @type Range: {integer, integer, integer, integer}

---
--- intrenal
---

---return the closest ancestor node which has element type from a node
--- @param node TSNode
--- @return TSNode|nil
local find_element_node = function(node)
  local cursor = node
  while true do
    if cursor:type() == "jsx_element" or cursor:type() == "jsx_self_closing_element" then
      return cursor
    end

    local parent = cursor:parent()
    if parent == nil then
      return nil
    end

    cursor = parent
  end
end

--
-- module
--

---@class CustomModule
local M = {}

---return the smallest node which has element type at the cursor position
---@return nil|TSNode
M.get_element_node = function()
  local curr_node = vim.treesitter.get_node()
  if curr_node == nil then
    return nil
  end

  -- find closest element node
  local element_node = find_element_node(curr_node)
  if element_node == nil then
    return nil
  end

  return element_node
end

---comment
---@param node TSNode
M.get_range_of_opening_element = function(element_node)
  return
end

---comment
---@param node TSNode
M.get_range_of_closing_element = function(element_node)
  return
end

---
---@return nil|Range
M.get_range_within_element = function()
  -- find closest element node
  local element_node = M.get_element_node()
  if element_node == nil or element_node:type() == "jsx_self_closing_element" then
    return nil
  end

  -- get a node for range
  if element_node:child(1):type() == "jsx_closing_element" then
    return nil
  end
  local first_child = element_node:child(1)
  local last_child = element_node:child(element_node:child_count() - 2)

  -- refer to update_selection() in vim.treesitter.ts_utils
  local start_row, start_col, _, _ = ts_utils.get_vim_range({ vim.treesitter.get_node_range(first_child) }, 0)
  local _, _, end_row, end_col = ts_utils.get_vim_range({ vim.treesitter.get_node_range(last_child) }, 0)

  return { start_row, start_col, end_row, end_col }
end

return M
