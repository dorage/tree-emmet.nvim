local M = {}

M.trim = function(s)
  return s:match("^%s*(.-)%s*$")
end

return M
