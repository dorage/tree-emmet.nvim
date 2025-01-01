local M = {}

---@class LangauageOptions
---@field is_element_node fun(): boolean
---@field is_opening_element_node fun(element_node: TSNode): boolean
---@field is_closing_element_node fun(element_node: TSNode): boolean
---@field get_identifier fun(element_node: TSNode): string

---comment
---@param opts LangauageOptions
---@return LangauageOptions
M.create_lang = function(opts)
  return opts
end

return M
