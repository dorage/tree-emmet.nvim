-- main module file
local module = require("tree-emmet.module")

---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.expand_abbreviation = function() end

--- find element node
--- @param node TSNode
--- @return TSNode|nil
local function find_element_node(node)
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

-- Balance
-- https://docs.emmet.io/actions/match-pair/
--
-- find closest element node
-- if, there is an element node among the parent nodes
-- elseif, there is an element node starting from the next sibling of the child node of root node that contains the element node
-- else, not found, print 'cannot find element node'
--
-- get a node for range
-- if inward,
--  if, the node is self closing tag, return nil
--  else, return 2nd child of the element node
-- elseif outward,
--	return the element node
--
-- select range of node
M.balance_inward = function()
  local curr_node = vim.treesitter.get_node()
  if curr_node == nil then
    return nil
  end

  -- find closest element node
  local element_node = find_element_node(curr_node)
  if element_node == nil or element_node:type() == "jsx_self_closing_element" then
    return nil
  end

  -- get a node for range
  local element_inward_node = element_node:child(1)
  if
    element_inward_node == nil
    or element_inward_node:type() == "jsx_openeing_element"
    or element_inward_node:type() == "jsx_closing_element"
  then
    return nil
  end

  -- select range of node
  local start_row, start_col, end_row, end_col = element_inward_node:range(false)
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
  return start_row, start_col, end_row, end_col
end
M.balance_outward = function()
  local curr_node = vim.treesitter.get_node()
  if curr_node == nil then
    return nil
  end

  -- find closest element node
  local element_node = find_element_node(curr_node)
  if element_node == nil then
    return nil
  end

  -- select range of node
  local start_row, start_col, end_row, end_col = element_node:range(false)
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })
  return start_row, start_col, end_row, end_col
end

-- Go to Matching Pair
-- https://docs.emmet.io/actions/go-to-pair/
--
-- find closest element node
-- if, there is an element node among the parent nodes
-- else, return ull

-- get opening tag node(1st), closing tag node(3rd)
-- find out which node the current cursor is on

-- move cursor to the matching pair
M.go_to_matching_pair = function()
  local curr_node = vim.treesitter.get_node()
  if curr_node == nil then
    return nil
  end

  local element_node = find_element_node(curr_node)
  if element_node == nil then
    return nil
  end
  if element_node:type() == "jsx_self_closing_element" then
    return nil
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local opening_start_row, opening_start_col, opening_end_row, opening_end_col = element_node:child(0):range()
  local closing_start_row, closing_start_col, closing_end_row, closing_end_col =
    element_node:child(element_node:child_count() - 1):range()

  if -- if the cursor was on the opening tag
    row >= opening_start_row + 1
    and row <= opening_end_row + 1
    and col >= opening_start_col
    and col <= opening_end_col - 1
  then
    vim.api.nvim_win_set_cursor(0, { closing_start_row + 1, closing_start_col + 1 })
  elseif -- elseif cursor was on the closing tag
    row >= closing_start_row + 1
    and row <= closing_end_row + 1
    and col >= closing_start_col
    and col <= closing_end_col - 1
  then
    vim.api.nvim_win_set_cursor(0, { opening_start_row + 1, opening_start_col + 1 })
  end

  return vim.api.nvim_win_get_cursor(0)
end

-- Wrap with abbreviation
M.wrap_with_abbreviation = function() end

-- https://docs.emmet.io/actions/go-to-edit-point/
M.go_to_edit_point = function()
  -- between tags
  -- empty attributes
  -- newlines with indentation
end

-- https://docs.emmet.io/actions/select-item/
M.select_item = function() end

-- https://docs.emmet.io/actions/toggle-comment/
M.toggle_comment = function() end

-- https://docs.emmet.io/actions/split-join-tag/
M.split_tag = function() end
M.join_tag = function() end

-- https://docs.emmet.io/actions/remove-tag/
M.remove_tag = function() end

-- https://docs.emmet.io/actions/merge-lines/
M.merge_line = function() end

-- https://docs.emmet.io/actions/update-image-size/
M.update_image_size = function() end

-- https://docs.emmet.io/actions/evaluate-math/
M.evaluate_math = function() end

--https://docs.emmet.io/actions/base64/
M.encode_image = function() end
M.decode_image = function() end

return M
