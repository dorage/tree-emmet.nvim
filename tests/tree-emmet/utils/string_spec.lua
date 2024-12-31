local plugin = require("tree-emmet")
local str = require("tree-emmet.string")

local source = { "lorem", "ipsum", "yayho" }

describe("remove_range", function()
  it("should remove range", function()
    local result = str.remove_ranges(source, { { 1, 1, 1, 3 }, { 2, 2, 2, 3 }, { 3, 4, 3, 5 } })
    assert.are_equal({ "em", "ium", "yay" }, result)
  end)
  it("should remove range", function()
    local result = str.remove_ranges(source, { { 1, 4, 3, 2 } })
    assert.are_equal({ "lor", "", "yho" }, result)
  end)
  it("should remove range", function()
    local result = str.remove_ranges(source, { { 1, 1, 1, 3 }, { 3, 3, 3, 5 } })
    assert.are_equal({ "em", "ipsum", "ya" }, result)
  end)
end)
