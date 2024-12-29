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

return M
