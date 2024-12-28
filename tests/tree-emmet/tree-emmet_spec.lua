local plugin = require("tree-emmet")

---move to search position, yank it
---@param search string
---@param action function
---@return integer|nil
---@return string
local function move_and_yank(search, action)
  -- move to text content element
  local start_row, start_col = unpack(vim.fn.searchpos(search))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })

  local res = action()
  vim.cmd('normal! "ay')
  local reg = vim.fn.getreg("a")
  return res, reg
end

describe("balance inward in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/tsx.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("returns text on an element with text content", function()
    local res, reg = move_and_yank("element_with_text_content", plugin.balance_inward)

    assert.not_nil(res)
    assert.are_equal(reg, "lorem ipsum")
  end)

  it("returns expression on an element with js expression", function()
    local res, reg = move_and_yank("element_with_js_expr", plugin.balance_inward)

    assert.not_nil(res)
    assert.are_equal(reg, "{2}")
  end)

  it("returns expression on an nested element", function()
    local res, reg = move_and_yank("element_nested", plugin.balance_inward)

    assert.not_nil(res)
    assert.are_equal(reg, "<div></div>")
  end)

  it("returns nil on an self closing element", function()
    local res = move_and_yank("element_self_closed", plugin.balance_inward)

    assert.is_nil(res)
  end)
end)

describe("balance outward in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/tsx.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("returns text on an element with text content", function()
    local res, reg = move_and_yank("element_with_text_content", plugin.balance_outward)

    assert.not_nil(res)
    assert.are_equal(reg, '<div id="element_with_text_content">lorem ipsum</div>')
  end)

  it("returns expression on an element with js expression", function()
    local res, reg = move_and_yank("element_with_js_expr", plugin.balance_outward)

    assert.not_nil(res)
    assert.are_equal(reg, '<div id="element_with_js_expr">{2}</div>')
  end)

  it("returns expression on an nested element", function()
    local res, reg = move_and_yank("element_nested", plugin.balance_outward)

    assert.not_nil(res)
    assert.are_equal(
      reg,
      [[<div id="element_nested">
        <div></div>
      </div>]]
    )
  end)

  it("returns nil on an self closing element", function()
    local res, reg = move_and_yank("element_self_closed", plugin.balance_outward)

    assert.not_nil(res)
    assert.are_equal(reg, '<div id="element_self_closed" />')
  end)
end)
