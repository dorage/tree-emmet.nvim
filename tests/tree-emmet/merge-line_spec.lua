local plugin = require("tree-emmet")

---move cursor to search position
---@param search any
local function move(search)
  -- move to text content element
  local start_row, start_col = unpack(vim.fn.searchpos(search))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
end

describe("merge line in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/merge-line.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("merge line", function()
    move("merge_target")
    local start_row, start_col = unpack(vim.api.nvim_win_get_cursor(0))

    plugin.merge_line()
    local lines = vim.api.nvim_buf_get_lines(0, start_row, start_col, false)

    assert.are_equal('<div id="merge_target">123<div><div>456</div></div>{789}</div>', lines[1])
  end)
end)
