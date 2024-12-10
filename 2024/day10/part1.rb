$grid = []
$visited_global = []
$score = 0

##### ##### ##### ##### #####

File.open("input.txt", "r") do |file|
  file.each_line do |line|
    $grid << line.chomp.chars.map(&:to_i)
  end
end

##### ##### ##### ##### #####

$max_x = $grid[0].size
$max_y = $grid.size

##### ##### ##### ##### #####

def visit(x, y, num, visited)
  return if x < 0 || x >= $max_x || y < 0 || y >= $max_y
  return if visited.include?([x, y])
  return if $grid[y][x] != num

  visited << [x, y]

  if num == 9
    $score += 1
  end

  visit(x + 1, y, num + 1, visited)
  visit(x - 1, y, num + 1, visited)
  visit(x, y + 1, num + 1, visited)
  visit(x, y - 1, num + 1, visited)
end

##### ##### ##### ##### #####

$max_x.times do |x|
  $max_y.times do |y|
    if $grid[y][x] == 0 && !$visited_global.include?([x, y])
      visited = []

      #####

      visit(x, y, 0, visited)

      #####

      $visited_global.concat(visited)
    end
  end
end

puts $score
