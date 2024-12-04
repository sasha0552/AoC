-- variables
local grid = {}
local result = 0

-- read file
for line in io.lines("input.txt") do
  local col = {}

  for char in line:gmatch(".") do
    table.insert(col, char)
  end

  table.insert(grid, col)
end

-- safe get val
function sgv(grid, row, col)
  if row < 1 or row > #grid or col < 1 or col > #grid[row] then
    return nil
  end

  return grid[row][col]
end

-- calculate
for row = 1, #grid do
  for col = 1, #grid[1] do
    if grid[row][col] == "A" then
      local tl = sgv(grid, row - 1, col - 1) -- top left
      local br = sgv(grid, row + 1, col + 1) -- bottom right
      local tr = sgv(grid, row - 1, col + 1) -- top right
      local bl = sgv(grid, row + 1, col - 1) -- bottom left

      if ((tl == "M" and br == "S") or (tl == "S" and br == "M")) and
         ((tr == "M" and bl == "S") or (tr == "S" and bl == "M")) then
        result = result + 1
      end
    end
  end
end

-- print result
print(result)
