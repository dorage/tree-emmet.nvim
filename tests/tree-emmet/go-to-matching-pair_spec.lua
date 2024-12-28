local plugin = require("tree-emmet")

---move cursor to search position
---@param search any
local function move(search)
  -- move to text content element
  local start_row, start_col = unpack(vim.fn.searchpos(search))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
end

describe("go to matching pair in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/matching-pair.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("moves to the matching pair on an blank element", function()
    move("element_blank")
    local row, col

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 11)
    assert.are_equal(col, 31)

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 11)
    assert.are_equal(col, 7)
  end)
  it("moves to the matching pair on an element with text content", function()
    move("element_with_text_content")
    local row, col

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 12)
    assert.are_equal(col, 54)

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 12)
    assert.are_equal(col, 7)
  end)

  it("moves to the matching pair on self closing element", function()
    move("element_self_closed")

    local cursor = plugin.go_to_matching_pair()
    assert.is_nil(cursor)
  end)

  it("moves to the matching pair on an element containing an element", function()
    move("element_nested")
    local row, col

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 16)
    assert.are_equal(col, 7)

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 14)
    assert.are_equal(col, 7)
  end)

  it("moves to the matching pair on an element containing multiple elements", function()
    move("element_nested_multiple")
    local row, col

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 22)
    assert.are_equal(col, 7)

    plugin.go_to_matching_pair()
    row, col = unpack(vim.api.nvim_win_get_cursor(0))

    assert.are_equal(row, 17)
    assert.are_equal(col, 7)
  end)
end)
