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
--- @return TSNode?
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
---@return TSNode?
M.get_element_node = function()
  local curr_node = vim.treesitter.get_node()
  if curr_node == nil then
    print("the cursor is not hovering any element node")
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
---@param element_node TSNode
---@return TSNode?
M.get_opening_element = function(element_node)
  if element_node:type() == "jsx_self_closing_element" then
    print("it is self closing element")
    return
  end

  for i = 0, element_node:child_count() do
    if element_node:child(i):type() == "jsx_opening_element" then
      return element_node:child(i)
    end
  end

  return nil
end

---comment
---@param element_node TSNode
---@return TSNode?
M.get_closing_element = function(element_node)
  if element_node:type() == "jsx_self_closing_element" then
    print("it is self closing element")
    return
  end

  for i = 0, element_node:child_count() do
    if element_node:child(i):type() == "jsx_closing_element" then
      return element_node:child(i)
    end
  end

  return nil
end

---comment
---@param element_node TSNode
---@return string?
M.get_identifier = function(element_node)
  local opening_element = M.get_opening_element(element_node)

  -- if it is self closing element
  if element_node:type() == "jsx_self_closing_element" then
    opening_element = element_node
  end

  if opening_element == nil then
    print("cannot find opening element node or self closing element node")
    return nil
  end

  local identifier_node = opening_element:child(1):child(1)

  if identifier_node == nil then
    print("cannot find identifier node")
    return nil
  end

  local start_row, start_col, end_row, end_col = identifier_node:range()
  local line = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)[1]
  local tagname = string.sub(line, start_col, end_col + 1)
  return tagname
end

---
---@return Range?
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
