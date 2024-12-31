local str = require("tree-emmet.string")
local plugin = require("tree-emmet")

---move cursor to search position
---@param search any
local function move(search)
  -- move to text content element
  local start_row, start_col = unpack(vim.fn.searchpos(search))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
end

describe("split join tag in tsx", function()
  before_each(function()
    vim.cmd("edit tests/sources/split-join-tag.tsx")
  end)

  after_each(function()
    -- undo to very first state
    vim.cmd("u0")
    -- close current buffer
    vim.cmd("bd")
  end)

  it("must split self closed element", function()
    -- split
    move("element_self_closed")
    plugin.split_join_tag()

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local expected_join = str.split(
      [[const A = { B: () => <div></div> };
export const Element = () => {
  return (
    <div>
      <A.B id="element_splitted"></A.B>
      <A.B
        id="element_splitted_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      ></A.B>
      <A.B id="element_self_closed"></A.B>
      <A.B
        id="element_self_closed_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      />
    </div>
  );
};]],
      "[^\n]+"
    )

    for i = 1, #lines, 1 do
      assert.are_equal(str.trim(expected_join[i]), str.trim(lines[i]))
    end
  end)

  it("must split multiline self closed element", function()
    -- split
    move("element_self_closed_multiline")
    plugin.split_join_tag()

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local expected_join = str.split(
      [[const A = { B: () => <div></div> };
export const Element = () => {
  return (
    <div>
      <A.B id="element_splitted"></A.B>
      <A.B
        id="element_splitted_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      ></A.B>
      <A.B id="element_self_closed" />
      <A.B
        id="element_self_closed_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      ></A.B>
    </div>
  );
};]],
      "[^\n]+"
    )

    for i = 1, #lines, 1 do
      assert.are_equal(str.trim(expected_join[i]), str.trim(lines[i]))
    end
  end)

  it("must join splitted element", function()
    -- split
    move("element_splitted")
    plugin.split_join_tag()

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local expected_join = str.split(
      [[const A = { B: () => <div></div> };
export const Element = () => {
  return (
    <div>
      <A.B id="element_splitted" />
      <A.B
        id="element_splitted_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      ></A.B>
      <A.B id="element_self_closed" />
      <A.B
        id="element_self_closed_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      />
    </div>
  );
};]],
      "[^\n]+"
    )

    for i = 1, #lines, 1 do
      assert.are_equal(str.trim(expected_join[i]), str.trim(lines[i]))
    end
  end)

  it("must join multiline splitted element", function()
    -- split
    move("element_splitted_multiline")
    plugin.split_join_tag()

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local expected_join = str.split(
      [[const A = { B: () => <div></div> };
export const Element = () => {
  return (
    <div>
      <A.B id="element_splitted"></A.B>
      <A.B
        id="element_splitted_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      />
      <A.B id="element_self_closed" />
      <A.B
        id="element_self_closed_multiline"
        onClick={() => {}}
        className="test asdfasdjfhasdlkjh"
      />
    </div>
  );
};]],
      "[^\n]+"
    )
    print(vim.inspect(lines))

    for i = 1, #lines, 1 do
      assert.are_equal(str.trim(expected_join[i]), str.trim(lines[i]))
    end
  end)
end)
