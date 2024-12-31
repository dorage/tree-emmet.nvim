local plugin = require("tree-emmet")
local str = require("tree-emmet.string")

---move cursor to search position
---@param search any
local function move(search)
  -- move to text content element
  local start_row, start_col = unpack(vim.fn.searchpos(search))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
end

describe("remove tag in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/remove-tag_spec.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("must remove multiline tag", function()
    move("multiline")

    plugin.remove_tag()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local expected = str.split(
      [[export const Element = () => {
  return (
    <>
        abc
        {123}
        <div></div>
      <div id="singline">abc</div>
    </>
  );
};]],
      "[^\n]+"
    )

    for i = 1, #lines, 1 do
      assert.are_equal(str.trim(expected[i]), str.trim(lines[i]))
    end
  end)

  it("must remove tag", function()
    move("singline")

    plugin.remove_tag()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local expected = str.split(
      [[export const Element = () => {
  return (
    <>
      <div
        id="multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjhasdhfjkasdhfjk"
      >
        abc
        {123}
        <div></div>
      </div>
      abc
    </>
  );
};]],
      "[^\n]+"
    )

    for i = 1, #lines, 1 do
      assert.are_equal(str.trim(expected[i]), str.trim(lines[i]))
    end
  end)
end)
