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

  int Gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  (double, double) CalcTRange(int a, int step, int lowerBound, int upperBound) {
    double tMin = 0, tMax = 0;

    if (step > 0) {
      tMin = (lowerBound - a) / step;
      tMax = (upperBound - a) / step;
    } else if (step < 0) {
      tMin = (upperBound - a) / step;
      tMax = (lowerBound - a) / step;    
    } else {
      if (lowerBound <= a && a <= upperBound) {
        tMin = double.NegativeInfinity;
        tMax = double.PositiveInfinity;
      }  else {
        tMin = double.PositiveInfinity;
        tMax = double.NegativeInfinity;
      }
    }

    return (tMin, tMax);
  }

  foreach (var item in antennas) {
    var pos = item.Value;

    if (pos.Count < 2) {
      continue;
    }

    foreach (var p in pos)
    {
        antinodes.Add(p);
    }

    for (var i = 0; i < pos.Count; i++) {
      for (var j = i + 1; j < pos.Count; j++) {
        var a1 = pos[i];
        var a2 = pos[j];

        var dx = a2.x - a1.x;
        var dy = a2.y - a1.y;

        int gcd = Gcd(Math.Abs(dx), Math.Abs(dy));

        if (gcd == 0)
        {
            antinodes.Add(a1);
        }

        int stepX = dx / gcd;
        int stepY = dy / gcd;

        var (tMinX, tMaxX) = CalcTRange(a1.x, stepX, 0, maxX);
        var (tMinY, tMaxY) = CalcTRange(a1.y, stepY, 0, maxY);

        double tStart = Math.Max(tMinX, tMinY);
        double tEnd = Math.Min(tMaxX, tMaxY);

        int intTStart = (int)Math.Ceiling(tStart);
        int intTEnd = (int)Math.Floor(tEnd);

        if (intTStart > intTEnd) continue;

        for (int t = intTStart; t <= intTEnd; t++) {
          var ax = t * stepX + a1.x;
          var ay = t * stepY + a1.y;

          if (0 <= ax && ax < maxX && 0 <= ay && ay < maxY) {
            antinodes.Add((ax, ay));
          }
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
