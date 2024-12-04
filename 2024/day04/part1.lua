-- variables
local grid = {}
local word = "XMAS"
local result = 0

-- read file
for line in io.lines("input.txt") do
  local col = {}

  for char in line:gmatch(".") do
    table.insert(col, char)
  end

  table.insert(grid, col)
end

-- calculate
for row = 1, #grid do
  for col = 1, #grid[1] do
    for idx, dir in ipairs({{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {-1, 1}, {1, -1}, {1, 1}}) do
      local dr, dc = dir[1], dir[2]
      local found = true

      for i = 0, #word - 1 do
        local nr, nc = row + i * dr, col + i * dc

        if nr < 1 or nr > #grid or nc < 1 or nc > #grid[1] or grid[nr][nc] ~= word:sub(i + 1, i + 1) then
          found = false
          break
        end
      end

      if found then
        result = result + 1
      end
    end
  end
end

-- print result
print(result)
