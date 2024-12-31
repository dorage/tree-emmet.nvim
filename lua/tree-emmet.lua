local str = require("tree-emmet.string")

-- main module file
local module = require("tree-emmet.module")

---@class Config
---@field opt string Your config option
local config = {}

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

-- Balance
-- https://docs.emmet.io/actions/match-pair/

M.balance_inward = function()
  local range = module.get_range_within_element()
  if range == nil then
    return nil
  end
  local start_row, start_col, end_row, end_col = unpack(range)

  -- select range of node
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { start_row, start_col - 1 })
  vim.cmd("normal! o")
  vim.api.nvim_win_set_cursor(0, { end_row, end_col - 1 })

  return start_row, start_col, end_row, end_col
end

M.balance_outward = function()
  local element_node = module.get_element_node()
  if element_node == nil then
    return nil
  end

  local start_row, start_col, end_row, end_col = element_node:range()

  require("nvim-treesitter.ts_utils").update_selection(0, element_node)
  return start_row, start_col, end_row, end_col
end

-- Go to Matching Pair
-- https://docs.emmet.io/actions/go-to-pair/

M.go_to_matching_pair = function()
  local element_node = module.get_element_node()
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
  else
    return nil
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

-- Toggle Comment
-- https://docs.emmet.io/actions/toggle-comment/

M.toggle_comment = function()
  local element_node = module.get_element_node()
  if element_node == nil then
    return
  end

  -- TODO:
  -- 코메트 블럭의 코멘트를 해제
  -- 코멘트 블럭 내부를 파싱해서 element인지 확인하고 맞다면 해제
  -- local parser = vim.treesitter.get_parser()
  -- parser.parse()

  local start_row, start_col, end_row, end_col = element_node:range()

  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

  -- opening comment block
  lines[1] = string.sub(lines[1], 0, start_col) .. "{/*" .. string.sub(lines[1], start_col + 1)
  -- closing comment block
  lines[#lines] = string.sub(lines[#lines], 0, end_col + 1) .. "*/}" .. string.sub(lines[#lines], end_col + 1)

  vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, lines)
end

-- Split/Join Tag
-- https://docs.emmet.io/actions/split-join-tag/
--

M.split_join_tag = function()
  local element_node = module.get_element_node()
  if element_node == nil then
    return
  end

  -- split
  if element_node:type() == "jsx_self_closing_element" then
    local tagname = module.get_identifier(element_node)
    local start_row, _, end_row, end_col = element_node:range()
    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
    lines[#lines] = string.sub(lines[#lines], 0, end_col - 2):gsub("%s+$", "")
      .. "></"
      .. tagname
      .. ">"
      .. string.sub(lines[#lines], end_col + 1)

    vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, lines)
  -- join
  elseif element_node:type() == "jsx_element" then
    local start_row, _, end_row, end_col = element_node:range()
    local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

    -- opening element range
    local opening_element = module.get_opening_element(element_node)
    if opening_element == nil then
      return nil
    end

    local _, _, opening_end_row, opening_end_col = opening_element:range()

    local delete_start_row = opening_end_row - start_row + 1
    lines = str.remove_ranges(lines, {
      {
        delete_start_row,
        opening_end_col + 1,
        delete_start_row + (end_row - opening_end_row),
        end_col,
      },
    })

    lines[#lines] = lines[#lines]:sub(0, opening_end_col - 1) .. " />" .. lines[#lines]:sub(opening_end_col + 1)
    vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, lines)
  end
end

-- https://docs.emmet.io/actions/remove-tag/
M.remove_tag = function()
  local element_node = module.get_element_node()
  if element_node == nil then
    return
  end

  local start_row, start_col, end_row, end_col = element_node:range()
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

  -- self closing element
  if element_node:type() == "jsx_self_closing_element" then
    str.remove_ranges(lines, { { 1, start_col + 1, end_row - start_row + 1, end_col } })
    return
  end

  local opening_start_row, opening_start_col, opening_end_row, opening_end_col =
    module.get_opening_element(element_node):range()
  local closing_start_row, closing_start_col, closing_end_row, closing_end_col =
    module.get_closing_element(element_node):range()

  lines = str.remove_ranges(lines, {
    {
      opening_start_row - start_row + 1,
      opening_start_col + 1,
      (opening_start_row - start_row + 1) + (opening_end_row - start_row),
      opening_end_col,
    },
    {
      closing_start_row - start_row + 1,
      closing_start_col + 1,
      (closing_start_row - start_row + 1) + (closing_end_row - start_row),
      closing_end_col,
    },
  })

  vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, lines)
end

-- Merge Lines
-- https://docs.emmet.io/actions/merge-lines/

M.merge_line = function()
  local element_node = module.get_element_node()
  if element_node == nil then
    return
  end
  local start_row, start_col, end_row, end_col = element_node:range()

  if start_row == end_row then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
  table.foreach(lines, function(key, value)
    lines[key] = str.trim(value)
  end)
  local new_line = table.concat(lines, "")
  vim.api.nvim_buf_set_lines(0, start_row + 1, end_row + 1, false, { new_line })
end

-- https://docs.emmet.io/actions/update-image-size/
M.update_image_size = function() end

-- https://docs.emmet.io/actions/evaluate-math/
M.evaluate_math = function() end

--https://docs.emmet.io/actions/base64/
M.encode_image = function() end
M.decode_image = function() end

return M
