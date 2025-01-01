local M = {}

---@class LangauageOptions
---@field is_element_node fun(): boolean
---@field is_opening_element_node fun(element_node: TSNode): boolean
---@field is_closing_element_node fun(element_node: TSNode): boolean
---@return LangauageOptions
M.create_lang = function(opts)
  return opts
end

return M
