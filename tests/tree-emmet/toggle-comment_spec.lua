local str = require("tree-emmet.string")
local plugin = require("tree-emmet")

---move cursor to search position
---@param search any
local function move(search)
  -- move to text content element
  local start_row, start_col = unpack(vim.fn.searchpos(search))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
end

describe("toggle comment in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/toggle-comment.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("merge line", function()
    local reg, res

    -- on
    move("comment_target")
    plugin.toggle_comment()

    vim.cmd("normal! vi(")
    vim.cmd('normal! "ay')
    reg = vim.fn.getreg("a")

    res = table.concat(str.split(reg, "[^\r\n]+"), "")

    assert.are_equal([[<div>{/*<div id="comment_target">1234<div></div></div>*/}</div>]], res)

    -- off
    move("comment_target")
    plugin.toggle_comment()

    vim.cmd("normal! vi(")
    vim.cmd('normal! "ay')
    reg = vim.fn.getreg("a")

    res = table.concat(str.split(reg, "[^\r\n]+"))

    assert.are_equal([[<div><div id="comment_target">1234<div></div></div></div>]], res)
  end)
end)
