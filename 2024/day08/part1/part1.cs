using System.Text;

///// ///// ///// ///// /////

static void PrintGrid(List<List<char>> grid) {
  foreach (var row in grid) {
    foreach (var col in row) {
      Console.Write(col);
    }

    Console.WriteLine();
  }
}

static void PrintAntennas(Dictionary<char, List<(int x, int y)>> antennas) {
  foreach (var item in antennas) {
    Console.Write($"{item.Key}: [");

    foreach (var antenna in item.Value) {
      Console.Write($"({antenna.x}, {antenna.y})");
    }

    Console.WriteLine("]");
  }
}

///// ///// ///// ///// /////

var grid = new List<List<char>>();
var mGrid = new List<List<char>>();
var antennas = new Dictionary<char, List<(int x, int y)>>();
var antinodes = new HashSet<(int x, int y)>();

{ // read file
  using (var file = File.OpenRead("../input.txt")) {
    using (var reader = new StreamReader(file, Encoding.UTF8)) {
      String? line;

      while ((line = reader.ReadLine()) != null) {
        grid.Add(line.ToCharArray().ToList());
        mGrid.Add(line.ToCharArray().ToList());
      }
    }
  }
}

//PrintGrid(grid);

{ // parse antennas
  for (var i = 0; i < grid.Count; i++) {
    var row = grid[i];

    for (var j = 0; j < row.Count; j++) {
      var col = row[j];

       if (col != '.') {
        if (!antennas.ContainsKey(col)) { 
          antennas[col] = new List<(int x, int y)>();
        }

        antennas[col].Add((i, j));
      }
    }
  }
}

//PrintAntennas(antennas);

{ // create antinodes
  var maxX = grid[0].Count;
  var maxY = grid.Count;

  foreach (var item in antennas) {
    var pos = item.Value;

    for (var i = 0; i < pos.Count; i++) {
      for (var j = i + 1; j < pos.Count; j++) {
        var a1 = pos[i];
        var a2 = pos[j];

        var a1x = 2 * a2.x - a1.x;
        var a1y = 2 * a2.y - a1.y;

        var a2x = 2 * a1.x - a2.x;
        var a2y = 2 * a1.y - a2.y;

        if (0 <= a1x && a1x < maxX && 0 <= a1y && a1y < maxY) {
          antinodes.Add((a1x, a1y));
        }

        if (0 <= a2x && a2y < maxX && 0 <= a2y && a2y < maxY) {
          antinodes.Add((a2x, a2y));
        }
      }
    }
  }
}

{ // place antinodes
  foreach (var antinode in antinodes) {
    for (var i = 0; i < mGrid.Count; i++) {
      for (var j = 0; j < mGrid[i].Count; j++) {
        if (antinode.x == i && antinode.y == j) {
          mGrid[j][i] = '#';
        }
      }
    }
  }
}

//PrintGrid(mGrid);

{ // print antinodes
  Console.WriteLine(antinodes.Count);
}
