local M = {}

---
---@param s string
---@return string
M.trim = function(s)
  return s:match("^%s*(.-)%s*$")
end

---split text by pattern
---@param text string
---@param pattern string
---@return string[]
M.split = function(text, pattern)
  local lines = {}
  for s in text:gmatch(pattern) do
    table.insert(lines, M.trim(s))
  end
  return lines
end

---remove texts in the range
---@param lines string[]
---@param ranges number[][]
---@return string[]
M.remove_ranges = function(lines, ranges)
  ---@type string[][]
  local results = vim
    .iter(lines)
    :map(function(line)
      local chars = {}
      for i = 1, string.len(line) do
        table.insert(chars, i, string.sub(line, i, i))
      end
      return chars
    end)
    :totable()

  for _, range in ipairs(ranges) do
    local start_row, start_col, end_row, end_col = unpack(range)

    for curr_row, line in ipairs(results) do
      for curr_col = 1, #line do
        ---@type string
        local curr_char = line[curr_col]
        local char = curr_char

        if curr_row == start_row then
          if curr_col >= start_col then
            char = ""
          end
        end

        if curr_row == end_row then
          if curr_col <= end_col then
            char = ""
          end
        end

        if curr_row == start_row and curr_row == end_row then
          if curr_col < start_col or curr_col > end_col then
            char = curr_char
          end
        end

        if curr_row > start_row and curr_row < end_row then
          char = ""
        end

        results[curr_row][curr_col] = char
      end
    end
  end

  ---@type string[]
  local new_lines = {}

  for curr_row, line in ipairs(results) do
    local new_line = table.concat(line, "")
    if M.trim(new_line) == "" then
      new_lines[curr_row] = nil
    else
      new_lines[curr_row] = new_line
    end
  end

  return new_lines
end

return M
